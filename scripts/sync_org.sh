#!/usr/bin/env bash

TMP_DIR=/tmp/org-tmp/org
# files=`find ~/Dropbox ~/research -type f -name "*\.org" -print`
files=`emacsclient --eval 'org-agenda-files' | tr -d '()"~'`

rm -rf $TMP_DIR
mkdir -p $TMP_DIR

for file in $files; do
    file="$HOME/$file"
    dir=`basename $(dirname $file)`
    # fnew=${dir}_$(basename $file)
    fnew=$(basename $file)
    # echo "$fnew"
    # rsync -zhv $file personal:~/org/$fnew
    cp $file $TMP_DIR/$fnew
done

rsync -ahv $TMP_DIR personal:~/

ssh personal 'cd org; git add .; git commit -am "commit"'

