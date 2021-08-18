# vim使用笔记

## 最近使用

- [vim snippets][snippets]
  - Type the "snippet trigger" and press TAB in insert mode to evaluate the snippet block.
  - Use Ctrl + j to jump forward within the snippet.
  - Use Ctrl + k to jump backward within the snippet.
  - Use Ctrl + l to list all the snippets available for the current file-type

  [snippets]: https://bhupesh-v.github.io/learn-how-to-use-code-snippets-vim-cowboy/

- Visual 模式下插入文字：按 「Shift + i」

- 查找单词时要求完全匹配：`/\<word\>`

- vim的noremap映射
  - `noremap` 是不会递归的映射 (大概是no recursion)，例如`noremap Y y; noremap y Y`不会出现问题。前缀代表生效范围。
  - inoremap就只在插入(insert)模式下生效
  - vnoremap只在visual模式下生效
  - nnoremap就在normal模式下生效

- 全局搜索并跳转
  - `:vim /main ** | copen` 在当前目录及其子目录下搜索“hello”字符串
  - `:cw`  打开quickfix 列表窗口
  - `:ccl` 关闭quickfix 列表串口
  - `:cfirst, :cnext, :cprev, :clast` 跳转到quickfix的第一项、后一项、前一项及最后项
  - `%` 在当前缓冲区文件中搜索
  - `*.cpp` 在当前目录下的.cpp文件中搜索
  - `**/*.cpp` 在当前目录及子目录中.cpp文件中搜索
  - `**/*.cpp, **/*.h` 在当前目录及子目录中.cpp, .h文件中搜索

- 删除指定字符串的行
  - `g/pattern/d` 删除含有pattern的行
  - `v/pattern/d` 删除不含有pattern的行

- 把当前单词插入到命令行：`<Ctrl-r><Ctrl-w>`

- 相对于活动文件目录打开一个文件
  - `:edit %<Tab>` 输入活动缓冲区的完整文件路径
  - `:edit %:h<Tab>` 输入当前文件所在目录的路径
  - `cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'` 创建映射项

- 定位编译错误的位置
  - `:make`进行编译
  - `:cw` 打开错误窗口
  - `:cc` 显示当前错误信息
  - `:cn` 显示下一个错误信息
  - `:cp` 显示上一个错误信息
  - `:ccl` 关闭错误信息窗口

- 元字符
  - `\+` 匹配1个或多个
  - `\?` 匹配0个或1个
  - `\{n, m}` 匹配n～m个

- 将命令的标准输出重定向到当前缓冲区：`:read !{cmd}`

- 关闭光标闪烁（没找到彻底关闭的方法，但找到只闪1秒钟的方法）
```
gsettings set org.gnome.desktop.interface cursor-blink-timeout 1
```

- 设置特定文件格式的缩进规则
```
augroup FileTypeSpecificAutocommands
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType php setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
```

- 解决git status 不能显示中文的问题
```
git config --global core.quotepath false
```

## 常用

- [vim-tabe多标签切换](https://blog.csdn.net/xs1326962515/article/details/77837017)

- vim支持clipboard
  - 查看是否支持clipboard：`vim --version | grep "clipboard `（clipboard前面是减号则不支持，加号则支持）
  - 安装图形化界面的vim使其支持clipboard：`sudo apt-get install vim-gnome`

- 安装YouCompleteMe报错：
  - "YouCompleteme unavailable : no module named future"
    解决方法：首先`cd ~/.vim/bundle/YouCompleteMe`，然后`git submodule update --init --recursive`
  - "The ycmd server SHUT DOWN..."
    解决方法：首先`cd ~/.vim/bundle/YouCompleteMe`，然后`python install.py`

- 多文档编辑：
  - `Ctrl+^` 在当前缓冲区和上一个缓冲区之间跳转
  - `:bn[ext]` 下一个缓冲区
  - `:bp[revious]` 上一个缓冲区
  - `:files`或`:ls`或`:buffers` 列出目前缓冲区中的所有文档。+表示缓冲区已经被修改，#代表上一次编辑的文档，%代表目前正在编辑的文档
  - `:b num` 切换到第num个文件，其中num为buffer list中的编号
  - `:bd[elete]` 关闭当前缓冲区
  - `:n` 编辑下一个文档
  - `:2n` 编辑下两个文档
  - `:N` 编辑上一个文档
  - `e file` 不离开vim的情形下打开其他文档
  - `:f`或`Ctrl+G` 显示当前正在编辑的文档名称
  - `:f file` 改变编辑中的文档名

- 多标签页命令
  - `:tabe file`: 在新标签页打开文件file
  - `:tabs`: 显示已打开标签页的列表
  - `:tabc`: 关闭当前标签页
  - `:tabo`: 关闭所有标签页
  - `gt`: 跳转到下一个标签页
  - `gT`: 跳转到上一个标签页
  - `3gt`: 跳转到第3个标签页

- 高亮当前单词
  - `shift + *`: 向下查找并高亮显示
  - `shift + #`: 向上查找并高亮显示
  - `g + d`: 高亮显示光标所属单词，"n" 查找

- 支持markdown实时预览：[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)
```
" for normal mode
nmap <silent> <F8> <Plug>MarkdownPreview
" for insert mode
imap <silent> <F8> <Plug>MarkdownPreview
" for normal mode
nmap <silent> <F9> <Plug>StopMarkdownPreview
" for insert mode
imap <silent> <F9> <Plug>StopMarkdownPreview
```

- 重新加载已打开的文件：`:e file`.

- 从光标处删除到指定字符c（包括字符c）：dfc

- 删除文档中的^M符号：使用ex命令替换^M为空即可，注意通过Ctrl-v, Ctrl-m来输入^M。详见[Vim 中如何去掉 ^M 字符？](https://www.zhihu.com/question/22130727).

- [折叠设置](https://www.cnblogs.com/welkinwalker/archive/2011/05/30/-html)
  - set foldmethod=indent "set default foldmethod
  - "zi 打开关闭折叠
  - "zv 查看此行
  - zm 关闭折叠
  - zM 关闭所有
  - zr 打开
  - zR 打开所有
  - zc 折叠当前行
  - zo 打开当前折叠
  - zd 删除折叠
  - zD 删除所有折叠

## vim插件

### Vundle管理插件
    
- 打开vim，输入`:PluginInstall`来安装vim插件
- 要卸载插件，先在 .vimrc 中注释或者删除对应插件配置信息，然后在 vim 中执行`:PluginClean`
- 如果按下ESC时，输入法会由英文切换到中文，则在vimrc中注释掉'lilydjwg/fcitx.vim'

### CtrlSF

注意：CtrlSF 依赖于 ag 程序，可以通过`sudo apt install silversearcher-ag` 进行安装。

- 基本用法：`:CtrlSF pattern dir`（如果后面不带dir则默认是当前目录搜索）
- 使用`j k h l`浏览CtrlSP窗口，使用`Ctrl + j/k`在匹配项中跳转，使用q退出CtrlSP窗口
- In CtrlSF window:
  - Enter, o, double-click - Open corresponding file of current line in the window which CtrlSF is launched from.
  - <C-O> - Like Enter but open file in a horizontal split window.
  - t - Like Enter but open file in a new tab.
  - p - Like Enter but open file in a preview window.
  - P - Like Enter but open file in a preview window and switch focus to it.
  - O - Like Enter but always leave CtrlSF window opening.
  - T - Like t but focus CtrlSF window instead of new opened tab.
  - M - Switch result window between normal view and compact view.
  - q - Quit CtrlSF window.
  - <C-J> - Move cursor to next match.
  - <C-K> - Move cursor to previous match.
  - <C-C> - Stop a background searching process.

- 设置搜索路径：`:CtrlSF word path`

### ctags

- 在项目根目录下使用`ctags -R *`生成索引文件
- ctags常用命令
  - `Ctrl-]` Jump to the tag underneath the cursor
  - `:ts <tag> <RET>`  Search for a particular tag
  - `:tn`  Go to the next definition for the last tag
  - `:tp`  Go to the previous definition for the last tag
  - `:ts`  List all of the definitions of the last tag
  - `Ctrl-t`  Jump back up in the tag stack

### nerdtree

- ctr+w+h  光标移到左侧树形目录，ctrl+w+l 光标移到右侧文件显示窗口。多次摁 ctrl+w，光标自动在左右侧窗口切换。

## ex命令

- `:11,19g/./s/^/* /g`：在第11~19行中的非空行开头加上星号

- 全局搜索
  - `:g/pattern/p`: 寻找并显示文件中所有包含模式pattern的行
  - `:g!/pattern/nu`: 寻找并显示文件汇总所有不包含模式pattern的行，并显示其行号
  - `20,40g/pattern/p`: 寻找并显示第20到40行之间所有包含模式pattern的行

- `set ic`: 忽略大小写。 `set noic`：区分大小写。

## 参考资料

- [如何在 Linux 下利用 Vim 搭建 C/C++ 开发环境? - 韦易笑的回答 - 知乎](https://www.zhihu.com/question/47691414/answer/373700711)
