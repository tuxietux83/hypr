#!/bin/bash

### Wayland latest ok
if [ -d wayland ];then rm -rfv wayland ;fi 
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland is installed, press enter to continue ..."
