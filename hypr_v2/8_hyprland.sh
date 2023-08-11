#!/bin/bash

### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
sudo make install &&
sudo cp example/hyprland.desktop /usr/share/wayland-sessions/
cd ..
