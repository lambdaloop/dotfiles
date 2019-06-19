#!/usr/bin/env bash

export BORG_PASSPHRASE=`pass online/rsync.net-backup`

# folders=(~/cs ~/research ~/learning ~/Dropbox)
# folders_unlink=`for folder in ${folders[*]}; do readlink $folder; done | tr '\n' ' '`

borg create -C lz4 -v -p --stats --remote-path=borg1 \
     --exclude-from ~/scripts/rsync_backup_exclude.txt \
     --exclude-if-present .nobak \
     rsync:backup::jellyfish-{user}-{now:%Y-%m-%dT%H-%M} \
     /jellyfish
     # $folders_unlink
#~/Camera
