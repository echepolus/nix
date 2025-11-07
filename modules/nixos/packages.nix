{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  # App and package management
  home-manager

  # F 
  fontconfig
  font-manager
  fuzzel

  # Testing and development tools
  direnv
  xorg.xwininfo # Provides a cursor to click and learn about windows

  # File and system utilities
  libnotify
  # pcmanfm # File browser

  # PDF viewer
  zathura

  # C
  chatgpt-cli

  # G
  # gcc # GNU Compiler Collection

  # L
  # lcov
  libgccjit
  binutils
  check
  cmake
  pkg-config
  gnumake

  # M
  mako
  # N
  nyxt  # The Hacker's Browser not yet ported

  # P

  # S
  swaybg
  syncthing

  # T
  tailscale
]
