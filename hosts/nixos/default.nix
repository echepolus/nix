{ agenix, config, lib, pkgs, modulesPath, user, ... }:

let
  # user = "alexeykotomin";
  myEmacs = import ../../modules/shared/config/emacs/emacs.nix { inherit pkgs; };
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/shared
    # ../../modules/nixos/secrets.nix
    # ../../modules/shared/cachix
    ./hardware-configuration.nix
    # agenix.nixosModules.default
  ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale      = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT    = "ru_RU.UTF-8";
    LC_MONETARY       = "ru_RU.UTF-8";
    LC_NAME           = "ru_RU.UTF-8";
    LC_NUMERIC        = "ru_RU.UTF-8";
    LC_PAPER          = "ru_RU.UTF-8";
    LC_TELEPHONE      = "ru_RU.UTF-8";
    LC_TIME           = "ru_RU.UTF-8";
  };

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    # niri = {
    #   enable = true;
    # };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    # ssh.startAgent = true;
    # ssh.agents = [
    #   {
    #     identities = [ "~/.ssh/id_ed25519" ];
    #   }
    # ];

    waybar.enable = true;
  };

  # Для нормальной работы Wayland + приложений
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Console configuration for virtual terminals
  console.useXkbConfig = true;
  virtualisation.vmware.guest.enable = true;

  # Services configuration
  services = {
    # xserver = {
    #   windowManager.bspwm.enable = true;
    # };

    xserver.enable = true;

    # desktopManager.gnome.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    xserver.xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };

    emacs = {
      enable = true;
      package = myEmacs;
    };

    # displayManager = {
    #   enable = true;
    #   sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #   };
    # };

    rsyncd = {
      enable = true;
    };
    # desktopManager.plasma6.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with PipeWire
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  tailscale.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  # Define a user account
  users.users.${user} = {
    isNormalUser = true;
    description  = "Alexey Kotomin";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    git
    myEmacs
    wl-clipboard     # Wayland clipboard utilities
    wayland-utils    # Wayland utilities
    # lm_sensors       # Hardware monitoring sensors
    btop             # Modern resource monitor
    open-vm-tools
    # alacritty
    ghostty
    agenix.packages."${pkgs.system}".default
  ];

  # Bootloader
  boot = {
    loader.systemd-boot = {
      enable             = true;
      configurationLimit = 3;
    };
    loader.efi.canTouchEfiVariables = true;
  };
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable     = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  # Font s
  fonts.packages = import ../../modules/shared/fonts.nix { inherit pkgs; };

  # Configure Nix settings for flakes
  nix = {
    nixPath = [
      "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos"
    ];
    settings = {
      allowed-users       = [ "${user}" ];
      trusted-users       = [ "@admin" "${user}" "root" ];
      substituters        = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    package      = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "25.05";
}
