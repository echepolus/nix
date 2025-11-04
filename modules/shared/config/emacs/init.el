;; -------------------------
;; Evil early setup (must be before evil or evil-collection is loaded!)
;; -------------------------
;; (setq evil-want-integration t)      ;; default = t
;; (setq evil-want-keybinding nil)     ;; disable default bindings so evil-collection can set them
;; (setq evil-want-fine-undo 'fine)    ;; granular undo
;; (setq evil-want-Y-yank-to-eol t)    ;; Y yanks to end of line
;; (setq evil-want-C-u-scroll t)       ;; C-u scrolls like in Vim

;; -------------------------
;; Variable Declarations
;; -------------------------
(defvar org-config-file "~/.config/nix/modules/shared/config/emacs/config.org")
(defvar default-config-file "~/.emacs.d/default-config.org")
(defvar default-config-url "https://raw.githubusercontent.com/dustinlyons/nixos-config/9ad810c818b895c1f67f4daf21bbef31d8b5e8cd/shared/config/emacs/config.org")

;; -------------------------
;; Package Manager Setup
;; -------------------------
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "http://elpa.gnu.org/packages/")))


(unless (assoc-default "melpa" package-archives)
  (message "Warning: MELPA source not found. Adding MELPA to package-archives.")
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (message "Warning: Org source not found. Adding Org to package-archives.")
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t))

(setq package-enable-at-startup nil)
(package-initialize)

;; -------------------------
;; Use-Package Setup
;; -------------------------
(unless (package-installed-p 'use-package)
  (package-initialize)
  (if (package-install 'use-package)
      (message "use-package installed successfully.")
    (error "Error: Failed to install use-package."))
  (setq use-package-verbose t)
  ;; Disable auto-installation since Nix handles packages
  (setq use-package-always-ensure nil)
  (require 'use-package))

(use-package quelpa
  :ensure nil)

(use-package quelpa-use-package
  :after quelpa
  :ensure nil)

;; -------------------------
;; Environment Variables Setup
;; -------------------------
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH" "GOPATH" "PNPM_HOME"))
  (if (exec-path-from-shell-initialize)
      (message "Environment variables initialized successfully.")
    (error "Error: Failed to initialize environment variables.")))

;; В случае работы в Emacs daemon добавляем hook
(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (_frame)
              (exec-path-from-shell-initialize))))

(defvar ak/config-dir (expand-file-name "~/.config/emacs/"))
;; -------------------------
;; Window and UI Setup
;; -------------------------
(defun system-is-mac () (string-equal system-type "darwin"))
(defun system-is-linux () (string-equal system-type "gnu/linux"))

(defun dl/window-setup ()
  (condition-case nil
      (progn
        (column-number-mode)
        (scroll-bar-mode -1)
        (menu-bar-mode -1)
        (tool-bar-mode -1)
        (winner-mode 1)
        (when (system-is-mac)
          (add-to-list 'default-frame-alist '(ns-transparent-titlebar . nil))
          ;; (add-to-list 'default-frame-alist '(ns-appearance . dark))
          ;; (add-to-list 'default-frame-alist '(undecorated . t))
          (setq ns-use-proxy-icon t))
        (setq frame-title-format nil)
        (message "Window and UI setup completed successfully."))
    (error (message "Error occurred in Window and UI setup."))))
(dl/window-setup)

;; Function to set transparency and styling
(defun dl/setup-transparency-and-styling ()
    (when (system-is-mac)
	;; Values: 0-100 (0 = fully transparent, 100 = opaque)
	(set-frame-parameter nil 'alpha-background 50) ; For Emacs 29+
	(set-frame-parameter nil 'alpha '(85 . 80))     ; For older Emacs versions
	(add-to-list 'default-frame-alist '(alpha-background . 50))
	(add-to-list 'default-frame-alist '(alpha . (85 . 80)))
	;; Enable rounded corners carefully to not interfere with window management
	(when (and (boundp 'ns-appearance)
		(not (getenv "AEROSPACE_STARTUP")))
	    ;; Only apply rounded corners if not in aerospace startup to avoid conflicts
	(set-frame-parameter nil 'undecorated-round t)
	(add-to-list 'default-frame-alist '(undecorated-round . t)))))

;; Apply transparency settings
(when (display-graphic-p)
    (dl/setup-transparency-and-styling))

;; Apply to new frames created by emacsclient
(when (daemonp)
    (add-hook 'after-make-frame-functions
	    (lambda (frame)
		(select-frame frame)
		(dl/setup-transparency-and-styling))))

;; Keybinding to toggle transparency
(defun dl/toggle-transparency ()
    "Toggle frame transparency between opaque and transparent."
    (interactive)
    (let ((alpha (frame-parameter nil 'alpha-background)))
	(if (or (not alpha) (>= alpha 90))
	    (progn
		(set-frame-parameter nil 'alpha-background 85)
		(set-frame-parameter nil 'alpha '(85 . 80))
		(message "Frame transparency enabled"))
	    (progn
		(set-frame-parameter nil 'alpha-background 100)
		(set-frame-parameter nil 'alpha '(100 . 100))
		(message "Frame transparency disabled")))))

;; Optional: Keybinding for transparency toggle
(global-set-key (kbd "C-c C-t") 'dl/toggle-transparency)

;; -------------------------
;; Copy to Clipboard in TTY 
;; -------------------------
(use-package clipetty
  :ensure t
  :config
  (global-clipetty-mode 1))

;; -------------------------
;; Org Mode Setup
;; -------------------------
(defun dl/org-mode-setup ()
  (condition-case nil
      (progn
        (org-indent-mode)
        (variable-pitch-mode 1)
        (auto-fill-mode 0)
        (visual-line-mode 1)
        ;; (setq evil-auto-indent nil)
        (message "Org mode setup completed successfully."))
    (error (message "Error occurred in Org mode setup."))))

(use-package org
  :ensure nil
  :defer t
  :hook (org-mode . dl/org-mode-setup)
  :config
  (setq org-edit-src-content-indentation 2
        org-hide-emphasis-markers t
        org-hide-block-startup t)
  :bind (("C-c a" . org-agenda)))

;; -------------------------
;; Default Config Download
;; -------------------------
(defun dl/download-default-config ()
  (condition-case nil
      (progn
        (unless (file-exists-p default-config-file)
          (with-current-buffer
              (url-retrieve-synchronously default-config-url)
            (goto-char (point-min))
            (re-search-forward "\r?\n\r?\n")
            (write-region (point) (point-max) default-config-file))
          (message "Default configuration downloaded successfully.")))
    (error (message "Error occurred while downloading the default configuration."))))

;; -------------------------
;; Load Org Config or Default
;; -------------------------
(condition-case err
    (progn
      (unless (file-exists-p org-config-file)
        (dl/download-default-config))
      (if (file-exists-p org-config-file)
          (org-babel-load-file org-config-file)
        (org-babel-load-file default-config-file))
      (message "Configuration loaded successfully."))
  (error 
   (message "Error occurred while loading the configuration: %s" (error-message-string err))
   ;; fallback for evil-mode and leader-keys
   ;; (when (fboundp 'evil-mode)
   ;;   (evil-mode 1))
   (when (fboundp 'general-create-definer)
     (general-create-definer dl/leader-keys
       :keymaps '(normal visual emacs)
       :prefix ","))))

;; ------------------------------------
;; Храним все служебные файлы в ~/.config/emacs/
;; ------------------------------------

;; bookmarks
(setq bookmark-default-file (expand-file-name "bookmarks" ak/config-dir))
(setq bookmark-save-flag 1) ;; Автосохранение закладок

;; projectile (если используешь)
(when (boundp 'projectile-cache-file)
  (setq projectile-cache-file (expand-file-name "projectile.cache" ak/config-dir)))
(when (boundp 'projectile-known-projects-file)
  (setq projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" ak/config-dir)))

;; -------------------------
;; Load local overrides and custom settings
;; -------------------------

(defvar ak/local-config (expand-file-name "local.el" ak/config-dir))
(defvar ak/custom-config (expand-file-name "custom.el" ak/config-dir))

;; Подгружаем local.el, если есть
(when (file-exists-p ak/local-config)
  (load ak/local-config)
  (message "Loaded local.el overrides."))

;; Подгружаем custom.el, если есть
(when (file-exists-p ak/custom-config)
  (load ak/custom-config)
  (message "Loaded custom.el for customize interface."))

;; -------------------------
;; Умная авто-подгрузка local.el и custom.el с префиксом ak
;; -------------------------
(defun ak/smart-reload-config (file)
  (when (file-exists-p file)
    (condition-case err
        (let ((has-leader-definer (fboundp 'ak/leader-keys)))
          (load file nil 'nomessage)
          (when has-leader-definer
            (ak/leader-keys))
          (message "Smart reloaded %s successfully." file))
      (error
       (message "Error reloading %s: %s"
                file (error-message-string err))))))

(defun ak/auto-reload-config-on-save ()
  "Reload local.el or custom.el from ~/.config/emacs/ when saved."
  (let ((fname (buffer-file-name)))
    (when fname
      (cond
       ((string-equal (file-truename fname) ak/local-config)
        (ak/smart-reload-config fname))
       ((string-equal (file-truename fname) ak/custom-config)
        (ak/smart-reload-config fname))))))

;; Хук для автоматической перезагрузки при сохранении
(add-hook 'after-save-hook #'ak/auto-reload-config-on-save)

