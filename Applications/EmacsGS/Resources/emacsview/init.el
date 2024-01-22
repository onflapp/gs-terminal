(xterm-mouse-mode 1)
(global-set-key "\C-x\M-c" 'kill-emacs)
;(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
;(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

  (defun xterm-title-update ()
    (interactive)
    (send-string-to-terminal (concat "\033]1; " (buffer-name) "\007"))
    (if buffer-file-name
        (send-string-to-terminal (concat "\033]2; " (buffer-file-name) "\007"))
        (send-string-to-terminal (concat "\033]2; " (buffer-name) "\007"))))
   
  (add-hook 'post-command-hook 'xterm-title-update)
