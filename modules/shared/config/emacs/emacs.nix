
{ pkgs }:
let
  emacsPackage = pkgs.emacs;
 
  emacsWithPackages = (pkgs.emacsPackagesFor emacsPackage).emacsWithPackages (epkgs: with epkgs; [
        gcmh
        general
        undo-tree
        quelpa
        quelpa-use-package
        denote-markdown
        denote-sequence
        vterm

        # B
        beframe
        
        # C
        calibredb
        citar
        
        # UI and themes
        doric-themes
        doom-modeline
        all-the-icons
        # all-the-icons-ivy
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
        fontaine
        pulsar
        spacious-padding
        golden-ratio

        # Minibuffers framework
        vertico
        vertico-posframe
        marginalia
        consult
        orderless
        embark
        embark-consult
        math-preview
        dired-ranger
        dired-collapse
        dired-preview
        key-chord
        
        # Project management
        projectile
        ripgrep
        deadgrep
        
        # Org mode
        org-super-agenda
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
        consult-denote
        denote-org
        denote-journal
        
        # Version control
        # magit
        
        # Programming - Language servers
        lsp-mode
        lsp-ui
        
        # Programming - Languages
        nix-mode
        
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
        saveplace-pdf-view

        # I
        indent-bars
        
        # G


        # N
        nov

        # O
        org-modern
        
        # S
        sdcv
        quick-sdcv

        # T
        # telega

        # W
        wgrep
  ]);
in 
emacsWithPackages
