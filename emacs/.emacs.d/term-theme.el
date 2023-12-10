;;; term --- Daniel Stiles
;;;
;;; Commentary:
;;; Faces for the terminal
;;; Code:
(deftheme term
  "Created 2020-11-12.")

(custom-theme-set-faces
 'term
 '(term ((t (:inherit default :foreground "#B2B2B2"))))
 '(term-bold ((t (:inherit term :foreground "#FFFFFF" :weight bold))))
 '(term-color-black ((t (:background "#000000" :foreground "#525252"))))
 '(term-color-blue ((t (:background "#0052FF" :foreground "#5266FF"))))
 '(term-color-cyan ((t (:background "#00B4B4" :foreground "#52FFFF"))))
 '(term-color-green ((t (:background "#64B946" :foreground "#52FF52"))))
 '(term-color-magenta ((t (:background "#EE5CEE" :foreground "#FF52FF"))))
 '(term-color-red ((t (:background "#FF3000" :foreground "#FF5252"))))
 '(term-color-white ((t (:background "#A2A2A2" :foreground "#FFFFFF"))))
 '(term-color-yellow ((t (:background "#A55B00" :foreground "#FFFF52")))))

(provide-theme 'term)
;;; term-theme.el ends here

