#!/bin/bash

set -x

sudo apt install vim
sudo apt instal vim-gnome

sudo apt install git

git config --global user.name "along"
git config --global user.email "wuhl6@mail2.sysu.edu.cn"
git config --global push.default simple
git config --global core.editor "vim"

sudo apt install xclip
ssh-keygen -t rsa -b 4096 -C "wuhl6@mail2.sysu.edu.cn"
xclip -sel clip < ~/.ssh/id_rsa.pub

sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt update
sudo apt install shadowsocks-qt5
