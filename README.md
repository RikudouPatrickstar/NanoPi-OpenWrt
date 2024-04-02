# NanoPi-R2S/R4S 的 OpenWrt 极简固件
基于 [nicholas-opensource/OpenWrt-Autobuild](https://github.com/nicholas-opensource/OpenWrt-Autobuild/tree/main) 对 [openwrt/openwrt](https://github.com/openwrt/openwrt/tree/openwrt-23.05) 进行定制编译

## 特性
- 默认 LAN IP： 192.168.24.1
- 插件清单：
    - 应用：[Samba4](https://github.com/openwrt/luci/tree/openwrt-23.05/applications/luci-app-samba4)、[ShellClash](https://github.com/juewuy/ShellClash)
    - 主题：[Argon](https://github.com/jerrykuku/luci-theme-argon/tree/master)
- 移除上游[部分](https://github.com/RikudouPatrickstar/R2S-OpenWrt/blob/master/SCRIPTS/my_prepare_package.sh#L10)组件
- 继承自上游的[更多特性](https://github.com/nicholas-opensource/OpenWrt-Autobuild/tree/main#feature)

## 感谢
感谢所有提供了上游项目代码和给予了帮助的大佬们，特别是 [Nicholas Sun](https://github.com/nicholas-opensource)。
