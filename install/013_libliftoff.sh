#!/bin/bash
set -e

### Libliftoff latest ok
[ ! -d libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
#sudo ninja -C build/ install
cd ..
