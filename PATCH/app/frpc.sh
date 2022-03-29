#!/bin/bash

echo 'frpc'

OP_SC_DIR=$(pwd)

pushd package/base-files/files
  mkdir -p usr/bin
  mkdir -p etc/frp
  mkdir -p etc/init.d
  frp_url=$(curl -sL https://api.github.com/repos/fatedier/frp/releases/latest | grep browser_download_url.*linux_arm64 | sed 's/.*url\": \"//g' | sed 's/\"//g')
  wget "$frp_url" -O - | tar xz
  mv frp*linux_arm64/frpc usr/bin/frpc
  mv frp*linux_arm64/frpc*.ini etc/frp/
  mv ${OP_SC_DIR}/../PATCH/app/frpc.service etc/init.d/frpc
  rm -fr ./frp*linux_arm64
  chmod 755 usr/bin/frpc etc/init.d/frpc
popd
