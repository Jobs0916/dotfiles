(setq inhibit-startup-message t)
(setq visible-bell t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;Inicializar lista de paquetes
(require 'use-package)
(setq use-package-always-ensure t)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	    ("elpa"  . "https://elpa.gnu.org/packages/")))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(package-initialize)
(unless package-archive-contents
	(package-refresh-contents))

;Para usar en sistemas windows
(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))

(setq evil-want-C-u-scroll t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(display-line-numbers 'relative)
 '(package-selected-packages
   '(phpstan phpactor sbt-mode scala-ts-mode evil slime-company slime cider vue-mode evil-collection yasnippet-snippets which-key vertico use-package spacemacs-theme solarized-theme scala-mode rust-mode reformatter rainbow-delimiters projectile pkg-info php-mode paredit org-roam-ui org-bullets org-alert orderless minimap marginalia magit lsp-ui inf-elixir hydra gruber-darker-theme geiser-chez emmet-mode elixir-ts-mode elixir-mode eglot doom-modeline dante counsel clang-format avy auto-complete atom-dark-theme all-the-icons affe ada-ts-mode ada-mode 0blayout)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#181818" :foreground "#e4e4ef" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 113 :width normal :foundry "PfEd" :family "JetBrainsMono NFM")))))
