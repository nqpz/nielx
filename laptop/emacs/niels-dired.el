(require 'dired)
(require 'dired-x)

(add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

(define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
(define-key dired-mode-map (kbd "#") 'dired-run-program-on-current)
(define-key dired-mode-map (kbd "z") 'dired-run-o-on-current)
(define-key dired-mode-map (kbd "r") 'dired-run-vc-rename-on-current)
(define-key dired-mode-map (kbd "b") 'dired-run-git-rename-on-current)

(defun dired-run-program-on-current (prog)
  (interactive "sProgram: ")
  (let ((name (car (dired-get-marked-files))))
    (start-process prog nil prog name)))

(defun dired-run-o-on-current ()
  (interactive)
  (let ((name (car (dired-get-marked-files))))
    (start-process "o" nil "o" name)))

(defun is-in-git (path)
  (= 0 (call-process "git" nil nil nil
                     "-C" (file-name-directory (expand-file-name path))
                     "ls-files" path "--error-unmatch")))

(defun git-rename-file (old new)
  (message old)
  (message new)
  (call-process "git" nil nil nil
                "-C" (file-name-directory (expand-file-name old))
                "mv" old new))

(defun dired-run-git-rename-on-current ()
  (interactive)
  (let ((name (car (dired-get-marked-files))))
    (if (is-in-git name)
        (let ((name-new (read-file-name (concat "Rename in git: "))))
          (git-rename-file name (expand-file-name name-new))
          (revert-buffer))
      (dired-do-rename name))))

;; Does not work on directories.
(defun dired-run-vc-rename-on-current ()
  (interactive)
  (let ((name (car (dired-get-marked-files))))
    (if (vc-state name)
        (let ((name-new (read-file-name (concat "Rename in VC: "))))
          (vc-rename-file name name-new)
          (revert-buffer))
      (dired-do-rename name))))

(defun kill-all-dired-buffers ()
  (interactive)
  (mapc (lambda (buffer)
          (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
            (kill-buffer buffer)))
        (buffer-list)))

(provide 'niels-dired)
