
;;------------------------------------------------------
;; transparency
(global-set-key [(f9)] 'loop-alpha)
(setq alpha-list '((95 90) (100 100)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
  )

;; setup GADB
;; use gdb-many-windows by default
;; Non-nil means display source file containing the main routine at startup
(setq gdb-many-windows t gdb-show-main t )

;;  highlight mode
(global-hl-line-mode 1)
(set-face-background 'hl-line "#0d0f16")


;;  title

(setq frame-title-format
      (list "Shawb@"
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))





;; disable menu-bar
(menu-bar-mode -1)

;;set the cursor as bar and cyan
(setq-default cursor-type 'bar)

;; set default size
(setq default-frame-alist
      '((height . 50) (width . 80)))
(set-frame-position (selected-frame) 900 50)


;; gdb shortcut key
(global-set-key [(f7)] 'gud-next)
(global-set-key [(f6)] 'gud-step)

;; Chinese font
(set-fontset-font "fontset-default" 'unicode '("WenQuanYi Zen Hei"))

;;no auto-save file
(setq auto-save-default nil) ;; 默认值是t， 要关闭直接用nil更改默认值
;; no backup
(setq make-backup-files nil)
;关闭自动保存模式
(setq auto-save-mode nil)

;; F4 to open eshell
(global-set-key [f4] 'eshell)



(provide `init-local)


