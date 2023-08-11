#!/usr/bin/bash
# Assunming git is installed
set -e
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi

pkg=(
  build-essential
  cava
  clang-tidy
  cmake
  cmake-extras
  edid-decode
  fontconfig
  freebsd-manpages
  gdk-pixbuf-tests
  gettext
  gettext-base
  glslang-tools
  hwdata
  jq
  libavcodec-dev
  libavformat-dev
  libc++-dev
  libc++1
  libdrm-dev
  libegl-dev
  libegl1-mesa-dev
  libffi-dev
  libfontconfig-dev
  libgbm-dev
  libgtk-3-dev
  libgulkan-dev
  libinput-bin
  libinput-dev
  libnotify-bin
  libpango1.0-dev
  libpixman-1-dev
  libpipewire-0.3-dev
  libproc2-dev
  libsystemd-dev
  libudev-dev
  libvkfft-dev
  libvulkan-dev
  libvulkan-volk-dev
  libxcb-composite0-dev
  libxcb-dri3-dev
  libxcb-ewmh-dev
  libxcb-ewmh2
  libxcb-icccm4-dev
  libxcb-present-dev
  libxcb-render-util0-dev
  libxcb-res0-dev
  libxcb-xinput-dev
  libxml2-dev
  libxkbcommon-dev
  libxkbcommon-x11-dev
  libxkbregistry-dev
  libzfslinux-dev
  libseat-dev
  libdisplay-info-dev
  libgtk-4-dev
  libinih-dev
  meson
  ninja-build
  pixmap
  pipewire
  psmisc
  polkit-kde-agent-1
  qt6-wayland
  qtwayland5
  seatd
  usermode
  valgrind
  vulkan-validationlayers-dev
  wayland-scanner++
  wireplumber
  xwayland
  xdg-desktop-portal
)
sudo apt install -y "${pkg[@]}"

## Installing stuffs to run with hyprland (minimum needed)
apps=(
firefox-esr
kitty
mako-notifier
thunar
wofi
fonts-font-awesome
network-manager
nm-tray
)
sudo apt install -y "${apps[@]}"
sudo apt install ‑‑no‑install‑recommends sddm

### Needed
# 1 wayland
# 2 wayland-protocols
# 3 libliftoff
# 4 libinput
# 5 xdg-desktop-portal-hyprland
# 5.1 hyprland-protocols
