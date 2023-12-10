;;; Customization --- Daniel Stiles
;;;
;;; Commentary:
;;; Customization file for Emacs
;;; Code:
(set-face-attribute 'default nil :height 200) ; 20pt font
(setq frame-resize-pixelwise t)
(add-to-list'initial-frame-alist '(fullscreen . maximized)) ; maximize on startup
(setq inhibit-startup-buffer-menu t) ; when opening many files, just show one
(setq inhibit-startup-screen t) ; disable splash screen
(add-hook 'emacs-startup-hook
          (lambda () (delete-other-windows)) t) ; after opening, kill all windows but one
(setq load-prefer-newer t) ; when loading .el files, prefer to recompile if there is new code

(setq custom-file (expand-file-name "custom.el" user-emacs-directory)) ; set custom file
(when (file-exists-p custom-file) ; load custom file if it exists
  (load custom-file))

(load-theme 'my-wombat) ; my-wombat theme is wombat with an extra dark background (#141414)
(load-theme 'term) ; load in terminal colors

(setq max-mini-window-height 0.75) ; let the miniwindow get big - useful for lsp prompts
(setq-default tab-width 4) ; default to length 4 tabs - 8 is huge
(setq-default indent-tabs-mode nil) ; indent with spaces by default - overridden by editorconfig files or mode hooks
(defun use-tabs()
  "Set 'indent-tabs-mode' to t."
  (setq indent-tabs-mode t))
(add-hook 'paragraph-indent-text-mode-hook 'use-tabs) ; use tabs in paragraph text mode
(bind-key "C-c p" #'paragraph-indent-text-mode) ; C-c p to switch to paragraph indent text mode
(add-hook 'make-mode 'use-tabs) ; use tabs in make-mode
(column-number-mode 1) ; show column numbers in the menu bar

(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . 10))) ; custom scrolling behavior to slow it down by default
(setq mouse-wheel-progressive-speed nil) ; keep a constant scroll speed
(setq mouse-wheel-follow-mouse t) ; mouse wheel scrolls in window the mouse cursor is pointing at
(set-scroll-bar-mode 'right) ; move the scrollbar to the right

(defvar --backup-directory (concat user-emacs-directory "backups")) ; set up custom backup folder
(setq backup-directory-alist `(("." . ,--backup-directory)))
(defvar --auto-save-directory (concat user-emacs-directory "emacs-saves")) ; set up custom autosave folder
(setq auto-save-file-name-transforms `((".*" ,--auto-save-directory t)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      kept-old-versions 0               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 10              ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200)           ; number of keystrokes between auto-saves (default: 300)

(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'."
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent) ; use set-newline-and-indent for python-mode (electric-indent doesn't work well)

(defvar user-lisp-directory (expand-file-name "lisp" user-emacs-directory)) ; add a folder to hold custom .el files
(add-to-list 'load-path user-lisp-directory)

; switch bell from sound to flashing the mode line
(defun flash-mode-line ()
  "Invert the mode line for 100ms."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))
(setq visible-bell nil ring-bell-function 'flash-mode-line)

; load emacs' package system. Add MELPA repository.
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/")
 t)
(package-initialize)

; Download use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

(require 'bind-key)

; editorconfig picks up .editorconfig files in a project to set styling for that project
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(add-hook 'emacs-lisp-mode-hook 'electric-indent-local-mode) ; use electric-indent-mode in emacs-lisp
(add-hook 'sh-mode 'electric-indent-local-mode) ; use electric-indent mode in shell scripts

(defun kill-and-join-forward (&optional arg)
  "Remove starting whitespace at the beginning of the next line when joining.
ARG defines the number of lines to kill, default 1."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))
(bind-key "C-k" #'kill-and-join-forward)

(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))
(bind-key "C-y" #'yank-and-indent emacs-lisp-mode-map) ; auto-indent yanked code in emacs-lisp mode

(require 'tramp) ; set up tramp to allow sudo editing of files without running emacs as root
(setq tramp-default-method "ssh")
(defun open-sudo(filename)
  "Open FILENAME with sudo.  If nil, opens the current buffer."
  (interactive
   (find-file-read-args "Open file with sudo: "
                        (confirm-nonexistent-file-or-buffer)))
  (unless (string-or-null-p filename)
    (signal 'wrong-type-argument (list 'string-or-null-p filename)))
  (let ((tramp-name (concat "/sudo::" (if (or (not filename) (= 0 (length filename)))
                                          (buffer-file-name)
                                        filename))))
    (find-file tramp-name)))

(require 'term)
(defvar auto-term-name "Console")
(defun auto-term(&optional new)
  "Set up terminal mode.  Use non-nil value  NEW to force a new termial."
  (interactive (list (y-or-n-p "Force new? ")))
  (let ((buffer-name (concat "*" auto-term-name "*")))
    (if (and (null new) (get-buffer buffer-name))
        (pop-to-buffer-same-window buffer-name)
      (ansi-term "/bin/bash" auto-term-name))))
(defun main-term() "Set up or switch to main terminal." (interactive) (auto-term))
(defun new-term() "Open up a new auto-term." (interactive) (auto-term t))
(defun kill-term(buffer)
  "End the terminal process in buffer BUFFER."
  (if (get-buffer buffer)
      (progn
        (pop-to-buffer-same-window buffer)
        (term-kill-subjob)
        (term-send-eof)
        (list buffer))
    nil))
(defun quit-auto-term(&optional all)
  "Send EOF to the auto-term.  Use ALL to kill all auto-term buffers.
Returns list of buffers killed."
  (interactive (list (y-or-n-p "Kill all? ")))
  (let ((name (concat "*" auto-term-name "*"))
        (any nil))
    (if all
        (dolist (buffer (buffer-list) any)
          (if (string-match name (buffer-name buffer))
              (setq any (append any (kill-term (buffer-name buffer))))))
      (if (not (null (string-match name (buffer-name)))) (kill-term (buffer-name)) any))))
(defun quit-current-term() "Quit the current auto-term." (interactive) (quit-auto-term))
(defadvice term-handle-exit (after term-kill-buffer-on-exit activate)
  "Kill terminal buffer after exit."
  (kill-buffer))
(defun start-new-emacs()
  "Start an independant Emacs process."
  (call-process "/bin/bash" nil 0 nil "-xc" (format "%s --eval \"(auto-term)\" &" (shell-quote-argument (expand-file-name invocation-name invocation-directory)))))
(defun async-restart(&rest args)
  "Start a new Emacs process and kill this one.  ARGS ignored."
  (add-hook 'kill-emacs-hook 'start-new-emacs)
  (save-buffers-kill-emacs))
(defun restart-emacs()
  "Restart Emacs with an auto-term."
  (interactive)
  (advice-add 'term-handle-exit :after #'async-restart)
  (cd "~")
  (if (not (quit-auto-term t)) (async-restart)))

(defun frame-maximize(&optional frame)
  "Set the FRAME to maximized.  If nil defaults to current frame."
  (interactive)
  (set-frame-parameter frame 'fullscreen nil)
  (set-frame-parameter frame 'fullscreen 'maximized))

; set up bindings for terminal mode.  The default map is used in line-mode, the raw map in char-mode
(bind-keys ("C-t" . main-term)
           ("C-c C-t" . new-term)
           ("C-c C-q" . quit-current-term)
           ("C-c C-r" . restart-emacs)
           ("C-c C-s" . open-sudo)
           ("C-c m" . frame-maximize))
(bind-keys :map term-raw-map
           ("C-c M-:" . eval-expression)
           ("C-c M-w" . kill-ring-save)
           ("C-c C-y" . term-paste)
           ("C-c C-t" . new-term)
           ("C-c C-q" . quit-current-term)
           ("C-c C-r" . restart-emacs)
           ("C-c C-s" . open-sudo)
           ("C-c m" . frame-maximize)
           ("ESC" . term-send-raw))

(blink-cursor-mode 0) ; don't blink the cursor

(server-start) ; start the emacs server so that calls to emacsclient form the auto-term open a new buffeer in this process instead

(defvar flycheck-default-check ; flycheck during normal runing
  '(mode-enabled save idle-change idle-buffer-switch))
(use-package flycheck
  :ensure t
  :custom
  (flycheck-relevant-error-other-file-show t) ; show errors in other files (useful to be able to use M-g p to skip to them)
  (flycheck-check-syntax-automatically flycheck-default-check) ; set up automatic checks
  :init
  (global-flycheck-mode) ; enable flycheck everywhere
  :bind
  ("C-c l" . flycheck-list-errors) ; easier list errors shortcut
  :functions flycheck-buffer
  :config
  (declare-function flycheck-error-format-message-and-id "flycheck")
  (defun flycheck-help-echo-one(errors)
    "Return only one error"
    (pcase (delq nil errors)
      (`nil ;; no errors
       "")
      (`(,err) ;; one errorx
       (flycheck-error-format-message-and-id err))
      (`(,err . ,rest) ;; multiple errors)
       (format "%s (%d more)"
               (flycheck-error-format-message-and-id err)
               (length rest))))))

(require 'ispell) ; set up english dictionary
(setq ispell-dictionary "en_US")
(setq ispell-program-name "aspell")
(setq ispell-silently-savep t)
(defvar flycheck-aspell-path (expand-file-name "flycheck-aspell" user-lisp-directory))
(use-package flycheck-aspell
  :ensure t
  :load-path flycheck-aspell-path ; use custom flycheck-aspell that limits suggestions
  :init
  (advice-add #'ispell-pdict-save :after #'flycheck-maybe-recheck) ; after updating dictionary rerun flycheck if applicable
  (defun flycheck-maybe-recheck (_)
    "If flycheck is enabled, recheck buffer."
    (when (bound-and-true-p flycheck-mode)
      (flycheck-buffer)))
  :custom
  (flycheck-aspell-suggest-limit 10) ; limit suggestions to 10
  :config
  (flycheck-aspell-define-checker "text" "Text" nil (text-mode paragraph-indent-text-mode)) ; define a checker that doesn't have any filters
  (add-to-list 'flycheck-checkers 'text-aspell-dynamic)
  (add-to-list 'flycheck-checkers 'markdown-aspell-dynamic))

(use-package go-mode
  :ensure t
  :bind (:map go-mode-map ; add a hook to revendor dependencies; indent yanked code
              ("C-y" . yank-and-indent))
  :hook
  (go-mode . use-tabs) ; use tabs in go-mode
  (go-mode . electric-indent-local-mode)) ; use electric-indent-mode in go-mode

; settings recommended by lsp-mode
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(use-package lsp-mode
  :ensure t
  :after go-mode
  :custom
  (lsp-go-env '((GOFLAGS . "-tags=integration"))) ; enable build tag for integration tests
  (lsp-go-analyses '((shadow . t)
                     (simplifycompositelit . :json-false)))
  (lsp-enable-snippet nil) ; turn off snippets
  (lsp-enable-folding nil) ; turn off folding
  (lsp-enable-links nil) ; don't auto-detect links
  (lsp-go-hover-kind "SynopsisDocumentation") ; Show a quick description of structs if available and link to go-doc
  :functions lsp-format-buffer lsp-organize-imports
  :config
  (defun lsp-go-install-save-hooks ()
    "Set up save hooks for go-mode"
    (add-hook 'before-save-hook 'lsp-format-buffer t t)
    (add-hook 'before-save-hook 'lsp-organize-imports t t))
  (add-to-list 'lsp-file-watch-ignored "[/\\\\]vendor\\/") ; don't watch vendored files
  :hook
  (go-mode . lsp) ; use lsp-mode in go-mode
  (go-mode . lsp-go-install-save-hooks) ; auto-format code and imports on save
  :bind (:map lsp-mode-map
              ("M-? . lsp-find-references"))
  :commands lsp)

(use-package lsp-ui ; all customization is in the custom file
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.5) ; wait a bit before displaying suggestions
  (setq company-minimum-prefix-length 1) ; start dislaying suggestions after only a single character is typed
  (setq company-tooltip-align-annotations t)) ; align annotations to the right tooltip border

(provide '.emacs)
;;; .emacs ends here
