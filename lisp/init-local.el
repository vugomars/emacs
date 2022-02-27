;;; init-local.el --- Support for the local config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(set-face-attribute 'default nil :font "Fira Code Retina" :height 170)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 170)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 170 :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(when (maybe-require-package 'evil)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(when (maybe-require-package 'general)
  :config
  (general-create-definer dqv/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (dqv/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/config.org")))

    ;; Dired
    "ff" '(find-file :which-key "Find Files")
    "fr" '(recentf-open-files :which-key "Recentf Open Files")

    ;; Vterm
    "ot" '(vterm-other-window :which-key "Vterm Other Windown")
    "oT" '(vterm :which-key "Vterm")

    ;; Treemacs
    "m"  '(:ignore t :which-key "Treemacs")
    "mt" '(treemacs :which-key "Treemacs")
    "mdf" '(treemacs-delete-file :which-key "Delete Files")
    "mdp" '(treemacs-remove-project-from-workspace :which-key "Delete Projects")
    "mcd" '(treemacs-create-dir :which-key "Create Directory")
    "mcf" '(treemacs-create-file :which-key "Create File")
    "ma" '(treemacs-add-project-to-workspace :which-key "Add Projects")
    "mc" '(treemacs-create-workspace :which-key "Create Workspace")
    "ms" '(treemacs-switch-workspace :which-key "Switch Workspace")
    "md" '(treemacs-remove-workspace :which-key "Remove Workspace")
    "mf" '(treemacs-rename-workspace :which-key "Rename Workspace")

    ;; Buffer
    "j" '(switch-to-buffer :which-key "Switch Buffer")
    "bk" '(kill-this-buffer :which-key "Kill This Buffer")
    ))


(when (maybe-require-package 'evil-collection)
  :config
  (evil-collection-init))


;; Native Compilation
;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)

;; Set the right directory to store the native comp cache
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; Startup Performance
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;; Keep Folders Clean
(when (maybe-require-package 'no-littering))

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(provide 'init-local)
