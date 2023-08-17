#!/bin/bash
set -e

## Libinput latest ok
[ ! -d libinput ] && git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
# Adding user to group input
if ! groups $USER | grep &>/dev/null "\binput\b";then
    sudo usermod -a -G input $USER
    echo "User $USER added to INPUT group"
else
    echo "User $USER already is in group INPUT"
fi


