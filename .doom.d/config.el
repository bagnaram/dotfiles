;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Matt Bagnara"
      user-mail-address "bagnaramatt@gmail.com")

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
 (setq doom-font (font-spec :family "Iosevka Medium" :size 13)
       doom-big-font (font-spec :family "Iosevka" :size 36)
       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq treemacs-read-string-input 'from-minibuffer)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; These functions allow the color scheme to be switched from light to dark. Can
;; be called from emacsclient.
(defun light-theme ()
  (interactive)
  (message "Caught signal %S" last-input-event)
  (setq doom-earl-grey-brighter-comments t)
  (load-theme 'doom-earl-grey t))

(defun dark-theme ()
  (interactive)
  (message "Caught signal %S" last-input-event)
  (load-theme 'dracula-pro t))

(with-temp-buffer
    (insert-file-contents "~/DAY")
    (defvar daytime (buffer-string)))
(setq daytime (replace-regexp-in-string "\n" "" daytime))

(when (string= daytime "1")
  (light-theme))
(when (string= daytime "0")
  (dark-theme))


;; custom keybindings
(map! :leader
      :desc "Window left" "w <left>" #'evil-window-left)
(map! :leader
      :desc "Window right" "w <right>" #'evil-window-right)
(map! :leader
      :desc "Window up" "w <up>" #'evil-window-up)
(map! :leader
      :desc "Window down" "w <down>" #'evil-window-down)

(map! :leader
      :desc "Window kill" "w k" #'evil-window-quit)

;; unbind the typical keys since we are on dvorak
(map! :leader
      :desc "Window left" "w h" nil)
(map! :leader
      :desc "Window left" "w H" nil)
(map! :leader
      :desc "Window left" "w j" nil)
(map! :leader
      :desc "Window left" "w J" nil)
(map! :leader
      :desc "Window left" "w l" nil)
(map! :leader
      :desc "Window left" "w L" nil)
(map! :leader
      :desc "Window left" "w K" nil)

;; mutt email composition
(add-to-list 'auto-mode-alist '("/mutt" . message-mode))

;; disble spell checking in yaml-lsp mode
(setq spell-fu-ignore-modes (list 'yaml-mode))
(remove-hook 'yaml-mode-hook #'spell-fu-mode)
(add-hook 'yaml-mode-hook #'spell-fu-mode-disable)

;; disable ws butler as to not remove trailing whitespace from the signature
(defun my-message-mode-hook ()
  (ws-butler-mode 0))
(add-hook 'message-mode-hook 'my-message-mode-hook)

(after! epa
  (set (if EMACS27+
           'epg-pinentry-mode
         'epa-pinentry-mode) ; DEPRECATED `epa-pinentry-mode'
       nil))

(require 'company-terraform)
(company-terraform-init)

(auth-source-pass-enable)
(setq auth-sources '(password-store))
(defconst EMACS27+ (not (version< emacs-version "27")))
