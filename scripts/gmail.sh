#!/usr/bin/env bash

count=`curl -s https://krchtchk:PASSWORDGOESHERE@mail.google.com/mail/feed/atom | grep fullcount | sed 's_<.*>\(.*\)</.*>_\1_'`
echo "<fc=yellow>Mail </fc><fc=green>$count</fc>"
