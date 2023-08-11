#!/usr/bin/bash
# Waybar latest

sudo apt build-dep -y waybar
sudo apt install -y libiniparser-dev libncurses-dev libasound2-dev libportaudio-ocaml-dev libsdl2-dev\
                   clang-tidy libfftw3-dev libfmt-dev libspdlog-dev libgtkmm-3.0-dev libdbusmenu-gtk3-dev\
                   libjsoncpp-dev libnotify-dev libinotify-ocaml-dev libnl-genl-3-dev libnl-3-dev scdoc\
                   libupower-glib-dev libplayerctl-dev libmpdclient-dev 

sudo ln -s /usr/include/iniparser/* /usr/include/
sudo ln -s /usr/include/libnotify/* /usr/include/
sudo usermod -a -G input $USER
if [ -d Waybar ];then rm -rfv Waybar ;fi
git clone https://github.com/Alexays/Waybar.git
cd Waybar
sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson --prefix=/usr --buildtype=plain --auto-features=enabled build &&
meson configure -Dexperimental=true build &&
sudo ninja -C build install
cd ..
