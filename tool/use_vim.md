# vim使用笔记

1. [vim-tabe多标签切换](https://blog.csdn.net/xs1326962515/article/details/77837017)

2. vim支持clipboard
    * 查看是否支持clipboard：`vim --version | grep "clipboard `（clipboard前面是减号则不支持，加号则支持）
    * 安装图形化界面的vim使其支持clipboard：`sudo apt-get install vim-gnome`

3. 安装YouCompleteMe报错：
    * "YouCompleteme unavailable : no module named future"
    解决方法：首先`cd ~/.vim/bundle/YouCompleteMe`，然后`git submodule update --init --recursive`
    * "The ycmd server SHUT DOWN..."
    解决方法：首先`cd ~/.vim/bundle/YouCompleteMe`，然后`python install.py`
