{ pkgs, ... }:
let
  myPython = pkgs.python3.withPackages (ps: with ps; [
    slpp
    pip
    rich
    mysql-connector
    virtualenv
    black
    requests
    faker
    textual
    pyqt5
    epc
    sexpdata
    six
    inflect
    unidecode
    pyaml
    feedparser
    python-dateutil
  ]);

  myPHP = pkgs.php82.withExtensions ({ enabled, all }: enabled ++ (with all; [
    xdebug
  ]));

  myFonts = import ./fonts.nix { inherit pkgs; };
in

with pkgs; [
  # A
  act # Run Github actions locally
  age # File encryption tool
  aspell # Spell checker
  aspellDicts.en # English dictionary for aspell
  aspellDicts.el # Modern Greek dictionary for aspell
  aspellDicts.grc # Ancient Greek dictionary for aspell
  aspellDicts.la # Latin dictionary for aspell

  # B
  bash-completion # Bash completion scripts
  bat # Cat clone with syntax highlighting
  bear
  
  # C
  coreutils # Basic file/text/shell utilities

  # D
  direnv # Environment variable management per directory
  difftastic # Structural diff tool
  djvulibre
  docker
  
  # E

  # F
  fd # Fast find alternative
  fzf # Fuzzy finder
  ffmpeg
 
  # G
  gh # GitHub CLI
  glow # Markdown renderer for terminal
  ghostscript # PDF to images converter
  gdb
  gcc
  gnupg
    
  # H
  htop # Interactive process viewer
  hunspell # Spell checker
  hunspellDicts.en_US
  hunspellDicts.ru_RU
  hunspellDicts.el_GR

  # I
  iftop # Network bandwidth monitor
  
  # J

  # K
  killall # Kill processes by name

  # L
  lnav # Log file navigator
  libpng

  # M
  myPHP # Custom PHP with extensions
  myPython # Custom Python with packages
  math-preview

  # N
  ncurses
  ncdu
  nodejs_20

  # O
  openssh # SSH client and server

  # P
  pass # Stores, retrieves, generates, synchronizes passwords
  pandoc # Document converter
  poppler # PDF to plain text tool
  pkg-config

  # Q
  qt5.qtbase

  # R
  ripgrep # Fast text search tool
  rbenv

  # S
  sqlite # SQL database engine
  symlinks
  sdcv

  # T
  tree # Directory tree viewe

  # U
  unrar # RAR archive extractor
  unzip # ZIP archive extractor
  uv # Python package installer

  # V

  # W
  wget # File downloader

  # X

  # Y
  
  
  # Z
  zip # ZIP archive creator
  zsh-powerlevel10k # Zsh theme
  zoxide
  zlib
] ++ myFonts
