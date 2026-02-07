{ config, pkgs, ... }:

let
  emacsOverlaySha256 = "1bczv0y0916f0gjrm79g0xj9y5fdn39bmf8rbnlvsfja9qpv5zbv";
  # telegaOverlaySha256 = "1asrb6df66zjhhcrh1wvfh64r39jmj5a0zainnwy87a0mx3vsjai";
  myEmacs = import ./config/emacs/emacs.nix { inherit pkgs; };
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
      let
        path = ../../overlays;
      in with builtins;
        map (n: import (path + ("/" + n)))
          (filter (n:
            (match ".*\\.nix" n != null ||
             pathExists (path + ("/" + n + "/default.nix"))))
              (attrNames (readDir path)))

      ++ [(import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = emacsOverlaySha256;
      }))];
      # ++ [(import (builtins.fetchTarball {
      #   url = "https://github.com/ipvych/telega-overlay/archive/main.tar.gz";
      #   sha256 = telegaOverlaySha256;
      # }))];
  };
}
