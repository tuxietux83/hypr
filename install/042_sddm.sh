#!/usr/bin/bash
set -e

if [ -d sddm ];then rm -rfv sddm ;fi
git clone https://github.com/sddm/sddm.git

cd sddm && mkdir -v build && cd build
cmake .. &&
make &&
sudo make install
cd ../..
