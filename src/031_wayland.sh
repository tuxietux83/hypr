#!/bin/bash
set -e

### Wayland latest ok
[ ! -d wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
