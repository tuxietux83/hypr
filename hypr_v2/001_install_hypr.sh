#!/usr/bin/bash
set -e
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi
apps=(
firefox-esr
kitty
mako-notifier
thunar
wofi
fonts-font-awesome
network-manager-gnome
nm-tray
)
echo -e "\nWe are going to install some apps:\n\n${apps[*]}\n"
read -p "To continue press Enter ..."
sudo apt install -y "${apps[@]}"
#sudo apt install ‑‑no‑install‑recommends sddm
clear

read -p "Trying to install wayland, to continue press Enter ..."
### Wayland latest ok
if [ -d wayland ];then rm -rfv wayland ;fi 
git clone https://gitlab.freedesktop.org/wayland/wayland.git
cd wayland
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear
read -p "wayland is installed, press enter to continue ..."
clear

read -p "Trying to install wayland-protocols, to continue press Enter ..."
### Wayland-protocols latest ok
if [ -d wayland-protocols ];then rm -rfv wayland-protocols ;fi
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear
read -p "wayland-protocols is installed, press enter to continue ..."
clear

read -p "Trying to install libliftoff, to continue press Enter ..."
### Libliftoff latest ok
if [ -d libliftoff ];then rm -rfv libliftoff ;fi
git clone https://gitlab.freedesktop.org/emersion/libliftoff.git
cd libliftoff
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear
read -p "libliftoff is installed, press enter to continue ..."
clear

read -p "Trying to install libinput, to continue press Enter..."
# Libinput latest ok
if [ -d libinput ];then rm -rfv libinput ;fi
git clone https://gitlab.freedesktop.org/libinput/libinput
cd libinput
sudo apt build-dep libinput -y
meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear
read -p "libinput is installed, press enter to continue ..."
clear

read -p "Trying to install xdg-desktop-portal-hyprland, to continue press Enter ..."
# xdg-desktop-portal-hyprland
if [ -d xdg-desktop-portal-hyprland ];then rm -rfv xdg-desktop-portal-hyprland ;fi
git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
meson setup --prefix=/usr --buildtype=release build/ &&
ninja -C build/ &&
sudo ninja -C build/ install
cd ..
clear
read -p "xdg-desktop-portal-hyprland is installed, press enter to continue ..."
clear

read -p "Trying to install Hyprland, to continue press Enter ..."
### Hyprland latest
if [ -d Hyprland ];then sudo rm -rfv Hyprland ;fi
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
sudo make install &&
sudo cp -v example/hyprland.desktop /usr/share/wayland-sessions/
cd ..
clear
read -p "Hyprland is installed, press enter to constinue"
clear

read -p "Trying to install Waybar, to continue press Enter ..."
sudo apt build-dep -y waybar
#sudo apt install -y libiniparser-dev libncurses-dev libasound2-dev libportaudio-ocaml-dev libsdl2-dev\
#                   clang-tidy libfftw3-dev libfmt-dev libspdlog-dev libgtkmm-3.0-dev libdbusmenu-gtk3-dev\
#                   libjsoncpp-dev libnotify-dev libinotify-ocaml-dev libnl-genl-3-dev libnl-3-dev scdoc\
#                   libupower-glib-dev libplayerctl-dev libmpdclient-dev 

sudo ln -s -v /usr/include/iniparser/* /usr/include/
sudo ln -s -v /usr/include/libnotify/* /usr/include/
sudo usermod -a -G input $USER
if [ -d Waybar ];then rm -rfv Waybar ;fi
git clone https://github.com/Alexays/Waybar.git
cd Waybar
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp &&
meson --prefix=/usr --buildtype=plain --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
sudo ninja -C build install 
cd ..
clear
read -p "Waybar is installed, pres enter to continue..."
clear
echo "Pleas reboot your system..."
