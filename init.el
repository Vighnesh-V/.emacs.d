;;; Personal configuration -*- lexical-binding: t -*-

;; Save the contents of this file under ~/.emacs.d/init.el
;; Do not forget to use Emacs' built-in help system:
;; Use C-h C-h to get an overview of all help commands.  All you
;; need to know about Emacs (what commands exist, what functions do,
;; what variables specify), the help system can provide.

;; Add the NonGNU ELPA package archive
(require 'package)
(add-to-list 'package-archives  '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(unless package-archive-contents  (package-refresh-contents))

(unless (package-installed-p 'rg)
  (package-install 'rg))

;; Set default font face
(set-face-attribute 'default nil :font "Cascadia Code PL-15")

;; Disable the menu bar
(menu-bar-mode -1)

;; Disable the tool bar
(tool-bar-mode -1)

;; Disable the scroll bars
(scroll-bar-mode -1)

;; Disable splash screen
(setq inhibit-startup-screen t)

;; Mode line configuration
;; see custom.el

;; Enable completion by narrowing
(vertico-mode t)
;; Improve directory navigation
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
  (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char))

;;; Extended completion utilities
(unless (package-installed-p 'consult)
  (package-install 'consult))
(global-set-key [rebind switch-to-buffer] #'consult-buffer)
(global-set-key (kbd "C-s") #'consult-line)
(global-set-key (kbd "C-c i") #'consult-imenu)
(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      completion-ignore-case t)

(unless (package-installed-p 'orderless)
  (package-install 'orderless))
(setq completion-styles '(orderless basic))
(setq completion-category-overrides '((file (styles basic partial-completion substring))))

;; Enable line numbering in `prog-mode'
(defun line-number-custom ()
  (display-line-numbers-mode))
(add-hook 'prog-mode-hook 'line-number-custom)

;; What is the default shell mode
(setq explicit-shell-file-name "/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

;; Automatically pair parentheses
(electric-pair-mode t)

;; Replace text 
(unless (package-installed-p 'change-inner)
  (package-install 'change-inner))
(require 'change-inner)
(global-set-key (kbd "M-i") 'change-inner)
(global-set-key (kbd "M-o") 'change-outer)
;;; LSP Support
(unless (package-installed-p 'eglot)
  (package-install 'eglot))

;; Enable LSP support by default in programming modes
(add-hook 'prog-mode-hook #'eglot-ensure)

;; Create a memorable alias for `eglot-ensure'.
(defalias 'start-lsp-server #'eglot)
;; Enable windmove mode
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
;; Projectile setup
(unless (package-installed-p 'projectile)
  (package-install 'projectile))
;; Projectile configuration
(require 'projectile)
;; Recommended keymap prefix on macOS
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)

;; Setup C++ code editing prefs (indentation, etc)
(defun my-c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;; Pop-up completion
(unless (package-installed-p 'corfu)
  (package-install 'corfu))

;; Enable autocompletion by default in programming buffers
(add-hook 'prog-mode-hook #'corfu-mode)

;; Enable automatic completion.
(setq corfu-auto t)

;;; Git client
(unless (package-installed-p 'magit)
  (package-install 'magit))

;;; avy
(unless (package-installed-p 'avy)
  (package-install 'avy-isearch))
(global-set-key (kbd "C-;") 'avy-goto-char-2)

;; Bind the `magit-status' command to a convenient key.
(global-set-key (kbd "C-c g") #'magit-status)

;; Find definitions!
(global-set-key (kbd "M-.") 'xref-find-definitions-other-window)
;; Find references!
(global-set-key (kbd "M-?") 'xref-find-references)
;; Search in file (C-s) see consult configuration above
;; Scan by syntactically relevant constructs (C-c i) consult-imenu
;; Grep project for a term
(global-set-key (kbd "C-c s") 'projectile-ripgrep) 
;; Find header/cpp file in other window
(global-set-key (kbd "C-c o") 'projectile-find-other-file-other-window)
;; Run the compile command from the root directory of the project
(global-set-key (kbd "C-c c") 'projectile-compile-project)
;; Run the test command from the root directory of the project 
(global-set-key (kbd "C-c t") 'projectile-test-project)
;; Is there a project wide fuzzy search?

;; Miscellaneous options
(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))
(setq confirm-kill-emacs #'yes-or-no-p)
(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(defalias 'yes-or-no #'y-or-n-p)

;; Store automatic customisation options elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
