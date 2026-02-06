{ config, pkgs, lib, home-manager, ... }:

let
  user = "alexeykotomin";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # imports = [
  #   ./dock
  # ];

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
      "gitlab-runner"
      "rbenv"
      "bear"
      "tesseract"
      "tesseract-lang"
      "imagemagick"
      "tdlib"
    ];
  };

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
            # { ".terminfo".source = "${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/Resources/terminfo"; }
        ];
        stateVersion = "25.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };
}
