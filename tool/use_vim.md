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

6. 高亮当前单词
    * `shift + *`: 向下查找并高亮显示
    * `shift + #`: 向上查找并高亮显示
    * `g + d`: 高亮显示光标所属单词，"n" 查找

7. 支持markdown实时预览：[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)

8. 重新加载已打开的文件：`:e file`.

9. 从光标处删除到指定字符c（包括字符c）：dfc

10. 删除文档中的^M符号：使用ex命令替换^M为空即可，注意通过Ctrl-v, Ctrl-m来输入^M。详见[Vim 中如何去掉 ^M 字符？](https://www.zhihu.com/question/22130727).

## vim插件

### Vundle管理插件
    
1. 打开vim，输入`:PluginInstall`来安装vim插件
2. 要卸载插件，先在 .vimrc 中注释或者删除对应插件配置信息，然后在 vim 中执行`:PluginClean`
3. 如果按下ESC时，输入法会由英文切换到中文，则在vimrc中注释掉'lilydjwg/fcitx.vim'

### CtrlSF

1. 基本用法：`:CtrlSF pattern dir`（如果后面不带dir则默认是当前目录搜索）
2. 使用`j k h l`浏览CtrlSP窗口，使用`Ctrl + j/k`在匹配项中跳转，使用q退出CtrlSP窗口
3. In CtrlSF window:
    * Enter, o, double-click - Open corresponding file of current line in the window which CtrlSF is launched from.
    * <C-O> - Like Enter but open file in a horizontal split window.
    * t - Like Enter but open file in a new tab.
    * p - Like Enter but open file in a preview window.
    * P - Like Enter but open file in a preview window and switch focus to it.
    * O - Like Enter but always leave CtrlSF window opening.
    * T - Like t but focus CtrlSF window instead of new opened tab.
    * M - Switch result window between normal view and compact view.
    * q - Quit CtrlSF window.
    * <C-J> - Move cursor to next match.
    * <C-K> - Move cursor to previous match.
    * <C-C> - Stop a background searching process.

### ctags

1. 在项目根目录下使用`ctags -R *`生成索引文件
2. ctags常用命令
    * `Ctrl-]` Jump to the tag underneath the cursor
    * `:ts <tag> <RET>`  Search for a particular tag
    * `:tn`  Go to the next definition for the last tag
    * `:tp`  Go to the previous definition for the last tag
    * `:ts`  List all of the definitions of the last tag
    * `Ctrl-t`  Jump back up in the tag stack

## ex命令

1. `:11,19g/./s/^/* /g`：在第11~19行中的非空行开头加上星号

2. 全局搜索
    * `:g/pattern/p`: 寻找并显示文件中所有包含模式pattern的行
    * `:g!/pattern/nu`: 寻找并显示文件汇总所有不包含模式pattern的行，并显示其行号
    * `20,40g/pattern/p`: 寻找并显示第20到40行之间所有包含模式pattern的行
