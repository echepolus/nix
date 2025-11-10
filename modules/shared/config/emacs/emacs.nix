{ pkgs }:
let
  emacsPackage = if pkgs.stdenv.isDarwin
    then pkgs.emacs
    else pkgs.emacs-unstable-pgtk;

  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (epkgs: with epkgs; [
    gcmh
    general
    evil
    evil-collection
    evil-org
    evil-commentary
    undo-tree
    quelpa
    quelpa-use-package
    meow
    meow-tree-sitter
    
    # UI and themes
    ef-themes
    doom-modeline
    all-the-icons
    all-the-icons-ivy
    all-the-icons-dired
    dashboard
    rainbow-delimiters
    ace-window
    which-key
    highlight-indent-guides
    helpful
    nerd-icons
    nerd-icons-completion
    nerd-icons-dired
    nerd-icons-ibuffer
    nerd-icons-ivy-rich
    tab-line-nerd-icons
    modus-themes
    fontaine
    pulsar
    spacious-padding
    golden-ratio

    # Minibuffers framework
    vertico
    marginalia
    consult
    orderless
    embark
    embark-consult

    # Ivy/Counsel framework
    ivy
    counsel
    ivy-rich
    ivy-prescient
    prescient
    counsel-projectile
    swiper
    
    # File management
    treemacs
    treemacs-evil
    treemacs-projectile
    treemacs-icons-dired
    treemacs-magit
    treemacs-nerd-icons
    dired-ranger
    dired-collapse
    perspective
    key-chord
    
    # Project management
    projectile
    ripgrep
    deadgrep
    
    # Org mode
    org-super-agenda
    org-modern
    org-superstar
    org-transclusion
    org-download
    org-roam
    emacsql
    sqlite3
    visual-fill-column
    
    # Writing
    writeroom-mode
    flyspell-correct
    flyspell-correct-ivy
    reverse-im
    denote
    citar
    
    # Version control
    # magit
    
    # Programming - Language servers
    lsp-mode
    lsp-ui
    lsp-treemacs
    
    # Progr   eamming - Languages
    nix-mode
    yaml-mode
    lua-mode
    tree-sitter
    tree-sitter-langs
    tide
    prettier-js
    emmet-mode
    
    # Python
    lsp-pyright
    blacken
    
    # PHP
    php-mode
    
    # Other tools
    f  # File manipulation library
    rotate
    exec-path-from-shell
    pdf-tools   
    tablist # required by pdf-tools
    
    # AI
    gptel
    mcp

  ]);
in 
emacsWithPackages
