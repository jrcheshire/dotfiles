;; Font size
(set-face-attribute 'default nil :height 125)

;; Esc to quit
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(tool-bar-mode -1)

(global-display-line-numbers-mode 1)

(hl-line-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff"
    "#eeeeec"])
 '(custom-enabled-themes '(tsdh-dark))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(company conda isortify julia-mode lsp-pyright lsp-ui org projectile
	     py-isort pyenv-mode python-black python-isort pyvenv
	     quelpa-use-package yaml-mode))
 '(tramp-default-method "ssh")
 '(tramp-password-prompt-regexp
   (concat "^.*"
	   (regexp-opt
	    '("password" "Password" "verification code"
	      "Verification Code")
	    t)
	   ".*:? *")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(autoload 'matlab-mode "~/.config/emacs/matlab.el" "Enter Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(setq tramp-ssh-controlmaster-options
      (concat
        "-o ControlPath='~/.ssh/master-%%r@%%h:%%p' "
        "-o ControlMaster=auto -o ControlPersist=yes"))
(use-package julia-mode
  :ensure t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.
;; See `package-archive-priorities` and `package-pinned-packages`.
;; Most users will not need or want to do this.
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; quelpa
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; Python stuff
(setenv "PYTHONIOENCODING" "utf8")

;; Conda
(require 'conda)
(setq conda-env-home-directory "/home/jamie/miniforge3")
(add-hook 'lsp-before-initialize-hook 'conda-env-activation-hook)
(defun conda-env-activation-hook ()
  (conda-env-activate (getenv "CONDA_DEFAULT_ENV")))
(setq-default mode-line-format (cons mode-line-format '(:exec conda-env-current-name)))

(setq python-shell-interpreter-args "-m asyncio")

;; Black setup
(use-package python-black
    :ensure t
    :quelpa
    (python-black
        :fetcher git
        :url "https://github.com/wbolster/emacs-python-black")
    :after python)
(setq python-black-extra-args '("-S"))

(use-package py-isort
    :ensure t
    :quelpa
    (py-isort
         :fetcher git
         :url "https://github.com/paetzke/py-isort.el")
    )

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(defun python-format ()
    "Format python buffer with isort and black"
    (interactive)
    (py-isort-buffer)
    (python-black-buffer))

(add-hook 'python-mode-hook
	  (lambda () (local-set-key (kbd "C-c r") 'python-format)))

;;(with-eval-after-load 'lsp-mode
;;  (add-to-list 'lsp-file-watch-ignored-directories "/home/jamie/spherex/cosmo/tests/out"))
(setq lsp-enable-file-watchers nil)
;;
