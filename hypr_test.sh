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
	check
	hwdata
	edid-decode
	glslang-tools
)
lib_dev=(
	[title]="Dev-Libraries"
	libseat-dev
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
	libwebkit2gtk-4.0-dev
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

# Making install directory
if [ ! -d install ]; then
	mkdir install && cd install
else
	cd install
fi

# libinput
[ ! -d libinput ] && git clone https://gitlab.freedesktop.org/libinput/libinput.git
cd libinput
[ -d build ] && meson setup --prefix=/usr build --wipe
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
sudo ninja -C build install
cd ..

# Hyprland and subprojects
[ ! -d Hyprland ] && git clone https://github.com/hyprwm/Hyprland.git
[ ! -d Hyprland/subprojects/wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git Hyprland/subprojects/wayland
[ ! -d Hyprland/subprojects/wayland-protocols ] && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git Hyprland/subprojects/wayland-protocols
[ ! -d Hyprland/subprojects/libdisplay-info ] && git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git Hyprland/subprojects/libdisplay-info
[ ! -d Hyprland/subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git Hyprland/subprojects/libliftoff
cd Hyprland
[ -d build ] && meson setup --prefix=/usr build --wipe
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
sudo ninja -C build install
cd ..

# XDG-Desktop-Portal-Hyprland
[ ! -d xdg-desktop-portal-hyprland ] && git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
[ -d build ] && meson setup --prefix=/usr build --wipe
[ ! -d build ] && meson setup --prefix=/usr build
ninja -C build
sudo ninja -C build install
cd ../..

# Delete install dir
rm -rfv install
