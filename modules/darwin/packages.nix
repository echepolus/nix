{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  aerospace
  colima # Container runtime
  docker
  kanata-with-cmd
  gnupg # GNU Privacy Guard
  gcc
  libclang
  xray
  zip
  gperf
  cmakeMinimal
  pkg-configUpstream
  # tdlib
]
