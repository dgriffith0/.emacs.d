;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq custom-file "C:\\Users\\dgrif\\AppData\\Roaming\\.emacs.d\\custom.el")
(load custom-file)

(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; visible scrollbar
(tool-bar-mode -1) ;disable the toolbar
(tooltip-mode -1) ;disable tooltips
(set-fringe-mode 10)

(menu-bar-mode -1)

(setq visible-bell t) ; stop ding sound effect

(column-number-mode)

(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hoo))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(defvar my/default-font-size 80)

(set-face-attribute 'default nil :font  "Fira Code" :height my/default-font-size)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :height my/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Fira Code" :height my/default-font-size :weight 'regular)

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner 'logo)
  (dashboard-setup-startup-hook))

;; Make ESC quit prompts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (use-package general
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
    "e"  '(treemacs :which-key "File tree")
    "b"  '(counsel-switch-buffer :which-key "Buffers")
    "f"  '(find-file :which-key "Find File")
    "F"  '(projectile-ripgrep :which-key "Find Text")
    "t"  '(:ignore t :which-key "Toggles")
    "tt" '(counsel-load-theme :which-key "Choose theme")))

  (use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  (evil-global-set-key 'normal "K" 'lsp-ui-doc-toggle-focus-frame)

  (evil-define-key 'normal 'lsp-ui-doc-frame-mode
    [?q] #'lsp-ui-doc-hide)

  (evil-define-key 'normal 'lsp-ui-doc-frame-mode
    [escape] 'lsp-ui-doc-hide)

  (evil-normalize-keymaps))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-gruvbox))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
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

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
:custom
(counsel-describe-function-function #'helpful-callable)
(counsel-describe-variable-function #'helpful-variable)
:bind
([remap describe-function] . counsel-describe-function)
([remap describe-command] . helpful-command)
([remap describe-variable] . counsel-describe-variable)
([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(my/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun my/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Fira Code" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun my/org-mode-setup ()
(org-indent-mode)
(variable-pitch-mode 1)
(visual-line-mode 1))


(use-package org
  :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-ellipsis " ▼")
  (my/org-font-setup))

(use-package org-bullets
:after org
:hook (org-mode . org-bullets-mode))

(defun my/org-mode-visual-fill ()
  (setq visual-fill-column-width 100)
  ;; (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . my/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    ;;other languages
    ))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle our config.org config file when we save it
(defun my/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name  "C:\\Users\\dgrif\\AppData\\Roaming\\.emacs.d\\custom.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'my/org-babel-tangle-config)))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode 1))

 (use-package magit
   :commands (magit-status magit-get-current-branch)
   :custom
   (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(defun my/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . my/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package evil-commentary
  :after evil
  :config (evil-commentary-mode))

;; (unless (package-installed-p 'cider)
;;   (package-install 'cider))

;; (use-package lsp-mode
;;   :ensure t
;;   :hook ((clojure-mode . lsp)
;;          (clojurec-mode . lsp)
;;          (clojurescript-mode . lsp))
;;   :config
;;   ;; add paths to your local installation of project mgmt tools, like lein
;;   (setenv "PATH" (concat
;;                    "/usr/local/bin" path-separator
;;                    (getenv "PATH")))
;;   (dolist (m '(clojure-mode
;;                clojurec-mode
;;                clojurescript-mode
;;                clojurex-mode))
;;      (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
;;   (setq lsp-clojure-server-command '("/path/to/clojure-lsp"))) ;; Optional: In case `clojure-lsp` is not in your $PATH

;; (unless (package-installed-p 'clojure-mode)
;;   (package-install 'clojure-mode))

(use-package rustic)
