#!/usr/bin/bash
set -e
if [[ $EUID == 0 ]]; then
    echo -e "Don't be ROOT!"
    exit 1
fi

apps=(
	[title]="Applications"
	kitty
	dunst
	geany
	wofi
	thunar
	firefox-esr
)
fonts=(
	[title]="Fonts"
	fonts-jetbrains-mono
	fonts-font-awesome
	xfonts-terminus	
)
build=(
	[title]="Build-Essentials"
	build-essential
	cmake
	meson
	ninja-build
 	golang
	check
	hwdata
	edid-decode
	glslang-tools
	jq
	qt6-base-dev
	scdoc
	clang-tidy
	catch2
)
lib_dev=(
	[title]="Dev-Libraries"
	libudev-dev
	libmtdev-dev
	libevdev-dev
	libwacom-dev
	libdrm-dev
	libgbm-dev
	libseat-dev
	libavutil-dev
	libavcodec-dev
	libavformat-dev
	libvulkan-dev
	libxcb-dri3-dev
	libxcb-composite0-dev
	libxcb-render-util0-dev
	libxcb-ewmh-dev
	libxcb-xinput-dev
	libxcb-icccm4-dev
	libxcb-res0-dev
	libxcb-present-dev
	libsystemd-dev
	libgtk-4-dev
	libinih-dev
	libpipewire-0.3-dev
	libwebkit2gtk-4.0-dev
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
	portaudio19-dev
 	libsdl2-dev
	libfmt-dev
	libspdlog-dev
)
system=(
	[title]="System"
	libnotify-bin
	network-manager-gnome
	seatd
	pipewire
	wireplumber
	pavucontrol
	pasystray
	polkit-kde-agent-1
	qtwayland5
	qt6-wayland
	qt5ct
	gnome-icon-theme
	arc-theme
	breeze-gtk-theme
	breeze-icon-theme
	breeze-cursor-theme
	xwayland
)
PKG_LIST=( "${build[*]}" "${fonts[*]}" "${apps[*]}" "${lib_dev[*]}" "${system[*]}" )
pkg_mngr="apt"

for installs in "${PKG_LIST[@]}"; do
var_apps=$(echo "$installs" | cut -d' ' -f1)
var_install=$(echo "$installs" | cut -d' ' -f2-)
sudo "$pkg_mngr" install -y $var_install
done

[ ! -f /usr/include/xlocale.h ] && sudo ln -s /usr/include/locale.h /usr/include/xlocale.h
[ ! -f /usr/include/iniparser.h ] && sudo ln -s -v /usr/include/iniparser/* /usr/include/

# Making install directory
[ ! -d install ] && mkdir install

# Getting sources
[ ! -d install/libinput ] && git clone https://gitlab.freedesktop.org/libinput/libinput.git &&
	mv -v libinput install/libinput # libinput
[ ! -d install/hyprland  ] && wget -nv https://github.com/hyprwm/Hyprland/releases/download/v0.28.0/source-v0.28.0.tar.gz &&\
	tar -zxvf source-v0.28.0.tar.gz &>/dev/null &&
	mv -v hyprland-source install/hyprland && rm -v source-v0.28.0.tar.gz # hyprland
[ ! -d install/hyprland/subprojects/wayland ] && wget -nv https://gitlab.freedesktop.org/wayland/wayland/-/archive/1.22.0/wayland-1.22.0.tar.gz &&\
	tar -zxvf wayland-1.22.0.tar.gz &>/dev/null &&\
	mv -v wayland-1.22.0 install/hyprland/subprojects/wayland && rm -v wayland-1.22.0.tar.gz # wayland
[ ! -d install/hyprland/subprojects/wayland-protocols ] && wget -nv https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.32/wayland-protocols-1.32.tar.gz &&\
	tar -zxvf wayland-protocols-1.32.tar.gz &>/dev/null &&\
	mv -v wayland-protocols-1.32 install/hyprland/subprojects/wayland-protocols && rm -v wayland-protocols-1.32.tar.gz # wayland-protocols
[ ! -d install/hyprland/subprojects/libdisplay-info ] && wget -nv https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/0.1.1/libdisplay-info-0.1.1.tar.gz &&\
	tar -zxvf libdisplay-info-0.1.1.tar.gz &>/dev/null &&\
	mv -v libdisplay-info-0.1.1 install/hyprland/subprojects/libdisplay-info && rm -v libdisplay-info-0.1.1.tar.gz # libdisplay
[ ! -d install/hyprland/subprojects/libliftoff ] && wget -nv https://gitlab.freedesktop.org/emersion/libliftoff/-/archive/v0.4.1/libliftoff-v0.4.1.tar.gz &&\
	tar -zxvf libliftoff-v0.4.1.tar.gz &>/dev/null &&\
	mv -v libliftoff-v0.4.1 install/hyprland/subprojects/libliftoff && rm -v libliftoff-v0.4.1.tar.gz # libliftoff
[ ! -d install/xdg-desktop-portal-hyprland ] && git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git &&\
	mv -v xdg-desktop-portal-hyprland install/xdg-desktop-portal-hyprland #xdg-desktop-portal-hyprland
[ ! -d install/waybar ] && wget -nv https://github.com/Alexays/Waybar/archive/refs/tags/0.9.22.tar.gz &&\
	tar -zxvf 0.9.22.tar.gz &>/dev/null &&\
	mv -v Waybar-0.9.22 install/waybar && rm -v 0.9.22.tar.gz # waybar

cd install

# libinput
cd libinput
[ -d build ] && rm -rfv build
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
sudo ninja -C build install
cd ..

# Hyprland and subprojects
cd hyprland
[ -d build ] && rm -rfv build
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
sudo ninja -C build install
cd ..

# XDG-Desktop-Portal-Hyprland
cd xdg-desktop-portal-hyprland
[ -d build ] && rm -rfv build
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
cd hyprland-share-picker && make all && cd ..
sudo ninja -C build install
sudo cp -v ./hyprland-share-picker/build/hyprland-share-picker /usr/bin
cd ..

#waybar
cd waybar
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
[ -d build ] && rm -rfv build
[ ! -d build ] && meson setup --prefix=/usr --auto-features=enabled build
meson configure -Dexperimental=true build
ninja -C build
sudo ninja -C build install
cd ../..

# Delete install dir
rm -rf install
