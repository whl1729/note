# reinstall ubuntu

## reference

1. [Windows + Ubuntu 16.04 双系统安装详细教程](https://blog.csdn.net/flyyufenfei/article/details/79187656)
2. [windows10安装ubuntu双系统教程](https://www.cnblogs.com/masbay/p/10745170.html)

## backup configuration file
- ~/.vimrc
- ~/.bashrc
- /etc/shadowsocks.json
- ~/.ssh/\*

## install ubuntu
1. "legacy USB support" should be enabled, otherwise the computer cannot read input from USB devices.
2. An efi area should be partitioned, otherwise the computer cannot startup.
3. Choose the UEFI mode.
4. boot loader should be installed on /boot.

## install softwares

### contents

- [ ] git
- [ ] vim
- [ ] sogou
- [ ] chrome && shadowsocks
- [ ] foxit
- [ ] youdao-dict
- [ ] c/c++
- [ ] python
- [ ] golang
- [ ] rust

### git

1. 安装git：`sudo apt-get install git`

2. git基本配置
```
git config --global user.name "along"
git config --global user.email "wuhl6@mail2.sysu.edu.cn"
git config --global push.default simple
git config --global core.editor "vim"
```

3. 配置~/.bashrc文件
```
alias gad="git add ."
alias gco="git commit"
alias glo="git log"
alias gph="git push"
alias gpl="git pull"
alias gst="git status"
alias gck="git checkout"
```

4. 配置SSH key
```
ssh-keygen -t rsa -b 4096 -C "wuhl6@mail2.sysu.edu.cn"
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
// then paste it to the github SSH key configuration blank.
```

### vim

1. 使用命令`sudo apt-get install vim`或通过源码重新编译最新版的vim：[Building-vim-from-source](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

2. 使用`sudo apt-get install vim-gnome`安装vim-gnome，以支持系统剪贴板。

3. 参考[use vim as ide](https://github.com/yangyangwithgnu/use_vim_as_ide)来配置~/.vimrc文件
    - 安装插件管理工具Vundle：`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
    - 拷贝note/tool/conf/vimrc到`~/.vimrc`
    - 打开vim，输入`:PluginInstall`来安装vim插件
    - 要卸载插件，先在 .vimrc 中注释或者删除对应插件配置信息，然后在 vim 中执行`:PluginClean`
    - 安装CtrlSF时需要依赖ag，参考[vim搜索插件ctrlsf](https://catdoc.iteye.com/blog/2162402)

### sogou

1. install commands
```
sudo dpkg -i sogou_xxx.deb
sudo apt-get install -f
sudo dpkg -i sogou_xxx.deb
sudo apt-get purge fcitx-ui-qimpanel // solve the problem of two icons
```

2. 如果是ubuntu 18，接下来的步骤：
    - 打开Settings -> Region & Language -> Manage Installed Language，在弹出的Language Support中的keyboard input method system选择fcitx
    - 在桌面右上方点击输入法菜单，选择Configure Current input method，在input method一栏点击"+"，添加sogou pinyin. 注意：**需要取消勾选"Only Show Current Language"，否则不会找到sogou pinyin**

3. 如果是ubuntu 14，接下来的步骤：
    - 打开System Settings -> Language Support -> Language，keyboard input method system选择fcitx
    - 打开System Setting -> Text Entry，input source添加sougou pinyin，然后右下角点击形如钳子的图标，Input Methods Configurations添加sogou pinyin。（为避免输入乱码，不要把sougou放在第一位）

4. 如果在搜狗中设置了`Shift`切换输入法，但输入`Ctrl + Shift`时也会切换输入法，可能是fcitx中启动了该设置，可以将其取消掉。方法是：sogou settings -> “高级” -> “打开Fcitx配置界面” -> “Global Config”，把“Enable Hotkey to scroll between Input Method”取消掉。

### chrome && shadowsocks

1. 下载chrome安装包：注意如果在windows系统下载linux安装包，需要在网页左下方点击other platform，否则会默认下载windows版本的安装包。

2. `sudo dpkg -i google-chrome-xxx.deb`

3. `sudo apt install shadowsocks`（或者参考第9点安装shadowsocks-qt5）

4. 新增并配置/etc/shadowsocks.json文件，参考博客[Ununtu下shadowsocks配置说明](https://www.linuxidc.com/Linux/2015-09/123579.htm)

5. 在/etc/rc.local文件中添加`sslocal -c /etc/shadowsocks.json > /var/log/ss.log &`（注意启动shadowsock后还需要安装SwitchyOmega来配置浏览器的网络连接）

6. [下载SwitchOmega的.crx文件](https://www.switchyomega.com/download.html)，并拖到[chrome拓展程序页面](chrome://extensions/)。注意：最新版的Chrome不允许拖拽crx到扩展程序里，这时可以将crx文件后缀改为zip并解压，然后勾选developer模式，点击load unpacked来加载加压后的文件即可。

7. 在SwitchyOmega配置页面，点击SETTINGS -> Import/Export -> Restore frome file，然后选择本地的OmegaOptions.bak文件

8. 点击PROFILES -> Shadowsocks -> Proxy servers，Protocol选择`SOCKS5`，Server和port要和/etc/shadowsocks.json保持一致，一般为`127.0.0.1:1080`

9. 安装shadowsocks-qt5
```
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```

10. 如果是ubuntu 18，执行第9步会失败，这时需要作以下修改：（参考[Ubuntu18 安装shadowsocks-qt5方法](https://yq.aliyun.com/articles/619951)）
```
$ sudo mv hzwhuang-ubuntu-ss-qt5-bionic.list hzwhuang-ubuntu-ss-qt5-artful.list
$ sudo vim hzwhuang-ubuntu-ss-qt5-artful.list
# add the following settings
deb http://ppa:launchpad.net/hzwhuang/ss-qt5/ubuntu artful main
#deb-src http://ppa:launchpad.net/hzwhuang/ss-qt5/ubuntu artful main
```

### foxit

### terminator

1. `sudo apt-get install terminator`

2. 配置~/.bashrc文件，参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改PS1变量的值。

3. `source ~/.bashrc`

### C/C++

- ctags
- cmake

### Python

- pyenv
- `apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev`

### Golang

### Rust
