(deftheme my-wombat
  "Created 2020-11-12.")

(custom-theme-set-variables
 'my-wombat
 '(ansi-color-names-vector ["#141414" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"]))

(custom-theme-set-faces
 'my-wombat
 '(cursor ((((class color) (min-colors 89)) (:background "#858585"))))
 '(fringe ((t nil)))
 '(highlight ((((class color) (min-colors 89)) (:background "#454545" :foreground "#ffffff" :underline t))))
 '(region ((((class color) (min-colors 89)) (:background "#444444" :foreground "#f6f3e8"))))
 '(secondary-selection ((((class color) (min-colors 89)) (:background "#333366" :foreground "#f6f3e8"))))
 '(isearch ((((class color) (min-colors 89)) (:background "#343434" :foreground "#857b6f"))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:background "#384048" :foreground "#a0a8b0"))))
 '(mode-line ((((class color) (min-colors 89)) (:background "#444444" :foreground "#f6f3e8"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:background "#444444" :foreground "#857b6f"))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(escape-glyph ((((class color) (min-colors 89)) (:foreground "#ddaa6f" :weight bold))))
 '(homoglyph ((((class color) (min-colors 89)) (:foreground "#ddaa6f" :weight bold))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#99968b"))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#e5786d"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#cae682"))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#8ac6f2" :weight bold))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#95e454"))))
 '(font-lock-type-face ((((class color) (min-colors 89)) (:foreground "#92a65e" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#cae682"))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#ccaa8f"))))
 '(link ((((class color) (min-colors 89)) (:foreground "#8ac6f2" :underline t))))
 '(link-visited ((((class color) (min-colors 89)) (:foreground "#e5786d" :underline t))))
 '(button ((((class color) (min-colors 89)) (:background "#333333" :foreground "#f6f3e8"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#303030" :foreground "#e7f6da"))))
 '(default ((t (:background "#141414" :foreground "#f6f3e8")))))

(provide-theme 'my-wombat)
