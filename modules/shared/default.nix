{ config, pkgs, callPackage, ... }:

let
  emacsOverlaySha256 = "0s1rpm7q0wj8l1kxpc0nvnlv6md0cf4rccvgqmm9gsasdqv9sqip";
  myEmacs = import ./emacs.nix { inherit pkgs; };
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # First apply the official emacs-overlay
      [(import (builtins.fetchTarball {
               url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
               sha256 = emacsOverlaySha256;
           }))]
      # Then apply local overlays (including custom emacs patches)
      ++ (let path = ../../overlays; in with builtins;
          map (n: import (path + ("/" + n)))
              (filter (n: match ".*\\.nix" n != null ||
                          pathExists (path + ("/" + n + "/default.nix")))
                      (attrNames (readDir path))));
  };
}
