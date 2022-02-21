#!/bin/bash

OP_SC_DIR=$(pwd)


################ 修改 Nick 的脚本 -Start- ################
# 创建插件存放目录
mkdir -p package/new

# 移除多余组件
sed -i '/coremark/,/fuck/d' 02_prepare_package.sh

# 换回官方 rtl8152-vendor
sed -i '/8152/d' 02_R2S.sh
################ 修改 Nick 的脚本 -End- ################


################ 执行 02 脚本 -Start- ################
/bin/bash 02_prepare_package.sh
/bin/bash 02_R2S.sh
################ 执行 02 脚本 -End- ################


################ 自定义部分 -Start- ################
# 调整 LuCI 依赖，去除 luci-app-opkg，替换主题 bootstrap 为 argon
sed -i 's/+luci-app-opkg //' ./feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci/Makefile

# 去除多余信息显示
sed -i '/Target Platform/d' ./package/emortal/autocore/files/*/rpcd_10_system.js

# Argon 主题
bash ${OP_SC_DIR}/../PATCH/app/Argon.sh

# ShellClash
bash ${OP_SC_DIR}/../PATCH/app/ShellClash.sh

# 调整默认 LAN IP
sed -i 's/192.168.1.1/192.168.24.1/g' package/base-files/files/bin/config_generate
################ 自定义部分 -End- ################


unset OP_SC_DIR

exit 0
