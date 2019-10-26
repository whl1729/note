# ubuntu 使用笔记

## 最近使用

1. 查看字节序 `lscpu | grep "Byte Order"`

2. 设置开机启动：在`/etc/rc.local`脚本中添加需要开机启动的操作。

3. 设置登录时启动：将待启动的脚本放在`/etc/profile.d`目录下。

4. 键盘映射
```
xev | grep keycode  // 查看某个符号对应的键值
xmodmap -e "keycode 68=x"  // 将f2的键值68映射到字母x，这时按下f2键时会显示x
```

## 软件包管理

1. apt-get：适用于 deb 包管理式的操作系统，主要用于自动从互联网软件库中搜索、安装、升级以及卸载软件或者操作系统。

2. 查询软件包
```
dpkg -l | grep xxx
apt-cache search <pattern>    // 搜索满足 <pattern> 的软件包。
apt-cache show/showpkg <package>    // 显示软件包 <package> 的完整描述。
```

3. 删除软件包
```
apt-get remove <package>    // 移除 <package> 以及所有依赖的软件包
```

4. Ubuntu的软件包获取依赖升级源，可以通过修改 “/etc/apt/sources.list” 文件来修改升级源（需要 root 权限） ；或者修改新立得软件包管理器中 “设置 > 软件库”。

5. 设置网络代理（下载国外的安装包失败时检查网络代理是否设置ok）
```
export http_proxy=socks5://127.0.0.1:1080
export https_proxy=socks5://127.0.0.1:1080
```

## 网络管理

1. [ubuntu 同时使用无线网卡和有线网卡](https://blog.csdn.net/huohongpeng/article/details/78608671)

## 终端

1. 如何从vim中复制内容到系统剪切板？
    - ubuntu系统的vim默认不支持系统剪切板，安装vim-gnome即可。`sudo apt-get install vim-gnome`

2. 如何修改终端颜色、路径名以及ls命令显示设置？
    - 参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改\~/.bashrc文件中的`PS1`的值。

## 其他

1. Q：如何定位Ubuntu启动失败的问题？
    - 开机后长按F2或F12可进入BIOS启动菜单，排查配置是否正确。
    - 当启动到登录界面后，按`Ctrl+Alt+F1~F6`可进入tty1~tty6，也就是命令行界面。
    - 可以在/var/log/syslog日志中查看启动失败原因。

2. Q: 如何解决ubuntu子系统中文乱码的问题？
    - A: 参考[Windows10内置ubuntu子系统安装后中文环境设置](https://blog.csdn.net/KERTORP/article/details/80102143)

3. ubuntu下alt + tab切换窗口时,不要把同组的窗口合并的配置方法
    - 运行 dconf-editor 
    - 打开 org/gnome/desktop/wm/keybindings
    - 可以看到 <alt> Tab 是放在了 switch-application 里面的，要把它拿出来, 放到 switch-windows 中。switch application 就是把相同的窗口合并，这个就是罪魁祸首。
    - 保存，立马生效。
