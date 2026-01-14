(setq user-full-name "echepolus"
  user-mail-address "a.kotominn@gmail.com")

(require 'package)
(unless (assoc-default "melpa" package-archives)
   (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "nongnu" package-archives)
   (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

(defun system-is-mac ()
  (string-equal system-type "darwin"))

(defun system-is-linux ()
  "Return true if system is GNU/Linux-based"
  (string-equal system-type "gnu/linux"))

;; Set path for darwin
(when (system-is-mac)
  (let ((home-dir (getenv "HOME")))
    (setenv "PATH" (concat (getenv "PATH") ":" home-dir "/.nix-profile/bin:/usr/bin"))
    (setq exec-path (append (list (concat home-dir "/bin")
                                 "/profile/bin"
                                 (concat home-dir "/.npm-packages/bin")
                                 (concat home-dir "/.nix-profile/bin")
                                 "/nix/var/nix/profiles/default/bin"
                                 "/usr/local/bin"
                                 "/usr/bin")
                           exec-path))))

;; Turn off UI junk
(column-number-mode)
(scroll-bar-mode 0)
(menu-bar-mode -1)
(tool-bar-mode 0)
(winner-mode 1) ;; ctrl-c left, ctrl-c right for window undo/redo
(blink-cursor-mode -1)

;; Для более плавной работы с оконным менеджером:
(setq frame-resize-pixelwise t)  ; Точность в пикселях (может быть полезно)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package nerd-icons)

;; f.el - modern file API
(use-package f
  :ensure nil  ; Managed by Nix
  :demand t)

(use-package doom-modeline
  :ensure nil  ; Managed by Nix
  :after f
  :init (doom-modeline-mode 1))

;; Remove binding for facemap-menu, use for ace-window instead
(global-unset-key (kbd "M-o"))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
    (aw-scope 'frame)
    (aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))
    (aw-minibuffer-flag t)
  :config
    (ace-window-display-mode 1)
    (advice-add 'ace-select-window :after #'win/auto-resize))

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq confirm-kill-emacs #'y-or-n-p)

  ;; Smooth out garbage collection
  (use-package gcmh
    :ensure nil  ; Managed by Nix
    :demand t
    :config
    (gcmh-mode 1))

(save-place-mode 1)
(setq save-place-file "~/.local/state/emacs/saveplace")

(savehist-mode 1)
(setq savehist-additional-variables
  '(search-ring
    regexp-search-ring
    kill-ring
    register-alist
    org-refile-history
    org-capture-history))
(setq savehist-file "~/.local/state/emacs/savehist")

(use-package recentf
  :ensure nil
  :init
  (setq recentf-max-saved-items 100
    recentf-max-menu-items 50
    recentf-save-file "~/.local/state/emacs/recentf")
  :config
    (recentf-mode 1))

(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(use-package fontaine
  :ensure nil 
  :hook
  ;; Persist the latest font preset when closing/starting Emacs.
  ((after-init . fontaine-mode)
   (after-init . (lambda ()
                   ;; Set last preset or fall back to desired style from `fontaine-presets'.
                   (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular)))))
  :bind (("C-c f" . fontaine-set-preset)
         ("C-c F" . fontaine-toggle-preset))
  :config
(defconst my/mono "Geist Mono")
(defconst my/var  "SF Pro Text") ; можно сменить на "San Francisco" / "Inter"

;; Набор пресетов. Высоты — в “сотых” по классике Emacs: 140 ≈ 14pt.
(setq fontaine-presets
      `(
        ;; компактный
        (small
         :default-family ,my/mono
         :default-weight light 
         :default-height 110
         :fixed-pitch-family ,my/mono
         :variable-pitch-family ,my/var)

        (regular
         :default-family ,my/mono
         :default-weight regular 
         :default-height 160
         :fixed-pitch-family ,my/mono
         :variable-pitch-family ,my/var)

        (medium
         :inherit regular
         :default-height 150)

        (large
         :inherit regular
         :default-height 180)

        (presentation
         :inherit regular
         :default-height 200)

        (jumbo
         :inherit regular
         :default-height 230)

        (coding
         :inherit regular
         :default-height 150)

        ;; fallback по умолчанию (используется как база для наследования)
        (t
         :default-family ,my/mono
         :default-weight regular
         :default-slant normal
         :default-width normal
         :default-height 140

         :fixed-pitch-family ,my/mono
         :fixed-pitch-height 1.0

         :variable-pitch-family ,my/var
         :variable-pitch-height 1.0

         :mode-line-active-height 1.0
         :mode-line-inactive-height 1.0
         :header-line-height 1.0
         :line-number-height 1.0
         :tab-bar-height 1.0
         :tab-line-height 1.0
         :bold-weight bold
         :italic-slant italic)))

  (with-eval-after-load 'pulsar
    (add-hook 'fontaine-set-preset-hook #'pulsar-pulse-line)))

(require 'spacious-padding)

 (setq spacious-padding-widths
      '( :internal-border-width 15
         :header-line-width 4
         :mode-line-width 6
         :tab-width 4
         :right-divider-width 30
         :scroll-bar-width 8
         :fringe-width 8))

;; Read the doc string of `spacious-padding-subtle-mode-line' as it
;; is very flexible and provides several examples.
(setq spacious-padding-subtle-frame-lines
      `( :mode-line-active 'default
         :mode-line-inactive vertical-border))

(spacious-padding-mode 1)

;; Set a key binding if you need to toggle spacious padding.
(define-key global-map (kbd "<f8>") #'spacious-padding-mode)

(use-package minibuffer
  :ensure nil
  :config
  (setq completion-styles '(basic substring initials flex orderless)) ; also see `completion-category-overrides'
  (setq completion-pcm-leading-wildcard t)) ; Emacs 31: make `partial-completion' behave like `substring'

;; settings to ignore letter casing
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq-default case-fold-search t)   ; For general regexp
(setq read-file-name-completion-ignore-case t)
(file-name-shadow-mode 1)

(use-package mb-depth
  :ensure nil
  :hook (after-init . minibuffer-depth-indicate-mode)
  :config
  (setq read-minibuffer-restore-windows nil) ; Emacs 28
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :ensure nil 
  :demand t
  :after minibuffer
  :config
  (setq orderless-matching-styles '(orderless-prefixes orderless-regexp))
  (setq orderless-smart-case nil)

  ;; SPC should never complete: use it for `orderless' groups.
  ;; The `?' is a regexp construct.
  :bind ( :map minibuffer-local-completion-map
          ("SPC" . nil)
          ("?" . nil)))

(use-package vertico
  :ensure nil
  :config
  (setq vertico-cycle t
  	    vertico-count 10
  	    vertico-resize t)
  (vertico-mode 1)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

(use-package vertico-posframe
  :after vertico
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-parameters
        '((left-fringe . 5)
          (right-fringe . 5)))
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.

  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package embark
  :ensure nil
  :bind (("C-." . embark-act)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))
(use-package embark-consult
  :ensure nil)

(use-package wgrep
  :ensure nil
  :bind ( :map grep-mode-map
          ("e" . wgrep-change-to-wgrep-mode)
          ("C-x C-q" . wgrep-change-to-wgrep-mode)
          ("C-c C-c" . wgrep-finish-edit)))

(use-package dashboard
  :ensure nil
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'ascii
        dashboard-center-content t
        dashboard-items '((projects . 5)
                           (recents  . 5)))
  (setq dashboard-set-footer nil))

  (setq dashboard-banner-logo-title "This is your life")
  (setq dashboard-set-file-icons t)
  ;; (setq dashboard-projects-backend 'projectile)
  (setq initial-buffer-choice (lambda ()
                                  (get-buffer-create "*dashboard*")
                                  (dashboard-refresh-buffer)))

(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<s-}>") 'next-buffer)
(global-set-key (kbd "<s-{>") 'previous-buffer)

;; Needed for `:after char-fold' to work
(use-package char-fold
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp))

(use-package reverse-im
  :ensure nil 
  :demand t 
  :after char-fold 
  :bind
  ("M-Τ" . reverse-im-translate-word) ; to fix a word written in the wrong layout
  :custom
  ;; cache generated keymaps
  (reverse-im-cache-file (locate-user-emacs-file "reverse-im-cache.el"))
  ;; use lax matching
  (reverse-im-char-fold t)
  ;; advice read-char to fix commands that use their own shortcut mechanism
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-input-methods '("russian-computer" "greek"))
  :config
  (reverse-im-mode t)) ; turn the mode on

(setq-default indent-tabs-mode nil
            js-indent-level 2
            tab-width 2)
;; (setq-default evil-shift-width 2)

(use-package doric-themes
  :ensure nil
  :demand t
  :config
  (setq doric-themes-to-toggle '(doric-dark doric-light))
  (setq doric-themes-to-rotate doric-themes-collection)

  (doric-themes-load-random 'dark)
  :bind
  (("<f5>" . doric-themes-toggle)
   ("C-<f5>" . doric-themes-select)
   ("M-<f5>" . doric-themes-rotate)))

(use-package pulsar
  :ensure nil
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line) ; overrides `count-lines-page'
    ("C-x L" . pulsar-highlight-permanently-dwim)) ; or use `pulsar-highlight-temporarily-dwim'
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-yellow)
  (setq pulsar-highlight-face 'pulsar-magenta))

;; The desired ratio of the focused window's size.
(setopt auto-resize-ratio 0.7)

(defun win/auto-resize ()
  (let* (
         (height (floor (* auto-resize-ratio (frame-height))))
         (width (floor (* auto-resize-ratio (frame-width))))
         ;; INFO We need to calculate by how much we should enlarge
         ;; focused window because Emacs does not allow setting the
         ;; window dimensions directly.
         (h-diff (max 0 (- height (window-height))))
         (w-diff (max 0 (- width (window-width)))))
    (enlarge-window h-diff)
    (enlarge-window w-diff t)))
(setopt window-min-height 10)
(setopt window-min-width 10)

(advice-add 'other-window :after (lambda (&rest args)
                                   (win/auto-resize)))
(advice-add 'windmove-up    :after 'win/auto-resize)
(advice-add 'windmove-down  :after 'win/auto-resize)
(advice-add 'windmove-right :after 'win/auto-resize)
(advice-add 'windmove-left  :after 'win/auto-resize)

(setq use-short-answers t)
(global-visual-line-mode t) 
(global-auto-revert-mode t) 
(show-paren-mode t)  
(setq show-paren-style 'mixed) 
(setq show-paren-delay 0)      
(setq warning-minimum-level :error)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(dolist (mode '(org-mode-hook
              text-mode-hook
              prog-mode-hook
              dired-mode-hook                
              conf-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(use-package general
  :config
  ;; (general-evil-setup t)
  (general-create-definer eux/leader-keys
    :keymaps '(normal visual emacs)
    :prefix ","))

(defvar current-time-format "%H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun eux/find-file (path)
  "Helper function to open a file in a buffer"
  (interactive)
  (find-file path))

(defun eux/load-buffer-with-emacs-config ()
  (interactive)
  (eux/find-file "~/.config/nix/modules/shared/config/emacs/config.org"))

(defun eux/load-buffer-with-nix-config ()
  (interactive)
  (eux/find-file "~/.config/nix/modules/shared/home-manager.nix"))

(defun eux/reload-emacs ()
  (interactive)
  (load "~/.emacs.d/init.el"))

(use-package math-preview
  :custom (math-preview-command "/Users/alexeykotomin/.nix-profile/bin/math-preview"))

(use-package nerd-icons-dired)

(use-package dired
  :ensure nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first")
  (setq dired-hide-details-hide-symlink-targets nil)
  (put 'dired-find-alternate-file 'disabled nil)
  (setq delete-by-moving-to-trash t)
  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))
  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (nerd-icons-dired-mode 1)
              (hl-line-mode 1))))
(add-hook 'dired-mode-hook 'dired-hide-details-mode)t

(use-package dired-ranger)
(use-package dired-collapse)

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define-global "gd" (lambda() (interactive)
                                (find-file "/Users/alexeykotomin/Downloads/")))
(key-chord-define-global "ge" (lambda() (interactive)
                                (find-file "/Users/alexeykotomin/.config/nix/modules/shared/config/emacs/")))
(key-chord-define-global "gb" (lambda() (interactive)
                                (find-file "/Users/alexeykotomin/Documents/library/")))
(key-chord-define-global "gs" (lambda() (interactive)
                                (find-file "/Users/alexeykotomin/s21_projects/")))

(when (system-is-mac)
  (setq insert-directory-program
        (expand-file-name ".nix-profile/bin/ls" (getenv "HOME"))))

(use-package tramp
  :ensure nil
  :config
  (setq tramp-shell-prompt-pattern "^[^$>\n]*[#$%>] *\\(\[[0-9;]*[a-zA-Z] *\\)*")
  (setq tramp-connection-timeout 10)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                vc-ignore-dir-regexp
                tramp-file-name-regexp)))

(setq backup-directory-alist
      `((".*" . "~/.local/state/emacs/backup"))
      backup-by-copying t    
      version-control t      
      delete-old-versions t)
(setq undo-tree-history-directory-alist '(("." . "~/.local/state/emacs/undo")))

(setq auto-save-file-name-transforms
      `((".*" "~/.local/state/emacs/" t)))
(setq lock-file-name-transforms
      `((".*" "~/.local/state/emacs/lock-files/" t)))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  
  (setq vterm-shell "zsh")                       
  (setq vterm-max-scrollback 10000))

(use-package denote
  :ensure nil
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/Documents/notes/"))
  (denote-rename-buffer-mode 1))

(use-package denote-markdown
  :ensure nil
  ;; Bind these commands to key bindings of your choice.
  :commands ( denote-markdown-convert-links-to-file-paths
              denote-markdown-convert-links-to-denote-type
              denote-markdown-convert-links-to-obsidian-type
              denote-markdown-convert-obsidian-links-to-denote-type ))

(use-package consult-denote
  :ensure nil
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-org
  :ensure nil
  :commands
  ;; I list the commands here so that you can discover them more
  ;; easily.  You might want to bind the most frequently used ones to
  ;; the `org-mode-map'.
  ( denote-org-link-to-heading
    denote-org-backlinks-for-heading

    denote-org-extract-org-subtree

    denote-org-convert-links-to-file-type
    denote-org-convert-links-to-denote-type

    denote-org-dblock-insert-files
    denote-org-dblock-insert-links
    denote-org-dblock-insert-backlinks
    denote-org-dblock-insert-missing-links
    denote-org-dblock-insert-files-as-headings))

(use-package denote-journal
  :ensure nil
  ;; Bind those to some key for your convenience.
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))

(use-package denote-sequence
  :ensure t
  :bind
  ( :map global-map
    ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
    ;; This is just for demonstration purposes: use the key bindings
    ;; that work for you.  Also check the commands:
    ;;
    ;; - `denote-sequence-new-parent'
    ;; - `denote-sequence-new-sibling'
    ;; - `denote-sequence-new-child'
    ;; - `denote-sequence-new-child-of-current'
    ;; - `denote-sequence-new-sibling-of-current'
    ("C-c n s s" . denote-sequence)
    ("C-c n s f" . denote-sequence-find)
    ("C-c n s l" . denote-sequence-link)
    ("C-c n s d" . denote-sequence-dired)
    ("C-c n s r" . denote-sequence-reparent)
    ("C-c n s c" . denote-sequence-convert))
  :config
  ;; The default sequence scheme is `numeric'.
  (setq denote-sequence-scheme 'alphanumeric))

(use-package citar
  :custom
  (citar-bibliography '("~/Documents/library/references.bib")))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package calibredb
  :ensure nil
  :commands (calibredb)
  :init
  (setq calibredb-root-dir "~/Documents/calibrary")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-library-alist '(("~/Documents/calibrary")))
  (setq calibredb-search-page-max-rows 100)
  (setq calibredb-id-width 0)
  (setq calibredb-comment-width 0)
  (setq calibredb-program "/Applications/calibre.app/Contents/MacOS/calibredb"))

;; Указать, что PDF/EPUB всегда открываются в специальном окне
(defvar eux/protected-buffer nil
  "Защищенный буфер с PDF/EPUB.")

(defun eux/display-pdf-epub (buffer alist)
  "Отображать PDF/EPUB в постоянном окне."
  (let ((window (display-buffer-in-side-window
                 buffer '((side . left) (slot . 0) (window-width . 0.7)))))
    (setq eux/protected-buffer buffer)
    window))

;; Для pdf-tools
(add-to-list 'display-buffer-alist
             `((derived-mode . pdf-view-mode)
               (display-buffer-in-side-window)
               (side . left)
               (slot . 0)
               (window-width . 0.7)))

;; Для nov-mode (EPUB)
(add-to-list 'display-buffer-alist
             `((derived-mode . nov-mode)
               (display-buffer-in-side-window)
               (side . left)
               (slot . 1)
               (window-width . 0.7)))
;; Для doc-view 
(add-to-list 'display-buffer-alist
           `((derived-mode . doc-view-mode)
             (display-buffer-in-side-window)
             (side . left)
             (slot . 0)
             (window-width . 0.7)))

(setq compilation-scroll-output t)
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
    (setq lsp-keymap-prefix "C-c l")
    (setq lsp-restart 'ignore)
    (setq lsp-headerline-breadcrumb-enable nil)
    (setq lsp-auto-guess-root t)
    (setq lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
    (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
        ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
   :custom
     (company-minimum-prefix-length 1)
     (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

(defun eux/lsp-find-references-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-references))

(defun eux/lsp-find-implementation-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-implementation))

(defun eux/lsp-find-definition-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-definition))

(eux/leader-keys
"l"  '(:ignore t :which-key "lsp")
"lf" '(eux/lsp-find-references-other-window :which-key "find references")
"lc" '(eux/lsp-find-implementation-other-window :which-key "find implementation")
"ls" '(lsp-treemacs-symbols :which-key "list symbols")
"lt" '(flycheck-list-errors :which-key "list errors")
"lh" '(lsp-treemacs-call-hierarchy :which-key "call hierarchy")
"lF" '(lsp-format-buffer :which-key "format buffer")
"li" '(lsp-organize-imports :which-key "organize imports")
"ll" '(lsp :which-key "enable lsp mode")
"lr" '(lsp-rename :which-key "rename")
"ld" '(eux/lsp-find-definition-other-window :which-key "goto definition"))

(use-package lsp-pyright
  :ensure nil  ; Managed by Nix
  :hook (python-mode . (lambda ()
    (require 'lsp-pyright)
    (lsp-deferred))))  ; or lsp-deferred

(setq python-indent-offset 2)

(use-package blacken
  :ensure nil)

(setq blacken-line-length '88)
(setq blacken-allow-py36 t)
(setq blacken-executable "black")
(setq blacken-fast-unsafe t)

(add-hook 'python-mode-hook 'blacken-mode)

(add-to-list 'auto-mode-alist '("\\.env" . shell-script-mode))

;; Ассоциируем файлы .kbd с lisp-mode
(add-to-list 'auto-mode-alist '("\\.kbd\\'" . lisp-mode))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package which-key
  :ensure nil  ; Managed by Nix
  :init
  (setq which-key-idle-delay 0.3
        which-key-idle-secondary-delay 0.1)
  :config
  (which-key-mode))

(use-package helpful
  :ensure nil  ; Managed by Nix
  :commands (helpful-callable helpful-variable helpful-key)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command]  . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key))

(with-eval-after-load 'org
  (org-babel-do-load-languages
  'org-babel-load-languages
  '(
    (emacs-lisp . t)
    (python . t)
    (sql . t)
    (shell . t))))

(use-package pdf-tools
    :defer t
    :commands (pdf-loader-install)
    :mode "\\.pdf\\'"
    :bind (:map pdf-view-mode-map
                ("i" . pdf-view-next-line-or-next-page)
                ("n" . pdf-view-previous-line-or-previous-page)
                ("C-=" . pdf-view-enlarge)
                ("C--" . pdf-view-shrink))
    :init (pdf-loader-install)
    :config (add-to-list 'revert-without-query ".pdf"))
  (setq pdf-history-enabled t)
  (setq pdf-view-auto-restore 'position)
(require 'bookmark)
(require 'saveplace-pdf-view)
(save-place-mode 1)

  (add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))
