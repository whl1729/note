## 使用技巧

### 1. 设置开机启动
在`/etc/rc.local`脚本中添加需要开机启动的操作。

## 常见问题

### ubuntu

#### 1. 如何从vim中复制内容到系统剪切板？
A：ubuntu系统的vim默认不支持系统剪切板，安装vim-gnome即可。
```
sudo apt-get install vim-gnome
```

#### 2. Q：如何修改终端颜色、路径名以及ls命令显示设置？
A：参考博客[Ubuntu终端颜色设置、路径名设置以及ls命令设置](http://blog.sina.com.cn/s/blog_65a8ab5d0101g6cf.html)，主要是修改\~/.bashrc文件中的`PS1`的值。

### CentOS

#### 1. CentOS系统安装lxml一直失败：“Error: unknown pseudo-op: '.'”。
A: 增加编译选项`-O0`后终于编译成功。
```
sudo CFLAGS="-O0" pip install lxml
```

#### 2. 安装scrapy时提示“Scrapy 1.4.0 requires Python 2.7”？
A: 系统中的python版本还是2.6，需要升级到2.7.参考链接：[centos升级python2.6至2.7](https://zhuanlan.zhihu.com/p/22008289)

