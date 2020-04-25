#!/usr/bin/env bash

cd ~/builds/emacs
git pull origin master
# export PKG_CONFIG_PATH=/usr/lib/imagemagick6/pkgconfig
./configure --with-imagemagick --with-x-toolkit=lucid --with-xft --with-modules=yes --with-m17n-flt
make -j4
sudo make install

