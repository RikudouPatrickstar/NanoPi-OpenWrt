#!/bin/bash

echo 'v2rayA'

pushd package/base-files/files
  mkdir -p usr/bin
  mkdir -p etc/config
  mkdir -p etc/init.d
  ## v2ray core
  v2ray_version=$(curl -sL https://api.github.com/repos/v2fly/v2ray-core/releases/latest | grep tag_name | sed 's/.*v//;s/".*//')
  wget https://github.com/v2fly/v2ray-core/releases/download/v${v2ray_version}/v2ray-linux-arm64-v8a.zip -O v2ray.zip
  unzip -d v2ray-core v2ray.zip
  cp v2ray-core/v2ray v2ray-core/v2ctl usr/bin/
  chmod +x usr/bin/v2ray
  chmod +x usr/bin/v2ctl
  rm -fr v2ray-core v2ray.zip
  ## v2rayA
  v2raya_version=$(curl -sL https://api.github.com/repos/v2rayA/v2rayA/releases/latest | grep tag_name | sed 's/.*v//;s/".*//')
  wget https://github.com/v2rayA/v2rayA/releases/download/v$v2raya_version/v2raya_linux_arm64_$v2raya_version -O usr/bin/v2raya
  chmod +x usr/bin/v2raya
  wget https://github.com/openwrt/packages/raw/master/net/v2raya/files/v2raya.config -O etc/config/v2raya
  sed -i "s/option enabled '0'/option enabled '1'/" etc/config/v2raya
  wget https://github.com/openwrt/packages/raw/master/net/v2raya/files/v2raya.init -O etc/init.d/v2raya
  chmod +x etc/init.d/v2raya
popd

exit 0
