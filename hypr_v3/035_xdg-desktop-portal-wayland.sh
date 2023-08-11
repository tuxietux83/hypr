#!/bin/bash
set -e

# xdg-desktop-portal-hyprland
if [ -d xdg-desktop-portal-hyprland ];then rm -rfv xdg-desktop-portal-hyprland ;fi
git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..

