#!/usr/bin/env bash

RS='rsync -ah --info=progress2'

$RS ~/.gnupg ~/Dropbox/backup/security
$RS ~/.password-store ~/Dropbox/backup/security
$RS ~/scripts ~/Dropbox/backup 
$RS ~/.ssh ~/Dropbox/backup/security
