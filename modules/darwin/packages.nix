{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  aerospace
  colima
  kanata-with-cmd
  xray
  xclip
  pngpaste
]
