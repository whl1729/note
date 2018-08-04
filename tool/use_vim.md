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

4. 多文档编辑：
    * `Ctrl+^` 在当前缓冲区和上一个缓冲区之间跳转
    * `:bn[ext]` 下一个缓冲区
    * `:bp[revious]` 上一个缓冲区
    * `:files`或`:ls`或`:buffers` 列出目前缓冲区中的所有文档。+表示缓冲区已经被修改，#代表上一次编辑的文档，%代表目前正在编辑的文档
    * `:b num` 切换到第num个文件，其中num为buffer list中的编号
    * `:bd[elete]` 关闭当前缓冲区
    * `:n` 编辑下一个文档
    * `:2n` 编辑下两个文档
    * `:N` 编辑上一个文档
    * `e file` 不离开vim的情形下打开其他文档
    * `:f`或`Ctrl+G` 显示当前正在编辑的文档名称
    * `:f file` 改变编辑中的文档名

5. 多标签页命令
    * `:tabe file`: 在新标签页打开文件file
    * `:tabs`: 显示已打开标签页的列表
    * `:tabc`: 关闭当前标签页
    * `:tabo`: 关闭所有标签页
    * `gt`: 跳转到下一个标签页
    * `gT`: 跳转到上一个标签页
    * `3gt`: 跳转到第3个标签页

6. 高亮当前单词：`shift + *`

## vim插件

### CtrlSF

1. 基本用法：`:CtrlSF pattern dir`（如果后面不带dir则默认是当前目录搜索）
2. 使用`j k h l`浏览CtrlSP窗口，使用`Ctrl + j/k`在匹配项中跳转，使用q退出CtrlSP窗口