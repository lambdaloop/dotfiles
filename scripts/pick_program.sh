#!/usr/bin/env bash

PATH=/home/pierre/bin:/home/pierre/.cabal/bin:$PATH

# /home/pierre/.cabal/bin/yeganesh -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# dmenu_run -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# /home/pierre/.cabal/bin/yeganesh -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash
# rofi -x -- -i -nb '#2d2d2d' -sb '#37526e'  -b -fn "Monospace-9" -l 10 | bash

rofi -show run -theme ~/.config/rofi/onedark.rasi
