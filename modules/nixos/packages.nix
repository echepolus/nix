{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  fontconfig
  font-manager

  # Testing and development tools
  direnv
  rofi
  rofi-calc
  libtool # for Emacs vterm

  # Text and terminal utilities
  feh # Manage wallpapers
  screenkey
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  i3lock-fancy-rapid
  libnotify
  pcmanfm # File browser
  xdg-utils

  # Other utilities
  yad # yad-calendar is used with polybar
  xdotool

  # PDF viewer
  zathura
]
