;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Ang Wei Neng"
      user-mail-address "weineng@twosigma.com"
      doom-scratch-buffer-major-mode 'org-mode
      doom-font (font-spec :family "JetBrains Mono" :weight 'light :size 13)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :weight 'light)
      doom-serif-font (font-spec :family "Iosevka" :weight 'light)
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

(use-package swiper
  :ensure t
  :config
  (progn
    (global-set-key "\C-s" 'swiper)
    ))
(map! :map pdf-isearch-minor-mode-map "C-s" #'isearch-forward)

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key (kbd "M-o") 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

;; MacOS specific error: Cannot find gls (GNU ls). This may cause issues with dired
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; resize window
(global-set-key (kbd "C-<up>") (lambda () (interactive) (shrink-window 5)))
(global-set-key (kbd "C-<down>") (lambda () (interactive) (enlarge-window 5)))
(global-set-key (kbd "C-<left>") (lambda () (interactive) (shrink-window-horizontally 5)))
(global-set-key (kbd "C-<right>") (lambda () (interactive) (enlarge-window-horizontally 5)))

(defun open-scratch-org ()
  "open a scratch file for quick writing of notes"
  (interactive)
  (setq org-scratch-file "~/org/scratch.org")
  (if (not (file-exists-p org-scratch-file)) (dired-create-empty-file org-scratch-file))
  (find-file org-scratch-file))


(defun insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(map!
 [C-tab] #'+fold/toggle
 [C-iso-lefttab] #'+fold/close-all
 [C-M-tab] #'+fold/open-all)

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

;; two sigma specific to connect to external services
(setq url-proxy-services (quote (
    ("http" . "127.0.0.1:20001")
    ("https" . "127.0.0.1:20001")
    ("no_proxy" . "\\(localhost\\|127.0.0.1\\|.*\\.twosigma\\.com\\)")
)))

(setq super-save-auto-save-when-idle t)
(setq auto-save-default t) ;; disable by default

(map! "C-c g" #'magit-status
      "C-c B" #'magit-blame-addition)

(global-set-key (kbd "<escape>") 'doom/escape)

(map! "C-x C-k" #'centaur-tabs--kill-this-buffer-dont-ask)
(map! "C-o" #'other-window)

(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
(setq org-reveal-mathjax t)
(require 'ox-reveal)

;; improve scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

;; open emacs in fullscreen mode
;; (set-frame-parameter (select-frame) 'fullscreen 'maximized)
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

(map! "M-z" #'undo-redo)
(map! "C-z" #'undo-only)
(map! "C-/" #'comment-line)

(use-package! smartparens
  :init
  (map! :map smartparens-mode-map
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp))

;; presentation
(after! org-present
  (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write))))

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))

;; make lookup 1000x faster for python
(after! gcmh
  (setq gcmh-high-cons-threshold 33554432))  ; 32mb, or 64mb, or *maybe* 128mb, BUT NOT 512mb
(setq read-process-output-max  (* 20 (* 1024 1024))) ;; 20mb

;; lint code in org-mode pdf exports
(setq org-latex-src-block-backend 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-minted-options '(("breaklines" "true") ("breakanywhere" "true"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f")
        )

(setq org-src-window-setup 'current-window
      org-return-follows-link t
      org-babel-load-languages '((emacs-lisp . t)
                                 (python . t)
                                 (dot . t)
                                 (R . t))
      org-confirm-babel-evaluate nil
      org-use-speed-commands t
      org-catch-invisible-edits 'show
      org-preview-latex-image-directory "/tmp/ltximg/"
      org-structure-template-alist '(("a" . "export ascii")
                                     ("c" . "center")
                                     ("C" . "comment")
                                     ("e" . "example")
                                     ("E" . "export")
                                     ("h" . "export html")
                                     ("l" . "export latex")
                                     ("q" . "quote")
                                     ("s" . "src")
                                     ("v" . "verse")
                                     ("el" . "src emacs-lisp")
                                     ("d" . "definition")
                                     ("t" . "theorem")))

;; alt up/down moves line
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; indentation
(map! "C->" #'indent-rigidly-right-to-tab-stop)
(map! "C-<" #'indent-rigidly-left-to-tab-stop)

(map! "M-g" #'goto-line)



;; only f5-f9 can be user defined.
(map! [f5] #'revert-buffer-quick
     ;;[f6] #'
     ;;[f7] #'
     [f8] #'projectile-find-file
     [f9] #'doom/open-scratch-buffer)

(after! python
  (add-hook
   'python-mode-hook
   (lambda ()
     (setq-local python-indent-offset 4))))

;; (setq projectile-track-known-projects-automatically nil)

(use-package! tree-sitter
  :hook
  (prog-mode . global-tree-sitter-mode))

;;; corfu package
(use-package corfu
  :custom
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-auto nil)
  (corfu-preselect-first nil)
  (corfu-on-exact-match nil)
  (corfu-quit-no-match t)
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)       ; Always have the same width

  (corfu-scroll-margin 4)
  :hook
  (doom-first-buffer . global-corfu-mode)
  ;; :bind (:map corfu-map
  ;;        ("SPC" . corfu-insert-separator)
  ;;        ("TAB" . corfu-next)
  ;;        ([tab] . corfu-next)
  ;;        ("S-TAB" . corfu-previous)
  ;;        ([backtab] . corfu-previous))
)
(map! "C-/" #'completion-at-point)

(use-package! corfu-doc
  :hook (corfu-mode . corfu-doc-mode)
  :custom
  (corfu-doc-delay 0)
  :bind (:map corfu-map
         ("M-p" . corfu-doc-scroll-down)
         ("M-n" . corfu-doc-scroll-up)
         ("M-d" . corfu-doc-toggle)))

(use-package! orderless
  :when (featurep! +orderless)
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package! cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package! kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam-buffer-toggle
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        :desc "org-roam-node-find" "f" #'org-roam-node-find
        :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "jethro/org-capture-slipbox" "<tab>" #'jethro/org-capture-slipbox
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/.org/braindump/org/")
        ;; org-roam-database-connector 'sqlite-builtin
        org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t)
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))
  :config
  (org-roam-db-autosync-mode +1)
  (set-popup-rules!
    `((,(regexp-quote org-roam-buffer) ; persistent org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 1)
      ("^\\*org-roam: " ; node dedicated org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 2)))
  (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
  (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "reference/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${slug}.org" "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)))
  (defun jethro/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (require 'citar)
  (defun jethro/org-roam-node-from-cite (keys-entries)
    (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
    (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                                "${author editor} :: ${title}")))
      (org-roam-capture- :templates
                         '(("r" "reference" plain "%?" :if-new
                            (file+head "reference/${citekey}.org"
                                       ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                            :immediate-finish t
                            :unnarrowed t))
                         :info (list :citekey (car keys-entries))
                         :node (org-roam-node-create :title title)
                         :props '(:finalize find-file)))))

(use-package! ox-hugo
  :after org)

(after! org
  (setq org-attach-dir-relative t))
