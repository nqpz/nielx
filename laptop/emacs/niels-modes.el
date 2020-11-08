;; Asciidoc.
(add-to-list 'auto-mode-alist '("\\.asciidoc\\'" . adoc-mode))
(add-hook 'adoc-mode-hook
          (lambda ()
            (setq-local comment-auto-fill-only-comments nil)))

;; CUDA.
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cu.h\\'" . c++-mode))

;; Prolog.
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

;; YAML.
(add-to-list 'auto-mode-alist '("\\.media\\'" . yaml-mode))

;; Haskell.
(setq haskell-process-type 'stack-ghci)
(setq haskell-process-path-ghci "stack exec ghci")
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; OCaml.

(let ((merlin-root (getenv "OCAML_MERLIN")))
  (add-to-list 'load-path (concat merlin-root "/share/emacs/site-lisp"))
  (setq merlin-command (concat merlin-root "/bin/ocamlmerlin"))
  (autoload 'merlin-mode "merlin" "Merlin mode" t)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (add-hook 'caml-mode-hook 'merlin-mode))

;; StumpWM.
(setq stumpwm-shell-program "/run/current-system/sw/bin/stumpish")

;; When returning from emacsclient.
(if window-system (add-hook 'server-done-hook (lambda () (shell-command
    "stumpish 'eval (stumpwm::return-es-called-win stumpwm::*es-win*)' >/dev/null 2>/dev/null"))))

(defun stumpwm-echo (message)
  "Echoes a string in StumpWM."
  (interactive "sEcho: ")
  (start-process "stumpwm-echo" nil "stumpish" "echo" message))

;; Futhark.
(require 'futhark-mode)

;;; APL.
(add-hook 'gnu-apl-mode-hook (lambda () (set-input-method "APL-Z")))
(add-hook 'gnu-apl-interactive-mode-hook (lambda () (set-input-method "APL-Z")))

;; Email.
(add-to-list 'auto-mode-alist '("neomutt-svin" . mail-mode))
(add-hook 'mail-mode-hook
          (lambda ()
            (setq-local comment-auto-fill-only-comments nil)
            (setq fill-column 72)))

;; Markdown.
(add-hook 'markdown-mode-hook
          (lambda ()
            (setq fill-column 72)))

;; HTML.
(add-hook 'html-mode-hook
          (lambda ()
            (setq-local comment-auto-fill-only-comments nil)))

;; OpenCL.
(add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))

(provide 'niels-modes)
