#!/bin/bash

echo 'SSRPlus'

svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
rm -rf ./package/lean/luci-app-ssr-plus/po/zh_Hans
# SSRPlus Dependies
rm -rf ./feeds/packages/net/shadowsocks-libev
rm -rf ./feeds/packages/net/xray-core
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dns2socks package/lean/dns2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/microsocks package/lean/microsocks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd-alt
svn co https://github.com/fw876/helloworld/trunk/tcping package/lean/tcping
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/lean/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/lean/naiveproxy
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/redsocks2 package/lean/redsocks2
svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/lean/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/simple-obfs package/lean/simple-obfs
svn co https://github.com/fw876/helloworld/trunk/trojan package/lean/trojan
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipt2socks package/lean/ipt2socks
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/lean/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/lean/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/xray-core package/lean/xray-core
# Merge Pull Requests from developers
pushd package/lean
  #wget -qO - https://patch-diff.githubusercontent.com/raw/fw876/helloworld/pull/691.patch | patch -p1
popd
# Add Extra Proxy Ports, Change Lists and Deny HappyCast Ads
pushd package/lean/luci-app-ssr-plus
  ## 修改部分内容
  sed -i 's/143/143,25,5222/' root/etc/init.d/shadowsocksr
  sed -i 's,ispip.clang.cn/all_cn,cdn.jsdelivr.net/gh/QiuSimons/Chnroute@master/dist/chnroute/chnroute,' root/etc/init.d/shadowsocksr
  sed -i 's,YW5vbnltb3Vz/domain-list-community@release/gfwlist,Loyalsoldier/v2ray-rules-dat@release/gfw,' root/etc/init.d/shadowsocksr
  sed -i '/Clang.CN.CIDR/a\o:value("https://cdn.jsdelivr.net/gh/QiuSimons/Chnroute@master/dist/chnroute/chnroute.txt", translate("QiuSimons/Chnroute"))' luasrc/model/cbi/shadowsocksr/advanced.lua
  pushd luasrc/model/cbi/shadowsocksr
    sed -i 's_ShadowSocksR Plus+ Settings"), translate(.*))_SSRPlus"))_' client.lua
    sed -i 's_shadowsocksr", translate(".*")_shadowsocksr"_' servers.lua
    sed -i '/Customize Netflix IP Url/d' advanced.lua
  popd
  pushd luasrc/view/shadowsocksr
    sed -i 's_ShadowsocksR Plus+ __' status.htm
  popd
  ## 修改部分翻译
  pushd po/zh-cn/
    sed -i '/ShadowSocksR Plus+ Settings/d' ssr-plus.po
    sed -i '/ShadowSocksR Plus+ 设置/d' ssr-plus.po
    sed -i '/<h3>Support SS/d' ssr-plus.po
    sed -i '/<h3>支持 SS/d' ssr-plus.po
    sed -i '/Customize Netflix IP Url/d' ssr-plus.po
    sed -i '/自定义Netflix IP更新URL（默认项目地址：/d' ssr-plus.po
  popd
  ## 全局替换 ShadowSocksR Plus+ 为 SSRPlus
  ssfiles="$(find 2>"/dev/null")"
  for ssf in ${ssfiles}; do
    if [ -f "$ssf" ]; then
      sed -i 's/ShadowSocksR Plus+/SSRPlus/gi' "$ssf"
    fi
  done
popd

exit 0
