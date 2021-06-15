# NanoPi-R2S 的 OpenWrt 极简固件

基于 [nicholas-opensource/OpenWrt-Autobuild](https://github.com/nicholas-opensource/OpenWrt-Autobuild/tree/main) 对 [openwrt/openwrt v21.02](https://github.com/openwrt/openwrt/tree/openwrt-21.02) 进行定制编译

## 固件特性

1. 设置主机名为 `NanoPi-R2S`

2. 默认 LAN IP： `192.168.88.1`

3. 默认用户、密码： `root` `无`

4. 插件仅包含：[`OpenClash`](https://github.com/vernesong/OpenClash) [`Samba4网络共享`](https://github.com/openwrt/luci/tree/openwrt-21.02/applications/luci-app-samba4) [`SSRPlus`](https://github.com/fw876/helloworld) [`腾讯云DDNS`](https://github.com/msylgj/OpenWrt_luci-app/tree/main/luci-app-tencentddns)

5. 主题仅包含：[`luci-theme-argon`](https://github.com/jerrykuku/luci-theme-argon) [`luci-theme-bootstrap`](https://github.com/openwrt/luci/blob/master/themes/luci-theme-bootstrap)

6. 默认关闭 `IPv6`

7. 移除上游的 [`fuck`](https://github.com/nicholas-opensource/OpenWrt-Autobuild/blob/main/PATCH/new/script/fuck) 等组件

## 感谢

感谢所有提供了上游项目代码和给予了帮助的大佬们

