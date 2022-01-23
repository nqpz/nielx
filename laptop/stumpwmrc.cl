(in-package :stumpwm)

(set-prefix-key (kbd "C-t"))

;; Utils
(defcommand sh (command)
  ((:rest "sh: "))
  (run-shell-command command))

;; No startup message
(setf *startup-message* nil)

;; Macro for creating shell-accessing functions
(defmacro shelldef (name command)
  `(defcommand ,name (&optional arg) (:rest)
     (echo-string (current-screen)
                  (run-shell-command (concatenate 'string ,command " " arg) t))))

;; Shell-accessing functions
(shelldef battery "battery")
(shelldef checkmail "checkmail")
(shelldef radioalfa "radioswitch radioalfa")
(shelldef rivieraradio "radioswitch rivieraradio")
(shelldef radiostop "radioswitch _stop")
(shelldef discofetish "radioswitch discofetish")
(define-key *root-map* (kbd "C-.") "battery")
(define-key *root-map* (kbd "C-o") "checkmail")
(define-key *root-map* (kbd "C-F1") "radioalfa")
(define-key *root-map* (kbd "C-F2") "rivieraradio")
(define-key *root-map* (kbd "C-F3") "radiostop")
(define-key *root-map* (kbd "C-F4") "discofetish")

;; Misc. bindings
(define-key *root-map* (kbd "SunAltGraph") "sh")
(define-key *root-map* (kbd "EuroSign") "select")
(define-key *top-map* (kbd "S-M-SPC") "prev-in-frame")
(define-key *top-map* (kbd "M-SPC") "next-in-frame")
(define-key *root-map* (kbd ";") "colon")
(define-key *root-map* (kbd "C-;") "colon")
(define-key *root-map* (kbd "h") "select")
(define-key *root-map* (kbd ":") "eval")
(define-key *root-map* (kbd "C-:") "eval")
(define-key *root-map* (kbd "M-<") "gnext")
(define-key *root-map* (kbd "M-~") "gprev")
(define-key *top-map* (kbd "C-M-S-Right") "gnext-with-window")
(define-key *top-map* (kbd "C-M-S-Left") "gprev-with-window")

;; Emacs window memory hackery
(defvar *es-win* nil
  "to hold the window called by stumpemacsclient")
(defun save-es-called-win ()
  (setf *es-win* (current-window)))

(defun return-es-called-win (win)
  (let* ((group (window-group win))
         (frame (window-frame win))
         (old-frame (tile-group-current-frame group)))
    (frame-raise-window group frame win)
    (focus-all win)
    (unless (eq frame old-frame)
      (show-frame-indicator group))))

;; Message window settings
(set-bg-color "Black")
(set-fg-color "White")
(set-border-color "Grey")
(set-msg-border-width 2)
(set-focus-color "DarkGreen")
(setf *message-window-padding* 1)
(setf *maxsize-border-width* 0)
(setf *normal-border-width* 0)
(setf *transient-border-width* 2)
(setf *window-border-style* :thin)
(setf *mouse-focus-policy* :click)
(setf stumpwm:*mode-line-position* :bottom)

;; Programs
(defcommand terminal () ()
  (run-or-raise "terminator" '(:class "Terminator")))
(defcommand firefox () ()
  (run-or-raise "firefox" '(:class "Firefox")))
(defcommand zathura () ()
  (run-or-raise "zathura" '(:class "Zathura")))
(defcommand chromium () ()
  (run-or-raise "chromium-browser" '(:title "Chromium")))
(defcommand emacs () ()
  (run-or-raise "emacs" '(:class "Emacs")))
(defcommand pavucontrol () ()
  (run-or-raise "pavucontrol" '(:title "Volume Control")))

(define-key *root-map* (kbd "<") "terminal")
(define-key *root-map* (kbd ">") "firefox")
(define-key *root-map* (kbd "aring") "zathura")
(define-key *root-map* (kbd "c") "chromium")
(define-key *root-map* (kbd "C-<") "terminal")
(define-key *root-map* (kbd "C->") "firefox")
(define-key *root-map* (kbd "C-aring") "zathura")
(define-key *root-map* (kbd "C-c") "chromium")
(define-key *root-map* (kbd "C-p") "pavucontrol")
(shelldef screenshot "screenshot")
(define-key *top-map* (kbd "F10") "screenshot")

;; Groups
(gnew "Left")
(gnew "Middle")
(gnew "Right")
(run-commands "gselect Middle")
(run-commands "banish")

(define-key *top-map* (kbd "s-h") "gselect Left")
(define-key *top-map* (kbd "s-t") "gselect Middle")
(define-key *top-map* (kbd "s-n") "gselect Right")

;; Startup programs
(emacs)
(firefox)
(terminal)
