{ config, pkgs, ... }:

let
  emacsOverlaySha256 = "0ar8nswi236rrmcj25b7j0cl71syyj5hc011xdvj3k5sbhz5mbc4";
  myEmacs = import ./config/emacs/emacs.nix { inherit pkgs; };
  telegaOverlaySha256 = "1vv41rclll90kksl1096dyim4lhzi9rawc56i45bc38cilabgxw9";
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
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
      }))]
      ++ [(import (builtins.fetchTarball {
        url = "https://github.com/echepolus/telega-overlay/archive/main.tar.gz";
        sha256 = telegaOverlaySha256;
      }))];
  };
}
