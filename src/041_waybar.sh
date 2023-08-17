#!/usr/bin/bash
# Waybar latest
set -e

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
