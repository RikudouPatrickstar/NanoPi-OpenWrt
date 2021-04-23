#!/bin/bash
#
# 主要用于在本地修改 config，取消最后一段注释也可以用于本地编译
#
# wget -q https://cdn.jsdelivr.net/gh/RikudouPatrickstar/R2S-OpenWrt/SCRIPTS/build.sh -O build.sh && chmod +x build.sh && ./build.sh
#

# Clone Repository
git clone -b master --single-branch https://github.com/RikudouPatrickstar/R2S-OpenWrt.git

cd ./R2S-OpenWrt/

# Get Nick Source
git clone https://github.com/nicholas-opensource/OpenWrt-Autobuild.git
mv ./OpenWrt-Autobuild/SCRIPTS/* ./SCRIPTS/
mv ./SCRIPTS/R2S/* ./SCRIPTS/
mv ./OpenWrt-Autobuild/PATCH/* ./PATCH/
rm -rf ./OpenWrt-Autobuild/

# Get OpenWrt Source
cp ./SCRIPTS/01_get_ready.sh ./
bash 01_get_ready.sh
cp -r ./SCRIPTS/* ./openwrt/

cd ./openwrt/

# Prepare Package
bash my_prepare_package.sh
bash 03_convert_translation.sh
bash 04_remove_upx.sh
bash 05_create_acl_for_luci.sh -a

# Make Config
mv ../SEED/config.seed .config
make defconfig

# # Make Download
# make download -j10

# # Compile
# let make_process=$(nproc)+1
# make toolchain/install -j${make_process} V=m
# make -j${make_process} V=m || make -j${make_process} V=m || make -j1 V=s
