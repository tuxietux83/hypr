#!/bin/bash
set -e

## Libinput latest ok
if [ -d libinput ];then rm -rfv libinput ;fi
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install

if ! groups $USER | grep &>/dev/null "\binput\b";then
    sudo usermod -a -G input $USER
    echo "User $USER added to INPUT group"
else
    echo "User $USER already is in group INPUT"
fi

cd ..
read -p "libinput is installed, press enter to continue ..."
