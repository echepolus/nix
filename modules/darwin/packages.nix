{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil # Manage icons in the dock
  fswatch # File change monitor
  # jankyborders
  aerospace
  # colima # Container runtime
  # docker
  kanata-with-cmd
  # clang-tools
  # wezterm
  # vial # Ergo keyboard setup tool
  # tabby
  # starship
  gnupg # GNU Privacy Guard

  libgccjit
  binutils
  check
  cmake
  pkg-config
  gnumake
  valgrind

]
