{ config, pkgs, lib, home-manager, ... }:

let
  user = "alexeykotomin";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs lib; };
in
{
  imports = [
    ./dock
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };


  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    brews = [
      # "kanata"
      "speedtest-cli"
      "gitlab-runner"
      "rbenv"
      # "bear"
      # "llvm"
      "syncthing"
      "check"
      "gcc"
      "pkgconf"
      "glibc"
    ];
    masApps = {
      #"1password" = 1333542190;
      #"wireguard" = 1451685025;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
            sharedFiles
            additionalFiles
            { "emacs-launcher.command".source = myEmacsLauncher; }
            { ".terminfo".source = "${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/Resources/terminfo"; }
        ];

        stateVersion = "23.11";
      };

      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };
      
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      username = user;
      entries = [

        # { path = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
        # { path = "/Applications/iPhone Mirroring.app/"; }
        # {
        #   path = toString myEmacsLauncher;
        #   section = "others";
        # }
        # {
        #   path = "${config.users.users.${user}.home}/.local/share/";
        #   section = "others";
        #   options = "--sort name --view grid --display folder";
        # }
        # {
        #   path = "${config.users.users.${user}.home}/.local/share/downloads";
        #   section = "others";
        #   options = "--sort name --view grid --display stack";
        # }
      ];
    };
  };
}
