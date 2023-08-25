#!/bin/bash

echo 'ShellClash'

pushd package/base-files/files
  mkdir -p etc/clash
  mkdir -p etc/init.d
  shellclash_version=$(curl -sL https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/version | grep "versionsh" | awk -F "=" '{print $2}')
  pushd etc/clash
    # 创建ShellClash相关目录
    mkdir -p configs tools ui yamls
    ## 脚本及 Clash Meta Core
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/clashfm.tar.gz -O - | tar xz -C ./
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/clash.meta/clash-linux-armv8 -O clash
    chmod 755 *
    ## 设置系统服务
    mv clashservice ../init.d/clash
    ## 地址库
    wget https://raw.githubusercontent.com/RikudouPatrickstar/GeoIP2-CN/release/Country.mmdb -O Country.mmdb
    ## 控制面板
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master/bin/dashboard/meta_yacd.tar.gz -O - | tar xz -C ./ui
    sed -i "s/127.0.0.1:9090/192.168.24.1:9999/g" ui/*.html
    pushd configs
      ## 放置各list文件
      mv ../*.list ./
      ## 初始化ShellClash.cfg
      echo "versionsh_l=${shellclash_version}" >> ShellClash.cfg
      echo "update_url=https://raw.githubusercontent.com/RikudouPatrickstar/ShellClash/master" >> ShellClash.cfg
      echo "userguide=1" >> ShellClash.cfg
      echo "redir_mod=Nft混合" >> ShellClash.cfg
      echo "clashcore=clash.meta" >> ShellClash.cfg
      echo "cpucore=armv8" >> ShellClash.cfg
      echo "hostdir=':9999/ui'" >> ShellClash.cfg
      echo "geotype=cn_mini.mmdb" >> ShellClash.cfg
      echo "Geo_v=$(date +'%Y%m%d')" >> ShellClash.cfg
      echo "ipv6_support=未开启" >> ShellClash.cfg
      echo "ipv6_dns=未开启" >> ShellClash.cfg
      echo "local_proxy=已开启" >> ShellClash.cfg
      echo "local_type=nftables增强模式" >> ShellClash.cfg
      echo "web_save_cron=已关闭" >> ShellClash.cfg
      chmod 644 *
    popd
    ## 清理多余文件
    rm -fr clash.service misnap_init.sh
  popd
  ## 设置环境变量
  echo 'alias clash="sh /etc/clash/clash.sh"' >> etc/profile
  echo 'export clashdir="/etc/clash"' >> etc/profile
popd

exit 0
