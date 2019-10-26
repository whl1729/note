# CentOS 使用笔记

## 软件安装

1. CentOS系统安装lxml一直失败：“Error: unknown pseudo-op: '.'”。
    - 增加编译选项`-O0`后终于编译成功。
```
sudo CFLAGS="-O0" pip install lxml
```

2. 安装scrapy时提示“Scrapy 1.4.0 requires Python 2.7”？
    - 系统中的python版本还是2.6，需要升级到2.7.参考链接：[centos升级python2.6至2.7](https://zhuanlan.zhihu.com/p/22008289)

