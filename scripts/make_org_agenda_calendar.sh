#!/usr/bin/env bash
 
/usr/local/bin/emacs --batch -l ~/.emacs.d/init.el --eval '(org-icalendar-combine-agenda-files)'
