#!/usr/bin/env bash

cd ~/builds/emacs
#git pull origin master
# export PKG_CONFIG_PATH=/usr/lib/imagemagick6/pkgconfig
export CC="gcc-11"
# export CFLAGS='-O3'
./configure \
    --with-imagemagick --with-x-toolkit=gtk  --with-modules=yes --with-m17n-flt \
    --with-gif --with-gnutls --with-jpeg --with-png --with-tiff --with-mailutils --with-json \
    --with-cairo --with-native-compilation --with-xft
make -j6
sudo make install

