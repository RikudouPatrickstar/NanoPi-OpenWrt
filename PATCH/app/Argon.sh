#!/bin/bash

echo 'Argon'

OP_SC_DIR=$(pwd)

rm -fr package/new/luci-theme-argon
git clone -b master --single-branch https://github.com/jerrykuku/luci-theme-argon package/new/luci-theme-argon
pushd package/new/luci-theme-argon
  pushd luasrc/view/themes/argon
    ## 移除 footer.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer.htm
    sed -i '/<%= ver.distversion %>/d' footer.htm
    ## 移除 footer_login.htm 底部文字
    sed -i '/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\"/d' footer_login.htm
    sed -i '/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\"/d' footer_login.htm
    sed -i '/<%= ver.distversion %>/d' footer_login.htm
  popd
  pushd htdocs/luci-static/argon
    ## 替换默认首页背景
    rm -f img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg img/bg1.jpg
    cp ${OP_SC_DIR}/../PATCH/background.jpg background/
  popd
popd

unset OP_SC_DIR

exit 0
