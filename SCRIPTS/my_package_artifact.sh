#!/bin/bash

mv ./.config ./bin/targets/rockchip/armv8/config-full.buildinfo
pushd ./bin/targets/rockchip/armv8/
    gzip -d *.gz
    mkdir ./ext4_firmware
    mount -o loop,offset=67108864 *ext4*.img ./ext4_firmware
    pushd ./ext4_firmware
        rm -fr overlay rom sbin/firstboot
    popd
    umount ./ext4_firmware
    rm -fr ./ext4_firmware ./packages
    gzip *.img
    rm ./sha256sums && sha256sum * > ./sha256sums
popd

exit 0
