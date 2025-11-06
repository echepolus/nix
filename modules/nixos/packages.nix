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
  pcmanfm # File browser

  # PDF viewer
  zathura

  # C
  cmake
  check
  chatgpt-cli

  # G
  gcc # GNU Compiler Collection
  gnumake

  # L
  lcov
  libgccjit

  # M
  mako
  # N
  nyxt  # The Hacker's Browser not yet ported

  # P
  pkg-config

  # S
  swaybg
  syncthing

  # T
  tailscale
]
