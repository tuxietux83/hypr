#!/bin/bash

### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
meson subprojects update --reset
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install
