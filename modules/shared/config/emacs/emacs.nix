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
        ccls

        # D
        djvu
        
        # E
        evil
        evil-collection
        
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
        lsp-mode
        lsp-ui
        
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
        dap-mode
        
        # H
        
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
        org-superstar
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
