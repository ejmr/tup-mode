;;; tup-mode.el --- Major mode for editing files for Tup
;;;
;;; Copyright 2012 Eric James Michael Ritz
;;;     <lobbyjones@gmail.com>
;;;     <https://github.com/ejmr/tup-mode>
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
;;; Place this file somewhere in your Emacs Lisp path, i.e. `load-path',
;;; and add this to your `.emacs' file:
;;;
;;;     (require 'tup-mode)
;;;
;;; Files ending with the `*.tup' extension, or files named `Tupfile'
;;; automatically enable tup-mode.

(require 'custom)
(require 'font-lock)
(require 'regexp-opt)

(defconst tup-mode-version-number "1.1"
  "Tup mode version number.")

(defgroup tup nil
  "Major mode for editing files for the Tup build system."
  :prefix "tup-"
  :group 'languages)

(defcustom tup-executable "/usr/local/bin/tup"
  "The location of the `tup' program."
  :type 'string
  :group 'tup)

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
   ;; Matches all keywords defined by tup/keywords-regexp.
   (cons tup/keywords-regexp font-lock-keyword-face)
   ;; Matches macros, lines such as '!foo = bar'.
   (cons "^\\(!\\sw+\\)[[:space:]]*=" '(1 font-lock-preprocessor-face))
   ;; Matches 'FOO=bar' and 'FOO+=bar' with optional spaces.
   (cons "^\\(\\sw+\\)[[:space:]]*\\+?=[[:space:]]*.+" '(1 font-lock-variable-name-face))
   ;; Matches variables like $(FOO).
   (cons "\\$(\\(\\sw+\\))" '(1 font-lock-variable-name-face))
   ;; Matches variables like @(FOO).
   (cons "\\@(\\(\\sw+\\))" '(1 font-lock-variable-name-face))
   ;; Matches bin variables like {foo}
   (cons "{\\(\\sw+\\)}" '(1 font-lock-variable-name-face))
   ;; Matches the initial colon in rule definitions.
   (cons "^:" font-lock-constant-face)
   ;; Matches the '|>' delimeter in rules and macros.
   (cons "|>" font-lock-constant-face)
   ;; Matches flags in rules like '%f' and '%B'.
   (cons "\\<%[[:alpha:]]\\{1\\}" font-lock-preprocessor-face))
  "A map of regular expressions to font-lock faces that are used
for syntax highlighting.")

(define-derived-mode tup-mode prog-mode "Tup"
  "Major mode for editing tupfiles for the Tup build system.

\\{tup-mode-map}"
  ;; Inform font-lock of all of the regular expressions above which
  ;; map to different font-lock faces, and then enable font-lock-mode
  ;; so they actually affect the tupfile.
  (set (make-local-variable 'font-lock-defaults)
       '(tup/font-lock-definitions nil t))
  (font-lock-mode 1)
  ;; Treat the underscore as a 'word character'.  In the regular
  ;; expressions we use for font-lock we often match against '\sw',
  ;; i.e. word characters.  We want the underscore to be such a
  ;; character so that it will count as part of variable names, among
  ;; other things.  Without this a variable like @(FOO_BAR) would only
  ;; be partially highlighted; it would stop at the underscore.
  (modify-syntax-entry ?_ "w" tup-mode-syntax-table)
  ;; Modify the syntax table so that tup-mode understands the comment
  ;; format in tupfiles: lines beginning with '#' and running until
  ;; the end of the line.
  (modify-syntax-entry ?# "< b" tup-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" tup-mode-syntax-table)
  ;; Tup can complain with an error if the tupfile does not end with a
  ;; newline, especially when we have tup rules that span multiple
  ;; lines.  So we always require a newline at the end of a tupfile.
  (set (make-local-variable 'require-final-newline) t))

(defun tup/run-command (command)
  "Execute a Tup `command' in the current directory.
If the `command' is 'upd' then the output appears in the special
buffer `*Tup*'.  Other commands do not show any output."
  (if (string= command "upd")
      (progn
        (call-process-shell-command "tup" nil "*Tup*" t command)
        (switch-to-buffer "*Tup*"))
      (call-process-shell-command "tup" nil nil nil command)))

(defmacro tup/make-command-key-binding (key command)
  "Binds the `key' sequence to execute the Tup `command'.
The `key' must be a valid argument to the `kbd' macro."
  `(define-key tup-mode-map (kbd ,key)
     '(lambda ()
        (interactive)
        (tup/run-command ,command))))

;;; Bind keys to frequently used Tup commands.
(tup/make-command-key-binding "C-c C-i" "init")
(tup/make-command-key-binding "C-c C-u" "upd")
(tup/make-command-key-binding "C-c C-m" "monitor")
(tup/make-command-key-binding "C-c C-s" "stop")

;;; Automatically enable tup-mode for any file with the `*.tup'
;;; extension and for the specific file `Tupfile'.
(add-to-list 'auto-mode-alist '("\\.tup$" . tup-mode))
(add-to-list 'auto-mode-alist '("Tupfile" . tup-mode))

(provide 'tup-mode)
