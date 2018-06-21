;;; json+-mode.el --- A modern configuration for the excellent json-mode.

;; Copyright (C) 2018+ Affan Salman

;; Author: Affan Salman
;; URL: https://github.com/affan-salman/jsonplus-mode
;; Package-Version: 20180619.1200
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Configure the excellent json-mode and related Emacs editing extensions for a
;; modern out-of-the-box JSON editing and navigation experience.
;;
;; * Suggested Usage
;;
;; After the usual `require', `use-package' or similar:
;;
;;     M-x json+-mode toggles json+ mode in the current buffer.
;;
;; To automatically enable it in your json-mode buffers, use:
;;
;;     (add-hook 'json-mode-hook 'turn-on-json+-mode)

;;; Code:

(require 'json-mode)

(defgroup json+-mode nil
  "json+ minor mode."
  :group 'json+)

(defcustom json+-mode-manage-smartparens t
  "Whether json+ should configure and auto-enable smartparens.

When set, it does the following during `json+-mode' activation:

- Enables smartparens if not already switched on.

- Sets up the RETURN key for smartparens insertion to
  automatically create a new line while moving the closing curly
  brace below the newly inserted line with correct indentation as
  well as placing the point at the appropriate indented
  position."
  :type 'boolean
  :group 'json+)

(defcustom json+-mode-manage-hideshow t
  "Whether json+ should configure and auto-enable hideshow.

When set, it does the following during `json+-mode' activation:

- Enables hideshow if not already switched on.

- Sets up context-sensitive org-mode style keybindings through
  `hideshow-org'."
  :type 'boolean
  :group 'json+)

(defun json+-create-newline-and-enter-sexp (&rest _ignored)
  "Tweak the post-closing-brace insertion behaviour.

Open a new brace or bracket expression, with relevant newline and
indentation instead of the default '{}'."
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

;;
;; Track the state of auto-activated modes to respect the user's previous
;; settings when json+ mode is toggled off.
;;

(defvar json+-enabled-smartparens nil
  "Whether `smartparens' was enabled by `json+-mode'.")

(defvar json+-enabled-hideshow nil
  "Whether `hideshow' was enabled by `json+-mode'.")

(defvar json+-enabled-hideshow-org nil
  "Whether `hideshow-org' was enabled by `json+-mode'.")

;;;###autoload
(define-minor-mode json+-mode
    "A modern configuration for `json-mode'.

Toggle json+ mode on or off. Turn json+ mode on if ARG is
positive, off otherwise."
  :lighter " js+"
  :group 'json+
  (if json+-mode
      (progn
        (when (and json+-mode-manage-smartparens
                   (require 'smartparens "smartparens" t))
         ;; Be careful not to override existing smartparens configuration.
         (when (not smartparens-mode)
           (smartparens-mode 1)
           (setq-local json+-enabled-smartparens t))
         (sp-local-pair 'json-mode "{" nil :post-handlers
                        '((json+-create-newline-and-enter-sexp "RET"))))
        (when (and json+-mode-manage-hideshow
                   (require 'hideshow "hideshow" t)
                   (require 'hideshow-org "hideshow-org" t))
          ;; Be careful not to override existing hideshow configuration.
          (when (not hs-minor-mode)
            (hs-minor-mode 1)
            (setq-local json+-enabled-hideshow t))
          (when (not hs-org/minor-mode)
            (hs-org/minor-mode 1)
            (setq-local json+-enabled-hideshow-org t))))
    (progn
      (when json+-enabled-smartparens
        (smartparens-mode -1)
        (setq-local json+-enabled-smartparens nil))
      (when json+-enabled-hideshow
        (hs-minor-mode -1)
        (setq-local json+-enabled-hideshow nil))
      (when json+-enabled-hideshow-org
        (hs-org/minor-mode -1)
        (setq-local json+-enabled-hideshow-org nil)))))

;;;###autoload
(defun turn-on-json+-mode ()
  "Unconditionally turn on json+ mode in the current buffer."
  (json+-mode 1))

;;;###autoload
(defun turn-off-json+-mode ()
  "Unconditionally turn off json+ mode in the current buffer."
  (json+-mode -1))

(provide 'json+-mode)
;;; json+-mode ends here
