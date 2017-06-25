##常见问题
* Q: ubuntu系统的vim默认不支持系统剪切板，无法在vim中复制内容到系统剪切板？
  A: 安装vim-gnome即可.  
```
sudo apt-get install vim-gnome
```
* Q: 在CentOS系统安装lxml一直失败，提示“Error: unknown pseudo-op: `.'”等。
  A: 增加编译选项`-O0`后终于编译成功。
```
sudo CFLAGS="-O0" pip install lxml
```
