#!/usr/bin/env bash

TODO_FILE=/home/pierre/Dropbox/lists/todo.txt

N_LINES=`grep -nP "^\s*$" $TODO_FILE | head -3 | tail -1 | cut -d: -f1`

TEXT=`head -$N_LINES $TODO_FILE | sed 's_^-\(.*\)$_<b>\1</b>_' | sed s/-/\*/ | sed 's/&/&amp;/'`

notify-send "<u>TODO</u>" "$TEXT"
