;; Add Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Disable Menu Items
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Disable Backup files
(setq make-backup-files nil)

;; Enable Evil mode
(require 'evil)
(evil-mode 1)

;; Enable Gruvbox
(load-theme 'gruvbox t)
