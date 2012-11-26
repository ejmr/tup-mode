;;; tup-mode.el --- Major mode for editing files for Tup
;;;
;;; Copyright 2012 Eric James Michael Ritz
;;;     <lobbyjones@gmail.com>
;;;     <http://github.com/ejmr/tup-mode>
;;;
;;;
;;;
;;; License:
;;;
;;; This file is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published
;;; by the Free Software Foundation; either version 3 of the License,
;;; or (at your option) any later version.
;;;
;;; This file is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this file; if not, write to the Free Software
;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;;; 02110-1301, USA.
;;;
;;;
;;;
;;; Usage:
;;;
;;; Place this file somewhere in your Emacs Lisp path, i.e. `site-lisp',
;;; and add this to your `.emacs' file:
;;;
;;;     (require 'tup-mode)
;;;
;;; Files ending with the `*.tup' extension, or files named `Tupfile'
;;; automatically enable tup-mode.

(require 'font-lock)
(require 'regexp-opt)

(defconst tup-mode-version-number "0.0"
  "Tup mode version number.")

(defconst tup/keywords-regexp
  (regexp-opt
   (list "foreach"
         "ifeq"
         "ifneq"
         "ifdef"
         "ifndef"
         "else"
         "endif"
         "include"
         "include_rules"
         "run"
         "export"
         ".gitignore")
   'words)
  "A regular expression matching all of the keywords that can
appear in Tupfiles.")

(defconst tup/font-lock-definitions
  (list
   (cons "#.*" font-lock-comment-face)
   (cons tup/keywords-regexp font-lock-keyword-face)
   ;; Matches: 'FOO=bar' and 'FOO+=bar' with optional spaces.
   (cons "^\\(\\sw+\\)[[:space:]]*\\+?=[[:space:]]*\\sw+" '(1 font-lock-variable-name-face))
   (cons "\\$(\\(\\sw+\\))" '(1 font-lock-variable-name-face))
   (cons "\\@(\\(\\sw+\\))" '(1 font-lock-variable-name-face))
   (cons "^:" font-lock-constant-face)
   (cons "|>" font-lock-constant-face))
  "A map of regular expressions to font-lock faces that are used
for syntax highlighting.")

(define-derived-mode tup-mode prog-mode "Tup"
  "Major mode for editing tupfiles for the Tup build system.

\\{tup-mode-map}"
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '(tup/font-lock-definitions nil t))
  (modify-syntax-entry ?_ "w" tup-mode-syntax-table)
  (font-lock-mode 1))

;;; Automatically enable tup-mode for any file with the `*.tup'
;;; extension and for the specific file `Tupfile'.
(add-to-list 'auto-mode-alist '("\\.tup$" . tup-mode))
(add-to-list 'auto-mode-alist '("Tupfile" . tup-mode))

(provide 'tup-mode)
