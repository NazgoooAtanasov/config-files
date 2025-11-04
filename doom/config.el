;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Iosevka" :size 20))
(setq doom-theme 'gruber-darker)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")
(setq projectile-project-search-path '("~/_Projects/" "~/_Forkpoint/"))
(setq flycheck-javascript-eslint-executable "eslint_d")
(setq +workspaces-switch-project-function 'magit)

(after! corfu
  (map! :map corfu-map
        :i "C-t" #'corfu-next
        :i "C-y" #'corfu-previous
        :i "TAB" nil
        :i "<tab>" nil))

(custom-theme-set-faces!
 'gruber-darker
 '(org-level-8 :inherit outline-3 :height 1.0)
 '(org-level-7 :inherit outline-3 :height 1.0)
 '(org-level-6 :inherit outline-3 :height 1.1)
 '(org-level-5 :inherit outline-3 :height 1.2)
 '(org-level-4 :inherit outline-3 :height 1.3)
 '(org-level-3 :inherit outline-3 :height 1.4)
 '(org-level-2 :inherit outline-2 :height 1.5)
 '(org-level-1 :inherit outline-1 :height 1.6)
 '(org-document-title  :height 1.8 :bold t :underline nil))

(map! :leader
      (:prefix "v"
        :n "s" #'evil-window-vsplit
        :n "h" #'evil-window-split)
      (:prefix "w"
        :n "o" #'delete-other-windows)
      (:prefix "e"
        :n "f" #'lsp-eslint-fix-all))

(map! :after dired
      :map dired-mode-map
      :n "%" #'dired-create-empty-file)

(add-to-list 'auto-mode-alist '("\\.isml\\'" . web-mode))

(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'compile-history)
(add-to-list 'savehist-additional-variables 'compile-command)
