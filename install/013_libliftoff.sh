#!/bin/bash
set -e

### Libliftoff latest ok
if [ -d libliftoff ];then rm -rfv libliftoff ;fi
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
read -p "libliftoff is installed, press enter to continue ..."
