{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  tg
  aerospace
  colima # Container runtime
  docker
  kanata-with-cmd
  gnupg # GNU Privacy Guard
  gcc
  libclang
  xray
  zip
]
