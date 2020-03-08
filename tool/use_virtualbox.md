# VirtualBox使用笔记

1. 解决Virtual使用Ubuntu时分辨率太低的问题：
    * 在setting - Display - Screen中，将Video Memory调到最大（128MB），并且勾选“Enable 3D Acceleration”
    * 启动ubuntu，在ubuntu界面上方的Device菜单下面勾选“Insert Guest Additions CD Image...”，在弹出的提示框中点击Run，运行完成后重启即可。

2. 通过host key（我的是Right Ctrl）可以让按键在host与guest之间切换。

3. 在windows 10与Ubuntu虚拟机之间共享文件夹：要在`/mnt`下面创建文件作为挂载点，我一开始创建"~/share"作为挂载点没成功。

4. 在虚拟机中输入F5、F6等功能键：同时输入Fn + F5、Fn + F6.

5. 虚拟机桌面最大化：`Ctrl+F`

6. 在virtualbox虚拟机终端上使用主机VPN
    - 在虚拟机终端设置http/https代理：`export https_proxy=socks5://192.168.0.105:1080`
    - 修改主机的shadowsocks配置：勾选“允许其他设备连入”
