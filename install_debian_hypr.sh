#!/usr/bin/bash
set -e
ninjameson="1" # 0->config only, 1->config->build->install
## List of apps and libs
# Apps that you desire
apps=(
	[title]="apps"
	apt-file
	mlocate
	mako-notifier
	libnotify-bin
	geany
	mpv
	kitty
	firefox-esr
	polkit-kde-agent-1
	wofi
	unzip
	rar
	thunar
	thunar-archive-plugin
	thunar-volman
	gvfs-fuse
	gvfs-backends
	udiskie
	xwayland
	rsync
)
# Drivers (intel for me)
drivers=(
	[title]="drivers"
	intel-media-va-driver
	vainfo
)
# Some fonts
fonts=(
	[title]="fonts"
	fonts-jetbrains-mono
	fonts-font-awesome
	xfonts-terminus	
)
# Network manager and tray icon
network=(
	[title]="network"
	network-manager-gnome
	nm-tray
)
# Audio, we go with pipewire and wireplumber
audio=(
	[title]="audio"
	pipewire
	wireplumber
	pavucontrol
	pasystray
)
# Some tweeks
appeareance=(
	[title]="appeareance"
	qtwayland5
	qt6-wayland
	gnome-icon-theme
	tango-icon-theme
	arc-theme
	breeze-gtk-theme
	breeze-icon-theme
	breeze-cursor-theme
	lxappearance
	gtk-theme-switch
)
# Base build libs
build=(
	[title]="build"
	build-essential
	meson
	ninja-build
	pkg-config
	cmake
	check
 	golang
)
# Libdisplay-info libs
libdisplay_info=(
	[title]="libdisplay-info"
	hwdata
	edid-decode
)
# Libinput libs
libinput=(
	[title]="libinput"
	libudev-dev
	libmtdev-dev
	libevdev-dev
	libwacom-dev
	libgtk-4-dev
	libsystemd-dev
	valgrind
)
# Libliftoff libs
libliftoff=(
	[title]="libliftoff"
	libdrm-dev
)
# Wayland libs
wayland=(
	[title]="wayland"
	libxml2-dev
	graphviz
	doxygen
	xsltproc
)
# Wayland-protocols libs
wayland_protocols=(
	[title]="wayland-protocols"
)
# Wlroots libs
wlroots=(
	[title]="wlroots"
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
# XDG-desktop-portal-hyprland libs
xdg_desktop_portal_hyprland=(
	[title]="xdg-desktop-portal-hyprland"
	libpipewire-0.3-dev
	libinih-dev
	xdg-desktop-portal
 	qt6-base-dev
)
# Hyprland libs
hyprland=(
	[title]="hyprland"
	jq
)
# Waybar libs
waybar=(
	[title]="waybar"
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
	scdoc
	clang-tidy
	catch2
)
nwg_look=(
	[title]="nwg-look"
	libwebkit2gtk-4.0-dev
)
PKG_LIST=( "${apps[*]}" "${drivers[*]}" "${fonts[*]}" "${network[*]}" "${audio[*]}" "${appeareance[*]}" "${build[*]}"\
		"${libdisplay_info[*]}" "${libinput[*]}" "${libliftoff[*]}" "${wayland[*]}" "${wayland_protocols[*]}" "${wlroots[*]}"\
		"${xdg_desktop_portal_hyprland[*]}" "${hyprland[*]}" "${waybar[*]}" "${nwg_look[*]}" )
# Colors
default=$(tput sgr0)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
bold=$(tput bold)

# Info
action="[${green}ACTION${default}]"
question="[${cyan}QUESTION${default}]"
info="[${blue}INFO${default}]"

# Check if is running as user
if [[ $EUID == 0 ]]; then
    echo -e "${info}: ${green}Please dont run as ${red}ROOT${green}!${default}"
    exit 1
fi

# Nala or apt-get
echo
echo "${green}What package manager would you like to use${default}:"
echo
echo "1: ${yellow}nala ${default}- ${cyan}apt-get ${green}but more fancy${default}"
echo "2: ${yellow}apt-get${default}"
echo
read -p "${cyan}Select option${default}: " option
case $option in
	1)
		if ! command -v nala &>/dev/null; then
			sudo apt-get update
			sudo apt-get install -y nala
			pkg_mngr="nala"
			echo -e "${action}: ${yellow}nala${default}: ${green}installed ok${default}!"
		else
			sudo apt-get update
			pkg_mngr="nala"
		fi
		;;
	2)
		sudo apt-get update
		pkg_mngr="apt-get"
		echo -e "${info}: ${yellow}apt-get${default}: ${green}ok${default}!"
		;;
	*)
		echo -e "${info}: ${red}Invalid option${default}!"
		exit 1
		;;
esac

# We go in lazy mode to enable non-free and contrib
sudo "$pkg_mngr" install -y software-properties-common
sudo apt-add-repository -y non-free contrib
# Here we go
clear

# To build, we need some paths to export
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH
#export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
#export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
#export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH

### Installing ...
for installs in "${PKG_LIST[@]}"; do
var_apps=$(echo "$installs" | cut -d' ' -f1)
var_install=$(echo "$installs" | cut -d' ' -f2-)
echo
echo -e "${info}: ${yellow}We need this for ${green}$var_apps${default}:\n ${default}$installs${default}"
read -p "${action}: ${green}Press${default} ENTER${green} to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install $var_install
clear
done

echo
echo -e "${info}: ${yellow}We need this for ${green}SDDM${default} & ${green}xmlto${default}:\n ${yellow}This two sucks ...${default}"
read -p "${action}: ${green}Press${default} ENTER${green} to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y sddm --no-install-recommends
sudo "$pkg_mngr" install -y xmlto --no-install-recommends
clear

# Making install directory
if [ ! -d install ]; then
	mkdir install && cd install
	echo -e "${action}: ${yellow}Make directory ${green}install${default}."
else
	cd install
	echo -e "${info}: ${yellow}Directory exist ${green}install${default}."
fi
clear

### LibInput -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}libinput${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d libinput ] && git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/
[ "$ninjameson" = 1 ] && sudo ninja -C build/ install
# Adding user to group input
echo -e "${action}: ${yellow}Adding ${green}$USER ${yellow} to ${default}input ${cyan}Group${default}."
if ! groups $USER | grep &>/dev/null "\binput\b";then
    sudo usermod -a -G input $USER
    echo -e "${action}: ${yellow}User ${green}$USER${yellow} added to ${default}input ${cyan}Group${default}."
else
    echo -e "${info}: ${yellow}User ${green}$USER${yellow} already is in ${default}input ${cyan}Group${default}."
fi
cd ..
clear

### Libdisplay-info -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}libdisplay-info${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d libdisplay-info ] && git clone https://gitlab.freedesktop.org/emersion/libdisplay-info.git
cd libdisplay-info
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
meson setup --prefix=/usr --buildtype=release build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && sudo ninja -C build/ install
cd ..
clear

### Wayland-Protocols -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}Wayland-Protocols${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d wayland-protocols ] && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
meson setup --prefix=/usr --buildtype=release build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && sudo ninja -C build/ install
cd ..
clear

### Wayland -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}Wayland${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d wayland ] && git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && sudo ninja -C build install
cd ..
clear

### Wlroots and libliftoff -> Git versions (latest)
read -p "${action}: ${yellow}Trying to install ${green}wlroots ${yellow}and ${green}libliftoff${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d wlroots ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
cd wlroots
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff/build ] && sudo rm -rfv subprojects/libliftoff/build
meson setup --prefix=/usr --buildtype=release build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && sudo ninja -C build/ install
cd ..
clear

# XDG-desktop-portal-hyprland -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}XDG-desktop-portal-hyprland${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d xdg-desktop-portal-hyprland ] && git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rf build
meson setup --prefix=/usr --buildtype=release build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && cd hyprland-share-picker && make all && cd ..
[ "$ninjameson" = 1 ] && sudo ninja -C build/ install
cd ..
clear

#### Hyprland and libliftoff -> Git versions (latest)
read -p "${action}: ${yellow}Trying to install ${green}Hyprland ${yellow}and ${green}libliftoff${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d Hyprland ] && git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
[ ! -d subprojects/libliftoff ] && git clone https://gitlab.freedesktop.org/emersion/libliftoff.git subprojects/libliftoff
[ -d subprojects/libliftoff/build ] && sudo rm -rfv subrpojects/libliftoff/build
meson setup --prefix=/usr --buildtype=release build/ &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build/ &&
[ "$ninjameson" = 1 ] && sudo ninja -C build install
if [ ! -d /usr/share/wayland-sessions ]; then
	sudo mkdir -p -v /usr/share/wayland-sessions
	echo -e "${action}: Dir ${green}wayland-sessions ${yellow}created in ${default}/usr/share/"
	if [ ! -f /usr/share/wayland-sessions/hyprland.desktop ]; then
		sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
		echo "${action}: ${yellow}Copy ${green}hyprland.desktop ${yellow} to: ${default}/usr/share/wayland-sessions"
	fi
else
	echo -e "${info}: ${yellow}Dir ${green}wayland-session ${yellow} exist in ${default}/usr/share"
	echo -e "${info}: ${yellow}File ${green}hyprland.desktop ${yellow}exist in: ${default}/usr/share/wayland-sessions"
fi
cd ..
clear

# Waybar -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}Waybar${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}We link ${green}iniparse.h ${yellow} from ${default}/usr/include/iniparser ${yellow} to ${default}/usr/include"
[ ! -f /usr/include/iniparser.h ] && sudo ln -s -v /usr/include/iniparser/* /usr/include/
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d Waybar ] && git clone https://github.com/Alexays/Waybar.git
cd Waybar
echo -e "${action}: ${yellow}If we have a ${green}build${default}. ${yellow}we remove, else we pass ${default}..."
[ -d build ] && rm -rfv build
echo -e "${action}: ${yellow}We patch ${default}src/modules/wlr/workspace_manager.cpp ${yellow}for ${green}Hyprland${default}"
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson setup --prefix=/usr --buildtype=release --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && ninja -C build &&
[ "$ninjameson" = 1 ] && sudo ninja -C build install
cd ..
clear

# nwg-look -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}nwg-look${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
echo -e "${info}:${yellow} Dont't panic, this will take a while${default} ..."
[ ! -d nwg-look ] && git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
read -p "${question}: ${yellow}Did the ${red}build${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
[ "$ninjameson" = 1 ] && sudo make install
cd ../..
clear

# CleanUp
echo -e "${action}: ${yellow}We remove ${default}install ${yellow}directory${default}"
sleep 2
[ -d install ] && rm -rfv install
clear

### Post install
echo -e "${action}: ${yellow}Post install ${default}..."
echo
# Making network manager work
echo -e "${action}: ${yellow}Making ${green}NetworkManager ${yellow}to work ${default}..."
[ -f /etc/NetworkManager/NetworkManager.conf ] && sudo sed -i '/^\[ifupdown\]$/ {N; s/managed=false/managed=true/; }' "/etc/NetworkManager/NetworkManager.conf"
echo -e "${action}: ${yellow}Restarting ${green}NetworkManager${default}"
sudo service NetworkManager restart

### Check if there is a dot folder
echo -e "${action}: ${yellow}We check for ${green}dot ${yellow}folder${default}"
[ ! -d dot ] && echo -e "${info}: ${yellow}Folder ${green}dot ${yellow}not found${default}" && exit 1

echo -e "${action}: ${yellow}We add some spice to finish the install${default}"
# Check and make session target, sway included also
[ ! -d $HOME/.config/systemd/user/ ] && mkdir -pv $HOME/.config/systemd/user/
[ ! -f $HOME/.config/systemd/user/session-hyprland.target ] && cp -rv dot/config/systemd/user/session-hyprland.target $HOME/.config/systemd/user/
[ ! -f $HOME/.config/systemd/user/session-sway.target ] && cp -rv dot/config/systemd/user/session-sway.target $HOME/.config/systemd/user/session-sway.target
# Autostart script (works on hyprland and sway)
[ ! -d $HOME/bin ] && mkdir -pv $HOME/bin
if [ ! -f $HOME/bin/autostart.sh ]; then
	cp -rv dot/bin/autostart.sh $HOME/bin/
	chmod +x $HOME/bin/autostart.sh
	ls -l $HOME/bin/autostart.sh
fi
if [ ! -f $HOME/bin/theme.sh ]; then
	cp -rv dot/bin/theme.sh $HOME/bin/
	chmod +x $HOME/bin/theme.sh
	ls -l $HOME/bin/theme.sh
fi
date_tag=$(date +"%Y%m%d%H%M")
while true; do
echo -e "${info}: ${yellow}This script depends on config provided in ${green}dot ${yellow}folder${default}"
echo -e "${info}: ${yellow}Your original configs will be backed up in${default}: $HOME/.config/backup/"
read -p "${cyan}Proceed${default}: ${green}Y${default}/${green}y ${default}or ${red}N${default}/${red}n${default}: " backup
case $backup in
	Y|y)
	source_dir="dot/config"
	dest_dir="$HOME/.config/backup/${date_tag}"
	echo -e "${info}: ${yellow}BackingUp${default}: $HOME/.config/backup/${date_tag}"
	mkdir -pv "$HOME/.config/backup/${date_tag}"
		if [ -d "$HOME/.config/systemd" ]; then
			exclude_dir="systemd"
		else
			exclude_dir=""
		fi
	directories=($(ls -1 -I "$exclude_dir" "$source_dir"))
		for dir in "${directories[@]}"; do
    		mv_dir="$HOME/.config/$dir"
    		if [ -d "$mv_dir" ];then
				mv -v "$mv_dir" "$dest_dir"
			fi
		done
	[ -d $HOME/.config/systemd ] && rsync -av --exclude "$source_dir/systemd" "$source_dir/" "$HOME/.config"
	[ ! -d $HOME/.config/systemd ] && rsync -av "$source_dir/" "$HOME/.config"
 	exit 0
	;;
	N|n)
	echo -e "${action} ${yellow} Nothing to do ${default}."
	exit 0
	;;
	*)
	echo -e "${info}: ${red}Invalid option${default}!"
	;;
esac
done
