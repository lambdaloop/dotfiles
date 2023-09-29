#!/usr/bin/env bash

cd /home/pierre/Pictures/wallpapers/chosen/small-desktops
rm -f 0 1 2 3 4 5 6 7 8 9
for i in 0 1 2 3 4 5 6 7 8 9; do
    ln -s "$(find ~/Pictures/wallpapers/chosen/small -type f -print | shuf | head -1)" $i
done
notify-send "changed jellyfish backgrounds"
