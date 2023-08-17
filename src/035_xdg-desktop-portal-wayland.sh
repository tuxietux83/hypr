#!/bin/bash
set -e

# xdg-desktop-portal-hyprland
[ ! -d xdg-desktop-portal-hyprland ] && git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
[ -d build ] && sudo rm -rf build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..

