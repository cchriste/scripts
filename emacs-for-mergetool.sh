#!/bin/sh
#/Applications/Emacs.app/Contents/MacOS/emacs --no-desktop $*
/Applications/Emacs.app/Contents/MacOS/emacs --no-desktop --eval "(ediff-files \"$1\" \"$2\")"