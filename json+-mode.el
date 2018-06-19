;;; json+-mode.el --- An opinionated configuration for the excellent json-mode.

;; Copyright (C) 2018+ Affan Salman

;; Author: Affan Salman
;; URL: https://github.com/affan-salman/json+-mode
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
;; Extend the excellent json-mode for a modern out-of-the-box experience.
;;
;; * Suggested Usage
;;
;; M-x json+-mode toggles json+ mode in the current buffer.
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
  "Set this to nil if you do not need json+ mode configuring and
auto-enabling smartparens.  When set, it does the following:

- Enables smartparens if not already switched on.

- Sets up smartparens to automatically create a newline, indent
  and place the point at the appropriate position if the user
  presses RETURN after smartparens inserts the matching curly
  bracket."
  :type 'boolean
  :group 'json+)

(defun json+-create-newline-and-enter-sexp (&rest _ignored)
  "Open a new brace or bracket expression, with relevant newline
and indentation instead of the default '{}'."
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

;;;###autoload
(define-minor-mode json+-mode
    "A modern configuration for `json-mode'.
Toggle json+ mode on or off.
Turn json+ mode on if ARG is positive, off otherwise."
  :lighter " js+"
  :group 'json+
  (if json+-mode
      (progn
        (when (and json+-mode-manage-smartparens (featurep 'smartparens))
          ;; Be careful not to override existing smartparens configuration.
          (if (not smartparens-mode)
              (progn
                (require 'smartparens)
                (smartparens-mode 1)))
          (sp-local-pair json-mode "{" nil :post-handlers
                         '((json+-create-newline-and-enter-sexp "RET")))))))

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
