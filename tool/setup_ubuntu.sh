#!/bin/bash

set -x

sudo apt install vim
sudo apt install vim-gnome

sudo apt install git

sudo apt install curl

sudo apt install ctags

git config --global user.name "along"
git config --global user.email "wuhl6@mail2.sysu.edu.cn"
git config --global push.default simple
git config --global core.editor "vim"

sudo apt install xclip
ssh-keygen -t rsa -b 4096 -C "wuhl6@mail2.sysu.edu.cn"
xclip -sel clip < ~/.ssh/id_rsa.pub

# install shadowsocks-qt5
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo mv /etc/apt/sources.list.d/hzwhuang-ubuntu-ss-qt5-bionic.list /etc/apt/sources.list.d/hzwhuang-ubuntu-ss-qt5-artful.list
sed -i "s/bionic/artful/g" /etc/apt/sources.list.d/hzwhuang-ubuntu-ss-qt5-artful.list
sudo apt update
sudo apt install shadowsocks-qt5

# install tools for js
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sed -i "s/https/http/g" /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt-get install -y nodejs

# install tools for python
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
source ~/.bashrc
pyenv install 3.8.3
pyenv global 3.8.3
