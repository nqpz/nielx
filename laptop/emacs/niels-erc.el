(add-hook 'erc-mode-hook 'toggle-word-wrap)

(defvar niels-erc-hosts
  "List of IRC hosts to connect to")

(defun erc-join-all ()
  "Join all IRC hosts."
  (interactive)
  (mapc #'(lambda (x)
            (erc-tls :server (elt x 0) :port (elt x 1) :password (elt x 2)
                     :nick (elt x 3) :full-name (elt x 4)))
        niels-erc-hosts))

(defun erc-quit-all ()
  "Quit all IRC hosts."
  (interactive)
  (mapc #'(lambda (x)
            (kill-buffer (elt x 5)))
        niels-erc-hosts))

(provide 'niels-erc)
