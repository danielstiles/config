#!/bin/bash

EMACS_VERSION=$1
if [ -z $EMACS_VERSION ]; then
    EMACS_VERSION="29.1"
fi

sudo apt-get update
sudo apt-get install -y libjansson-dev libgccjit-10-dev gcc-10
export CC="gcc-10"
sudo apt build-dep -y emacs
wget https://ftp.gnu.org/pub/gnu/emacs/emacs-$EMACS_VERSION.tar.gz
tar xvf emacs-$EMACS_VERSION.tar.gz
cd emacs-$EMACS_VERSION
./autogen.sh
./configure --with-native-compilation
make -j4
sudo make install
cd ..
rm -rf emacs-$EMACS_VERSION*
