#!/usr/bin/bash
# Assunming git is installed
set -e
if [[ $(id -u) = 0 ]]; then
  echo "Please don't run the script as ROOT"
  exit 1
fi

pkg=(
  avcodec-dev
  avformat-dev
  build-essential
  cava
  clang-tidy
  cmake
  cmake-extras
  edid-decode
  fontconfig
  freebsd-manpages
  gdk-pixbuf
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
  libgulkan-dev
  libinput-bin
  libinput-dev
  libnotify-bin
  libpango1.0-dev
  libpixman-1-dev
  libpipewire-0.3-dev
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
  meson
  ninja-build
  pixmap
  pipewire
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

# Build dep
# sudo apt build-dep libdisplay-info libliftoff libinput wlroots wayland wayland-protocols
## Installing stuffs to run with hyprland (minimum needed)
sudo apt install -y firefox-esr kitty mako-notifier thunar waybar wofi fonts-font-awesome network-manager-applet

