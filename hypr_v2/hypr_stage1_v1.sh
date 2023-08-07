#!/usr/bin/bash
# Assunming git is installed
set -e
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi
# Installing stuffs to build hyprland
sudo apt install -y build-essential wget xwayland cmake libxcb-ewmh-dev pipewire wireplumber libpipewire-0.3-dev libinih-dev jq qtwayland5 qt6-wayland polkit-kde-agent-1 fonts-font-awesome
# Build dep
sudo apt build-dep libdisplay-info libliftoff libinput wlroots wayland wayland-protocols
## Installing stuffs to run with hyprland (minimum needed)
sudo apt install -y firefox-esr kitty mako-notifier sddm thunar usermod waybar wofy


##################### Building things ...
### Wayland latest ok
if [ -d wayland ];then rm -rfv wayland ;fi 
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland is installed, press enter to continue ..."

### Wayland-protocols latest ok
if [ -d wayland-protocols ];then rm -rfv wayland-protocols ;fi
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wayland-protocols is installed, press enter to continue ..."

### Libdisplay-info latest ok
if [ -d libdisplay-info ];then rm -rfv libdisplay-info ;fi
git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libdisplay-info is installed, press enter to continue ..."

### Libliftoff latest ok
if [ -d libliftoff ];then rm -rfv libliftoff ;fi
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "libliftoff is installed, press enter to continue ..."

# Libinput latest ok
if [ -d libinput ];then rm -rfv libinput ;fi
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/
ninja -C build/
sudo ninja -C build/ install
cd ..
sudo usermod -a -G input $USER
read -p "libinput is installed, press enter to continue ..."

### Wlroots ok
if [ -d wlroots ];then rm -rfv wlroots ;fi
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..
read -p "wlroots is installed, press enter to continue ..."

# xdg-desktop-portal-hyprland
if [ -d xdg-desktop-portal-hyprland ];then rm -rfv xdg-desktop-portal-hyprland ;fi
git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/
sudo ninja -C build/ install
cd ..

## Waybar latest
#if [ -d Waybar ];then rm -rfv Waybar ;fi
#git clone https://github.com/Alexays/Waybar.git
#cd Waybar
##sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
#meson setup --prefix=/usr --buildtype=release build/ &&
#ninja -C build/
#sudo ninja -C build/ install
#cd ..

### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
meson subprojects update --reset
meson setup --prefix=/usr --buildtype=release build/
ninja -C build/
sudo ninja -C build/ install


