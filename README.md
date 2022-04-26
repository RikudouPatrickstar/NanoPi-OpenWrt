# NanoPi-R2S 的 OpenWrt 极简固件

基于 [nicholas-opensource/OpenWrt-Autobuild](https://github.com/nicholas-opensource/OpenWrt-Autobuild) 对 [openwrt/openwrt v21.02](https://github.com/openwrt/openwrt/tree/openwrt-21.02) 进行定制编译

## 特性

1. 默认 LAN IP： `192.168.24.1`

2. 默认用户、密码： `root` `无`

3. 插件清单：

    - 应用：[`Samba4`](https://github.com/openwrt/luci/tree/openwrt-21.02/applications/luci-app-samba4) [`WOL-plus`](https://github.com/msylgj/OpenWrt_luci-app/tree/main/luci-app-services-wolplus) [`ShellClash`](https://github.com/juewuy/ShellClash) [`frpc`](https://github.com/fatedier/frp)
    
    - 主题：[`Argon`](https://github.com/jerrykuku/luci-theme-argon/tree/master)

4. 默认关闭 `IPv6`，移除上游[部分](https://github.com/RikudouPatrickstar/R2S-OpenWrt/blob/master/SCRIPTS/my_prepare_package.sh#L10)组件

## 感谢

感谢所有提供了上游项目代码和给予了帮助的大佬们，特别是 [nicholas-opensource](https://github.com/nicholas-opensource)。

