# linux使用笔记

## 基本技巧

### 设置开机启动
在`/etc/rc.local`脚本中添加需要开机启动的操作。

### 键盘映射
```
xev | grep keycode  // 查看某个符号对应的键值
xmodmap -e "keycode 68=x"  // 将f2的键值68映射到字母x，这时按下f2键时会显示x
```

### 软件包管理

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

### 进程管理

1. 后台进程：如果您有一个命令将占用很多时间，您想把它放入后台运行，也很简单。只要在命令运行时按下ctrl-z，它就会停止。然后键入 bg使其转入后台。fg 命令可使其转回前台。

### 软件开发工具

1. exuberant-ctags：可以为程序语言对象生成索引，其结果能够被一个文本编辑器或者其他工具简捷迅速的定位。支持的编辑器有 Vim、Emacs 等。习惯GUI的同学可以使用understand或source insight等软件。
    * 使用`ctags -h=.h.c.S -R`来生成索引文件
    * 使用 “ctrl + ]” 可以跳转到相应的声明或者定义处，使用 “ctrl + t” 返回（查询堆栈） 等。

2. diff & patch：实验中可能会在 proj_b 中应用前一个实验proj_a 中对文件进行的修改，可以使用如下命令。习惯GUI的同学可以使用meld、kdiff3和UltraCompare等软件。
```
diff -r -u -P proj_a_original proj_a_mine > diff.patch
cd proj_b
patch -p1 -u < ../diff.patch
```

3. gcc：
    * 如果你还没装gcc编译环境或自己不确定装没装，不妨先执行 ：`sudo apt-get install build-essential`
    * 选项 -Wall 开启编译器几乎所有常用的警告──强烈建议你始终使用该选项。编译器有很多其他的警告选项，但-Wall 是最常用的。默认情况下GCC 不会产生任何警告信息。

## ubuntu

### 1. 如何从vim中复制内容到系统剪切板？
A：ubuntu系统的vim默认不支持系统剪切板，安装vim-gnome即可。
```
sudo apt-get install vim-gnome
```

### 2. Q：如何修改终端颜色、路径名以及ls命令显示设置？
A：参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改\~/.bashrc文件中的`PS1`的值。

### 3. Q：如何定位Ubuntu启动失败的问题？
A：相关调试手段如下：
1. 开机后长按F2或F12可进入BIOS启动菜单，排查配置是否正确。
2. 当启动到登录界面后，按`Ctrl+Alt+F1~F6`可进入tty1~tty6，也就是命令行界面。
3. 可以在/var/log/syslog日志中查看启动失败原因。

### 4. Ubuntu as a subsystem on Windows  10

#### 1. Q: 如何解决ubuntu子系统中文乱码的问题？
A: 参考[Windows10内置ubuntu子系统安装后中文环境设置](https://blog.csdn.net/KERTORP/article/details/80102143)

## CentOS

### 1. CentOS系统安装lxml一直失败：“Error: unknown pseudo-op: '.'”。
A: 增加编译选项`-O0`后终于编译成功。
```
sudo CFLAGS="-O0" pip install lxml
```

### 2. 安装scrapy时提示“Scrapy 1.4.0 requires Python 2.7”？
A: 系统中的python版本还是2.6，需要升级到2.7.参考链接：[centos升级python2.6至2.7](https://zhuanlan.zhihu.com/p/22008289)

