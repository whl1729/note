# Reinstall Ubuntu

## Backup configuration file

- ~/.vimrc
- ~/.bashrc
- ~/.ssh
- OmegaOptions.bak

## Install ubuntu

1. "legacy USB support" should be enabled, otherwise the computer cannot read input from USB devices.
2. An efi area should be partitioned, otherwise the computer cannot startup.
3. Choose the UEFI mode.
4. boot loader should be installed on /boot.

## Install softwares

### Software List

- [ ] git
- [ ] vim
- [ ] sogou
- [ ] chrome && shadowsocks
- [ ] foxit
- [ ] GoldenDict
- [ ] Wudao-dict
- [ ] c/c++
- [ ] python
- [ ] golang
- [ ] rust

### Git

- `sudo apt-get install git`

- Basic configuration for git

  ```sh
  git config --global user.name "along"
  git config --global user.email "wuhl6@mail2.sysu.edu.cn"
  git config --global push.default simple
  git config --global core.editor "vim"
  ```

- Git alias

  ```sh
  git config --global alias.a 'add'
  git config --global alias.br 'branch'
  git config --global alias.ci 'commit'
  git config --global alias.ciam 'commit --amend --no-edit'
  git config --global alias.co 'checkout'
  git config --global alias.d 'diff'
  git config --global alias.l 'log'
  git config --global alias.last 'log -1 HEAD --stat'
  git config --global alias.ll 'log --oneline'
  git config --global alias.ln 'log --name-only'
  git config --global alias.ph 'push'
  git config --global alias.pl 'pull'
  git config --global alias.re 'remote'
  git config --global alias.st 'status'
  ```

- Create SSH key and copy the public key to Github/Gitlab

  ```sh
  ssh-keygen -t rsa -b 4096 -C "wuhl6@mail2.sysu.edu.cn"
  ```

### Vim

- `sudo apt-get install vim-gtk3` （如果直接安装vim将不会支持系统剪贴板）

- [安装 vim 插件及进行基本配置][1]

  ```sh
  git clone git@github.com:whl1729/vimrc.git ~/.vim_runtime
  cd ~/.vim_runtime
  ./install_dependencies.sh
  ./install_awesome_vimrc.sh
  ```

### Sogou

- [Install Sogou on Ubuntu 20.04][2]

- Install commands for Ubuntu 16.04/18.04

  ```sh
  sudo dpkg -i sogou_xxx.deb
  sudo apt-get install -f
  sudo dpkg -i sogou_xxx.deb
  sudo apt-get purge fcitx-ui-qimpanel // solve the problem of two icons
  ```

- 如果是ubuntu 18，接下来的步骤：
  - 打开Settings -> Region & Language -> Manage Installed Language，在弹出的Language Support中的keyboard input method system选择fcitx
  - 在桌面右上方点击输入法菜单，选择Configure Current input method，在input method一栏点击"+"，添加sogou pinyin.
    注意： **需要取消勾选"Only Show Current Language"，否则不会找到sogou pinyin**

- 如果是ubuntu 16，接下来的步骤：
  - 打开System Settings -> Language Support -> Language，keyboard input method system选择fcitx
  - 打开System Setting -> Text Entry，input source添加sougou pinyin，然后右下角点击形如钳子的图标，Input Methods Configurations添加sogou pinyin。
    注意： **为避免输入乱码，不要把sougou放在第一位。**

- 如果在搜狗中设置了`Shift`切换输入法，但输入`Ctrl + Shift`时也会切换输入法，可能是fcitx中启动了该设置，可以将其取消掉。方法是：
  - sogou settings -> “高级” -> “打开Fcitx配置界面” -> “Global Config”，把“Enable Hotkey to scroll between Input Method”取消掉。

### Chrome && Shadowsocks

- Download Chrome
  - 如果在windows系统下载linux安装包，需要在网页左下方点击other platform，否则会默认下载windows版本的安装包。

- Install shadowsocks-qt5 （图形化界面）
  - Ubuntu 20.04: 下载[shadowsocks-qt5 安装包][3]，并按照[Ubuntu 20.04 科学上网][4]进行安装。
  - Ubuntu 18.04/16.04: 输入以下命令进行安装。
    注意：Ubuntu 18.04 添加 apt 源后，[需要将 apt 源配置文件中的 bionic 替换为 xenial][8]。

    ```sh
    sudo add-apt-repository ppa:hzwhuang/ss-qt5
    sudo apt-get update
    sudo apt-get install shadowsocks-qt5
    ```

- Install shadowsocks （命令行界面）
  - `sudo apt install shadowsocks`
  - [新增并配置/etc/shadowsocks.json][5]
  - 在/etc/rc.local文件中添加`sslocal -c /etc/shadowsocks.json > /var/log/ss.log &`
    （注意启动shadowsock后还需要安装SwitchyOmega来配置浏览器的网络连接）

- Install SwitchOmega on Chrome
  - [下载SwitchOmega的.crx文件][6]，并拖到[chrome拓展程序页面][7]。
  - 注意：最新版的Chrome不允许拖拽crx到扩展程序里，这时可以将crx文件后缀改为zip并解压，然后勾选developer模式，点击load unpacked来加载加压后的文件。
  - 在SwitchyOmega配置页面，点击SETTINGS -> Import/Export -> Restore frome file，然后选择本地的OmegaOptions.bak文件
  - 点击PROFILES -> Shadowsocks -> Proxy servers，Protocol选择`SOCKS5`，Server 填`127.0.0.1`，port 填 1080.

### Foxit

### GoldenDict

- 安装 GoldenDict： `sudo apt-get install goldendict`
- [为 GoldenDict 添加构词法规则库][9]
- [为 GoldenDict 添加离线词库和语音库][10]

### Wudao-dict

参考[无道词典的 README][14]进行安装。

### Terminator

- `sudo apt-get install terminator`
- 参考[Ubuntu终端颜色设置、路径名设置以及ls命令设置][11]配置`~/.bashrc`文件，主要是修改PS1变量的值。
- `source ~/.bashrc`

### C/C++

- ctags
- cmake

### Python

```sh
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
source ~/.bashrc
pyenv install 3.8.3
pyenv global 3.8.3
pip install ipython
```

### Golang

### Rust

### JavaScript

```sh
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sed -i "s/https/http/g" /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt-get install -y nodejs
```

## Reference

- [Windows + Ubuntu 16.04 双系统安装详细教程][12]
- [windows10安装ubuntu双系统教程][13]

  [1]: https://github.com/whl1729/vimrc
  [2]: https://pinyin.sogou.com/linux/help.php
  [3]: https://github.com/shadowsocks/shadowsocks-qt5/releases
  [4]: https://blog.meathill.com/linux/ubuntu-20-04-climb-over-gfw.html
  [5]: https://www.linuxidc.com/Linux/2015-09/123579.htm
  [6]: https://www.switchyomega.com/download.html
  [7]: chrome://extensions/
  [8]: https://vinming.github.io/2020/02/10/Ubuntu18_install_shadowsocks-qt5/
  [9]: https://jingyan.baidu.com/article/d8072ac4808225ec95cefde6.html
  [10]: https://blog.csdn.net/halazi100/article/details/44700631
  [11]: http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html
  [12]: https://blog.csdn.net/flyyufenfei/article/details/79187656
  [13]: https://www.cnblogs.com/masbay/p/10745170.html
  [14]: https://github.com/ChestnutHeng/Wudao-dict
