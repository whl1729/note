# install ubuntu

## install software

### basic software
* sogou
    * 解决出现两个图标和两个输入框的问题：sudo apt-get purge fcitx-ui-qimpanel
* chrome
* foxit
* SwitchOmega/shadowsock
    * 下载SwitchOmega，将.crx文件拖到chrome拓展程序页面
    * 配置proxy，包括server和port
    * 使用`sudo apt install shadowsocks`安装shadowsock
    * 新增/etc/shadowsocks.json文件并配置以下内容，参考博客[Ununtu下shadowsocks配置说明](https://www.linuxidc.com/Linux/2015-09/123579.htm)
    * 使用`sslocal -c /etc/shadowsocks.json`启动代理


### programming
* vim
* terminator
* git
* java
* hadoop
* spark

## configuaration
* vimrc
