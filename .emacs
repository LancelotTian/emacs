(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (monokai)))
 '(ecb-layout-window-sizes
   (quote
    (("left8"
      (ecb-directories-buffer-name 0.16143497757847533 . 0.28846153846153844)
      (ecb-sources-buffer-name 0.16143497757847533 . 0.23076923076923078)
      (ecb-methods-buffer-name 0.16143497757847533 . 0.28846153846153844)
      (ecb-history-buffer-name 0.16143497757847533 . 0.17307692307692307))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;; 设置Emacs全屏显示,需要根据屏幕大小调整数值
(add-to-list 'default-frame-alist '(height . 100))
(add-to-list 'default-frame-alist '(width . 223))

;;;; Show line number
(global-linum-mode t)
(setq linum-format "%d ")

;;;; Emacs包管理系统
;;;; 参考 http://ergoemacs.org/emacs/emacs_package_system.html
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

(require 'hlinum)
(hlinum-activate)

;;;; smex https://github.com/nonsequitur/smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;;;; helm https://github.com/emacs-helm/helm
;; (require 'helm)
;; (require 'helm-config)
;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
;;       helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
;;       helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
;;       helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
;;       helm-ff-file-name-history-use-recentf t)
;; (helm-mode 1)

;;;; Build TAGS
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (eshell-command 
   (format "find %s -type f -name \"*.[eh]rl\" | etags -" dir-name)))

;;;; Shell path配置
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")
(exec-path-from-shell-initialize)
;;;; Open file in one window
(setq ns-pop-up-frames nil)

;;;; Erlang环境配置
(setq load-path (cons "/usr/local/Cellar/erlang/17.1/lib/erlang/lib/tools-2.6.15/emacs" load-path))
(setq erlang-root-dir "/usr/local/Cellar/erlang/17.1/lib/erlang")
(setq exec-path (cons "/usr/local/Cellar/erlang/17.1/lib/erlang/bin" exec-path))
(require 'erlang-start)
;; Erlang mode hook
(defun my-erlang-mode-hook ()
       ;; when starting an Erlang shell in Emacs, default in the node name
       (setq inferior-erlang-machine-options '("-sname" "emacs"))
       ;; add Erlang functions to an imenu menu
       (imenu-add-to-menubar "Emenu")
       ;; customize keys
       (local-set-key [return] 'newline-and-indent)
       (local-set-key "\C-c\C-f" 'erlang-indent-current-buffer)
       (local-set-key "\M-a" 'erlang-beginning-of-function)
       (local-set-key "\M-e" 'erlang-end-of-function)
       (local-set-key "\M-\C-a" 'erlang-beginning-of-clause)
       (local-set-key "\M-\C-e" 'erlang-end-of-clause)
       (local-set-key "\M-h" 'erlang-mark-function)
       (local-set-key "\M-\C-h" 'erlang-mark-clause)
       (local-set-key "\C-c\M-h" 'mark-paragraph)
       (local-set-key "\C-h1" 'erlang-man-module)
       (local-set-key "\C-h2" 'erlang-man-function)
       (local-set-key "\C-h3" 'erlang-man-command) 
       )
;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

;;;; ECB配置
(add-to-list 'load-path "~/.emacs.d/elpa/ecb-20140215.114/")
(require 'ecb)

;;;; Load monokai theme
(load-theme 'monokai t)

;;;; Erlang-Flymake配置,用来检查语法错误
(require 'erlang-flymake)
;;仅在存盘时进行检查
(erlang-flymake-only-on-save)
;;键盘映射
(defvar flymake-mode-map (make-sparse-keymap))
(define-key flymake-mode-map (kbd "\C-c8") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "\C-c9") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "\C-c0") 'flymake-display-err-menu-for-current-line)
(or (assoc 'flymake-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
              (cons (cons 'flymake-mode flymake-mode-map)
		    minor-mode-map-alist)))

;;;; yasnippet
;;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)
;;(global-set-key (kbd "C-j") 'yas-expand)

;;;; Auto-Complete配置
(require 'auto-complete-config)
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20150218.819") 
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20150218.819/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")
;;必须在erlang-mode启用后
(add-to-list 'ac-modes 'erlang-mode)


;;;; Expand region
(require 'expand-region)
(global-set-key (kbd "C-c j") 'er/expand-region)
(setq expand-region-contract-fast-key "k")



;;;; Ace jump
(add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-20140616.115")
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)


;(define-key ac-mode-map  (kbd "M-RET") 'auto-complete)

;;;; 自动启动ECB，并且不显示每日提示
;;关闭自动启动ECB,使用快捷键启动
;;(setq ecb-auto-activate t)
(setq ecb-tip-of-the-day nil)
(setq ecb-primary-secondary-mouse-buttons 'mouse-1--mouse-2)
;;(setq ecb-mouse-click-destination t)

;; 激活/取消ECB
(global-set-key [f5] 'ecb-activate)
(global-set-key [C-f5] 'ecb-deactivate)

;;;; 各窗口间切换
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
 


;;;; 隐藏和显示ecb窗口
;;(define-key global-map [(control f1)] 'ecb-hide-ecb-windows)
;;(define-key global-map [(control f2)] 'ecb-show-ecb-windows)
  
;;;; 使某一ecb窗口最大化
;;(define-key global-map "\C-c1" 'ecb-maximize-window-directories)
;;(define-key global-map "\C-c2" 'ecb-maximize-window-sources)
;;(define-key global-map "\C-c3" 'ecb-maximize-window-methods)
;;(define-key global-map "\C-c4" 'ecb-maximize-window-history)
;;;; 恢复原始窗口布局
;(define-key global-map "\C-c`" 'ecb-restore-default-window-sizes)
