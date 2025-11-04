{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil # Manage icons in the dock
  fswatch # File change monitor
  # jankyborders
  aerospace
  clang-tools
  rsync
]
