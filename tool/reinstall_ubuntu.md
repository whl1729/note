# reinstall ubuntu

## backup configuration file
* ~/.vimrc
* ~/.bashrc
* /etc/shadowsocks.json
* ~/.ssh/*

## install ubuntu
1. "legacy USB support" should be enabled, otherwise the computer cannot read input from USB devices.
2. An efi area should be partitioned, otherwise the computer cannot startup.
3. Choose the UEFI mode.

## install softwares

### sogou
1. install commands
```
sudo dpkg -i sogou_xxx.deb
sudo apt-get install -f
sudo dpkg -i sogou_xxx.deb
sudo apt-get purge fcitx-ui-qimpanel // solve the problem of two icons
```

2. 打开System Settings --> Language Support --> Language，keyboard input method system选择fcitx

3. 打开System Setting --> Text Entry，input source添加sogou pinyin，然后右下角点击形如钳子的图标，Input Methods Configurations添加sogou pinyin。

### chrome
1. `sudo dpkg -i google-chrome-xxx.deb`
2. `sudo apt install shadowsocks`
3. 新增并配置/etc/shadowsocks.json文件，参考博客[Ununtu下shadowsocks配置说明](https://www.linuxidc.com/Linux/2015-09/123579.htm)
4. 在/etc/rc.local文件中添加`sslocal -c /etc/shadowsocks.json > /var/log/ss.log &`
5. [下载SwitchOmega的.crx文件](https://www.switchyomega.com/download.html)，并拖到[chrome拓展程序页面](chrome://extensions/)
6. 在SwitchyOmega配置页面，点击SETTINGS --> Import/Export --> Restore frome file，然后选择本地的OmegaOptions.bak文件
7. 点击PROFILES --> Shadowsocks --> Proxy servers，Protocol选择`SOCKS5`，Server和port要和/etc/shadowsocks.json保持一致，一般为`127.0.0.1:1080`

### foxit

### terminator
1. `sudo apt-get install terminator`
2. 配置~/.bashrc文件，参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改PS1变量的值。
3. `source ~/.bashrc`

### vim
1. `sudo apt-get install vim`
2. 配置~/.vimrc文件

### git
1. `sudo apt-get install git`
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
3. 配置SSH key
```
ssh-keygen -t rsa -b 4096 -C "wuhl6@mail2.sysu.edu.cn"
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
// then paste it to the github SSH key configuration blank.
```

### java

### hadoop

### spark
