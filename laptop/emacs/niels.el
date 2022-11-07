;;; niels.el --- niels' config  -*- lexical-binding: t; -*-

;; URL: https://metanohi.name/
;; Keywords: local
;; Version: 0.1
;; Package-Requires: ((emacs "24.3"))

;; This file is not part of GNU Emacs.

;;; Commentary:
;; Niels' Emacs config!

;;; Code:

;; Load all installed packages.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Support loading packages not in the package manager.
(add-to-list 'load-path (concat user-emacs-directory "local-lisp"))
(add-to-list 'load-path (concat user-emacs-directory "local-lisp/futhark-mode"))

;; Font
(set-face-attribute 'default nil :family "DejaVu Sans Mono")
(require 'unicode-fonts)
(unicode-fonts-setup)
;; Specify font for Unicode emojis.
;; (when (member "Symbola" (font-family-list))
;;   (set-fontset-font t 'unicode "Symbola" nil 'prepend))
(set-face-attribute 'default nil :height 110)

;; Define the necessary variables for certain things to work.
(defvar niels-hostname)

;; Fill in the variables with private details.
(load (concat user-emacs-directory "private-details"))

;; Misc. settings and functions.  I don't think I need all of this.
(require 'niels-misc)

;; This one also has some old code in it.
(require 'niels-latex)

;; Extend dired with some nice-to-haves.  Also some old cruft.
(require 'niels-dired)

;; Do small mode adjustments.
(require 'niels-modes)

;; IRC!
(require 'niels-erc)

;; More global keybindings.
(require 'niels-bindings)

;; Enable or disable auto fill in text-related modes.
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(add-hook 'markdown-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(add-hook 'fountain-mode-hook 'turn-off-auto-fill)

;; Enable Flycheck for certain modes.
(setq-default flycheck-emacs-lisp-load-path 'inherit)
;(add-hook 'haskell-mode-hook 'flycheck-mode) ; way too slow!
(add-hook 'futhark-mode-hook 'flycheck-mode)
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

;; Ask to remove trailing whitespace in certain modes.
(add-trailing-whitespace-hook 'emacs-lisp-mode-hook)
(add-trailing-whitespace-hook 'futhark-mode-hook)
(add-trailing-whitespace-hook 'c-mode-hook)
(add-trailing-whitespace-hook 'haskell-mode-hook)
(add-trailing-whitespace-hook 'prolog-mode-hook)
(add-trailing-whitespace-hook 'nix-mode-hook)

;; Use C-x k instead of C-x # to end an emacsclient session
(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
              (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit))))

;; Run an Emacs server if it is not already running.
(condition-case nil
    (unless (server-running-p) (server-start))
  (error (server-start)))

;; Load settings set by Customize.
(load (concat user-emacs-directory "customize-save"))

(provide 'niels)
;;; niels.el ends here
