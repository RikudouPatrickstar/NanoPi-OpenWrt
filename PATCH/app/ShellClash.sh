#!/bin/bash

echo 'ShellClash'

pushd package/base-files/files
  mkdir -p etc/clash
  mkdir -p etc/clash/ui
  mkdir -p etc/init.d
  shellclash_version=$(curl -sL https://raw.githubusercontent.com/juewuy/ShellClash/master/bin/version | grep "versionsh" | awk -F "=" '{print $2}')
  pushd etc/clash
    ## 脚本及 Clash Meta Core
    wget https://raw.githubusercontent.com/juewuy/ShellClash/master/bin/clashfm.tar.gz -O - | tar xz -C ./
    wget https://raw.githubusercontent.com/juewuy/ShellClash/master/bin/clash.meta/clash-linux-armv8 -O clash
    chmod 777 *
    ## 启动文件
    mv clashservice ../init.d/clash
    ## 地址库
    wget https://raw.githubusercontent.com/Hackl0us/GeoIP2-CN/release/Country.mmdb -O Country.mmdb
    ## 控制面板
    wget https://raw.githubusercontent.com/juewuy/ShellClash/master/bin/clashdb.tar.gz -O - | tar xz -C ./ui
    sed -i "s/127.0.0.1/192.168.24.1/g" ui/assets/*.js
    sed -i "s/9090/9999/g" ui/assets/*.js
    ## 创建相关文件
    touch log mac mark
    ## 配置标记文件
    echo "versionsh_l=${shellclash_version}" >> mark
    echo "update_url=https://raw.githubusercontents.com/juewuy/ShellClash/master" >> mark
    echo "userguide=1" >> mark
    echo "redir_mod=混合模式" >> mark
    echo "clashcore=clash.meta" >> mark
    echo "cpucore=armv8" >> mark
    echo "hostdir=':9999/ui'" >> mark
    echo "Geo_v=$(date +'%Y%m%d')" >> mark
    echo "geotype=cn_mini.mmdb" >> mark
    ## 清理
    rm -fr clash.service misnap_init.sh
  popd
  ## 设置环境变量
  echo 'alias clash="sh /etc/clash/clash.sh"' >> etc/profile
  echo 'export clashdir="/etc/clash"' >> etc/profile
popd

exit 0
