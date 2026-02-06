{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  aerospace
  colima
  docker
  kanata-with-cmd
  gnupg
  gcc
  libclang
  xray
  xclip
  zip
  tg
  tdlib
]
