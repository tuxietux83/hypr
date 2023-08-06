#!/bin/bash

### Wayland latest
if [ -d wayland ];then rm -rfv wayland ;fi 
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland is installed, press enter to continue ..."

### Wayland-protocols latest
if [ -d wayland-protocols ];then rm -rfv wayland-protocols ;fi
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland-protocols is installed, press enter to continue ..."

### Libdisplay-info latest
if [ -d libdisplay-info ];then rm -rfv libdisplay-info ;fi
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libdisplay-info is installed, press enter to continue ..."

### Libliftoff latest
if [ -d libliftoff ];then rm -rfv libliftoff ;fi
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libliftoff is installed, press enter to continue ..."

# Libinput latest
if [ -d libinput ];then rm -rfv libinput ;fi
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libinput is installed, press enter to continue ..."

### Wlroots
if [ -d wlroots ];then rm -rfv wlroots ;fi
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wlroots is installed, press enter to continue ..."

### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
meson subprojects update --reset
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install
