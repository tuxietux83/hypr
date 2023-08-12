#!/bin/bash
set -e

#### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland/subprojects

git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
git clone https://gitlab.freedesktop.org/libinput/libinput
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
git clone https://gitlab.freedesktop.org/wayland/wayland.git
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd ..

meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install

# sudo make install &&
# sudo mkdir -p -v /usr/share/wayland-sessions
# sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
cd ..
