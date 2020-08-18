#!/usr/bin/env bash

export BORG_PASSPHRASE=`pass online/rsync.net-backup`

# folders=(~/cs ~/research ~/learning ~/Dropbox)
# folders_unlink=`for folder in ${folders[*]}; do readlink $folder; done | tr '\n' ' '`

# IP=$(ssh callisto "curl -s -6 ifconfig.co")

cd ~

borg create -C auto,lzma,6 -v -p --stats \
     --remote-path=miniconda3/bin/borg \
     --exclude-from ~/scripts/rsync_backup_exclude.txt \
     --exclude-if-present .nobak \
     callisto:backups/borg::callisto-{user}-{now:%Y-%m-%dT%H-%M} \
     cs research learning Dropbox \
     Pictures Music \
     dotfiles bin /etc  \
     .config .doom.d .emacs.d .mozilla .password-store .ssh
     # $folders_unlink
#~/Camera
