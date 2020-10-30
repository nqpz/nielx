(global-set-key (kbd "C-<") 'undo-tree-undo)
(global-set-key (kbd "C->") 'undo-tree-redo)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-å") 'smex)
(global-set-key (kbd "C-.") 'dabbrev-expand)
(global-set-key (kbd "M-,") 'switch-to-buffer)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-å") 'switch-to-other-buffer)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-~") 'insert-tab)
(global-set-key (kbd "C-k") 'kill-and-join-forward)
(global-set-key (kbd "C-M-<") 'duplicate-line)
(global-set-key (kbd "C-S-y") 'clipboard-yank)
(global-set-key (kbd "C-M-S-k") 'kill-line)
(global-set-key (kbd "C-c q") 'calcy)
(global-set-key [f9] 'erc-join-all)
(global-set-key (kbd "C-M-)") 'erc-quit-all)
(global-set-key (kbd "s-<") 'forward-paragraph)
(global-set-key (kbd "s->") 'backward-paragraph)
(global-set-key (kbd "C-S-k") 'kill-this-buffer)
(global-set-key (kbd "s-+") 'global-font-height-increase)
(global-set-key (kbd "s-?") 'global-font-height-decrease)
(global-set-key (kbd "s-~") 'global-font-height-reset)
(global-set-key (kbd "M-Q") 'unfill-region)
(global-set-key (kbd "s-g") 'customize-group)
(global-set-key (kbd "C-c m") '(lambda () (interactive) (compile "make")))
(global-set-key (kbd "C-c RET") '(lambda () (interactive) (and (compile "make"))))

(provide 'niels-bindings)