(require 'package)
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "nongnu" package-archives)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

(setq user-full-name "echepolus"
      user-mail-address "a.kotominn@gmail.com")

(defun system-is-mac ()
  (string-equal system-type "darwin"))

(defun system-is-linux ()
  (string-equal system-type "gnu/linux"))

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

(column-number-mode 0)
(line-number-mode 0)
(tab-bar-mode)
(scroll-bar-mode 0)
(menu-bar-mode -1)
(tool-bar-mode 0)
(tooltip-mode -1)
(winner-mode 1)
(blink-cursor-mode 0)
(global-hl-line-mode)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq confirm-kill-emacs #'y-or-n-p)
(use-package gcmh
  :ensure nil
  :demand t
  :config (gcmh-mode 1))
(setq use-short-answers t)
(global-visual-line-mode t)
(global-auto-revert-mode t)
(show-paren-mode t)
(setq show-paren-style 'mixed)
(setq show-paren-delay 0)
(setq warning-minimum-level :error)
(dolist (mode '(prog-mode-hook))
  (add-hook mode #'display-line-numbers-mode 0))
(setq frame-resize-pixelwise t)

(global-unset-key (kbd "M-o"))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1)
  (advice-add 'ace-select-window :after #'eu/auto-resize))

(setopt auto-resize-ratio 0.7)

(defun eu/auto-resize ()
  (let* ((height (floor (* auto-resize-ratio (frame-height))))
         (width (floor (* auto-resize-ratio (frame-width))))
         (h-diff (max 0 (- height (window-height))))
         (w-diff (max 0 (- width (window-width)))))
    (enlarge-window h-diff)
    (enlarge-window w-diff t)))
(setopt window-min-height 10)
(setopt window-min-width 10)

(advice-add 'other-window :after (lambda (&rest args) (eu/auto-resize)))
(advice-add 'windmove-up    :after 'eu/auto-resize)
(advice-add 'windmove-down  :after 'eu/auto-resize)
(advice-add 'windmove-right :after 'eu/auto-resize)
(advice-add 'windmove-left  :after 'eu/auto-resize)

(use-package ultra-scroll
  :init (setq scroll-conservatively 3
              scroll-margin 0)
  :config (ultra-scroll-mode 1))

(use-package all-the-icons)

(use-package f
  :ensure nil
  :demand t)

(use-package doom-modeline
  :after f
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-icon 1))

(use-package fontaine
  :ensure nil
  :hook
  ((after-init . fontaine-mode)
   (after-init . (lambda ()
                   (fontaine-set-preset
                  (or (fontaine-restore-latest-preset) 'regular)))))
  :bind (("C-c f" . fontaine-set-preset)
         ("C-c F" . fontaine-toggle-preset))
  :config
  (defconst my/mono "Geist Mono")
  (setq fontaine-presets
        `(
          (regular
           :default-family ,my/mono
           :default-weight light
           :default-height 170
           :fixed-pitch-family ,my/mono)

          (presentation
           :inherit regular
           :default-height 200)

          (t
           :default-family ,my/mono
           :default-weight light
           :default-height 170

           :fixed-pitch-family ,my/mono
           :fixed-pitch-weight light
         :fixed-pitch-serif-weight regular
         :variable-pitch-weight regular

           :mode-line-active-weight regular
           :mode-line-inactive-weight regular
         :header-line-weight regular
         :italic-weight regular
         :bold-weight regular
           :italic-slant italic)))

  (with-eval-after-load 'pulsar
    (add-hook 'fontaine-set-preset-hook #'pulsar-pulse-line)))

(use-package spacious-padding
  :ensure nil
  :config
  (setq spacious-padding-widths
        '( :internal-border-width 25
           :header-line-width 4
           :mode-line-width 4
           :custom-button-width 3
           :tab-width 6
           :right-divider-width 10
           :scroll-bar-width 15
           :fringe-width 0
           :right-fringe-width 0))
  (spacious-padding-mode 1))

(use-package minibuffer
  :ensure nil
  :config
  (setq completion-styles '(basic substring initials flex orderless)) ; also see `completion-category-overrides'
  (setq completion-pcm-leading-wildcard t)) ; Emacs 31: make `partial-completion' behave like `substring'

(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq-default case-fold-search t)
(setq read-file-name-completion-ignore-case t)
(file-name-shadow-mode 1)

(use-package mb-depth
  :ensure nil
  :hook (after-init . minibuffer-depth-indicate-mode)
  :config
  (setq read-minibuffer-restore-windows nil)
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :ensure nil
  :demand t
  :after minibuffer
  :config
  (setq orderless-matching-styles '(orderless-prefixes orderless-regexp))
  (setq orderless-smart-case nil)
  :bind ( :map minibuffer-local-completion-map
          ("SPC" . nil)
          ("?" . nil)))

(use-package vertico
  :ensure nil
  :config
  (setq vertico-cycle t
        vertico-scroll-margin 0
        vertico-count 10
        vertico-resize t)
  (vertico-mode 1)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

(use-package marginalia
  :init (marginalia-mode))

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
         ("C-x 4 b" . consult-buffer-other-window) ;; switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; abbrev-prefix-mark(unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s f" . consult-find)                  ;; Alternative: consult-fd
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

(use-package doric-themes
  :ensure nil
  :demand t
  :config
  (setq doric-themes-to-toggle '(doric-dark doric-light))
  (setq doric-themes-to-rotate doric-themes-collection)
  (doric-themes-load-random 'dark)
  :bind ("M-<f5>" . doric-themes-rotate))

(use-package pulsar
  :ensure nil
  :bind
  (:map global-map
        ("C-x l" . pulsar-pulse-line)
        ("C-x L" . pulsar-highlight-permanently-dwim))
  :init (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-region-face 'pulsar-yellow)
  (setq pulsar-highlight-face 'pulsar-magenta))

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

(use-package recentf
  :ensure nil
  :init
  (setq recentf-max-saved-items 100
        recentf-max-menu-items 50
        recentf-save-file "~/.local/state/emacs/recentf")
  :config
  (recentf-mode 1))

(global-set-key (kbd "C-x C-r") 'recentf-open-files)

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
              (hl-line-mode 1))))
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(use-package dired-ranger)
(use-package dired-collapse)

(when (system-is-mac)
  (setq insert-directory-program
        (expand-file-name ".nix-profile/bin/ls" (getenv "HOME"))))



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
  (setq denote-directory (expand-file-name "~/org/inbox/"))
  (denote-rename-buffer-mode 1))

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
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :config
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  (setq denote-journal-keyword "journal")
  (setq denote-journal-title-format 'day-date-month-year))

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
  (setq calibredb-size-show t)
  (setq calibredb-format-all-the-icons t)
  (setq calibredb-program "/Applications/calibre.app/Contents/MacOS/calibredb"))

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
  :config (add-to-list 'revert-without-query ".pdf")

  (add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))
  (add-hook 'pdf-view-mode-hook #'pdf-view-roll-minor-mode))

(use-package pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)
  (setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore"))

(use-package markdown-mode
  :ensure nil
  :mode ("README\\.md\\'" . gfm-view-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
            ("C-c C-e" . markdown-do)))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

(global-set-key (kbd "s-<down>") (kbd "C-u 1 C-v")) ;; scroll up
(global-set-key (kbd "s-<up>") (kbd "C-u 1 M-v")) ;; scroll down
(global-set-key (kbd "C-1") 'kill-current-buffer)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-c r") 'remember)
(global-set-key (kbd "<f5>") (lambda() (interactive)(find-file "~/")))
(global-set-key (kbd "<s-right>") 'next-buffer)
(global-set-key (kbd "<s-left>") 'previous-buffer)
(global-set-key (kbd "<S-s-right>") 'tab-next)
(global-set-key (kbd "<S-s-left>") 'tab-previous)
(global-set-key (kbd "<C-tab>") 'tab-next)
(global-set-key (kbd "<C-S-tab>") 'tab-previous)
(global-set-key (kbd "<C-s-tab>") 'tab-new)
(global-set-key (kbd "<C-s-w>") 'tab-close)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x C-3 C-f") 'find-file-other-tab)
(global-unset-key (kbd "C-,"))
(global-set-key (kbd "C-,") 'duplicate-line)

(global-unset-key (kbd "C-f"))
(use-package general
  :ensure t)

(general-create-definer eu/leader-keys
  :prefix "C-f")

(defun eu/projects-visit ()
  (interactive)
  (find-file "/Users/alexeykotomin/org/20260105T151859--действующие-проекты-и-книги__задачи_книги_проекты.org"))

(defun eu/emacs-help-notes ()
  (interactive)
  (find-file "/Users/alexeykotomin/org/help-notes/20260317T163943--emacs-help-notes__emacs.org"))

(defun eu/org-help-notes ()
  (interactive)
  (find-file "/Users/alexeykotomin/org/help-notes/20260317T164018--org-help-notes__emacs.org"))

(defun eu/emacs-config ()
  (interactive)
  (find-file "/Users/alexeykotomin/.config/nix/modules/shared/config/emacs/config.org"))

(defun eu/kanata-config ()
  (interactive)
  (find-file "/Users/alexeykotomin/.config/kanata/main.kbd"))

(defun eu/aerospace-config ()
  (interactive)
  (find-file "/Users/alexeykotomin/.config/aerospace/aerospace.toml"))

(eu/leader-keys
 "p p" #'eu/projects-visit

 "h e" #'eu/emacs-help-notes
 "h o" #'eu/org-help-notes

 "c e" #'eu/emacs-config
 "c k" #'eu/kanata-config
 "c a" #'eu/aerospace-config)

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
  (reverse-im-cache-file (locate-user-emacs-file "reverse-im-cache.el"))
  ;; use lax matching
  (reverse-im-char-fold t)
  ;; advice read-char to fix commands that use their own shortcut mechanism
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-input-methods '("russian-computer" "greek"))
  :config
  (reverse-im-mode t)) ; turn the mode on

(setq reverse-im-fix-shortcuts t)

(use-package telega
  :commands (telega)
  ;; :bind ("C-c t" . telega)
  :init
  (define-prefix-command 'my-telega-prefix)
  (global-set-key (kbd "C-c t") 'my-telega-prefix)

  :config
  (setq telega-app '(38023252 . "25b30c0339ba45df5458e8e15f2d5840"))

  (define-key my-telega-prefix (kbd "t") #'telega)
  (define-key my-telega-prefix (kbd "c") #'telega-chat-with)
  (define-key my-telega-prefix (kbd "s") #'telega-search))

(setq org-M-RET-may-split-line nil)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(org-superstar-mode)

(use-package math-preview
  :custom
  (math-preview-command "/Users/alexeykotomin/.nix-profile/bin/math-preview"))

(defun eu/org-mode-visual-fill ()
  (setq visual-fill-column-width 90
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook
  (org-mode . eu/org-mode-visual-fill)
  (markdown-mode . eu/org-mode-visual-fill))

(setq org-directory "~/org")
(setq org-agenda-files '("~/org"))
(setq org-todo-keywords
      '((sequence "TODO" "DONE")))
;;(setq org-log-done 'time)
(setq org-archive-location "~/org/archive.org::")
;; (setq org-capture-templates
;;       '(("i" "Inbox" entry
;;          (file "~/org/inbox.org")
;;          "* TODO %?\n  %U")))

;; (setq org-agenda-custom-commands
;;       '(("d" "Daily"
;;          ((agenda "" ((org-agenda-span 1)))
;;           (todo "NEXT")))))

(use-package org-noter
  :ensure nil
  :demand t)

(require 'plantuml-mode)

;; (setq plantuml-executable-path "/nix/store/ysk4b6xr6clcl0pwcgjf2gka2pwr6fvy-plantuml-1.2025.9/bin/plantuml")
;; (setq plantuml-default-exec-mode 'executable)

(setq org-plantuml-jar-path "/Users/alexeykotomin/.nix-profile/lib/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)



(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(add-to-list 'auto-mode-alist '("\\.env" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.kbd\\'" . lisp-mode))
(use-package nix-mode
  :mode "\\.nix\\'")
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (sql . t) (shell . t) (plantuml . t))))

(defun eu/c-help-at-point ()
  (interactive)
  (let ((sym (thing-at-point 'symbol t)))
    (when sym
      (man sym))))

(eu/leader-keys
  "m" #'eu/c-help-at-point)

(add-to-list 'display-buffer-alist
           '("\\*\\(Help\\|Man\\).*\\*"
             (display-buffer-in-side-window)
             (side . right)
             (window-width . 0.5)))

(global-set-key "\C-cw"
                   (lambda ()
                     (interactive)
                     (let ((woman-use-topic-at-point t))
                       (woman))))

(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(use-package flycheck
  :ensure nil
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

;; (dap-mode 1)
;; (dap-ui-mode 1)
;; (dap-ui-controls-mode 1)
;; (require 'dap-lldb)
;; (setq dap-lldb-debug-program '("/Users/alexeykotomin/.nix-profile/bin/lldb-dap"))

(use-package which-key
  :ensure nil
  :init
  (setq which-key-idle-delay 0
        which-key-idle-secondary-delay 0)
  :config
  (which-key-mode))

(use-package helpful
  :ensure nil
  :commands (helpful-callable helpful-variable helpful-key)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command]  . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key))

;; Key bindings:
;; - Toggle Hebrew (biblical-sil): C-\
;; - Toggle Greek (babel): C-|

;; Type hard break for Hebrew to English
(define-key 'iso-transl-ctl-x-8-map "f" [?‎])
(setq alternative-input-methods
      '(("greek-babel" . [?\C-|])))

(setq default-input-method
      (caar alternative-input-methods))

(defun toggle-alternative-input-method (method &optional arg interactive)
  "Toggle input METHOD similar to `toggle-input-method'.
Uses METHOD instead of `default-input-method'.
With ARG, behaves like standard toggle-input-method."
  (if arg
      (toggle-input-method arg interactive)
    (let ((previous-input-method current-input-method))
      (when current-input-method
        (deactivate-input-method))
      (unless (and previous-input-method
                   (string= previous-input-method method))
        (activate-input-method method)))))

(defun reload-alternative-input-methods ()
  "Set up global key bindings for alternative input methods.
Creates toggle functions for each method in `alternative-input-methods'."
  (dolist (config alternative-input-methods)
    (let ((method (car config)))
      (global-set-key (cdr config)
                      `(lambda (&optional arg interactive)
                         ,(concat "Behaves similar to `toggle-input-method', but uses \""
                                  method "\" instead of `default-input-method'")
                         (interactive "P\np")
                         (toggle-alternative-input-method ,method arg interactive))))))

(reload-alternative-input-methods)

;;; Dynamic Cursor Adjustment

(defun my-adjust-cursor-for-language ()
  "Set cursor to bar in Greek/Hebrew region, box otherwise.
Checks characters within 5 positions before and after point."
  (let ((greek-or-hebrew-nearby nil))
    ;; Check characters within 5 positions before and after
    (save-excursion
      (let ((start (max (point-min) (- (point) 5)))
            (end (min (point-max) (+ (point) 5))))
        (goto-char start)
        (while (and (< (point) end) (not greek-or-hebrew-nearby))
          (let ((char (char-after)))
            (when (and char
                       (memq (char-table-range char-script-table char)
                             '(greek hebrew)))
              (setq greek-or-hebrew-nearby t)))
          (forward-char 1))))
    (setq-local cursor-type (if greek-or-hebrew-nearby '(bar . 2) 'box))))

(add-hook 'post-command-hook #'my-adjust-cursor-for-language)

(defun strip-numbers-and-brackets (beg end)
  "Remove numbers and brackets from selected region between BEG and END.
Also removes leading/trailing spaces and collapses multiple spaces between words.
Useful for cleaning up Greek/Hebrew text with verse numbers."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      ;; Remove numbers and brackets
      (goto-char (point-min))
      (while (re-search-forward "\\([0-9]+\\|\\[\\|\\]\\)" nil t)
        (replace-match ""))
      ;; Collapse multiple spaces into single space
      (goto-char (point-min))
      (while (re-search-forward " \\{2,\\}" nil t)
        (replace-match " "))
      ;; Remove leading and trailing whitespace from each line
      (goto-char (point-min))
      (while (re-search-forward "^[[:space:]]+" nil t)
        (replace-match ""))
      (goto-char (point-min))
      (while (re-search-forward "[[:space:]]+$" nil t)
        (replace-match "")))))

(defalias 'grk 'strip-numbers-and-brackets)

(defun greek-hebrew-flyspell-verify ()
  "Return nil if word at point contains Greek or Hebrew characters.
This tells flyspell to skip checking this word."
  (save-excursion
    (let ((case-fold-search t)
          (pos (point))
          (greek-hebrew-found nil))
      ;; Check if current word contains Greek or Hebrew
      (skip-chars-backward "^ \t\n\r")
      (while (and (< (point) pos) (not greek-hebrew-found))
        (let* ((char (char-after))
               (script (and char (char-table-range char-script-table char))))
          (when (memq script '(greek hebrew))
            (setq greek-hebrew-found t)))
        (forward-char 1))
      ;; Return t to check word, nil to skip
      (not greek-hebrew-found))))

;; Advice to add Greek/Hebrew checking to existing flyspell predicates
(defun greek-hebrew-flyspell-advice (orig-fun &rest args)
  "Advice to skip Greek/Hebrew words in addition to mode-specific checks."
  (and (greek-hebrew-flyspell-verify)
       (apply orig-fun args)))

;; Apply advice to markdown-mode's flyspell predicate
(with-eval-after-load 'markdown-mode
  (advice-add 'markdown-flyspell-check-word-p :around
              #'greek-hebrew-flyspell-advice))

;; For text-mode and org-mode, set the predicate directly
(add-hook 'text-mode-hook
          (lambda ()
            (unless (derived-mode-p 'markdown-mode)
              (setq-local flyspell-generic-check-word-predicate
                          #'greek-hebrew-flyspell-verify))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local flyspell-generic-check-word-predicate
                        #'greek-hebrew-flyspell-verify)))

(set-fontset-font "fontset-default" 'greek (font-spec :family "SBL BibLit" :size 22))
(set-fontset-font "fontset-default" 'hebrew (font-spec :family "SBL BibLit" :size 20))

(provide 'my-ancient-greek-tweaks)
