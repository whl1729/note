## \.模式

一键移动，另一键执行。示例：

* 给每行结尾添加分号
> 1\. A; 
> 2\. ESC
> 3\. j.

* 在加号前后各增加一个空格
> 1\. f+
> 2\. s, 然后输入" + "
> 3\. ;.

* 查找并手动替换单词
> 1\. /word
> 2\. cw，然后输入新单词
> 3\. n.

* 能够重复，就别用次数

## 模式

> 备注：
> 1. 操作符+作用范围=操作
> 2. 当一个操作符被重复两次，则作用于当前行
> 3. gUgU可以简写为gUU，其作用为将当前行所有字符替换成大写

### 插入模式

* 在插入模式下即时更正错误
    * Ctrl-h
    删除前一个字符
    * Ctrl-w
    删除前一个单词
    * Ctrl-u
    删至行首
    
* 在插入模式下粘贴寄存器中的文本
    * Ctrl-r 0
    把刚才复制的文本粘贴到光标处

* 在插入模式下做运算
    * Ctrl-r = 6*35
    计算6*35的值

### 可视模式

* 选择高亮选区
    * v
    切换到面向字符的可视模式
    * V
    切换到面向行的可视模式
    * Ctrl-V
    切换到面向列块的可视模式
    * gv
    重选上次的高亮选区

* 用可视模式编辑表格
    * 在列间增加分割线
    > 1\. Ctrl-v
    > 2\. 3j
    > 3\. r|

    * 在行间增加分割线
    > 1\. yy
    > 2\. p
    > 3\. Vr-

* 同时修改多列

> 1\. Ctrl-v
> 2\. 3je
> 3\. c，输入修改文本，最后按Esc

* 在长短不一的高亮块后添加分号

> 1\. Ctrl-v
> 2\. 3j$
> 3\. A;，最后按Esc

### 命令行模式

* 查询完整的Ex命令列表
>:h ex-cmd-index

* 用高亮选区指定范围
> 1\. 2G
> 2\. VG
> 3\. :
> 注：按下:后，命令行上会预先填充一个范围:'<,'>，其中‘<. '>分别代表高亮选区的首行和尾行

* 用模式指定范围
> :/< html>/,/<\/html>/p
> 注：该命令的作用：打印由< html>开标签所在的行开始，到对应闭标签所在的行结束。

* 用偏移对地址进行修正
    * :/< html>/+1, /<\/html>/-1p
    打印位于< html>和<\/html>标签之间的行，但不包括标签所在的行。

    * :., .+3p
    打印当前行开始，向下3行的内容。其中.代表当前行。

* 在指定范围上执行普通模式命令
    * :'<,'>normal .
    对高亮选区的每一行执行普通模式的.命令

    * :%normal A;
    在文件每行的结尾添加分号

* 重复上次的Ex命令
> @: 或 Ctrl-o

* 自动补全Ex命令
    * Ctrl-d
    显示可用的补全列表
    * Tab
    正向遍历补全列表项
    * Shift+Tab
    反向遍历补全列表项

* 把当前单词插入到命令行
> Ctrl-r + Ctrl-w

* 回溯历史命令
> : <方向键>
> 注：输入部分文本后，则只显示与输入内容开头的命令

* 命令行窗口
    * q/
    打开查找命令历史的命令行窗口
    * q:
    打开Ex命令历史的命令行窗口
    * Ctrl-f
    从命令行模式切换到命令行窗口

* 运行Shell命令
    * :!ls
    在vim中调用shell的ls命令，注意:ls是vim的内置命令，用于显示缓冲区列表的内容
    * :shell
    启动一个交互的shell回话，使用exit返回vim
    * Ctrl-z
    挂起vim所属的进程，使用fg恢复vim

## 文件

### 管理多个文件
* 用缓冲区列表管理打开的文件
    * :ls
    列出所有被载入内存的缓冲区列表
    * :bp[rev] :bn[ext]
    切换到下一个/上一个缓冲区
    * :bfirst :blast
    切换到第一个/最后一个缓冲区
    * :bdelete N1 N2 N3
    根据缓冲区编号来删除缓冲区

* 用参数列表将缓冲区分组
    * :args
    列出参数列表（在启动时作为参数传递给vim的文件列表）
    * :args {arglist}
    设置参数列表
    * :args `cat file`
    将file的内容作为参数列表
    * :next :prev
    遍历参数列表的文件
    * :argdo
    在列表中的每个缓冲区执行同一个命令

* 管理隐藏缓冲区
    * :w[rite]
    将缓冲区内容写入磁盘
    * :e[dit]!
    把磁盘文件内容读入缓冲区（即回滚所做修改）
    * :qa[ll]
    关闭所有窗口，摒弃修改而无需警告
    * :wa[ll]
    把所有改变的缓冲区写入磁盘

* 用标签页将窗口分组
    * :tabe[dit] file
    在新标签页中打开file
    * :tabnew
    新建空白标签页
    * :tabc[lose]
    关闭当前标签页及其中的所有窗口
    * :tabo[nly]
    只保留当前标签页，关闭所有其他标签页
    * :tabn[ext] {N} 或者{N}gt
    切换到编号为{N}的标签页
    * :tabn[ext]或者gt
    切换到下一个标签页
    * :tabp[revious]或者gT
    切换到上一个标签页

### 打开及保存文件

* 用:e[dit]打开文件
    * :pwd
    打印工作目录
    * :edit %
    %代表活动缓冲区的完整文件路径，按会将其展开
    * :edit %:h
    :h修饰符会去除文件名，但保留路径中的其他部分

* 用:find打开文件
    * 配置path选项
    :set path+=./**
    >注：**通配符会匹配所有子目录

    * :find file
    查找并打开文件file。若存在多个同名文件时，使用Tab切换。

* 用netrw管理文件系统
    * vim dir
    打开文件管理器netrw
    * :e[dit] dir
    打开文件管理器netrw
    * \-
    返回上级目录
    * ENTER
    进入当前目录
    * 杀手级功能
    通过网络来读写文件

## 移动

* 让手指保持在本位行上（ASDFGHJKL所在行）

* 区分实际行和屏幕行
>注：j,k,0,$都用于操作实际行，加上g前缀后则用于操作屏幕行

* 基于单词或字串移动
    *  w b e ge
    基于单词移动
    * W B E gE
    基于字串移动。
    >注：句号及单引号都被当成单词。字串比单词更长。

* 基于查找进行移动
    * d/get
    删除光标处到"get"之前的文本

* 基于文本对象选择选区
    * :h text-objexts
    查看文本对象的帮助信息
    * ci"#
    修改双引号内部的内容为#
    * a) a] a} a> a' a" a`
    选择包括括号或引号在内的文本
    * i) i] i} i> i' i" i`
    选择括号或引号里面的文本
    * at
    选择包括xml标签在内的文本
    * it
    选择标签内部的文本

* 设置位置标记
    * m{a-zA-Z}
    用选定的字母标记当前光标位置
    * 、{mark}
    跳到位置标记所在行的行首
    * 自动位置标记
        * ``
        当前文件中上次跳转动作之前的位置
        * `.
        上次修改的地方
        * `^
        上次插入的地方
        * `[
        上次修改或复制的起始位置
        * `]
        上次修改或复制的结束位置
        * `<
        上次高亮选区的起始位置
        * `>
        上次高亮选区的结束位置

* 在匹配括号间跳转
%
* 在匹配的关键字之间跳转
%
>注：需要激活matchit插件，命令为:h matchit-install

## 寄存器

### 寄存器分类

* 无名寄存器
""
* 复制专用寄存器
"0
* 有名寄存器
"a - "z
* 黑洞寄存器
"_
>注：运行"_d{motion}将删除文本且不保存任何副本

* 系统剪贴板
"+
* 选择专用寄存器
"*
* 表达式寄存器
"=
注：输入一段vim表达式并按Enter执行，如果返回的是字符串，则被存储在表达式寄存器"=中
* 当前文件名
"%
* 轮换文件名
"#
* 上次插入的文本
".
* 上次执行的Ex命令
":
* 上次查找的模式
"/

### 用寄存器进行删除、复制和粘贴

* 调换字符
xp
* 调换文本行
ddp
* 引用寄存器
"{register}