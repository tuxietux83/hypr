#!/bin/bash

### Wayland latest
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..

### Wayland-protocols latest
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..

### Libdisplay-info latest
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..

### Libliftoff latest
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install
cd ..

# Libinput latest
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/
ninja -C build/
sudo ninja -C build/ install
cd ..

### Wlroots
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..

### Hyprland latest
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
meson subprojects update --reset
meson setup build
ninja -C build
sudo ninja -C build install
