#!/usr/bin/bash
set -e
# Check user
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi
# Packages needed for hyrland build
PKGLIST=(
	meson wget build-essential ninja-build cmake-extras cmake gettext gettext-base fontconfig\
	libfontconfig-dev libffi-dev libxml2-dev libdrm-dev libxkbcommon-x11-dev libxkbregistry-dev\
	libxkbcommon-dev libpixman-1-dev libudev-dev libseat-dev seatd libxcb-dri3-dev libvulkan-dev\
	libvulkan-volk-dev  vulkan-validationlayers-dev libvkfft-dev libgulkan-dev libegl-dev libgles2\
	libegl1-mesa-dev glslang-tools libinput-bin libinput-dev libxcb-composite0-dev libavutil-dev\
	libavcodec-dev libavformat-dev libxcb-ewmh2 libxcb-ewmh-dev libxcb-present-dev libxcb-icccm4-dev\
	libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev xdg-desktop-portal-wlr libpango1.0-dev\
	hwdata libzfslinux-dev libgbm-dev freebsd-manpages edid-decode libsystemd-dev wayland-scanner++\
 	pixmap libc++-dev libgtk-4-dev valgrind qt6-wayland qtwayland5 pipewire wireplumber polkit-kde-agent-1\
  	htop kitty wofi
)
# Function to check if installed
function IS_INSTALLED {
  for pkg in "$@"; do
    dpkg -s "$pkg" &> /dev/null
  done
}
# Installing packages that are not already installed
for PKG in "${PKGLIST[@]}"; do
  if IS_INSTALLED $PKG; then
    echo "Package $PKG already exist."
  else
    sudo apt-get install -y $PKG
    if [[ $? -eq 0 ]]; then
      echo "Package $PKG has been installed!"
    else
      echo "Error installing $PKG."
    fi
  fi
done

# Some dependencies
sudo apt build-dep libliftoff libinput wlroots wayland wayland-protocols

# Preps for downloading deps and building hyprland
# mkdir HyprSource && cd HyprSource\

