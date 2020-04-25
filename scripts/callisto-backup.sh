#!/usr/bin/env bash

export BORG_PASSPHRASE=`pass online/rsync.net-backup`

# folders=(~/cs ~/research ~/learning ~/Dropbox)
# folders_unlink=`for folder in ${folders[*]}; do readlink $folder; done | tr '\n' ' '`

# IP=$(ssh callisto "curl -s -6 ifconfig.co")

borg create -C auto,lzma,6 -v -p --stats \
     --remote-path=miniconda3/bin/borg \
     --exclude-from ~/scripts/rsync_backup_exclude.txt \
     --exclude-if-present .nobak \
     callisto:backups/borg::europa-{user}-{now:%Y-%m-%dT%H-%M} \
     /jellyfish
     # $folders_unlink
#~/Camera
