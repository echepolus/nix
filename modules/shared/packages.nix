{ pkgs, ... }:
let
  myPython = pkgs.python3.withPackages (ps: with ps; [
    slpp
    pip
    rich
    virtualenv
    black
    epc
    sexpdata
    six
    inflect
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
  btop # System monitor and process viewer

  # C
  coreutils # Basic file/text/shell utilities
  colima # Container runtime

  # D
  direnv # Environment variable management per directory
  difftastic # Structural diff tool
  du-dust # Disk usage analyzer
  docker

  # E
#  espanso # Cross-platform Text Expander written in Rust

  # F
  fd # Fast find alternative
  ffmpeg # Multimedia framework
  ffmpegthumbnailer
  fzf # Fuzzy finder
 
  # G
  gcc # GNU Compiler Collection
  gh # GitHub CLI
  glow # Markdown renderer for terminal
  gnupg # GNU Privacy Guard

  # H
  htop # Interactive process viewer
  hunspell # Spell checker
  hunspellDicts.en_US
  hunspellDicts.ru_RU
  hunspellDicts.el_GR

  # I
  iftop # Network bandwidth monitor
  imagemagick # Image manipulation toolkit

  # J
  jpegoptim # JPEG optimizer
  jq # JSON processor

  # K
  killall # Kill processes by name
  # kmonad
  kanata-with-cmd

  # L
  lnav # Log file navigator
  libgccjit
  libpng
  lazygit

  # M
  myPHP # Custom PHP with extensions
  myPython # Custom Python with packages

  # N
  ncurses # Terminal control library with terminfo database
  neofetch # System information tool
  neovim
  # ngrok # Secure tunneling service
  nodejs
  nodePackages.live-server # Development server with live reload
  nodePackages.nodemon # Node.js file watcher
  (hiPrio nodePackages.prettier) # Code formatter
  # nyxt  # The Hacker's Browser not yet ported

  # O
  openssh # SSH client and server

  # P
  pass # Stores, retrieves, generates, synchronizes passwords
  pandoc # Document converter
  # php82Packages.composer # PHP dependency manager
  # php82Packages.deployer # PHP deployment tool
  # php82Packages.php-cs-fixer # PHP code style fixer
  # phpunit # PHP testing framework
  # pngquant # PNG compression tool

  # R
  ripgrep # Fast text search tool

  # S
  sqlite # SQL database engine
  symlinks
  # starship

  # T
  # tabby
  tmux # Terminal multiplexer
  tree # Directory tree viewer

  # U
  unrar # RAR archive extractor
  unzip # ZIP archive extractor
  uv # Python package installer

  # V
  # vial # Ergo keyboard setup tool

  # W
  wget # File downloader
  wezterm

  # X

  # Y
  # yazi

  # Z
  zip # ZIP archive creator
  zsh-powerlevel10k # Zsh theme
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zoxide
  zlib
  zsh-fzf-tab

  # C package
  clang-tools
  cmake
  codespell
  conan
  cppcheck
  doxygen
  gtest
  lcov
  vcpkg

] ++ myFonts
