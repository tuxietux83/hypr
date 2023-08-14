#!/usr/bin/bash
set -e
### Notes
# libinput -> ok 1
# libdisplay-info -> ok 2
# wayland-protocols subprojects wayland -> ok 3
# wlroots subprojects libliftoff -> ok 4
# xdg-desktop-portal-hyprland -> ok 5
# hyprland subproject libliftoff -> ok 6


apps=(
	apt-file
	mlocate
)
build=(
	build-essential
	meson
	ninja-build
	pkg-config
	cmake
	check
)
libdisplay_info=(
	hwdata
	edid-decode
)
libinput=(
	libudev-dev
	libmtdev-dev
	libevdev-dev
	libwacom-dev
	libgtk-4-dev
	libsystemd-dev
	valgrind
)
libliftoff=(
	libdrm-dev
)
wayland=(
	libxml2-dev
)
wayland_protocols=(
)
wlroots=(
	glslang-tools
	libgbm-dev
	libavutil-dev
	libavcodec-dev
	libavformat-dev
	libseat-dev
	libxcb-dri3-dev
	libxcb-present-dev
	libxcb-composite0-dev
	libxcb-render-util0-dev
	libxcb-ewmh-dev
	libxcb-xinput-dev
	libxcb-icccm4-dev
	libxcb-res0-dev
)
xdg_desktop_portal_hyprland=(
	libpipewire-0.3-dev
	libinih-dev
)
hyprland=(
	jq
)
waybar=(
	libgtkmm-3.0-dev
	libdbusmenu-gtk3-dev
	libjsoncpp-dev
	libnl-3-dev
	libnl-genl-3-dev
	libupower-glib-dev
	libplayerctl-dev
	libpulse-dev
	libmpdclient-dev
	libxkbregistry-dev
	libjack-dev
	libwireplumber-0.4-dev
	libsndio-dev
	libgtk-layer-shell-dev
	libiniparser-dev
	libfftw3-dev
	libncurses5-dev
	libasound2-dev
	libportaudio-ocaml-dev
	libsdl2-dev
	scdoc
	clang-tidy
	catch2
)

sudo apt install -y "${apps[@]}"
sudo apt install -y "${build[@]}"
sudo apt install -y "${libdisplay_info[@]}"
sudo apt install -y "${libinput[@]}"
sudo apt install -y "${libliftoff[@]}"
sudo apt install -y "${wayland[@]}"
sudo apt install -y "${wayland_protocols[@]}"
sudo apt install -y "${wlroots[@]}"
sudo apt install -y "${xdg_desktop_portal_hyprland[@]}"
sudo apt install -y "${hyprland[@]}"
sudo apt install -y "${waybar[@]}"
clear

[ ! -d install ] && mkdir install
cd install

read -p "Trying to install libinput, press enter to continue ..."
## Libinput latest ok
[ ! -d libinput ] && git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
# Adding user to group input
if ! groups $USER | grep &>/dev/null "\binput\b";then
    sudo usermod -a -G input $USER
    echo "User $USER added to INPUT group"
else
    echo "User $USER already is in group INPUT"
fi
clear

read -p "Trying to install libdisplay-info, pres enter to continue ..."
### Libdisplay-info latest ok
[ ! -d libdisplay-info ] && git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
[ -d build ] && sudo rm -rfv build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear

read -p "Trying to install wayland-protocols and wayland, press enter to continue ..."
### Wayland-protocols latest ok
[ ! -d wayland-protocols ] && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
[ -d build ] && sudo rm -rfv build

[ -d /subprojects/wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git subprojects/wayland
[ -d suprojects/wayland/build ] && sudo rm -rfv subprojects/wayland/build

meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear

read -p "Trying to install wlroots and libliftoff, press enter to continue ..."
### Wlroots ok
[ ! -d wlroots ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
[ -d build ] && sudo rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff/build ] && sudo rm -rfv subprojects/libliftoff/build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear

read -p "Trying to install xdg-desktop-portal-hyprland, press enter to continue"
# xdg-desktop-portal-hyprland
[ ! -d xdg-desktop-portal-hyprland ] && git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
[ -d build ] && sudo rm -rf build
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear

read -p "Trying to install hyprland and libliftoff again ..., press enter to continue"
#### Hyprland latest
[ ! -d Hyprland ] && git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
[ -d build ] && sudo rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff ] && sudo rm -rfv subrpojects/libliftoff
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build install
[ ! -d /usr/share/wayland-session ] && sudo mkdir -p -v /usr/share/wayland-sessions
[ ! -f /usr/share/wayland-session/hyprland.desktop ] && sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
cd ..
clear

read -p "Trying to install waybar, press enter to continue ..."
# Waybar latest ok
[ ! -f /usr/include/iniparser.h ] && sudo ln -s -v /usr/include/iniparser/* /usr/include/
[ ! -d Waybar ] && git clone https://github.com/Alexays/Waybar.git
cd Waybar
[ -d build ] && sudo rm -rfv build
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson setup --prefix=/usr --buildtype=release --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
ninja -C build
sudo ninja -C build install
cd ..

cd ..
[ -d install ] && sudo rm -rfv install
