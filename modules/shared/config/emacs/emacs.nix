{ pkgs }:
let
  emacsPackage = pkgs.emacs;
  
  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (epkgs: with epkgs; [
    gcmh
    general
    quelpa
    quelpa-use-package
    vterm

    # B
    
    # C
    calibredb
    citar
    counsel
    
    # D
    #djvu
    
    # E
    evil
    evil-collection
    eglot

    # F
    flycheck
    flycheck-eglot
    
    # UI and themes
    doric-themes
    doom-modeline
    all-the-icons
    rainbow-delimiters
    ace-window
    which-key
    highlight-indent-guides
    helpful
    fontaine
    pulsar
    spacious-padding

    # Minibuffers framework
    vertico
    marginalia
    consult
    orderless
    embark
    embark-consult
    math-preview
    dired-ranger
    dired-collapse
    key-chord
    
    # Project management
    projectile
    ripgrep
    deadgrep
    
    # Org mode
    emacsql
    sqlite3
    visual-fill-column
    
    # Writing
    writeroom-mode
    flyspell-correct
    reverse-im
    denote
    consult-denote
    denote-org
    denote-journal
    
    # Programming - Language servers
    
    # Programming - Languages
    nix-mode
    
    # Python
    
    # PHP
    
    # Other tools
    f  # File manipulation library
    rotate
    exec-path-from-shell
    pdf-tools   
    tablist # required by pdf-tools
    pdf-view-restore

    # D
    
    # H
    
    # I
    indent-bars
    
    # G
    gruber-darker-theme
    
    # L
    
    # M
    markdown-mode
    magit
        
    # N
    nov

    # O
    org-modern
    org-superstar
    org-noter

    # P
    plantuml-mode
    
    # S
    sdcv
    quick-sdcv

    # T
    melpaPackages.telega

    # U
    ultra-scroll
    
    # W
    wgrep

    # Y
    yasnippet
    
    # Z

  ]);
in 
emacsWithPackages
