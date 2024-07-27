#!/bin/bash

echo 'ShellCrash'

pushd package/base-files/files
  mkdir -p etc/ShellCrash
  mkdir -p etc/init.d
  crash_version=$(curl -sL https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev/bin/version | grep "versionsh" | awk -F "=" '{print $2}')
  core_version=$(curl -sL https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev/bin/version | grep "meta_v" | awk -F "=" '{print $2}')
  pushd etc/ShellCrash
    # 下载安装文件
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev/bin/clashfm.tar.gz -O - | tar xz -C ./
    # 创建ShellCrash相关目录
    mkdir -p configs jsons task tools ui yamls
    pushd task
      mv ../task.* ./
    popd
    pushd configs
      mv ../*.list ./
      # 初始化command.env
      echo "TMPDIR=/tmp/ShellCrash" >> command.env
      echo "BINDIR=/etc/ShellCrash" >> command.env
      echo 'COMMAND="$TMPDIR/CrashCore -d $BINDIR -f $TMPDIR/config.yaml"' >> command.env
      # 初始化ShellCrash.cfg
      echo "versionsh_l=${crash_version}" >> ShellCrash.cfg
      echo "firewall_mod=nftables" >> ShellCrash.cfg
      echo "update_url=https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev" >> ShellCrash.cfg
      echo "userguide=1" >> ShellCrash.cfg
      echo "redir_mod=Tproxy模式" >> ShellCrash.cfg
      echo "dns_mod=redir_host" >> ShellCrash.cfg
      echo "dns_nameserver='https://223.5.5.5/dns-query, https://doh.pub/dns-query, tls://dns.rubyfish.cn:853'" >> ShellCrash.cfg
      echo "dns_fallback='https://1.0.0.1/dns-query, https://8.8.4.4/dns-query, https://doh.opendns.com/dns-query'" >> ShellCrash.cfg
      echo "cpucore=arm64" >> ShellCrash.cfg
      echo "crashcore=meta" >> ShellCrash.cfg
      echo "core_v=${core_version}" >> ShellCrash.cfg
      echo "cn_mini_v=$(date +'%Y%m%d')" >> ShellCrash.cfg
      echo "hostdir=':9999/ui'" >> ShellCrash.cfg
      echo "ipv6_support=未开启" >> ShellCrash.cfg
      echo "ipv6_dns=未开启" >> ShellCrash.cfg
      echo "ipv6_redir=未开启" >> ShellCrash.cfg
      echo "firewall_area=3" >> ShellCrash.cfg
    popd
    # 设置系统服务
    mv shellcrash.procd ../init.d/shellcrash
    # 清理多余文件
    rm -fr shellcrash.service misnap_init.sh

    # 下载Meta内核
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev/bin/meta/clash-linux-arm64.tar.gz -O CrashCore.tar.gz
    # 下载IP地址库
    wget https://raw.githubusercontent.com/RikudouPatrickstar/GeoIP2-CN/release/Country.mmdb -O Country.mmdb
    # 下载控制面板
    wget https://raw.githubusercontent.com/RikudouPatrickstar/ShellCrash/dev/bin/dashboard/meta_xd.tar.gz -O - | tar xz -C ./ui
    sed -i "s/127.0.0.1/192.168.24.1/g" ui/assets/*.js
    sed -i "s/9090/9999/g" ui/assets/*.js

    # 授予文件权限
    chmod -R 644 *
    find . -type d -exec chmod 755 {} \;
    find . -type f -name '*.sh' -exec chmod 755 {} \;
  popd
  # 设置环境变量
  echo 'alias crash="ash /etc/ShellCrash/menu.sh"' >> etc/profile
  echo 'alias clash="ash /etc/ShellCrash/menu.sh"' >> etc/profile
  echo 'export CRASHDIR="/etc/ShellCrash"' >> etc/profile
popd

exit 0
