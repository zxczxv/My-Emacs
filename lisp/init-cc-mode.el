(defun c-wx-lineup-topmost-intro-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "EVT_" (line-end-position) t)
      'c-basic-offset
      (c-lineup-topmost-intro-cont langelem))))

;; avoid default "gnu" style, use more popular one
(setq c-default-style "linux")

;C/C++ SECTION
(defun my-c-mode-hook ()
  (interactive)
  (message "my-c-mode-hook called (buffer-file-name)=%s" (buffer-file-name))
  ;; @see http://stackoverflow.com/questions/3509919/ \
  ;; emacs-c-opening-corresponding-header-file
  (local-set-key (kbd "C-x C-o") 'ff-find-other-file)

  (setq cc-search-directories '("." "/usr/include" "/usr/local/include/*" "../*/include" "$WXWIN/include"))
  (setq c-basic-offset 4)

  ;; give me NO newline automatically after electric expressions are entered
  (setq c-auto-newline nil)

  ; @see http://xugx2007.blogspot.com.au/2007/06/benjamin-rutts-emacs-c-development-tips.html
  (setq compilation-window-height 8)
  (setq compilation-finish-function
        (lambda (buf str)
          (if (string-match "exited abnormally" str)
              ;;there were errors
              (message "compilation errors, press C-x ` to visit")
            ;;no errors, make the compilation window go away in 0.5 seconds
            (when (string-match "*compilation*" (buffer-name buf))
              ;; @see http://emacswiki.org/emacs/ModeCompile#toc2
              (bury-buffer "*compilation*")
              (winner-undo)
              (message "NO COMPILATION ERRORS!")
              ))))

  ;; wxWidgets setup
  (c-set-offset 'topmost-intro-cont 'c-wx-lineup-topmost-intro-cont)

  ;; syntax-highlight aggressively
  ;; (setq font-lock-support-mode 'lazy-lock-mode)
  (setq lazy-lock-defer-contextually t)
  (setq lazy-lock-defer-time 0)

  ;make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ;; make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  (autoload 'c-turn-on-eldoc-mode "c-eldoc" "" t)

  (when buffer-file-name
    ;; c-eldoc (https://github.com/mooz/c-eldoc)
    (c-turn-on-eldoc-mode)

    ;; @see https://github.com/seanfisk/cmake-flymake
    ;; make sure you project use cmake
    (flymake-mode 1)
    (if (executable-find "cmake")
        (if (not (or (string-match "^/usr/local/include/.*" buffer-file-name)
                     (string-match "^/usr/src/linux/include/.*" buffer-file-name)))
            (cppcm-reload-all)))
    ))

(defun fix-c-indent-offset-according-to-syntax-context (key val)
  ;; remove the old element
  (setq c-offsets-alist (delq (assoc key c-offsets-alist) c-offsets-alist))
  ;; new value
  (add-to-list 'c-offsets-alist '(key . val)))

;; donot use c-mode-common-hook or cc-mode-hook because many major-modes use this hook
(add-hook 'c-mode-common-hook
          (lambda ()
            (unless (is-buffer-file-temp)
              ;; indent
              (fix-c-indent-offset-according-to-syntax-context 'substatement 0)
              (fix-c-indent-offset-according-to-syntax-context 'func-decl-cont 0)
              ;; gtags (GNU global) stuff
              (setq gtags-suggested-key-mapping t)
              (unless (derived-mode-p 'java-mode)
                (my-c-mode-hook))
              (ggtags-mode 1)
              ;; emacs 24.4+ will set up eldoc automatically.
              ;; so below code is NOT needed.
              (setq-local eldoc-documentation-function #'ggtags-eldoc-function)
              )))

(provide 'init-cc-mode)
