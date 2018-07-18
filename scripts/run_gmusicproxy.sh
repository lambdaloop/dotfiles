#!/usr/bin/env bash

GMAIL_PASSWORD=$(gpg --quiet --for-your-eyes-only --no-tty --decrypt ~/tmp/gmail.gpg)

GMusicProxy -e krchtchk@gmail.com -p $GMAIL_PASSWORD -f -H localhost -d 31208fa6de1aa818
