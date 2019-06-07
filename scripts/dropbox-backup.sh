#!/usr/bin/env bash

RS='rsync -ah --info=progress2'

$RS ~/dotfiles/scripts ~/Dropbox/backup 
$RS /jellyfish/shared/security/.gnupg ~/Dropbox/backup/security
$RS /jellyfish/shared/security/.password-store ~/Dropbox/backup/security
$RS /jellyfish/shared/security/.ssh ~/Dropbox/backup/security
