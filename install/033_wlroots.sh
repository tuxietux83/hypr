#!/bin/bash
set -e

### Wlroots ok
[ ! -d wlroots ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
[ -d build ] && sudo rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff/build ] && sudo rm -rfv subprojects/libliftoff/build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..

