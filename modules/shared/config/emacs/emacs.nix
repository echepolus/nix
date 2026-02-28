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
        
        # C
        calibredb
        citar
        company
        ccls
        command-log-mode
        corfu
        
        # E
        evil
        evil-collection
        
        # UI and themes
        doric-themes
        doom-modeline
        all-the-icons
        all-the-icons-dired
        rainbow-delimiters
        ace-window
        which-key
        highlight-indent-guides
        helpful
        nerd-icons
        nerd-icons-completion
        nerd-icons-dired
        nerd-icons-ibuffer
        tab-line-nerd-icons
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
        pdf-view-restore

        # D
        dap-mode

        # H
        helm
        
        # I
        indent-bars
        
        # G
        gruber-darker-theme
        # L

        # M

        
        # N
        nov

        # O
        org-modern
        org-noter
        
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
