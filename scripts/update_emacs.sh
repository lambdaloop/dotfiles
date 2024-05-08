#!/usr/bin/env bash

cd ~/builds/emacs
#git pull origin master
# export PKG_CONFIG_PATH=/usr/lib/imagemagick6/pkgconfig
make extraclean
export CC="gcc-12"
bash autogen.sh
./configure --with-dbus --with-gif --with-jpeg --with-png --with-rsvg \
    --with-cairo --with-libsystemd --with-tree-sitter \
    --with-tiff --with-xft --with-xpm \
    --with-x-toolkit=gtk3 --with-modules --with-native-compilation  \
    CFLAGS="-O3 -mtune=native -march=native -fomit-frame-pointer"
make -j4 NATIVE_FULL_AOT=1
# make -j6
sudo make install

