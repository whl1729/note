# ubuntu 使用笔记

## 最近使用

- 查找大文件

  ```bash
  du -aBM -d 1 . | sort -nr | head -20
  # or
  du -cha --max-depth=1 / | grep -E "M|G"
  ```

- Ubuntu 20.04 关闭终端提示音
  - 在终端中点击右上方的菜单（一个含有三条横线的图标），选择「Preferences」
  - 点击左侧的「Unamed」菜单栏，在右侧的「Sound」配置下，将「Terminal bell」的 CheckBox 关闭。

- ubuntu 18.04 关闭终端提示音
  - In order to turn off Ubuntu error sound in Ubuntu 18.04, you need to go Setting > Sound > Sound Effects > Alert Volume > Off.

- [安装中文字体][cn_font]

  ```bash
  fc-list :lang=zh  // 查看已安装字体
  sudo apt install ttf-wqy-zenhei fonts-wqy-microhei
  sudo apt install fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-bsmi00lp fonts-arphic-bkai00mp
  ```

  [cn_font]: https://www.cnblogs.com/Jimc/p/10302267.html

- [Wudao-dict][wudao]: 有道词典命令行版本

  [wudao]: https://github.com/ChestnutHeng/Wudao-dict

- disable cursor blinking on ubuntu 16.04

  ```bash
  gsettings set org.gnome.desktop.interface cursor-blink false
  ```

- 查看字节序 `lscpu | grep "Byte Order"`

- 设置开机启动：在`/etc/rc.local`脚本中添加需要开机启动的操作。

- 设置登录时启动：将待启动的脚本放在`/etc/profile.d`目录下。

- 键盘映射

  ```bash
  xev | grep keycode  // 查看某个符号对应的键值
  xmodmap -e "keycode 68=x"  // 将f2的键值68映射到字母x，这时按下f2键时会显示x
  ```

- 设置virtualbox虚拟机使用主机代理：在Setting - Network Proxy中，选择Manual，并将http/https/socks的代理ip设置为10.0.2.2（virtual NAT默认网关），port设置为1080.

- 解决ubuntu 18.04触控板右键失灵的问题

  ```bash
  gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
  ```

- 创建桌面快捷方式: 参考[How to Add Application Shortcuts on Ubuntu Desktop](https://itsfoss.com/ubuntu-desktop-shortcut/)
  - go to the directory `/usr/share/applications`
  - create a `.desktop` file (you can copy an existing `.desktop` file and modify it)
  - drag-drop the file to the desktop
  - double click on that file on the desktop, and it will warn you that it’s an ‘untrusted application launcher’ so click on Trust and Launch.
  - 如果命令比较简单，可以直接在Exec参数配置命令，比如：`bash -c "cd /tmp && ./run.sh"`
  - 如果你想运行多条命令，可以写成一个脚本，再将`Exec`配置成调用该脚本。

## 软件包管理

- apt-get：适用于 deb 包管理式的操作系统，主要用于自动从互联网软件库中搜索、安装、升级以及卸载软件或者操作系统。

- 查询软件包

  ```bash
  dpkg -l | grep xxx
  apt-cache search <pattern>    // 搜索满足 <pattern> 的软件包。
  apt-cache show/showpkg <package>    // 显示软件包 <package> 的完整描述。
  ```

- 删除软件包

  ```bash
  apt-get remove <package>    // 移除 <package> 以及所有依赖的软件包
  ```

- Ubuntu的软件包获取依赖升级源，可以通过修改 “/etc/apt/sources.list” 文件来修改升级源（需要 root 权限） ；或者修改新立得软件包管理器中 “设置 > 软件库”。

- 设置网络代理（下载国外的安装包失败时检查网络代理是否设置ok）

  ```bash
  export http_proxy=socks5://127.0.0.1:1080
  export https_proxy=socks5://127.0.0.1:1080
  ```

## 网络管理

- [ubuntu 同时使用无线网卡和有线网卡](https://blog.csdn.net/huohongpeng/article/details/78608671)

- ubuntu server connect to wifi without Internet
  - 从另一台能上网的电脑上下载好wpa_supplicant安装包及其依赖的安装包，通过U盘拷贝到目标电脑并安装。
  - [使用wpa_supplicant连接wifi](https://www.linuxbabe.com/ubuntu/connect-to-wi-fi-from-terminal-on-ubuntu-18-04-19-04-with-wpa-supplicant)
  - 设置开机自启动

## 终端

- 如何从vim中复制内容到系统剪切板？
  - ubuntu系统的vim默认不支持系统剪切板，安装vim-gnome即可。`sudo apt-get install vim-gnome`

- 如何修改终端颜色、路径名以及ls命令显示设置？
  - 参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改\~/.bashrc文件中的`PS1`的值。

- 中文字体设置：推荐使用文泉驿-正黑字体。安装和设置方法：
  - 终端输入`sudo apt-get install ttf-wqy-zenhei`进行安装。
  - 在Terminal右键选择"Preferences"，点击"Profiles"，左边选中"Default"，在"General"中，取消勾选"Use the system fixed width font"，再选择"WenQuanYi Zen Hei Mono Regular"，字体设置为25.

## 其他

- Q：如何定位Ubuntu启动失败的问题？
  - 开机后长按F2或F12可进入BIOS启动菜单，排查配置是否正确。
  - 当启动到登录界面后，按`Ctrl+Alt+F1~F6`可进入tty1~tty6，也就是命令行界面。
  - 可以在/var/log/syslog日志中查看启动失败原因。

- Q: 如何解决ubuntu子系统中文乱码的问题？
  - A: 参考[Windows10内置ubuntu子系统安装后中文环境设置](https://blog.csdn.net/KERTORP/article/details/80102143)

- ubuntu下alt + tab切换窗口时,不要把同组的窗口合并的配置方法
  - 运行 dconf-editor
  - 打开 org/gnome/desktop/wm/keybindings
  - 可以看到 `<alt> Tab` 是放在了 switch-application 里面的，要把它拿出来, 放到 switch-windows 中。switch application 就是把相同的窗口合并，这个就是罪魁祸首。
  - 保存，立马生效。
