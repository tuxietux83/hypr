#!/usr/bin/bash
set -e
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi

# Apps
apps=(
    apt-file
    dunst
    firefox-esr
    fonts-font-awesome
    geany
    kitty
    mako-notifier
    mlocate
    network-manager
    network-manager-gnome
    nm-tray
    pavucontrol
    pipewire
    pipewire-pulse
    polkit-kde-agent-1
    psmisc
    thunar
    wofi
    wireplumber
    xdg-desktop-portal
    xwayland
)
# build-dep
dep=(
    libdisplay-info
    libinput
    libliftoff
    sddm
    waybar
    wayland
    wayland-protocols
    wlroots
    xdg-desktop-portal
)
# Libs
libs=(
    cmake
    cmake-extras
    clang-tidy
    edid-decode
    gdk-pixbuf-tests
    gobject-introspection
    jq
    libasound2-dev
    libdbusmenu-gtk3-dev
    libfftw3-dev
    libfmt-dev
    libgirepository1.0-dev
    libgtkmm-3.0-dev
    libiniparser-dev
    libinotify-ocaml-dev
    libinih-dev
    libjsoncpp-dev
    libmpdclient-dev
    libncurses-dev
    libnl-3-dev
    libnl-genl-3-dev
    libnotify-bin
    libnotify-dev
    libplayerctl-dev
    libportaudio-ocaml-dev
    libspdlog-dev
    libsystemd-dev
    libupower-glib-dev
    libxcb-ewmh-dev
    libsdl2-dev
    libupower-glib-dev
    qt6-wayland
    qtwayland5
    scdoc
    seatd
    upower
    valgrind
    xdg-desktop-portal
)

clear
echo -e "\nWe are going to install some apps:\n\n${apps[*]} ${dep[*]} ${libs[*]}\n"
read -p "To continue press Enter ..."
sudo apt update
sudo apt build-dep -y "${dep[@]}"
sudo apt install -y "${apps[@]}" "${libs[@]}"
sudo apt-file update
sudo updatedb
#sudo apt install ‑‑no‑install‑recommends sddm

## Setting NetworkManager
# Check for file /etc/NetworkManager/NetworkManager.conf
if [ ! -e /etc/NetworkManager/NetworkManager.conf ]; then
    echo "File /etc/NetworkManager/NetworkManager.conf doesn't exist."
    exit 1
fi
# Check if network is managed=true in /etc/NetworkManager/NetworkManager.conf
if grep -q "managed=true" /etc/NetworkManager/NetworkManager.conf; then
    echo "Option 'managed' already set to 'true'."
else
    # Modify managed=false in managed=true
    sudo sed -i 's/managed=false/managed=true/' "/etc/NetworkManager/NetworkManager.conf"
    sudo service NetworkManager restart
    echo "Option 'managed' modified in 'true'."
fi

clear

./011_*
./012_*
./013_*
./031_*
./032_*
./033_*
./034_*
./035_*
./041_*
# ./042_*

clear
echo "*****************************************************************"
echo "                                                                 "
echo "    Please consider to REBOOT yout pc ...                        "
echo "                                                                 "
echo "*****************************************************************"
