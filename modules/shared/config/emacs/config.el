(setq user-full-name "Alexey Kotomin"
  user-mail-address "a.kotominn@gmail.com")

(require 'package)
(unless (assoc-default "melpa" package-archives)
   (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "nongnu" package-archives)
   (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t))

(defun system-is-mac ()
  "Return true if system is darwin-based (Mac OS X)"
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
;; (setq frame-inhibit-implied-resize t)  ; Не менять размер автоматически

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

;;; Set default frame size and position 
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

;;;; Fontaine (font configurations)
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
;; Главные семейства для macOS
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

        ;; по умолчанию
        (regular
         :default-family ,my/mono
         :default-weight regular 
         :default-height 140
         :fixed-pitch-family ,my/mono
         :variable-pitch-family ,my/var)

        ;; слегка крупнее
        (medium
         :inherit regular
         :default-height 150)

        ;; заметно крупнее — удобно на ретине/диване
        (large
         :inherit regular
         :default-height 170)

        ;; для выступлений
        (presentation
         :inherit regular
         :default-height 190)

        ;; максимальный
        (jumbo
         :inherit regular
         :default-height 230)

        ;; пресет для кодинга: немного компактнее боксы UI
        (coding
         :inherit regular
         :default-height 135)

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

;; These are the default values, but I keep them here for visibility.
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
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init
  (marginalia-mode))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
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
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

;;; Extended minibuffer actions and more (embark.el)
(use-package embark
  :ensure nil
  :bind (("C-." . embark-act)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))

;; Needed for correct exporting while using Embark with Consult
;; commands.
(use-package embark-consult
  :ensure nil)

;; The `wgrep' packages lets us edit the results of a grep search
;; while inside a `grep-mode' buffer.  All we need is to toggle the
;; editable mode, make the changes, and then type C-c C-c to confirm
;; or C-c C-k to abort.
;;
;; Further reading: https://protesilaos.com/emacs/dotemacs#h:9a3581df-ab18-4266-815e-2edd7f7e4852
(use-package wgrep
  :ensure t
  :bind ( :map grep-mode-map
          ("e" . wgrep-change-to-wgrep-mode)
          ("C-x C-q" . wgrep-change-to-wgrep-mode)
          ("C-c C-c" . wgrep-finish-edit)))

(use-package dashboard
  :ensure nil  ; Managed by Nix
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

;; Needed for `:after char-fold' to work
(use-package char-fold
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp))

(use-package reverse-im
  :ensure nil 
  :demand t ; always load it
  :after char-fold ; but only after `char-fold' is loaded
  :bind
  ("M-T" . reverse-im-translate-word) ; to fix a word written in the wrong layout
  :custom
  ;; cache generated keymaps
  (reverse-im-cache-file (locate-user-emacs-file "reverse-im-cache.el"))
  ;; use lax matching
  (reverse-im-char-fold t)
  ;; advice read-char to fix commands that use their own shortcut mechanism
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  ;; translate these methods
  (reverse-im-input-methods '("russian-computer" "greek"))
  :config
  (reverse-im-mode t)) ; turn the mode on

(when (require 'meow nil t)             
(require 'meow-tree-sitter nil t)   
(when (fboundp 'meow-setup)
  (meow-setup)
  (meow-global-mode 1)))

(require 'ef-themes)
(setq ef-themes-to-toggle '(ef-owl ef-maris-dark))
(setq ef-themes-headings ; read the manual's entry or the doc string
      '((0 variable-pitch regular 1.9)
        (1 variable-pitch regular 1.8)
        (2 variable-pitch light 1.7)
        (3 variable-pitch light 1.6)
        (4 variable-pitch light 1.5)
        (5 variable-pitch light 1.4) ; absence of weight means `bold'
        (6 variable-pitch light 1.3)
        (7 variable-pitch light 1.2)
        (t variable-pitch light 1.1)))

(setq ef-themes-mixed-fonts t
      ef-themes-variable-pitch-ui t)

(mapc #'disable-theme custom-enabled-themes)

(load-theme 'ef-owl :no-confirm)

(define-key global-map (kbd "<f5>") #'ef-themes-toggle)

;;;; Pulsar
;; Read the pulsar manual: <https://protesilaos.com/emacs/pulsar>.
(use-package pulsar
  :ensure nil
  :config
  (setq pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 5
        pulsar-face 'pulsar-green
        pulsar-region-face 'pulsar-cyan
        pulsar-highlight-face 'pulsar-magenta)
  ;; Pulse after `pulsar-pulse-region-functions'.
  (setq pulsar-pulse-region-functions pulsar-pulse-region-common-functions)
  :hook
  ;; There are convenience functions/commands which pulse the line using
  ;; a specific colour: `pulsar-pulse-line-red' is one of them.
  ((next-error . (pulsar-pulse-line-red pulsar-recenter-top pulsar-reveal-entry))
   (minibuffer-setup . pulsar-pulse-line-red)
   ;; Pulse right after the use of `pulsar-pulse-functions' and
   ;; `pulsar-pulse-region-functions'.  The default value of the
   ;; former user option is comprehensive.
   (after-init . pulsar-global-mode))
  :bind
  ;; pulsar does not define any key bindings.  This is just my personal
  ;; preference.  Remember to read the manual on the matter.  Evaluate:
  ;;
  ;; (info "(elisp) Key Binding Conventions")
  (("C-x l" . pulsar-pulse-line) ; override `count-lines-page'
   ("C-x L" . pulsar-highlight-dwim))) ; or use `pulsar-highlight-line'

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
(global-visual-line-mode t) ;; Wraps lines everywhere
(global-auto-revert-mode t) ;; Auto refresh buffers from disk

;; Настройка подсветки скобок
(show-paren-mode t)  ;; Включить режим
(setq show-paren-style 'mixed) ;; Лучшая видимость (выделение всей пары или одной)
(setq show-paren-delay 0)      ;; Мгновенная подсветка 

(setq warning-minimum-level :error)

;; Нумерация
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; ESC will also cancel/quit/etc.
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(use-package general
  :config
  (general-create-definer dl/leader-keys
    :keymaps '(normal visual emacs)
    :prefix ","))

(defvar current-time-format "%H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun dl/find-file (path)
  "Helper function to open a file in a buffer"
  (interactive)
  (find-file path))

(defun dl/load-buffer-with-emacs-config ()
  "Open the emacs configuration"
  (interactive)
  (dl/find-file "~/.local/share/src/nixos-config/modules/shared/config/emacs/config.org"))

(defun dl/load-buffer-with-nix-config ()
  "Open the emacs configuration"
  (interactive)
  (dl/find-file "~/.local/share/src/nixos-config/modules/shared/home-manager.nix"))

(defun dl/reload-emacs ()
  "Reload the emacs configuration"
  (interactive)
  (load "~/.emacs.d/init.el"))

;; Emacs relates shortcuts
(dl/leader-keys
  "e"  '(:ignore t :which-key "emacs")
  "ee" '(dl/load-buffer-with-emacs-config :which-key "open emacs config")
  "er" '(dl/reload-emacs :which-key "reload emacs"))

(use-package math-preview
  :custom (math-preview-command "/Users/alexeykotomin/.nix-profile/bin/math-preview"))

(use-package obsidian
  :config
  (global-obsidian-mode t)
  (obsidian-backlinks-mode t)
  :custom
  ;; location of obsidian vault
  (obsidian-directory "~/Documents/notes/obsidian")
  ;; Default location for new notes from `obsidian-capture'
  (obsidian-inbox-directory "Inbox")
  ;; Useful if you're going to be using wiki links
  (markdown-enable-wiki-links t)

  ;; These bindings are only suggestions; it's okay to use other bindings
  :bind (:map obsidian-mode-map
              ;; Create note
              ("C-c C-n" . obsidian-capture)
              ;; If you prefer you can use `obsidian-insert-wikilink'
              ("C-c C-l" . obsidian-insert-link)
              ;; Open file pointed to by link at point
              ("C-c C-o" . obsidian-follow-link-at-point)
              ;; Open a different note from vault
              ("C-c C-p" . obsidian-jump)
              ;; Follow a backlink for the current file
              ("C-c C-b" . obsidian-backlink-jump)))

(use-package org-modern
  :ensure nil 
  :config
    ;; Add frame borders and window dividers
    (modify-all-frames-parameters
    '((right-divider-width . 20)
    (internal-border-width . 20)))
    (dolist (face '(window-divider
                    window-divider-first-pixel
                    window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
    (set-face-background 'fringe (face-attribute 'default :background))

    (setq
    ;; Edit settings
    org-auto-align-tags nil
    org-tags-column 0
    org-catch-invisible-edits 'show-and-error
    org-special-ctrl-a/e t
    org-insert-heading-respect-content t

    ;; Org styling, hide markup etc.
    org-hide-emphasis-markers t
    org-pretty-entities t
    org-agenda-tags-column 0
    org-ellipsis "…")

    (global-org-modern-mode))

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

(key-chord-define-global "dd" (lambda() (interactive)
(find-file "/Users/alexeykotomin/Downloads/")))
(key-chord-define-global "ee" (lambda() (interactive)
(find-file "/Users/alexeykotomin/.config/nix/modules/shared/config/emacs/")))
(key-chord-define-global "bb" (lambda() (interactive)
(find-file "/Users/alexeykotomin/Documents/library/")))
(key-chord-define-global "ss" (lambda() (interactive)
(find-file "/Users/alexeykotomin/s21_projects/")))

(when (system-is-mac)
  (setq insert-directory-program
    (expand-file-name ".nix-profile/bin/ls" (getenv "HOME"))))

(setq backup-directory-alist
      `((".*" . "~/.local/state/emacs/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t) ; Automatically delete excess backups

(setq undo-tree-history-directory-alist '(("." . "~/.local/state/emacs/undo")))

(setq auto-save-file-name-transforms
      `((".*" "~/.local/state/emacs/" t)))
(setq lock-file-name-transforms
      `((".*" "~/.local/state/emacs/lock-files/" t)))

;; Remember that the website version of this manual shows the latest
;; developments, which may not be available in the package you are
;; using.  Instead of copying from the web site, refer to the version
;; of the documentation that comes with your package.  Evaluate:
;;
;;     (info "(denote) Sample configuration")
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

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))

(use-package denote-markdown
 :ensure nil
 ;; Bind these commands to key bindings of your choice.
 :commands ( denote-markdown-convert-links-to-file-paths
   denote-markdown-convert-links-to-denote-type
   denote-markdown-convert-links-to-obsidian-type
   denote-markdown-convert-obsidian-links-to-denote-type ))
(use-package citar
:custom
(citar-bibliography '("~/Documents/library/references.bib")))

(use-package pdf-tools
:ensure nil
:config
(pdf-loader-install))
(add-hook 'pdf-view-mode-hook
        (lambda ()
          (display-line-numbers-mode -1)))

;; Auto scroll the buffer as we compile
(setq compilation-scroll-output t)

;; By default, eshell doesn't support ANSI colors. Enable them for compilation.
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

(defun dl/lsp-find-references-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-references))

(defun dl/lsp-find-implementation-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-implementation))

(defun dl/lsp-find-definition-other-window ()
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (lsp-find-definition))

(dl/leader-keys
"l"  '(:ignore t :which-key "lsp")
"lf" '(dl/lsp-find-references-other-window :which-key "find references")
"lc" '(dl/lsp-find-implementation-other-window :which-key "find implementation")
"ls" '(lsp-treemacs-symbols :which-key "list symbols")
"lt" '(flycheck-list-errors :which-key "list errors")
"lh" '(lsp-treemacs-call-hierarchy :which-key "call hierarchy")
"lF" '(lsp-format-buffer :which-key "format buffer")
"li" '(lsp-organize-imports :which-key "organize imports")
"ll" '(lsp :which-key "enable lsp mode")
"lr" '(lsp-rename :which-key "rename")
"ld" '(dl/lsp-find-definition-other-window :which-key "goto definition"))

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
    (shell . t)))
 )
