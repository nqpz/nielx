;; Press y and n instead of typing yes and no.
(fset 'yes-or-no-p 'y-or-n-p)

;; Shorter window title
(setq frame-title-format '("emacs: " "%b"))

;; Update the mode line to have line number and column number.
(setq mode-line-position
      '("%p (%l," (:eval (format "%d)" (1+ (current-column))))))

;; Force the update of the mode line so the column gets updated.
(add-hook 'post-command-hook 'force-mode-line-update)

;; Optional trailing whitespace deletion.
(defun has-trailing-whitespace ()
  (save-excursion
    (or (search-forward-regexp " $" (point-max) t)
        (search-backward-regexp " $" 0 t))))

(defun ask-delete-trailing-whitespace ()
  (when (and (has-trailing-whitespace)
             (y-or-n-p "Delete trailing whitespace?"))
    (delete-trailing-whitespace)))

(defun add-trailing-whitespace-hook (hook)
  (add-hook hook
            (lambda()
              (add-hook 'write-contents-functions
                        (lambda()
                          (save-excursion
                            (ask-delete-trailing-whitespace)))
                        nil t))))


(defun dos-to-unix ()
  "Convert DOS line endings to UNIX line endings."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix))

(defun switch-to-other-buffer ()
  "Switch to the recently visited buffer in the current frame."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun calcy ()
  "Run Emacs Calc on a line."
  (interactive)
  (save-excursion
    (end-of-line)
    (setq end (point))
    (beginning-of-line)
    (setq start (point))
    (calc-embedded start end)
    (calc-embedded start end)))


(defun camelCase-to-sep-region (start end &optional sep)
  "Convert all camelCase strings (not CamelCase strings) in the region to
lowercase strings with separators (defaults to underscores)."
  (interactive "r")
  (let ((case-fold-search nil)
        (sep (or sep "_"))
        (cam-reg0 "\\([a-z0-9]+\\)\\([A-Z]\\)")
        (cam-reg1 "\\([[:space:]\\.:\\-\\+\\*/(\\\\]+[a-z0-9]+\\)\\([A-Z]\\)"))
    (defun replace-with-sep ()
      (replace-match (concat (match-string 1) sep (downcase (match-string 2))))
      (setq end (+ end 1)))
    (defun replace-with-seps ()
      (replace-with-sep)
      (while (looking-at cam-reg0)
        (replace-with-sep)))
    (save-excursion
      (goto-char start)
      (if (looking-at cam-reg0)
          (replace-with-seps))
      (while (< (point) end)
        (if (looking-at cam-reg1)
            (replace-with-seps)
          (forward-char 1))))))

(defun sep-to-camelCase-region (start end &optional sep)
  "Convert all lowercase strings with separators (defaults to underscores) in
the region to camelCase strings (not CamelCase strings)."
  (interactive "r")
  (let ((case-fold-search nil)
        (sep (or sep "_"))
        (sep-reg0 (concat "\\([a-z0-9]+\\)" sep "\\([a-z]\\)"))
        (sep-reg1 (concat "\\([[:space:]\\.:\\-\\+\\*/(\\\\]+[a-z0-9]+\\)"
                          sep "\\([a-z0-9]\\)")))
    (defun replace-with-cam ()
      (replace-match (concat (match-string 1) (upcase (match-string 2))))
      (setq end (- end 1)))
    (defun replace-with-cams ()
      (replace-with-cam)
      (while (looking-at sep-reg0)
        (replace-with-cam)))
    (save-excursion
      (goto-char start)
      (if (looking-at sep-reg0)
          (replace-with-cams))
      (while (< (point) end)
        (if (looking-at sep-reg1)
            (replace-with-cams)
          (forward-char 1))))))


;; Buffer things.

(require 'window-margin)

(defun unfill-region (start end)
  "Takes multi-line paragraphs and makes it into single lines of text."
  (interactive "r")
  (let ((fill-column (point-max)))
    (fill-region start end)))

(defun kill-and-join-forward (&optional arg)
  "Kill a line and delete eventual whitespace."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))

(defun duplicate-line ()
  "Duplicate a line."
  (interactive)
  (save-excursion
    (end-of-line)
    (if (equal (point) (buffer-end 1))
        (insert "\n")))
  (let ((kill-read-only-ok t))
    (toggle-read-only 1)
    (kill-whole-line)
    (toggle-read-only 0)
    (yank)
    (backward-char)
    (beginning-of-line)))

(defun buffer-mode (&optional buffer-or-string)
  "Return the major mode associated with a buffer."
  (with-current-buffer (or buffer-or-string (current-buffer))
    major-mode))

(defun kill-matching-paths-buffers-ask (regexp)
  "Kill buffers whose path matches the specified REGEX if no objection."
  (interactive "sKill buffers whose path matches this regular expression: \n")
  (dolist (buffer (buffer-list))
    (let ((name (buffer-file-name buffer)))
      (when (and name (not (string-equal name ""))
                 (or (/= (aref name 0) ?\s))
                 (string-match regexp name))
        (kill-buffer-ask buffer)))))

(defun brian-compile-finish (buffer outstr)
  (unless (string-match "finished" outstr)
    (switch-to-buffer-other-window buffer))
  t)

(setq compilation-finish-functions 'brian-compile-finish)

(defadvice compilation-start
  (around inhibit-display
      (command &optional mode name-function highlight-regexp))
  (if (not (string-match "^\\(find\\|grep\\)" command))
      (cl-letf ((display-buffer   #'ignore)
                (set-window-point #'ignoreco)
                (goto-char        #'ignore))
        (save-window-excursion
          ad-do-it))
    ad-do-it))

(ad-activate 'compilation-start)

(provide 'niels-misc)
