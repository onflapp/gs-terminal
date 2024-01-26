(xterm-mouse-mode 1)
(menu-bar-mode -1)
(global-set-key "\C-x\M-c" 'kill-emacs)
(global-set-key (kbd "\e[1;0C~") 'emacsgs-copy-cmd)
(global-set-key (kbd "\e[1;0S~") 'emacsgs-selection-cmd)
(global-set-key (kbd "\e[1;0P~") 'emacsgs-paste-cmd)

(setq mylasttitle "")

;(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
;(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

(defun xterm-title-update ()
  (interactive)
  (when (not(string-equal mylasttitle (buffer-name)))
    (send-gstitle-update)
    (setq mylasttitle (buffer-name))
  )
)
    
(defun send-gstitle-update ()
  (send-string-to-terminal (concat "\033]0; " (buffer-name) "\007"))
  (when buffer-file-name
    (send-string-to-terminal (concat "\033]X;PATH-" (buffer-file-name) "\007"))
    ;(send-string-to-terminal (concat "\033]1; " (buffer-name) "\007"))
  )
)
   
(defun emacsgs-copy-cmd ()
  (interactive)
  (setq f (substitute-in-file-name "$EMACSGS_COPY_FILE"))
  (write-region (region-beginning) (region-end) f)
  (send-string-to-terminal (concat "\033]X;COPY\007"))
)

(defun emacsgs-selection-cmd ()
  (interactive)
  (setq f (substitute-in-file-name "$EMACSGS_COPY_FILE"))
  (write-region (region-beginning) (region-end) f)
  (send-string-to-terminal (concat "\033]X;SELECTION\007"))
)

(defun emacsgs-paste-cmd ()
  (interactive)
  (setq f (substitute-in-file-name "$EMACSGS_PASTE_FILE"))
  (insert-file-contents f)
)

(add-hook 'post-command-hook 'xterm-title-update)

(setf inhibit-splash-screen t)
(switch-to-buffer (get-buffer-create "Untitled"))
(delete-other-windows)
