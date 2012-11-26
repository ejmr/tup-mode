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

(defconst tup-mode-version-number "0.0"
  "Tup mode version number.")

(define-derived-mode tup-mode prog-mode "Tup"
  "Major mode for editing tupfiles for the Tup build system.

\\{tup-mode-map}"
  (font-lock-mode 1))

(add-to-list 'auto-mode-alist '("\\.tup$" . tup-mode))
(add-to-list 'auto-mode-alist '("Tupfile" . tup-mode))

(provide 'tup-mode)
