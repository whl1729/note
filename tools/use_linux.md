##常见问题
1. Q: ubuntu系统的vim默认不支持系统剪切板，无法在vim中复制内容到系统剪切板？

  A: 安装vim-gnome即可.  
```
sudo apt-get install vim-gnome
```
2. Q: 在CentOS系统安装lxml一直失败，提示“Error: unknown pseudo-op: `.'”等。
  
  A: 增加编译选项`-O0`后终于编译成功。
```
sudo CFLAGS="-O0" pip install lxml
```

3. Q: 安装scrapy时提示“Scrapy 1.4.0 requires Python 2.7”？
  
  A: 系统中的python版本还是2.6，需要升级到2.7.参考链接：[centos升级python2.6至2.7](https://zhuanlan.zhihu.com/p/22008289)
