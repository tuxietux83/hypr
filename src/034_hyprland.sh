#!/bin/bash
set -e

#### Hyprland latest
[ ! -d Hyprland ] && git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
[ -d build ] && sudo rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff ] && sudo rm -rfv subrpojects/libliftoff
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build install
sudo mkdir -p -v /usr/share/wayland-sessions
sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
cd ..

