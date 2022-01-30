#!/bin/bash

OP_SC_DIR=$(pwd)


################ 修改 Nick 的源码 -Start- ################
# 移除多余组件
sed -i '/coremark/d' 02_prepare_package.sh
sed -i '/autoreboot/d' 02_prepare_package.sh
sed -i '/ramfree/d' 02_prepare_package.sh
sed -i '/fuck/d' 02_prepare_package.sh

# 替换默认设置
pushd ${OP_SC_DIR}/../PATCH/duplicate/addition-trans-zh-r2s/files
  rm -f zzz-default-settings
  cp ${OP_SC_DIR}/../PATCH/zzz-default-settings ./
popd
################ 修改 Nick 的源码 -End- ################


################ 执行 02 脚本 -Start- ################
/bin/bash 02_prepare_package.sh
/bin/bash 02_R2S.sh
################ 执行 02 脚本 -End- ################


################ 自定义部分 -Start- ################
# 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i 's/+luci-app-opkg //' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci/Makefile

# Bootstrap 主题移除底部文字
sed -i '/<a href=\"https:\/\/github.com\/openwrt\/luci\">/d' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# Argon 主题
bash ${OP_SC_DIR}/../PATCH/app/Argon.sh

# ShellClash
bash ${OP_SC_DIR}/../PATCH/app/ShellClash.sh

# 移除 SSRPlus
rm -fr package/lean/luci-app-ssr-plus

# 调整默认 LAN IP
sed -i 's/192.168.1.1/192.168.24.1/g' package/base-files/files/bin/config_generate
################ 自定义部分 -End- ################


unset OP_SC_DIR

exit 0
