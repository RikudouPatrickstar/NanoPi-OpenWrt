#!/bin/bash

echo 'OpenClash'

OP_SC_DIR=$(pwd)

git clone -b master --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash
mv package/new/OpenClash/luci-app-openclash package/new/luci-app-openclash
rm -fr package/new/OpenClash
## 编译并使用最新的控制面板
git clone -b master --single-branch https://github.com/haishanh/yacd.git
pushd yacd
  yarn
  yarn build
popd
git clone -b master --single-branch https://github.com/Dreamacro/clash-dashboard.git
pushd clash-dashboard
  yarn
  yarn build
popd
pushd package/new/luci-app-openclash/root/usr/share/openclash
  rm -fr dashboard yacd
  mv ${OP_SC_DIR}/yacd/public ./yacd
  mv ${OP_SC_DIR}/clash-dashboard/dist ./dashboard
popd
rm -fr ${OP_SC_DIR}/yacd
rm -fr ${OP_SC_DIR}/clash-dashboard
## 预置 Clash 内核
clash_dev_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_game_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_premium_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
mkdir -p package/base-files/files/etc/openclash/core
pushd package/base-files/files/etc/openclash/core
  wget $clash_dev_url -O - | tar xOvz > clash
  wget $clash_game_url -O - | tar xOvz > clash_game
  wget $clash_premium_url -O - | gunzip -c > clash_tun
  chmod +x clash*
popd

unset OP_SC_DIR

exit 0
