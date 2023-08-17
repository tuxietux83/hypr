#!/bin/bash
set -e

### Libdisplay-info latest ok
[ ! -d libdisplay-info ] && git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
# read -p "libdisplay-info is installed, press enter to continue ..."
