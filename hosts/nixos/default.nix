{ agenix, config, lib, pkgs, modulesPath, user, ... }:

let
  user = "eupontos";
  # myEmacs = import ../../modules/shared/config/emacs/emacs.nix { inherit pkgs; };
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # ../../modules/shared
    ../../modules/shared/cachix
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Moscow";
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
    nyxt.enable = true;
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  console.useXkbConfig = true;

  services = {
    xserver.enable = true;
    emacs.enable = true;
    rsyncd.enable = true;
    printing.enable = true;
    tailscale.enable = true;
    openssh.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

  };

  users.users.${user} = {
    isNormalUser = true;
    description  = "Alexey Kotomin";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    emacs
    btop 
    ghostty
  ];

  boot = {
    loader.systemd-boot = {
      enable             = true;
      configurationLimit = 5;
    };
    loader.efi.canTouchEfiVariables = true;
  };
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

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

  fonts.packages = import ../../modules/shared/fonts.nix { inherit pkgs; };

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
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
  };

  system.stateVersion = "25.05";
}
