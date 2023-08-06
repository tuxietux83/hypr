#!/bin/bash

### Wayland latest
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
mkdir build &&
cd    build &&
meson setup .. --prefix=/usr --buildtype=release -Ddocumentation=false &&
ninja
sudo ninja install
cd ../..

### Wayland-protocols latest
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
mkdir build &&
cd    build &&
meson setup --prefix=/usr --buildtype=release &&
ninja
sudo ninja install
cd ../..

### Libdisplay-info latest
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
mkdir build &&
cd    build &&
meson setup --prefix=/usr --buildtype=release &&
ninja
sudo ninja install
cd ../..

### Libliftoff latest
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup build/
ninja -C build/
cd build
sudo ninja install
cd ../..
### Hyprland latest
git clone https://github.com/hyprwm/Hyprland.git
cd Hyprland
sudo make install
cd ..
