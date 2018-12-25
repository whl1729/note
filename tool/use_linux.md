# linux使用笔记

## 基本技巧

### 1. 设置开机启动
在`/etc/rc.local`脚本中添加需要开机启动的操作。

### 2. 键盘映射
```
xev | grep keycode  // 查看某个符号对应的键值
xmodmap -e "keycode 68=x"  // 将f2的键值68映射到字母x，这时按下f2键时会显示x
```

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

### Ubuntu as a subsystem on Windows  10

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

