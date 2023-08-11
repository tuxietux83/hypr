#!/usr/bin/bash
# Waybar latest
set -e

inidir="/usr/include"
if [ ! -f $inidir/iniparser.h ];then
sudo ln -s -v /usr/include/iniparser/* /usr/include/
fi
#sudo ln -s /usr/include/libnotify/* /usr/include/
if [ -d Waybar ];then rm -rfv Waybar ;fi
git clone https://github.com/Alexays/Waybar.git
cd Waybar
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson --prefix=/usr --buildtype=plain --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
sudo ninja -C build install
cd ..
