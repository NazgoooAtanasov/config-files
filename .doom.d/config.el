;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Cascadia Code" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq confirm-kill-emacs nil)
(setq
 projectile-project-search-path '("~/_Projects")
 projectile-indexing-method 'native)

;; HTML/CSS CONFIGS
;; DEPS ON : web-mode emmet-mode company-web
(require 'web-mode)
(require 'emmet-mode)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.isml?\\'" . web-mode))

(setq web-mode-enable-current-column-highlight t)
(setq web-mode-enable-current-element-highlight t)
;; HTML/CSS CONFIGS

(use-package lsp-mode
  :commands lsp)

(use-package company
  :after lsp-mode
  :config (push 'company company-backends))

;; VUE CONFIGS
(use-package vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp))
;; VUE CONFIGS

(use-package svelte-mode
  :mode "\\.svelte\\'"
  :config
  (add-hook 'svelte-mode-hook #'lsp))

(add-hook 'rjsx-mode-hook 'lsp)
(add-hook 'tide-mode-hook 'lsp)
(add-hook 'web-mode-hook  'emmet-mode)

(map! :leader
      :desc "Save file"
      "s" #'save-buffer)

(map! :leader
      :desc "multucursor"
      "d" #'mc/mark-next-like-this)

(map! :leader
      :desc "vterm"
      "v" #'projectile-run-vterm)
