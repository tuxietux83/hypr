#!/bin/bash
set -e

### Wayland-protocols latest ok
[ ! -d wayland-protocols ] && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
[ -d build ] && sudo rm -rfv build

[ -d /subprojects/wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git subprojects/wayland
[ -d suprojects/wayland/build ] && sudo rm -rfv subprojects/wayland/build

meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..

