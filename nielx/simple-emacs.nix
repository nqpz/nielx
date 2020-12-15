{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nielx.simple-emacs;
in
{
  options.nielx.simple-emacs = {
    enable = mkEnableOption "a basic console Emacs setup";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays =
      [ (self: super:
        {
          emacs = (pkgs.emacsPackagesFor ((super.emacs.override {
            withX = false;
            withGTK3 = false;
          }).overrideAttrs (attrs: {
            postInstall = (attrs.postInstall or "") + ''
      cat > $out/share/emacs/site-lisp/default.el <<EOF
      (require 'undo-tree)
      (global-undo-tree-mode)

      (defun switch-to-other-buffer ()
        "Switch to the recently visited buffer in the current frame."
        (interactive)
        (switch-to-buffer (other-buffer)))

      (setq backup-by-copying t)
      (setq backup-directory-alist (quote ((".*" . "~/.emacs-backup"))))

      (global-set-key (kbd "M-g") 'goto-line)
      (global-set-key (kbd "M-x") 'smex)
      (global-set-key (kbd "C-.") 'dabbrev-expand)
      (global-set-key (kbd "M-,") 'switch-to-buffer)
      (global-set-key (kbd "M-o") 'other-window)
      (global-set-key (kbd "M-å") 'switch-to-other-buffer)
      (global-set-key (kbd "RET") 'newline-and-indent)
      EOF
    '';
          }))).emacsWithPackages (epkgs: with epkgs; [
            undo-tree
            ack
            smex
            nix-mode
            magit
            org
            markdown-mode
            multiple-cursors
          ]);
        })
      ];
  };
}
