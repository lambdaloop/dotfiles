#!/usr/bin/env bash

BOOK_PATH="/home/pierre/Dropbox/reading/current"

# BOOK=$(ls $BOOK_PATH | dmenu -i -b -l 12 -fn "Open Sans-10")
BOOK=$(ls $BOOK_PATH | rofi -dmenu -i -font "Open Sans 20")

if [ -n "$BOOK" ]; then
    evince "$BOOK_PATH/$BOOK"
fi
