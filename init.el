(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


    ;; Initialize package sources
    (require 'package)

    (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                             ("org" . "https://orgmode.org/elpa/")
                             ("elpa" . "https://elpa.gnu.org/packages/")))

    (package-initialize)


  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))


(eval-when-compile
  (require 'use-package))

    (global-set-key (kbd "<escape>") 'keyboard-escape-quit)


    (require 'use-package)
    (setq use-package-always-ensure t)

(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1)   ; Disable the toolbar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room

(menu-bar-mode -1)   ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Fira Code Retina" :height 110)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 110)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Fira Code Retina" :height 110)

(use-package general
   :config
   (general-create-definer rune/leader-keys
   :keymaps '(normal insert visual emacs)
   :prefix "SPC"
   :global-prefix "C-SPC"))

(rune/leader-keys
 "t" '(:ignore t :which-key "toggles")
 "tt" '(counsel-load-theme :which-key "choose theme"))

 (general-define-key
 "C-M-j" 'counsel-switch-buffer
 "C-M-," 'comment-region
 "C-M-." 'uncomment-region)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  (evil-mode 1))

(defun dw/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-f" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1))
(setq doom-modeline-height 45)
(setq doom-modeline-major-mode-color-icon t)

(use-package doom-themes
	:config
	(load-theme 'doom-palenight t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


(use-package counsel
  :demand t
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ;; ("C-M-j" . counsel-switch-buffer)
         ("C-M-l" . counsel-imenu)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
 "ts" '(hydra-text-scale/body :which-key "scale text"))

;; Flex Autopair automatically insert pair braces and quotes,
;; insertion conditions & actions are highly customizable.

    (require 'flex-autopair)
    (flex-autopair-mode 1)

(set-frame-parameter (selected-frame) 'alpha '(90 90))

(add-to-list 'default-frame-alist '(alpha 90 90))


(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(90 . 90) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;; Turn on indentation and auto-fill mode for Org files
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

  (use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-agenda-files
	'("~/.org")))


        (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
	("Tasks.org" :maxlevel . 1)))

;; Save Org buffers refiling:
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

 ;;(set-face-attribute 'org-document-title nil :font "Arial" :weight 'bold :height 1.3)

  (defun dw/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)
        (visual-fill-column-mode 1))

(use-package visual-fill-column
        :hook (org-mode . dw/org-mode-visual-fill))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle our Emacs.org config file when we save it

(defun efs/org-babel-tangle-config()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/emacs.org"))

    ;; Dinamyc scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("go" . "src go"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

(setq inferior-lisp-program "sbcl")

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; (use-package undo-tree
;;   :init
;;   (global-undo-tree-mode 1))

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(defun efs/configure-eshell ()
;; Save command history when commands are entered
(add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

 ;; Truncate buffer for performance
(add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

;; Bind some useful keys for evil-mode
(evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
(evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
(evil-normalize-keymaps)

(setq eshell-history-size         10000
      eshell-buffer-maximum-lines 10000
    eshell-hist-ignoredups t
    eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-mode . efs/configure-shell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package evil-nerd-commenter
  :bind ("M-A" . evilnc-comment-or-uncomment-lines))

(use-package company
:ensure t
:config
(setq company-idle-delay 0.3)
(global-company-mode 1)
(global-set-key (kbd "C-<tab>") 'company-complete))

(use-package company-box
  :hook (company-mode . company-box-mode))

 (use-package flycheck)

(use-package lsp-mode
  :config
  (setq lsp-prefer-flymake nil)
  ;(setq lsp-clients-angular-language-server-command
        ;'("node"
          ;"C:/Users/user/AppData/Roaming/npm/node_modules/@angular/language-server"
          ;"--ngProbeLocations"
          ;"C:/Users/user/AppData/Roaming/npm/node_modules"
          ;"--tsProbeLocations"
          ;"C:/Users/user/AppData/Roaming/npm/node_modules"
          ;"--stdio"))
  :hook (php-mode . lsp)
  :commands lsp)

 (use-package lsp-ui
  :requires lsp-mode flycheck
  :config
  (setq lsp-ui-doc-enable t
  lsp-ui-doc-use-childframe t
  lsp-ui-doc-position 'top
  lsp-ui-doc-include-signature t
  lsp-ui-sideline-enable nil
  lsp-ui-flycheck-enable t
  lsp-ui-flycheck-list-position 'right
  lsp-ui-flycheck-live-reporting t
  lsp-ui-peek-enable t
  lsp-ui-peek-list-width 60
  lsp-ui-peek-peek-height 25
  lsp-ui-sideline-enable nil)

 (add-hook 'lsp-mode-hook 'lsp-ui-mode))

 (use-package lsp-treemacs
   :after lsp)

(require 'treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")
(setq doom-themes-treemacs-theme "doom colors")

(use-package typescript-mode
:mode "\\.ts\\'"
:hook (typescript-mode . lsp-deferred)
:config
(setq typescript-indent-level 2))

(use-package php-mode
 :ensure t
 :mode
 ("\\.php\\'" . php-mode))

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(use-package phpunit
 :ensure t)

(provide 'lang-php)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind ("C-M-p" . projectile-find-file)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :bind ("C-M-;" . magit-status)
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;(use-package evil-magit
  ;:after magit)

;;(use-package forge)


(rune/leader-keys
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Hide dotfiles. To show files press H.
(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; Rebind CapsLock to Ctrl
  (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

  ;; Set the screen resolution (update this to be the correct resolution for your screen!)
  (require 'exwm-randr)
  (exwm-randr-enable)
  ;; (start-process-shell-command "xrandr" nil "xrandr --output Virtual-1 --primary --mode 2048x1152 --pos 0x0 --rotate normal")

  ;; Load the system tray before exwm-init
  (require 'exwm-systemtray)
  (exwm-systemtray-enable)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-enable))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode which-key visual-fill-column use-package undo-tree typescript-mode treemacs-all-the-icons slime rainbow-delimiters phpunit php-mode org-bullets org lsp-ui lsp-treemacs ivy-rich helpful general forge flycheck flex-autopair exwm evil-nerd-commenter evil-collection eterm-256color eshell-git-prompt doom-themes doom-modeline dired-single dired-hide-dotfiles counsel-projectile company-box command-log-mode all-the-icons-dired))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
