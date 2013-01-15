Tup Mode for GNU Emacs
======================

This is a major mode for Emacs made for editing ‘tupfiles’, files used
by the [Tup build system](http://gittup.org/tup/).


Features
--------

Tup mode provides syntax highlighting for all of the elements of
tupfiles, such as rule definitions, user-defined variables, macros,
flags, bin variables, and so on.  The mode also allows you to execute
Tup commands.  It binds the following key sequences:

1. `C-c C-i`: `tup init`
2. `C-c C-u`: `tup upd`
3. `C-c C-m`: `tup monitor`
4. `C-c C-s`: `tup stop`

If you use a prefix argument with `C-c C-u`, e.g. if you press `C-u
C-c C-u`, then Tup mode will prompt you for the name of a
[variant](http://gittup.org/tup/manual.html#lbAJ).  It will then run
Tup to build that specific variant.  And in either case the command
will show you a `*Tup*` buffer containing the output from Tup so that
you can see if the build succeeded or not.


License
-------

[GNU General Public License Version 3](http://www.gnu.org/copyleft/gpl.html)
