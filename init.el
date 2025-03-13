;; Font size
(set-face-attribute 'default nil :height 125)

;; Esc to quit
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; No tool bar
(tool-bar-mode -1)

;; Line numbers
(global-display-line-numbers-mode 1)

;; Current line highlight
(global-hl-line-mode 1)

(package-initialize)

(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'load-path "~/.org-9.2.4/lisp")
(add-to-list 'load-path "~/.org-9.2.4/contrib/lisp" t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Load theme
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(load-theme 'monokai t)

;; MATLAB mode
(autoload 'matlab-mode "~/.config/emacs/matlab.el" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
;; Allow tramp to use ssh multiplexing
(setq tramp-ssh-controlmaster-options
      (concat
        "-o ControlPath='~/.ssh/master-%%r@%%h:%%p' "
        "-o ControlMaster=auto -o ControlPersist=yes"))
;; Inhibit startup and splash screens
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; quelpa setup
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; Python stuff
(setenv "PYTHONIOENCODING" "utf8")

;; Conda
(require 'conda)
(setq conda-env-home-directory "/home/jamie/miniforge3/")
(add-hook 'lsp-before-initialize-hook 'conda-env-activation-hook)
(defun conda-env-activation-hook ()
    (conda-env-activate (getenv "CONDA_DEFAULT_ENV")))
(setq-default mode-line-format (cons mode-line-format '(:exec conda-env-current-name)))

(setq python-shell-interpreter-args "-m asyncio")

;; Black setup
(use-package python-black
    :ensure nil
    :quelpa
    (python-black
        :fetcher git
        :url "https://github.com/wbolster/emacs-python-black")
    :after python)
(setq python-black-extra-args '("-S"))

(use-package py-isort
    :ensure nil
    :quelpa
    (py-isort
         :fetcher git
         :url "https://github.com/paetzke/py-isort.el")
    )

(use-package lsp-pyright
  :ensure nil
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0
	company-minimum-prefix-length 2
	company-show-numbers t
	company-tooltip-limit 10
	company-tooltip-align-annotations t
	company-tooltip-flip-when-above t)
  (global-company-mode t)
  )
(use-package company-quickhelp
  ;; Quickhelp may incorrectly place tooltip towards end of buffer
  ;; See: https://github.com/expez/company-quickhelp/issues/72
  :ensure t
  :config
  (company-quickhelp-mode)
  )

(defun python-format ()
    "Format python buffer with isort and black"
    (interactive)
    (py-isort-buffer)
    (python-black-buffer))

(add-hook 'python-mode-hook
	  (lambda () (local-set-key (kbd "C-c r") 'python-format)))

(setq lsp-enable-file-watchers nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(inhibit-startup-screen t)
 '(inhibit-startup-message t)
 '(package-selected-packages
   '(conda isortify julia-mode lsp-ui org lsp-pyright py-isort pyenv-mode
	   python-black python-isort pyvenv quelpa-use-package
	   yaml-mode company projectile company-anaconda company-quickhelp))
 '(tramp-default-method "ssh")
 '(tramp-password-prompt-regexp
   (concat "^.*"
	   (regexp-opt
	    (quote
	     ("password" "Password" "verification code" "Verification Code"))
	    t)
	   ".*:? *"))
  '(custom-safe-themes
   '("2925ed246fb757da0e8784ecf03b9523bccd8b7996464e587b081037e0e98001"
     default))
  '(conda-anaconda-home "/home/jamie/miniforge3/")
  '(company-quickhelp-color-background "black")
  '(company-quickhelp-color-foreground "dim gray"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
