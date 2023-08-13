#!/bin/bash
set -e

#### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
sudo make install &&
sudo mkdir -p -v /usr/share/wayland-sessions
sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
cd ..
