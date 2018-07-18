#!/usr/bin/env bash

export BORG_PASSPHRASE=`pass online/rsync.net-backup`

folders=(~/cs ~/research ~/learning ~/Dropbox)
folders_unlink=`for folder in ${folders[*]}; do readlink $folder; done | tr '\n' ' '`

borg create -C lz4 -v -p --stats --remote-path=borg1 \
     rsync:backup::jellyfish-{user}-{now:%Y-%m-%dT%H-%M} \
     $folders_unlink
#~/Camera
