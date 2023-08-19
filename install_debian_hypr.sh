#!/usr/bin/bash
set -e -u
## List of apps and libs
# Apps that you desire
apps=(
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
	intel-media-va-driver
	vainfo
)
# Some fonts
fonts=(
	fonts-jetbrains-mono
	fonts-font-awesome
	xfonts-terminus	
)
# Network manager and tray icon
network=(
	network-manager-gnome
	nm-tray
)
# Audio, we go with pipewire and wireplumber
audio=(
	pipewire
	wireplumber
	pavucontrol
	pasystray
)
# Some tweeks
appeareance=(
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
	hwdata
	edid-decode
)
# Libinput libs
libinput=(
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
	libdrm-dev
)
# Wayland libs
wayland=(
	libxml2-dev
	graphviz
	doxygen
	xsltproc
)
# Wayland-protocols libs
wayland_protocols=(
)
# Wlroots libs
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
# XDG-desktop-portal-hyprland libs
xdg_desktop_portal_hyprland=(
	libpipewire-0.3-dev
	libinih-dev
	xdg-desktop-portal
)
# Hyprland libs
hyprland=(
	jq
)
# Waybar libs
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
	libfmt-dev
	libspdlog-dev
	scdoc
	clang-tidy
	catch2
)
nwg_look=(
	libwebkit2gtk-4.0-dev
)

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

if [[ $EUID == 0 ]]; then
    echo -e "${info}: ${green}Please dont run as ${red}ROOT${green}!${default}"
    exit 1
fi
# Progress function
show_progress() {
    for ((i=0; i<10; i++)); do
        echo -n "${yellow}. ${default}"
        sleep 0.5
    done
    echo " "
}
# Call function
progress() {
    show_progress &
    progress_pid=$!
    sleep 5
    kill $progress_pid > /dev/null 2>&1
    echo "${green}Done${default}!"
}
clear
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
			sudo apt-get install -y nala
			pkg_mngr="nala"
			echo -e "${action}: ${yellow}nala${default}: ${green}installed ok${default}!"
		else
			pkg_mngr="nala"
			echo -e "${info}: ${yellow}nala${default}: ${green}already installed${default}!"
			
		fi
		;;
	2)
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
echo
echo -e "${info}: ${yellow}We need this for ${green}apps${default}:\n ${yellow}${apps[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${apps[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}drivers${default}:\n ${yellow}${drivers[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${drivers[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}fonts${default}:\n ${yellow}${fonts[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${fonts[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}network${default}:\n ${yellow}${network[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${network[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}audio${default}:\n ${yellow}${audio[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${audio[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}appeareances${default}:\n ${yellow}${appeareance[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${appeareance[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}build${default}:\n ${yellow}${build[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${build[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}libdisplay_info${default}:\n ${yellow}${libdisplay_info[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${libdisplay_info[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}libinput${default}:\n ${yellow}${libinput[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${libinput[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}libliftoff${default}:\n ${yellow}${libliftoff[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${libliftoff[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}wayland${default}:\n ${yellow}${wayland[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${wayland[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}wayland_protocols${default}:\n ${yellow}${wayland_protocols[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${wayland_protocols[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}wlroots${default}:\n ${yellow}${wlroots[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${wlroots[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}XDG_desktop_portal_hyprland${default}:\n ${yellow}${xdg_desktop_portal_hyprland[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${xdg_desktop_portal_hyprland[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}Hyprland${default}:\n ${yellow}${hyprland[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${hyprland[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}waybar${default}:\n ${yellow}${waybar[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${waybar[@]}"
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}SDDM${default} & ${green}xmlto${default}:\n ${yellow}This two sucks ...${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y sddm --no-install-recommends
sudo "$pkg_mngr" install -y xmlto --no-install-recommends
progress
clear
echo
echo -e "${info}: ${yellow}We need this for ${green}nwg-look${default}:\n ${yellow}${nwg_look[*]}${default}"
read -p "${green}Press enter to continue or ${red}Ctrl${default}+${red}c ${green}to abort${default} ..."
sudo "$pkg_mngr" install -y "${nwg_look[@]}"
progress
clear

# Making install directory
if [ ! -d install ]; then
	mkdir install && cd install
	echo -e "${action}: ${yellow}Make directory ${green}install${default}."
else
	cd install
	echo -e "${info}: ${yellow}Directory exist ${green}install${default}."
fi
progress
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
ninja -C build/
sudo ninja -C build/ install
# Adding user to group input
echo -e "${action}: ${yellow}Adding ${green}$USER ${yellow} to ${default}input ${cyan}Group${default}."
if ! groups $USER | grep &>/dev/null "\binput\b";then
    sudo usermod -a -G input $USER
    echo -e "${info}: ${yellow}User ${green}$USER${yellow} added to ${default}input ${cyan}Group${default}."
else
    echo -e "${info}: ${yellow}User ${green}$USER${yellow} already is in ${default}input ${cyan}Group${default}."
fi
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build install
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
progress
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
ninja -C build/ &&
sudo ninja -C build install
if [ ! -d /usr/share/wayland-sessions ]; then
	sudo mkdir -p -v /usr/share/wayland-sessions
	echo -e "${action}: Dir ${green}wayland-sessions ${yellow}created in ${default}/usr/share/"
else
	echo -e "${info}: ${yellow}Dir ${green}wayland-session ${yellow} exist in ${default}/usr/share"
fi
if [ ! -f /usr/share/wayland-sessions/hyprland.desktop ]; then
	sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
	echo "${action}: ${yellow}Copy ${green}hyprland.desktop ${yellow} to: ${default}/usr/share/wayland-sessions"
else
	echo -e "${info}: ${yellow}File ${green}hyprland.desktop ${yellow}exist in: ${default}/usr/share/wayland-sessions"
fi
cd ..
progress
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
progress
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson setup --prefix=/usr --buildtype=release --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
read -p "${question}: ${yellow}Did the ${red}config${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
ninja -C build &&
sudo ninja -C build install
cd ..
progress
clear

# nwg-look -> Git version (latest)
read -p "${action}: ${yellow}Trying to install ${green}nwg-look${default}, ${yellow}press ${red}Enter${yellow} to continue${default} ..."
echo -e "${action}: ${yellow}Cloning repository and entering it ${default}..."
[ ! -d nwg-look ] && git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
read -p "${question}: ${yellow}Did the ${red}build${yellow} pass${default}? ${yellow}If ${red}not${yellow} press ${red}Ctrl${default}+${red}c ${yellow}to ${red}abort${default}."
sudo make install
cd ../..
progress
clear

# CleanUp
echo -e "${action}: ${yellow}We remove ${default}install ${yellow}directory${default}"
sleep 4
[ -d install ] && sudo rm -rfv install
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
echo -e "${info}: ${yellow}This script depends on config provided in ${green}dot ${yellow}folder${default}"
echo -e "${info}: ${yellow}Your original configs will be backed up in${default}: $HOME/.config/backup/"
read -p "${cyan}Proceed${default}: ${green}Y${default}/${green}y ${default}or ${red}N${default}/${red}n${default}: " backup
case $backup in
	Y|y)
		echo -e "${info}: ${yellow}BackingUp${default}: $HOME/.config/backup/${date_tag}"
		mkdir -pv "$HOME/.config/backup/${date_tag}"
		source_dir="dot/config"
		dest_dir="$HOME/.config/backup/${date_tag}"
			if [ -d "$HOME/.config/systemd" ]; then
				exclude_dir="dot/config/systemd"
			else
				exclude_dir=""
			fi
		directories=($(find "$source_dir" -maxdepth 1 -type d -not -path "$exclude_dir" | tail -n +2))
			for dir in "${directories[@]}"; do
				dir_name=$(basename "$dir")
    				mv_dir="$HOME/.config/${dir_name}"
    				if [ -d "$mv_dir" ];then
					mv -v "$mv_dir" "$dest_dir"
     				fi
				rsync -av "$source_dir/" "$HOME/.config"
			done
		;;
	N|n)
		exit 1
		;;
	*)
		echo -e "${info}: ${red}Invalid option${default}!"
		exit 1
		;;
esac
