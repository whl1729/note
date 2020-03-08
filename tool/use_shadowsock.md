# 使用shadowsock来翻墙

## 参考资料
1. [Ubuntu下shadowsocks配置说明](https://www.linuxidc.com/Linux/2015-09/123579.htm)

## 操作步骤

### 安装及配置shadowsocks
1. 使用`sudo apt install shadowsocks`命令下载shadowsocks
2. 创建/etc/shadowsocks.json文件并配置以下内容：
```
{
    "server":"your_srv_ip",
    "server_port":19175,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"your_passwd",
    "method":"aes-256-cfb",
}
```
3. 使用`sslocal -c /etc/shadowsocks.json`命令启动shadowsocks客户端
4. 设置开机启动shadowsocks客户端：在/etc/rc.local文件中添加以上命令
5. 在virtualbox虚拟机终端上使用主机VPN
    - 在虚拟机终端设置http/https代理：`export https_proxy=socks5://192.168.0.105:1080`
    - 修改主机的shadowsocks配置：勾选“允许其他设备连入”

### 安装及配置SwitchyOmega
1. 在[SwitchyOmega的github网站](https://github.com/FelisCatus/SwitchyOmega/releases)下载`SwitchyOmega_Chromium.crx`文件
2. 打开[chrome拓展程序页面](chrome://extensions/)，并将crx文件拖到此页面
3. 配置SwitchyOmega连接的服务器ip和端口号等信息
> 在我的Ubuntu下`protocol`选择`http`翻墙失败，选择`sock5`则翻墙成功。

