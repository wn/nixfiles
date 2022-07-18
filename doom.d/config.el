;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Ang Wei Neng"
      user-mail-address "weineng.a@gmail.com"
      doom-scratch-initial-major-mode 'lisp-interaction-mode
      ;; doom-font (font-spec :family "Dank Mono" :size 16)
      ;;doom-variable-pitch-font (font-spec :family "Roboto" :size 16)
      ;;doom-serif-font (font-spec :family "Libre Baskerville")
      doom-theme 'doom-dracula
      display-line-numbers-type t
      load-prefer-newer t
      +zen-text-scale 1
      writeroom-extra-line-spacing 0.3

      lsp-ui-sideline-enable nil
      lsp-enable-symbol-highlighting nil
      search-highlight t
      search-whitespace-regexp ".*?"
      org-directory "~/.org/"
      org-ellipsis " ▼ "
      org-adapt-indentation nil
      org-habit-show-habits-only-for-today t)
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;aoeu aoeu
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package swiper
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    ))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key (kbd "C-o") 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

;; MacOS specific error: Cannot find gls (GNU ls). This may cause issues with dired
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; resize window
(global-set-key (kbd "<M-up>") (lambda () (interactive) (shrink-window 5)))
(global-set-key (kbd "<M-down>") (lambda () (interactive) (enlarge-window 5)))
(global-set-key (kbd "<M-left>") (lambda () (interactive) (shrink-window-horizontally 5)))
(global-set-key (kbd "<M-right>") (lambda () (interactive) (enlarge-window-horizontally 5)))

(use-package! easy-kill
  :bind*
  (([remap kill-ring-save] . easy-kill)))

(defun insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(map!
 [C-tab] #'+fold/toggle
 [C-iso-lefttab] #'+fold/close-all)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-x |") 'toggle-window-split)
