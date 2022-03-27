#!/bin/bash
#
# 主要用于在本地修改 config，取消最后一段注释也可以用于本地编译
#
# wget -q https://github.com/RikudouPatrickstar/R2S-OpenWrt/raw/master/SCRIPTS/build.sh -O build.sh && chmod +x build.sh && ./build.sh
#

# Clone Repository
git clone -b master --single-branch https://github.com/RikudouPatrickstar/R2S-OpenWrt.git

cd ./R2S-OpenWrt/

# Merge Nick's Code
git clone --single-branch -b Sino https://github.com/RikudouPatrickstar/Nicholas-OpenWrt.git OpenWrt-Autobuild
mv ./OpenWrt-Autobuild/SCRIPTS/* ./SCRIPTS/
mv ./SCRIPTS/R2S/* ./SCRIPTS/
mv ./OpenWrt-Autobuild/PATCH/* ./PATCH/
mv -f ./PATCH/zzz-default-settings ./PATCH/duplicate/addition-trans-zh-r2s/files/
rm -rf ./OpenWrt-Autobuild/

# Get OpenWrt Code
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

# Smart Chmod
MY_Filter=$(mktemp)
echo '/\.git' >  ${MY_Filter}
echo '/\.svn' >> ${MY_Filter}
find ./ -maxdepth 1 | grep -v '\./$' | grep -v '/\.git' | xargs -s1024 chmod -R u=rwX,og=rX
find ./ -type f | grep -v -f ${MY_Filter} | xargs -s1024 file | grep 'executable\|ELF' | cut -d ':' -f1 | xargs -s1024 chmod 755
rm -f ${MY_Filter}
unset MY_Filter
        
# # Make Download
# make download -j48

# Compile Openwrt
# let make_process=$(nproc)+1
# make toolchain/install -j${make_process} V=m
# make -j${make_process} V=m || make -j${make_process} V=m || make -j1 V=s
