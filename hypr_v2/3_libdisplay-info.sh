#!/bin/bash

### Libdisplay-info latest ok
if [ -d libdisplay-info ];then rm -rfv libdisplay-info ;fi
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libdisplay-info is installed, press enter to continue ..."

