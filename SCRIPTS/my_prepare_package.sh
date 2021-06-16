#!/bin/bash

OP_SC_DIR=$(pwd)

#########################################################
################ 修改 Nick 的源码 -Start- ################
# 移除多余组件
sed -i '/coremark/d' 02_prepare_package.sh
sed -i '/autoreboot/d' 02_prepare_package.sh
sed -i '/ramfree/d' 02_prepare_package.sh
sed -i '/fuck/d' 02_prepare_package.sh

## 调整 AutoCore 补丁
sed -i 's,Others/master/add-openwrt.patch,Others/master/autocore-repatch.patch,' 02_prepare_package.sh

# 替换默认设置
pushd ${OP_SC_DIR}/../PATCH/duplicate/addition-trans-zh-r2s/files
  rm -f zzz-default-settings
  cp ${OP_SC_DIR}/../PATCH/zzz-default-settings ./
popd
################ 修改 Nick 的源码 -End- ################
#######################################################


#####################################################
################ 执行 02 脚本 -Start- ################
/bin/bash 02_prepare_package.sh
/bin/bash 02_R2S.sh
################ 执行 02 脚本 -End- ################
###################################################


###################################################
################ 自定义部分 -Start- ################
# 调整 LuCI 依赖，去除 luci-app-opkg，替换 luci-theme-bootstrap 为 luci-theme-argon
sed -i 's/+luci-app-opkg //' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci/Makefile

# Argon 主题
rm -fr package/new/luci-theme-argon
git clone -b master --single-branch https://github.com/jerrykuku/luci-theme-argon package/new/luci-theme-argon
pushd package/new/luci-theme-argon
  pushd luasrc/view/themes/argon
    ## 移除 footer.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/d' footer.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/d' footer.htm
    sed -i '/<%= ver.distversion %>/d' footer.htm
    ## 移除 footer_login.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/d' footer_login.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/d' footer_login.htm
    sed -i '/<%= ver.distversion %>/d' footer_login.htm
  popd
  pushd htdocs/luci-static/argon
    ## 替换默认首页背景
    rm -f img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg background/
  popd
popd

# Bootstrap 主题移除底部文字
sed -i '/<a href=\"https:\/\/github.com\/openwrt\/luci\">/d' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# SSRPlus 微调
pushd package/lean/luci-app-ssr-plus
  ## 替换部分翻译
  pushd po/zh-cn/
    sed -i 's/ShadowSocksR Plus+ Settings/Basic Settings/' ssr-plus.po
    sed -i 's/ShadowSocksR Plus+ 设置/基本设置/' ssr-plus.po
    sed -i '/Customize Netflix IP Url/d' ssr-plus.po
    sed -i '/自定义Netflix IP更新URL（默认项目地址：/d' ssr-plus.po
    sed -i '/<h3>Support SS/d' ssr-plus.po
    sed -i '/<h3>支持 SS/d' ssr-plus.po
  popd
  ## 修改部分内容
  pushd luasrc/model/cbi/shadowsocksr
    sed -i 's/Map("shadowsocksr", translate("ShadowSocksR Plus+ Settings"), translate("<h3>Support SS\/SSR\/V2RAY\/TROJAN\/NAIVEPROXY\/SOCKS5\/TUN etc.<\/h3>"))/Map("shadowsocksr", translate("Basic Settings"))/' client.lua
    #sed -i '/Clang.CN.CIDR/a\o:value("https://raw.sevencdn.com/QiuSimons/Chnroute/master/dist/chnroute/chnroute.txt", translate("QiuSimons/Chnroute"))' advanced.lua
    sed -i '/Customize Netflix IP Url/d' advanced.lua
  popd
  ## 全局替换 ShadowSocksR Plus+ 为 SSRPlus
  ssfiles="$(find 2>"/dev/null")"
  for ssf in ${ssfiles}; do
    if [ -f "$ssf" ]; then
      sed -i 's/ShadowSocksR Plus+/SSRPlus/gi' "$ssf"
    fi
  done
popd

# OpenClash
rm -fr package/new/luci-app-openclash
rm -fr package/new/OpenClash
git clone -b master --depth 1 https://github.com/vernesong/OpenClash package/new/OpenClash
mv package/new/OpenClash/luci-app-openclash package/new/luci-app-openclash
rm -fr package/new/OpenClash
## 编译 dashboard
git clone -b master --single-branch https://github.com/Dreamacro/clash-dashboard.git
pushd clash-dashboard
  yarn
  yarn build
popd
mv clash-dashboard/dist ./dashboard-dist
rm -fr clash-dashboard
## 使用最新的控制面板，并调整 dashboard 默认地址
pushd package/new/luci-app-openclash/root/usr/share/openclash
  rm -fr dashboard
  mv ${OP_SC_DIR}/dashboard-dist ./dashboard
  sed -i 's,<!--meta name="external-controller" content="http://secret@example.com:9090"-->,<meta name="external-controller" content="http://123456@nanopi-r2s:9090">,' ./dashboard/index.html
popd
## 预置内核
clash_dev_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_game_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
clash_premium_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-armv8 | sed 's/.*url\": \"//g' | sed 's/\"//g')
mkdir -p package/base-files/files/etc/openclash/core
pushd package/base-files/files/etc/openclash/core
  wget -qO- $clash_dev_url | tar xOvz > clash
  wget -qO- $clash_game_url | tar xOvz > clash_game
  wget -qO- $clash_premium_url | gunzip -c > clash_tun
  chmod +x clash*
popd

# 腾讯 DDNS
svn co https://github.com/msylgj/OpenWrt_luci-app/trunk/luci-app-tencentddns package/new/luci-app-tencentddns
sed -i 's,tencentcloud,services,g' package/new/luci-app-tencentddns/luasrc/controller/tencentddns.lua

# 调整默认 LAN IP
sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate

# 纠正 luci-app-firewall 翻译
sed -i 's,路由/NAT 卸载,路由/NAT 分载,g' feeds/luci/applications/luci-app-firewall/po/zh_Hans/firewall.po
################ 自定义部分 -End- ################
#################################################

unset OP_SC_DIR
exit 0

