#!/bin/bash

echo 'ShellClash'

pushd package/base-files/files
  mkdir -p etc/clash
  mkdir -p etc/clash/ui
  mkdir -p etc/init.d
  shellclash_version=$(curl -sL https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/version | grep "versionsh" | awk -F "=" '{print $2}')
  pushd etc/clash
    ## 脚本及 Clash Meta Core
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/clashfm.tar.gz -O - | tar xz -C ./
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/clash.meta/clash-linux-armv8 -O clash
    chmod 777 *
    ## 启动文件
    mv clashservice ../init.d/clash
    ## 地址库
    wget https://raw.githubusercontent.com/RikudouPatrickstar/GeoIP2-CN/release/Country.mmdb -O Country.mmdb
    ## 控制面板
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/dashboard/meta_yacd.tar.gz -O - | tar xz -C ./ui
    sed -i "s/127.0.0.1:9090/192.168.24.1:9999/g" ui/*.html
    ## 创建相关文件
    touch log mac mark
    ## 配置标记文件
    echo "versionsh_l=${shellclash_version}" >> mark
    echo "update_url=https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master" >> mark
    echo "userguide=1" >> mark
    echo "redir_mod=Nft混合" >> mark
    echo "clashcore=clash.meta" >> mark
    echo "cpucore=armv8" >> mark
    echo "hostdir=':9999/ui'" >> mark
    echo "geotype=cn_mini.mmdb" >> mark
    echo "Geo_v=$(date +'%Y%m%d')" >> mark
    echo "ipv6_support=未开启" >> mark
    echo "ipv6_dns=未开启" >> mark
    echo "local_proxy=已开启" >> mark
    echo "local_type=nftables增强模式" >> mark
    echo "web_save_cron=已关闭" >> mark
    ## 清理
    rm -fr clash.service misnap_init.sh
  popd
  ## 设置环境变量
  echo 'alias clash="sh /etc/clash/clash.sh"' >> etc/profile
  echo 'export clashdir="/etc/clash"' >> etc/profile
popd

exit 0
