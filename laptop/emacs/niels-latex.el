(setq cdlatex-env-alist
      '(("axiom" "\\begin{axiom}\nAUTOLABEL\n?\n\\end{axiom}\n" nil)
        ("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil)
        ("matrix*" "\\begin{matrix*}[r]\n?\n\\end{matrix*}" nil)
        ("pmatrix*" "\\begin{pmatrix*}[r]\n?\n\\end{pmatrix*}" nil)
        ("bmatrix*" "\\begin{bmatrix*}[r]\n?\n\\end{bmatrix*}" nil)
        ("Bmatrix*" "\\begin{Bmatrix*}[r]\n?\n\\end{Bmatrix*}" nil)
        ("vmatrix*" "\\begin{vmatrix*}[r]\n?\n\\end{vmatrix*}" nil)
        ("gmatrix" "\\begin{gmatrix}[p]\n?\n\\end{gmatrix}" nil)
        ("verbatim" "\\begin{verbatim}\n?\n\\end{verbatim}" nil)
        ("description" "\\begin{description}\n\\item[?]\n\\end{description}" nil)
        ("frame" "\\begin{frame}\n\\frametitle{?}\n\\end{frame}" nil)
        ("tabular" "\\begin{tabular}{?}\n\n\\end{tabular}" nil)
        ("verse" "\\begin{verse}\n?\n\\end{verse}" nil)
        ("enum" "\\begin{enumerate}\n\\item ?\n\\end{enumerate}" nil)
        ("fig" "\\begin{figure}\n?\\end{figure}" nil)
        ))

(setq cdlatex-command-alist
      '(("ve" "Insert \\vec{}" "\\vec{?}" cdlatex-position-cursor nil t t)
        ("uu" "Insert \\uuline{}" "\\uuline{?}" cdlatex-position-cursor nil t t)
        ("u" "Insert \\underline{}" "\\underline{?}" cdlatex-position-cursor nil t t)
        ("cd" "Insert \\cdot" "\\cdot" cdlatex-position-cursor nil t t)
        ("tim" "Insert \\times" "\\times" cdlatex-position-cursor nil t t)

        ("tt" "" "\\texttt{?}" cdlatex-position-cursor nil t t)
        ("ttm" "" "\\textttm{?}" cdlatex-position-cursor nil t t)
        ("rm" "" "\\textrm{?}" cdlatex-position-cursor nil t t)
        ("rmm" "" "\\textrmm{?}" cdlatex-position-cursor nil t t)
        ("em" "" "\\emph{?}" cdlatex-position-cursor nil t t)
        ("tb" "" "\\textbf{?}" cdlatex-position-cursor nil t t)

        ("alia" "Insert align* env" "" cdlatex-environment ("align*") t nil)
        ("axm" "Insert axiom env" "" cdlatex-environment ("axiom") t t)
        ("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t t)
        ("mma" "Insert matrix* env" "" cdlatex-environment ("matrix*") t t)
        ("pma" "Insert pmatrix* env" "" cdlatex-environment ("pmatrix*") t t)
        ("sma" "Insert bmatrix* env" "" cdlatex-environment ("bmatrix*") t t)
        ("cma" "Insert Bmatrix* env" "" cdlatex-environment ("Bmatrix*") t t)
        ("ama" "Insert vmatrix* env" "" cdlatex-environment ("vmatrix*") t t)
        ("gma" "Insert gmatrix env" "" cdlatex-environment ("gmatrix") t t)
        ("ver" "Insert verbatim env" "" cdlatex-environment ("verbatim") t t)
        ("all" "Insert alltt env" "" cdlatex-environment ("alltt") t t)
        ("cod" "Insert code env" "" cdlatex-environment ("code") t t)
        ("desc" "Insert description env" "" cdlatex-environment ("description") t t)
        ("frm" "Insert frame env" "" cdlatex-environment ("frame") t t)
        ("tab" "Insert tabular env" "" cdlatex-environment ("tabular") t t)
        ("verse" "Insert verse env" "" cdlatex-environment ("verse") t t)

        ("sn" "Insert section" "\\section{?}" cdlatex-position-cursor nil t t)
        ("ss" "Insert subsection" "\\subsection{?}" cdlatex-position-cursor nil t t)
        ("sss" "Insert subsubsection" "\\subsubsection{?}" cdlatex-position-cursor nil t t)

        ("vect" "Insert vector with numbers" "\\vect{?}" cdlatex-position-cursor nil t t)
        ("ln" "Insert ln" "\\ln(?)" cdlatex-position-cursor nil t t)
        ("lnl" "Insert long ln" "\\ln\\left(?\\right)" cdlatex-position-cursor nil t t)
        ("log" "Insert log" "\\log(?)" cdlatex-position-cursor nil t t)
        ("logl" "Insert long log" "\\log\\left(?\\right)" cdlatex-position-cursor nil t t)
        ("vangle" "Insert formula for angle between two vectors" "\\vangle{?}{?}" cdlatex-position-cursor nil t t)
        ("distpopo" "Insert formula for distance between two points" "\\distpopo{?}{?}" cdlatex-position-cursor nil t t)
        ("distpopl" "Insert formula for distance between a point and a plane" "\\distpopl{?}{?}" cdlatex-position-cursor nil t t)
        ("distpoli" "Insert formula for distance between a point and a line" "\\distpoli{?}{?}" cdlatex-position-cursor nil t t)
        ("distlili" "Insert formula for distance between two lines" "\\distlili{?}{?}" cdlatex-position-cursor nil t t)
        ("vanglea" "Insert generic formula for angle between two vectors" "\\vangle*" cdlatex-position-cursor nil t t)
        ("distpopoa" "Insert generic formula for distance between two points" "\\distpopo*" cdlatex-position-cursor nil t t)
        ("distpopla" "Insert generic formula for distance between a point and a plane" "\\distpopl*" cdlatex-position-cursor nil t t)
        ("distpolia" "Insert generic formula for distance between a point and a line" "\\distpoli*" cdlatex-position-cursor nil t t)
        ("distlilia" "Insert generic formula for distance between two lines" "\\distlili*" cdlatex-position-cursor nil t t)
        ("veb" "Insert verb" "\\verb+?+" cdlatex-position-cursor nil t t)
        ))

(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (turn-on-cdlatex)
            (setq-local comment-auto-fill-only-comments nil)))

(condition-case nil
    (cdlatex-reset-mode)
  (error))

(provide 'niels-latex)
