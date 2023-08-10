#!/bin/bash

### Wayland-protocols latest ok
if [ -d wayland-protocols ];then rm -rfv wayland-protocols ;fi
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland-protocols is installed, press enter to continue ..."
