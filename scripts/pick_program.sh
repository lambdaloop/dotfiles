#!/usr/bin/env bash

PATH=/home/pierre/bin:/home/pierre/.cabal/bin:$PATH

# /home/pierre/.cabal/bin/yeganesh -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# dmenu_run -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# /home/pierre/.cabal/bin/yeganesh -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# rofi -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash

# rofi -show run -theme ~/.config/rofi/onedark.rasi -bw 2 -columns 3
rofi -show run -theme ~/.config/rofi/ribbon.rasi -columns 1

# rofi -show run -bw 2 -columns 3 -location 0 -font "Noto Sans 18"

# rofi -sidebar-mode \
#      -modi run,drun,window \
#      -lines 12 \
#      -padding 18 \
#      -width 60 \
#      -location 0 \
#      -show drun \
#      -columns 3 \
#      -font "Noto Sans 18"
