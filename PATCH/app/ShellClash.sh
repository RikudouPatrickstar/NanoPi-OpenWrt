#!/bin/bash

echo 'ShellClash'

pushd package/base-files/files
  mkdir -p etc/clash
  mkdir -p etc/clash/ui
  mkdir -p etc/init.d
  shellclash_version=$(curl -sL https://github.com/juewuy/ShellClash/raw/master/bin/version | grep "versionsh" | awk -F "=" '{print $2}')
  pushd etc/clash
    ## 脚本及 Clash Premium Core
    wget https://github.com/juewuy/ShellClash/raw/master/bin/clashfm.tar.gz -O - | tar xz -C ./
    wget https://github.com/juewuy/ShellClash/raw/master/bin/clashpre/clash-linux-armv8 -O clash
    chmod 777 *
    ## 启动文件
    mv clashservice ../init.d/clash
    ## 地址库
    wget https://github.com/Hackl0us/GeoIP2-CN/raw/release/Country.mmdb -O Country.mmdb
    ## 控制面板
    wget https://github.com/juewuy/ShellClash/raw/master/bin/clashdb.tar.gz -O - | tar xz -C ./ui
    sed -i "s/127.0.0.1/192.168.24.1/g" ui/assets/*.js
    sed -i "s/9090/9999/g" ui/assets/*.js
    ## 创建相关文件
    touch log mac mark
    ## 配置标记文件
    echo "versionsh_l=${shellclash_version}" >> mark
    echo "update_url=http://shellclash.ga/" >> mark
    echo "userguide=1" >> mark
    echo "redir_mod=混合模式" >> mark
    echo "clashcore=clashpre" >> mark
    echo "hostdir=':9999/ui'" >> mark
    echo "dns_nameserver='https://223.5.5.5/dns-query, https://doh.pub/dns-query, tls://dns.rubyfish.cn:853'" >> mark
    echo "dns_fallback='https://1.0.0.1/dns-query, https://8.8.4.4/dns-query, https://doh.opendns.com/dns-query'" >> mark
    echo "Geo_v=$(date +'%Y%m%d%H%M')" >> mark
    echo "geotype=cn_mini.mmdb" >> mark
    echo "cpucore=armv8" >> mark
    ## 清理
    rm -fr clash.service
  popd
  ## 设置环境变量
  echo 'alias clash="sh /etc/clash/clash.sh"' >> etc/profile
  echo 'export clashdir="/etc/clash"' >> etc/profile
popd

exit 0
