#!/bin/bash

# Libinput latest ok
if [ -d libinput ];then rm -rfv libinput ;fi
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libinput is installed, press enter to continue ..."
