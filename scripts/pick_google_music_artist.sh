#!/usr/bin/env bash

# mpc stop

## remove any previous curl
# ps -ef | grep curl | grep localhost:9999 | cut -d ' ' -f 4 | xargs kill

gmusic=`ps -ef | grep -i gmusic | grep -i proxy`

if [ -z "$gmusic" ]; then
    echo 'starting proxy...'
    notify-send 'starting proxy...'
    /usr/bin/GMusicProxy -e krchtchk@gmail.com -p $(gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/mail/gmail-credentials.gpg) -f -H localhost
fi

artist=$(echo | yeganesh -p artists -- -nb "#2d2d2d" -sb "#37526e" -i -l 10 -b -fn "Noto Sans CJK KR-12")
echo $artist

if [ -z "$artist" ]; then
    exit
fi
   

station_url="http://localhost:9999/get_new_station_by_search?type=artist"
echo $station_url

song_urls=$(curl -G --data-urlencode artist="$artist" -s $station_url | grep -Po 'http.*')

if [ -n "$song_urls" ]; then
    mpc clear
    echo "$song_urls" | xargs mpc add
    mpc play
fi
