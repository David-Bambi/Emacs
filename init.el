;; ==============================================================================
;; Environment variable
;; ==============================================================================
(load-file "C:/.emacs.d/envvar.el")

(defvar my-list-themes '(kaolin-aurora
 			 kaolin-light))



;; My package list -----------------------------------------------------
(defvar my-package '(better-defaults    ;; Better emacs with default action
                     smooth-scroll      ;; For a smooth scrolling
                     undo-tree          ;; Undo Redo
                     helm               ;; Framework for emacs
  		     kaolin-themes      ;; Theme
                     highlight-numbers  ;; Highlight for number
                     highlight-quoted   ;; Hightlight quoted
                     highlight-defined  ;; Highlight defined for elisp
                     rainbow-delimiters ;; Highlight delimiter
                     minimap            ;; minimap like sublime text
                     auctex             ;; Framework for latex
                     org                ;; Organisation mode
                     projectile         ;; Project manager
                     magit              ;; Versionning
                     yasnippet          ;; To insert some snippet need for company
                     company            ;; Autocompletion
                     diff-hl
                     auto-complete
                     ))

;; ==============================================================================
;; Public
;; ==============================================================================

;; Open the init file -----------------------------------------------------------
(defun find-emacs-init-file ()
  (interactive)
  (find-file emacs-init-file-path))

;; Quick-change for black/white theme 
(defun quick-change-theme ()
   (interactive)
   (setq my-list-themes (append (cdr my-list-themes)
                                (list (car my-list-themes))))
   (load-theme (car my-list-themes) t))

;; ==============================================================================
;; Private
;; ==============================================================================

;; PACKAGE ---------------------------------------------------------------------
(defun initialize-package-interface ()

  (require 'package)
  (add-to-list 'package-archives
	     '("melpa" . "http://stable.melpa.org/packages/")
	     '("melpa" . "http://melpa.org/packages/"))

  (package-initialize)

  (when (not package-archive-contents)
    (package-refresh-contents))

  ;; Install my package if they are not already.
  (dolist (p my-package)
    (unless (package-installed-p p)
      (package-install p))))

;; APPEARENCE ------------------------------------------------------------------
(defun load-my-theme ()
  (load-theme 'kaolin-aurora  t t)
  (enable-theme 'kaolin-aurora ))

(defun set-my-font ()
  (set-face-attribute 'default nil
                      :family "Consolas" :height 110))

(defun set-scrolling-bar ()  
  (require 'smooth-scroll)
  (smooth-scroll-mode t))

;; BACKUP ----------------------------------------------------------------------
(defun set-backup-directory ()
  (setq backup-directory-alist backup-directory)
  (setq undo-tree-history-directory-alist backup-undo-tree))

;; BASIC -----------------------------------------------------------------------
(defun setup-basic ()
  (require 'better-defaults)

  ;; Remove startup screen
  (setq inhibit-startup-screen t)  

  ;; Remove the sound when we reach the end of the file
  (setq ring-bell-function 'ignore))


;; UNDO ------------------------------------------------------------------------
(defun setup-undo ()
  (require 'undo-tree)
  (global-undo-tree-mode)
  (global-set-key (kbd "C-z") 'undo-tree-undo)
  (global-set-key (kbd "C-S-z") 'undo-tree-redo))

;; EXECUTION -------------------------------------------------------------------
(defun execute (f)
  (funcall f)
  (prin1-to-string f))

(defun execute-init-functions (&rest function-l)
  (let ((string-to-print ""))
    (dolist (f function-l)
      (setq string-to-print (concat string-to-print (execute f)"\n")))

  (with-output-to-temp-buffer "*Init*"
    (princ (format "%s" string-to-print))))
  
  (interactive)
  (delete-other-windows))

;; ==============================================================================
;; Execution
;; ==============================================================================
(execute-init-functions
 'initialize-package-interface
 'load-my-theme
 'set-my-font
 'set-scrolling-bar
 'set-backup-directory
 'setup-basic
 'setup-undo
 )

;; Program to preview the latex file
(defvar teX-view-programs
  '(("Sumatra PDF" ("\"SumatraPDF.exe\" -reuse-instance"
                    (mode-io-correlate " -forward-search %b %n ") " %o"))))


;; Open file in utf-8 when we do not know the coding system
;; (prefer-coding-system 'utf-8)

;; To change windows 
(global-set-key (kbd "C-q") 'other-window)

;; ;; HELM MODE ----------------------------------------------------------------
(require 'helm)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c r") 'helm-recentf)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-c h w") 'helm-wikipedia-suggest)
(global-set-key (kbd "C-c h g") 'helm-google-suggest)

;; By default tab is for helm-select-action, i change that
;; to the persistent action.
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-x") 'helm-select-action)

;; APPARENCE  ------------------------------------------------------------------





(global-set-key (kbd "C-=") 'quick-change-theme)
(add-hook 'prog-mode-hook 'linum-mode)

;; Highlight
(require 'highlight-numbers)
(require 'highlight-quoted)
(require 'highlight-defined)
(require 'rainbow-delimiters)

(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'highlight-quoted-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-defined-mode)


;; NAVIGATION BAR --------------------------------------------------------------

;; Bottom bar
(column-number-mode t)

;; For having a minimap like sublime text
(require 'minimap)

;; Changing colors
(custom-set-faces
  '(minimap-active-region-background
    ((((background dark)) (:background "#C0D6E4"))
      (t (:background "#C0D6E4")))
    "Face for the active region in the minimap.
    By default, this is only a different background color."
    :group 'minimap))

(global-set-key (kbd "C-<f1>") 'minimap-mode)

;; GAMBIT SCHEME ---------------------------------------------------------------

;; Custom extension, i have to change it because it open the buffer when
;; a compile error or execution error come.
;; (require 'gambit)

;; TEXT -----------------------------------------------------------------------

;; Orthograph program
;;(setq ispell-program-name hunspell-program)

;; No need to search how to make french quote just use C-x C-2
(defun french-guillemets ()
  (interactive)
  (insert "«  »");<-- deux espaces insécables
  (backward-char 2))
(global-set-key (kbd "C-x C-2") 'french-guillemets)

(add-hook 'text-mode-hook 'abbrev-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; LATEX -----------------------------------------------------------------------
(setq TeX-PDF-mode t)
(setq TeX-view-program-list teX-view-programs)

(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; ORG-MODE --------------------------------------------------------------------
(setq org-display-inline-images t)

(global-set-key "\C-ca" 'org-agenda)

;; Hide leading stars
(setq org-startup-indented t)
(setq org-hide-leading-stars t)

(setq org-todo-keywords
      '((sequence "À FAIRE"
                  "OP"
                  "IMPORTANT"
                  "EN COURS"
                  "ACHAT"
                  "EN ATTENTE"
                  "RENDEZ-VOUS"
                  "|"
                  "COMPLETÉ")))

(setq org-todo-keyword-faces
      '(("À FAIRE" . (:foreground "magenta"))
        ("OP" . (:foreground "aquamarine4"))
        ("IMPORTANT" . (:foreground "firebrick4"))
        ("EN COURS" . (:foreground "DeepSkyBlue1"))
        ("ACHAT" . (:foreground "MediumOrchid4"))
        ("EN ATTENTE" . (:foreground "gold"))
 	("RENDEZ-VOUS" . (:foreground "salmon1"))
        ("COMPLETÉ" . (:foreground "PaleGreen1"))))

(setq org-tag-faces
      '(("env" . (:foreground "ivory1" :background "ForestGreen" :weight bold))
        ("corvée" . (:foreground "ivory1" :background "salmon1" :weigt bold))
        ("urgent" . (:foreground "ivory1" :background "firebrick4" :weigt bold))
        ("bonheur" . (:foreground "ivory1" :background "DeepPink1" :weigt bold))
        ("travail" . (:foreground "ivory1" :background "DodgerBlue1" :weigt bold))
        ("école" . (:foreground "ivory1" :background "RoyalBlue4" :weigt bold))
        ("savoir" . (:foreground "ivory1" :background "SteelBlue4" :weight bold))
        ("physique" . (:foreground "ivory1" :background "CadetBlue4" :weight bold))
        ("philo" . (:foreground "ivory1" :background "SlateBlue2" :weight bold))
        ("math" . (:foreground "ivory1" :background "SeaGreen4" :weight bold))
        ("info" . (:foreground "ivory1" :background "HotPink4" :weight bold))
        ("art" . (:foreground "ivory1" :background "OrangeRed1" :weight bold))))
;; ;; MA TODO LISTE 
;; (find-file "C:\\Documents\\Agenda\\listeAFaire.org")
;; (org-check-deadlines 14)

;; Agenda
(setq org-agenda-files (list "D:\\Documents\\Agenda\\Appartement.org"
                             "D:\\Documents\\Agenda\\Ecole.org"
                             "D:\\Documents\\Agenda\\Exercice.org"
                             "D:\\Documents\\Agenda\\Perso.org"
                             "D:\\Documents\\Agenda\\Projets.org"))
;; (setq org-log-done 'time)
;; (setq org-log-done 'note)




;; PROJECTILE
(require 'projectile)
(projectile-global-mode)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-git-submodule-command nil) 
(setq projectile-indexing-method 'hybrid)
(setq projectile-enable-caching t)

(put 'projectile-project-run-cmd 'safe-local-variable (lambda (_) t))
(put 'projectile-project-compilation-cmd 'safe-local-variable (lambda (_) t))
(put 'projectile-project-configure-cmd 'safe-local-variable (lambda (_) t))

;; GIT
(require 'magit)

(global-diff-hl-mode)
(diff-hl-margin-mode t)
(setq diff-hl-margin-side 'left)
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; C++ -------------------------------------------------------------------------
(require 'company)
(setq c-default-style "gnu")

(global-auto-complete-mode t)


;; Compilation buffer
(setq compilation-window-height 10)








;; Little game mode
(defun CreateWorld ()
  (insert "#----------------------------#\n")
  (insert "|                            |\n")
  (insert "|                            |\n")
  (insert "|                            |\n")
  (insert "|                            |\n")
  (insert "|                            |\n")
  (insert "#----------------------------#\n"))

;(defun CreateOuterWall (line, column)

;  )

;(defun CreateWall ()
;  ())

(defun Game ()
  (interactive)
  (CreateWorld))

(global-set-key (kbd "C-c m") 'Game)


;; ;; Latex
;; (load "auctex.el" nil t t)
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)
;; (setq TeX-PDF-mode t)
;; (setq reftex-plug-into-AUCTeX t)
;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;; (add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode) 


;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)


;; ;; PROJECTILE ------------------------------------------------------------------
;; ;;(require 'projectile)
;; ;;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; ;;(projectile-mode)
;; (add-hook 'text-mode-hook 'flyspell-mode)

;; ;; DOC VIEW --------------------------------------------------------------------
;; (add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; ;; AUTO-FILL MODE
;; (setq-default fill-column 50)

;; ;; HTML MODE
;; ;;(require 'web-mode)
;; ;;(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

;; ;; MARKDOWN --------------------------------------------------------------------
;; (add-hook 'markdown-mode-hook (lambda ()
;; 				(set (make-local-variable 'compile-command)
;; 				     (let ((file (file-name-nondirectory buffer-file-name)))
;; 				     (format "pandoc -o %s.pdf %s"
;; 					     (file-name-sans-extension file)
;; 					     file)))))

;; (add-hook 'markdown-mode-hook 'auto-fill-mode)
;; (add-hook 'markdown-mode-hook 'flyspell-mode)
;; (add-hook 'fill-nobreak-predicate
;;           'markdown-inside-link-p nil t)


;; ;; LATEX -----------------------------------------------------------------------

;; ;; Preview Pane pour latex
;; (latex-preview-pane-enable)

;; ;; Latex
;; (load "auctex.el" nil t t)
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)
;; (setq TeX-PDF-mode t)
;; (setq reftex-plug-into-AUCTeX t)
;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;; (add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode) 
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)

;; ;; ORG-MODE --------------------------------------------------------------------
;; (setq org-support-shift-select 1)
;; (setq org-startup-indented t)
;; (setq org-cycle-separator-lines 0)
;; (setq org-link-search-must-match-exact-headline nil)
;; (setq org-src-preserve-indentation t)
;; ;;(setq org-plantuml-jar-path "~/.emacs.d/tools/plantuml.jar")
;; (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)
;; 							 (latex . t)))


;; (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

;; ;; To remove the annoying confirmation
;; (defun my-org-confirm-babel-evaluate (lang body)
;; "Do not ask for confirmation to evaluate code for specified languages."
;; (member lang '("plantuml")))

;; (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)


;; (add-hook 'org-mode-hook 'auto-fill-mode)
;; (add-hook 'org-mode-hook 'flyspell-mode)
;; (add-hook 'org-mode-hook (lambda () (linum-mode 0)))

;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cc" 'org-capture)
;; (global-set-key "\C-cb" 'org-iswitchb)

;; (setq org-log-done t)
;; (setq org-todo-keywords
;;       '((sequence "À FAIRE" "RENDEZ-VOUS" "IMPORTANT" "NON RÉUSSI" "EN COURS" "ACHAT" "|" "COMPLETÉ")))
;; (setq org-todo-keyword-faces
;;       '(("À FAIRE" . (:foreground "orange" :background "#c66a00" :weight bold))
;; 	("RENDEZ-VOUS" . (:foreground "yellow" :background "#858c02" :weight bold))
;; 	("IMPORTANT" . (:foreground "red" :backgro und "#931c01" :weight bold))
;; 	("NON RÉUSSI" . (:foreground "#8e024f" :background "#997b8b" :weight bold))
;; 	("ACHAT" . (:foreground "purple" :background "#470140" :weight bold))
;; 	("EN COURS" . (:foreground "blue" :background "#91bbff" :weight bold))))

;; ;; MA TODO LISTE 
;; (find-file "C:\\Documents\\Agenda\\listeAFaire.org")
;; (org-check-deadlines 14)

;; ;; Agenda
;; (setq org-agenda-files (list "C:\\Documents\\Agenda\\listeAFaire.org" ))
;; (setq org-log-done 'time)
;; (setq org-log-done 'note)


;; ;;Python IDE
;; ;; (require 'py-autopep8)
;; ;; (setq elpy-rpc-python-command "python3")
;; ;; (when (require 'flycheck nil t)
;; ;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;; ;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

;; ;; (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; ;; (setq python-indent 4)
;; ;; (set-variable 'python-indent-guess-indent-offset nil)


;; ;; LISP
;; ;; (add-to-list 'load-path "slime")
;; ;; (require 'slime-autoloads)
;; ;; (setq inferior-lisp-program "sbcl")

;; ;; (add-to-list 'load-path "~/.emacs.d/ac-slime")
;; ;; (require 'ac-slime)

;; ;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
;; ;;  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;;  ;; (eval-after-load "auto-complete"
;;  ;;   '(add-to-list 'ac-modes 'slime-repl-mode))

;; ;;Ivy

;; ;;function-args-mode
;; ;;(fa-config-default)

;; ;;C++ IDE


;; ;; (require 'rtags)
;; ;; (require 'company-rtags)

;; ;; (require 'company-irony-c-headers)
;; ;; (eval-after-load 'company
;; ;;   '(add-to-list
;; ;;     'company-backends '(company-irony-c-headers company-irony)))

;; ;; (setq rtags-completions-enabled t)
;; ;; (eval-after-load 'company
;; ;;   '(add-to-list
;; ;;     'company-backends 'company-rtags))
;; ;; (setq rtags-autostart-diagnostics t)
;; ;; (rtags-enable-standard-keybindings)

;; ;; (require 'helm-rtags)
;; ;; (setq rtags-use-helm t)

;; ;; (add-hook 'after-init-hook 'global-company-mode)
;; ;; (add-hook 'c++-mode-hook 'irony-mode)
;; ;; (add-hook 'c-mode-hook 'irony-mode)
;; ;; (add-hook 'objc-mode-hook 'irony-mode)


;; ;; (defun my-irony-mode-hook ()
;; ;;   (define-key irony-mode-map [remap completion-at-point]
;; ;;     'irony-completion-at-point-async)
;; ;;   (define-key irony-mode-map [remap complete-symbol]
;; ;;     'irony-completion-at-point-async))

;; ;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; ;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; ;; (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;; ;; (setq company-backends (delete 'company-semantic company-backends))

;; ;; (setq company-idle-delay 0)
;; ;; (define-key c-mode-map [(tab)] 'company-complete)
;; ;; (define-key c++-mode-map [(tab)] 'company-complete)

;; ;; (add-hook 'c++-mode-hook 'flycheck-mode)
;; ;; (add-hook 'c-mode-hook 'flycheck-mode)

;; ;; (require 'flycheck-rtags)

;; ;; (defun my-flycheck-rtags-setup ()
;; ;;   (flycheck-select-checker 'rtags)
;; ;;   (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;; ;;   (setq-local flycheck-check-syntax-automatically nil))
;; ;; ;; c-mode-common-hook is also called by c++-mode
;; ;; (add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;; ;; (eval-after-load 'flycheck
;; ;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))




;; ;;Java
;; ;; (setq jdee-server-dir "~/.emacs.d/javaConf")
;; ;; (setq jdee-flycheck-enable-p t)
;; ;; (setq jdee-jdk-registry
;; ;;    (quote
;; ;;     (("1.9" . "/usr/lib/jvm/java-9-openjdk-amd64")
;; ;;      ("1.8" . "/usr/lib/jvm/java-8-oracle")
;; ;;      ("1.8" . "/usr/lib/jvm/java-8-openjdk-amd64"))))


;; ;; Company mode
;; ;; (require 'pos-tip)
;; ;; (add-hook 'after-init-hook 'global-company-mode)
;; ;; (company-quickhelp-mode 1)



;; ;; Documentation
;; (require 'info-look)


;; ;; Scheme (quack)
;; ;; (require 'quack)



;; ;; ;; Paren mode
;; ;; (show-paren-mode 1)

;; ;; ;; indentation
;; ;; (setq c-default-style "linux"
;; ;;       c-basic-offset 4)

;; ;; ;; Gambit
;; ;; ;; (setq load-path
;; ;; ;;          (cons "~/g4/share/emacs/site-lisp"
;; ;; ;;                load-path))
;; ;; ;;    (setq scheme-program-name "gsi -:d-")
;; ;; ;;    (setq gambit-repl-command-prefix "\e")
;; ;; ;; (require 'gambit)


;; ;; ;; Assembleur x86
;; ;; (add-to-list 'auto-mode-alist '("\\.\\(asm\\|s\\)$" .
;; ;; 				asm-mode))





;; ;; ;; ESS Mode
;; ;; ;;(add-to-list 'load-path "ESS/lisp/")
;; ;; ;;(load "ess-site")


;; ;; ;;; Clojure

;; ;; (add-hook 'clojure-mode-hook 'paredit-mode)


;; ;; ;; ;; JAVSCRIPT
;; ;; ;; (defun   setup-js()

;; ;; ;;   ;; Push all the file for the ftp connection for myWebSite
;; ;; ;;   ;; must change for the root project and if there not then
;; ;; ;;   ;; don't do it
;; ;; ;;   ;; (add-hook 'after-save-hook
;; ;; ;;   ;; 	    (lambda() (shell-command "pushftp")))
;; ;; ;;   )

;; ;; ;; (add-to-list 'auto-mode-alist '("\\.js$" . setup-js))

;; ;; ;; ;;; Java script configuration
;; ;; ;; (require 'js2-mode)
;; ;; ;; (require 'js2-refactor)
;; ;; ;; (require 'xref-js2)

;; ;; ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; ;; ;; ;; Better imenu
;; ;; ;; (add-hook 'js2-mode-hook #'js2-refactor-mode)

;; ;; ;; (js2r-add-keybindings-with-prefix "C-c C-r")
;; ;; ;; (define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; ;; ;; ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; ;; ;; ;; unbind it.
;; ;; ;; (define-key js-mode-map (kbd "M-.") nil)

;; ;; ;; (add-hook 'js2-mode-hook (lambda ()
;; ;; ;;   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))


;; ;; ;; (require 'js-doc)

;; ;; ;; (add-to-list 'company-backends 'company-tern)
;; ;; ;; (add-hook 'js2-mode-hook (lambda ()
;; ;; ;;                            (tern-mode)
;; ;; ;;                            (company-mode)))


;; ;; ;; (setq js-doc-mail-address "your email address"
;; ;; ;;        js-doc-author (format "your name <%s>" js-doc-mail-address)
;; ;; ;;        js-doc-url "url of your website"
;; ;; ;;        js-doc-license "license name")

;; ;; ;;  (add-hook 'js2-mode-hook
;; ;; ;;            #'(lambda ()
;; ;; ;;                (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
;; ;; ;;                (define-key js2-mode-map "@" 'js-doc-insert-tag)))

;; ;; ;; (require 'flymake-jslint)
;; ;; ;;     (add-hook 'js2-mode-hook 'flymake-jslint-load)

;; ;; ;; ;; Disable completion keybindings, as we use xref-js2 instead
;; ;; ;; (define-key tern-mode-keymap (kbd "M-.") nil)
;; ;; ;; (define-key tern-mode-keymap (kbd "M-,") nil)

;; ;; ;;; PHP  ----------------------------------------------------------------------------

;; ;; ;; PHP Package
;; ;; (require 'cl)
;; ;; (require 'php-mode)
;; ;; (require 'ac-php)

;; ;; (defun setup-php ()

;; ;;   ;; Minor mode
;; ;;   (flycheck-mode)
  
;; ;;   ;; Auto-complete
;; ;;   (auto-complete-mode)
;; ;;   (setq ac-sources  '(ac-source-php))

;; ;;   (local-set-key  (kbd "C-<dead-cedilla>") 'ac-php-find-symbol-at-point)   ;goto define
;; ;;   (local-set-key  (kbd "C-<dead-diaeresis>") 'ac-php-location-stack-back)    ;go back
;; ;;   (ac-php-core-eldoc-setup ) ;; enable eldoc
  
;; ;;   ;; Remove the empty space at the end of the line
;; ;;   (local-set-key (kbd "C-<dead-grave>") (lambda ()
;; ;; 					  (interactive)
;; ;; 					  (progn
;; ;; 					    (end-of-line)
;; ;; 					    (while (char-equal (preceding-char) ?\s)
;; ;; 					      (delete-backward-char 1))

;; ;; 					    (end-of-line))))
  
;; ;;   ;; Handle the spacing manually at the begin of the line
;; ;;   (local-set-key (kbd "C-<")  (lambda ()
;; ;; 				(interactive)
;; ;; 				(let ((pos (point)))
;; ;; 				  (progn 
;; ;; 				    (beginning-of-line)
;; ;; 				    (tab-to-tab-stop)
;; ;; 				    (goto-char pos)))))
  
;; ;;   (local-set-key (kbd "C->")  (lambda ()
;; ;; 				(interactive)
;; ;; 				(let ((pos (point)))
;; ;; 				  (progn
;; ;; 				    (beginning-of-line)
;; ;; 				    (dotimes (number 4)
;; ;; 				      (if (char-equal (following-char) ?\s)
;; ;; 					  (delete-char 1)))
;; ;; 				    (goto-char pos)))))

;; ;;   ;; Bar de navigation 
;; ;;   (local-set-key (kbd "C-=") 'speedbar))



;; ;; ;; JAVASCRIPT ------------------------------------------------------------------------------------------

;; ;; ;; Javascript package
;; ;; (require 'js2-mode)
;; ;; (require 'tern)
;; ;; (require 'js2-refactor)
;; ;; (require 'xref-js2)
;; ;; (require 'js-doc) 
 

;; ;; (defun setup-js ()

;; ;;   ;; Doc
;; ;;   (setq js-doc-mail-address "davidboivinbambi@gmail.com"
;; ;; 	js-doc-author (format "David Boivin <%s>" js-doc-mail-address)
;; ;; 	js-doc-url "davidboivinbambi.com"
;; ;; 	js-doc-license "GNU GPLv3  <https://www.gnu.org/licenses/>")
  
;; ;;   (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
;; ;;   (define-key js2-mode-map "@" 'js-doc-insert-tag)

;; ;;   ;; Better imenu
;; ;;   (js2-imenu-extras-mode)

;; ;;   ;; Refactor
;; ;;   (js2-refactor-mode)
  
;; ;;   ;; Linting :: disable jshint since we prefer eslint checking.
;; ;;   (flycheck-mode)
;; ;;   (setq-default flycheck-disabled-checkers
;; ;; 		(append flycheck-disabled-checkers
;; ;; 			'(javascript-jshint)))

 
;; ;;   (flycheck-add-mode 'javascript-eslint 'js2-mode)

;; ;;   ;; Use space instead of tab
;; ;;   (setq-default indent-tabs-mode nil)
  
;; ;;   ;; AutoComplete :: After load tern setup it.
;; ;;   (tern-mode)
;; ;;   (auto-complete-mode)
;; ;;   (eval-after-load 'tern
;; ;;    '(progn
;; ;;       (require 'tern-auto-complete)
;; ;;       (tern-ac-setup)))
  
;; ;;   ;; Keybinding ----------------------------------------------------------------
;; ;;   (js2r-add-keybindings-with-prefix "C-c C-r")

;; ;;   ;; Supprime un bloc the code . Exemple un if au complet ou une fonction
;; ;;   (local-set-key (kbd "C-k") 'js2r-kill)
;; ;;   (local-set-key (kbd "C-c C-1") 'js2r-rename-var)
  
;; ;;   ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; ;;   ;; unbind it.
;; ;;   (define-key js-mode-map (kbd "M-.") nil)
;; ;;   (define-key tern-mode-keymap (kbd "M-.") nil)
;; ;;   (define-key tern-mode-keymap (kbd "M-,") nil)

;; ;;   ;; Find référence
;; ;;   (local-set-key (kbd "M-S-.") 'xref-find-references))

;; ;; (add-hook 'js2-mode-hook 'setup-js)
;; ;; (add-hook 'js2-mode-hook (lambda ()
;; ;; 			   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; ;; (add-hook 'php-mode-hook 'setup-php)
;; ;; (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; ;; HASKELL ------------------------------------------------------------------------------------------

;; ;; (add-hook 'haskell-mode-hook #'hindent-mode)
;; ;; (add-hook 'haskell-mode-hook #'auto-complete-mode)
;; ;; (eval-after-load 'haskell-mode
;; ;;           '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))

;; ;; (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
;; ;;   (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
;; ;;   (add-to-list 'exec-path my-cabal-path))
;; ;; (custom-set-variables
;; ;;  ;; custom-set-variables was added by Custom.
;; ;;  ;; If you edit it by hand, you could mess it up, so be careful.
;; ;;  ;; Your init file should contain only one such instance.
;; ;;  ;; If there is more than one, they won't work right.
;; ;;  '(custom-safe-themes
;; ;;    (quote
;; ;;     ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "be5b03913a1aaa3709d731e1fcfd4f162db6ca512df9196c8d4693538fa50b86" "28818b9b1d9e58c4fb90825a1b07b0f38286a7d60bf0499bc2dea7eea7e36782" "b48599e24e6db1ea612061252e71abc2c05c05ac4b6ad532ad99ee085c7961a7" "780c67d3b58b524aa485a146ad9e837051918b722fd32fd1b7e50ec36d413e70" "77515a438dc348e9d32310c070bfdddc5605efc83671a159b223e89044e4c4f1" "db510eb70cf96e3dbd48f5d24de12b03db30674ea0853f06074d4ccf7403d7d3" default)))
;; ;;  '(eclim-eclipse-dirs (quote ("~/Logiciel/eclipse/java-2018-09/eclipse")))
;; ;;  '(eclim-executable "~/.p2/pool/plugins/org.eclim_2.8.0/bin/eclim")
;; ;;  '(haskell-tags-on-save t)
;; ;;  '(package-selected-packages
;; ;;    (quote
;; ;;     (gnuplot-mode plantuml-mode smooth-scroll smooth-scrolling company-emacs-eclim ac-emacs-eclim ecb elpygen 2048-game typing-game sudden-death ppd-sr-speedbar eclim xref-js2 x86-lookup web-mode use-package twilight-bright-theme tern-context-coloring tern-auto-complete sr-speedbar solarized-theme slime scheme-complete racket-mode r5rs quack pyflakes py-autopep8 prolog popup-switcher popup-kill-ring popup-imenu popup-edit-menu popup-complete php-eldoc pdf-tools paredit nasm-mode memoize material-theme markdown-preview-mode markdown-preview-eww markdown-mode+ magit lenlen-theme latex-preview-pane latex-extra js2-refactor js-doc jedi ivy-rtags irony-eldoc iasm-mode helm-rtags helm-projectile helm-gtags goto-last-change ggtags function-args flymd flymake-python-pyflakes flymake-jslint flymake-cppcheck flylisp flycheck-rtags flycheck-pyflakes flycheck-irony flycheck-inline flycheck-hdevtools flycheck-haskell flycheck-clangcheck flycheck-clang-tidy flycheck-clang-analyzer flappymacs exec-path-from-shell evil elpy elisp-slime-nav elisp-sandbox elisp-refs elisp-lint elisp-format elisp-docstring-mode elisp-depend ediprolog dockerfile-mode docker-compose-mode docker-api docker darktooth-theme darkokai-theme darkmine-theme darkburn-theme darkane-theme dark-mint-theme dark-krystal-theme darcula-theme csv-mode color-theme-modern chess c-eldoc bongo better-defaults autumn-light-theme auto-complete-clang-async auto-complete-clang auctex-latexmk align-cljlet ag adjust-parens ac-rtags ac-php ac-math ac-ispell ac-dabbrev ac-clang ac-cider ac-c-headers abyss-theme))))

;; ;; ;; Pour executer des commandes en root
;; ;; ;; pris de https://stackoverflow.com/questions/2472273/how-do-i-run-a-sudo-command-in-emacs
;; ;; (defun sudo-shell-command (command)
;; ;;   (interactive "MShell command (root): ")
;; ;;   (with-temp-buffer
;; ;;     (cd "/sudo::/") 
;; ;;     (async-shell-command command)))
;; ;; (custom-set-faces
;; ;;  ;; custom-set-faces was added by Custom.
;; ;;  ;; If you edit it by hand, you could mess it up, so be careful.
;; ;;  ;; Your init file should contain only one such instance.
;; ;;  ;; If there is more than one, they won't work right.
;; ;;  )

;; ;; ;; JAVA
;; ;; (require 'eclim)
;; ;; (setq eclimd-autostart t)
;; ;; (setq eclimd-default-workspace "~/Documents/Developpement/JavaProjets/.")

;; ;; (defun setup-java ()

;; ;;   (require 'company)
;; ;;   (require 'company-emacs-eclim)
;; ;;   (company-mode)
;; ;;   (company-emacs-eclim-setup)

;; ;;   (eclim-mode t)
  
;; ;;   (setq help-at-pt-display-when-idle t)
;; ;;   (setq help-at-pt-timer-delay 0.1)
;; ;;   (help-at-pt-set-timer)

;; ;;   (global-set-key (kbd "M-2") 'eclim-run-class) 
;; ;; )

;; ;; (add-hook 'java-mode-hook 'setup-java)



;; ;; ;; ;; ERC
;; ;; ;; (setq erc-auto-set-away t)
;; ;; ;; (setq erc-auto-set-away t)
;; ;; ;; (erc :server "irc.freenode.net" :port 6667 :nick "MachineABambi")
;; ;; ;; (setq erc-autojoin-channels-alist
;; ;; ;;       '(("freenode.net" "#diroum")))

;; ;; ;; PYTHON
;; ;; (elpy-enable)
