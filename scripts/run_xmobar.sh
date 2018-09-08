#!/usr/bin/env bash

cd /tmp
bash ~/scripts/reset_empty_pipe.sh &
fname=`bash ~/scripts/get_xmobar_config.sh`
xmobar $fname 



