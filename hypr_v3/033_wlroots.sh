#!/bin/bash
set -e

### Wlroots ok
if [ -d wlroots ];then rm -rfv wlroots ;fi
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
read -p "wlroots is installed, press enter to continue ..."

