## 入门

### 位于第一行的#!

* 当一个文件开头的两个字符为#!时，内核会扫描该行其余的部分，看是否存在可用来执行程序的解释器的完整路径。

* 中间如果出现任何空白符号都会略过。

* 内核还会扫描是否有一个选项要传递给解释器。内核会以被指定的选项来引用解释器，再搭配命令行的其他部分。

### 命令与参数


* 命令行由命令名和选项组成。

* 以空格键或Tab键隔开命令行中各个组成部分。

* 选项的开头是一个减号，后面接着一个字母。选项是可有可无的，有可能需要加上参数。不需要参数的选项可以合并。示例：`ls -l -t Documents`可以合并为`ls -lt Documents`。

* 分号(;)可用来分隔同一行里的多条命令。

* 命令行最后加上&符号，则shell将在后台执行此命令。

* 命令分类
    * 内建命令
    
    * shell命令

    * 外部命令

    > 1\. 建立一个新的进程。
    >
    > 2\. 在新的进程里，在PATH变量所列出的目录中，寻找特定的命令。
    > 
    > 3\. 在新的进程里，以所找到的新程序取代执行中的shell程序并执行。

### 变量

* shell变量名的开头是字母或下划线，后面可接任意长度的字母、数字或下划线符号。变量名的长度无限制。

* shell变量可用来保存字符串值，所能保存的字符数也没有限制。

* 变量赋值的方式：先写变量名，紧接着等号(=)，最后是新值，中间完全没有任何空格。当所赋予的值含有空格时，请加上引号。示例：`school="Sun Yat-sen University"`。

* 在变量名前面加上$字符，可取出变量的值。

* 将一个变量赋值给另一个变量时，不需要使用双引号，但是使用双引号也没关系。不过，当你将几个变量连接起来时，就需要使用引号了。示例：`fullname="$first $second $third"`。

### 输出

* echo

    * 语法
    
    参数之间以一个空格隔开，并以换行符号结束。即：`echo [str1 str2 ...]`

    * 转义字符
    
    echo会解释每个字符串里的转义字符。

    * -n选项
    
    echo看到第一个参数为-n时，会忽略结尾的换行符。

* printf
    
    * 语法
    
    和C语言重点printf()函数类似，即：`printf format-string [arguments ..]`

### I/O重定向

* 标准输入/输出

    * 概念

    程序应该有数据的来源端、数据的目的端以及报告问题的地方，它们分别被成为标准输入、标准输出以及标准错误输出。

    * 默认的标准输入/输出

    当登录Unix时，默认的标准输入、输出及错误输出会被设置为你的终端。I/O重定向就是通过与终端交互或在shell脚本中设置，重新设置从哪里输入或输出到哪里。

* 重定向语法

    * 以<改变标准输入

    `program < file`可将program的标准输入修改为file。

    * 以>改变标准输出

    `program > file`可将program的标准输出修改为file。

    * 以>>附加到文件

    `program >> file`可将program的标准输出附加到file的结尾处。

    * 以|建立管道

    `program1 | program`可将program1的标准输出修改为program2的标准输入。

* 特殊文件
    
    * /dev/null
    
    传送到/dev/null的数据都会被系统丢掉，而读取/dev/null则会立即返回文件结束符号。

    * /dev/tty

    当程序打开该文件时，Unix会自动将它重定向到一个终端再与程序结合。这在程序必须读取人工输入时特别有用。示例：

    ```
    printf "Enter your password: "
    stty -echo    # 关闭自动打印输入字符的功能
    read pass1 < /dev/tty
    printf "Enter again: "
    read pass2 < /dev/tty
    stty echo    # 打开自动打印输入字符的功能
    ```

### 简单的执行跟踪

* `set -x`
    
打开跟踪功能。这会使得Shell显示每个被执行到的命令，并在前面加上"+ "。

* `set +x`

关闭跟踪功能。

## 查找与替换

### sed

#### 语法
```
sed [-n] 'editing command' [file ...]
sed [-n] -e 'editing command' ... [file ..]
sed [-n] -f script-file ... [file ...]
```

#### 主要选项

* `-e 'editing command'`

将editing command使用在输入数据上。适用于多个编辑命令需应用的场景，此时每个编辑命令都使用一个`-e`选项。例如：
```
sed -e 's/foo/bar/g' -e 's/chicken/cow/g' myfile.xml > myfile2.xml
```

* `-f script-file`

从script-file中读取编辑命令。当有多个命令需要执行时，可以将编辑命令全放进一个脚本里，再使用sed 搭配一个`-f`选项。例如：
```
$ cat fixup.sed
s/foo/bar/g
s/chicken/cow/g
s/draft animal/horse/g
...
$ sed -f fixup.sed myfile.xml > myfile2.xml
```

* `-n`

不是每个已修改结果行都正常打印，而是只显示以p指定的行。例如：
```
sed -n '/<HTML>/p' *.html    仅显示<HTML>这行
```

如果你使用一个脚本文件，可通过特殊的首行来打开此功能。例如：
```
#n
/<HTML>/p
```

#### 使用细节

* 虽然/是最常用的定界符，但任何可显示的字符都能作为定界符。在处理文件名时，通常都会以标点符号作为定界符。例如：
```
find /home/Documents -type d -print  |    寻找所有目录
sed 's;/home/Documents;/home/Doc;'   |    修改名称，这里使用分号作为定界符
sed 's/^/mkdir /'                    |    插入mkdir命令
sh -x                                |    以shell跟踪模式执行
```

* sed支持后向引用。例如：
```
$ echo /home/Documents | sed 's;/\(home\)/Documents;\1/Doc'
```

* 在s命令中以g结尾表示全局性，即用替代文本取代正则表达式中每一个匹配的。如果没有设置g，sed只会取代第一个匹配的。

* 你可以在结尾指定数字，指示第n个匹配出现才要被取代。例如：
```
$ sed 's/Apple/Banana/2' < fruit.txt    仅替代第二个匹配者
```

* sed命令会依次处理命令行上的每个文件名，如果没有文件，则使用标准输入，文件名"-"可用于表示标准输入。

* sed命令默认地将每一个编辑命令应用到每个输入行，你也可以指定sed命令应用于特定行，只有在命令前置一个地址即可。以下为不同类型的地址：

    * 正则表达式
    将一模式放在一条命令前，可限制命令应用于匹配模式的行，可与s命令搭配使用。例如：
    ```
    /oldfunc/ s/$/# XXX: migrate to newfunc/    注释部分源代码
    ```

    s命令里的空模式指的是“使用前一个正则表达式”：
    ```
    /Tony/ s//& and Nancy/    将"Tony"修改为"Tony and Nancy"    
    ```

    * 否定正则表达式
    将!加在正则表达式后面，可以将命令应用于不匹配特定模式的每一行。例如：
    ```
    /used/!s/new/used/g       将没有used的每一行里所有的new替换成used
    ```

    * 尾行
    符号$指”最后一行“。例如，`sed -n '$p' myfile.txt`打印myfile.txt的最后一行。

    * 行编号
    可使用绝对的行编号作为地址。

    * 行范围
    可指定行的范围，仅需将地址以逗号隔开。例如：
    ```
    sed -n '10,42p' foo.xml            仅打印第10~42行
    sed '/foo/, /bar/ s/baz/quux/g'    仅匹配范围内的行
    ```

* 正则表达式匹配可以匹配整个表达式的输入文本中最长的、最左边的子字符串。例如：
    ```
    $ echo Tolstoy is worldly | sed 's/T.*y/Camus/'
    Camus
    ```

### cut

#### 语法
```
cut -c list [ file ... ]
cut -f list [ -d delim ] [ file ... ]
```

#### 主要选项

* `-c list`

以字符为单位，执行剪下的操作。list为字符编号或一段范围的列表(以逗号隔开)，例如`1,3,5-12,42`

* `-d delim`

使用delim作为定界符。默认定界符为Tab字符。

* `-f list`

以字段为单位，执行剪下的操作。list为字段编号或一段范围的列表（以逗号隔开）。

### join

#### 语法
```
join [ option ... ] file1 file2
```

#### 主要选项

* `-1 field1 -2 field2`

标明要结合的字段。`-1 field1`指的是从file1取出field1，`-2 field2`指的是从file2取出field2。字段编号自1开始，而非0.

* `-o file.field`

输出file文件中的field字段。一般的字段则不打印。

* `-t separator`

使用separator作为输入字段分割字符，而非使用空白。此字符也为输出的字段分割字符。

### awk

#### 模式与操作

* awk的基本模式
```
awk 'program' [ file ... ]
```

* awk程序的基本架构：
awk读取命令行上指定的各个文件（若不指定则为标准输入），一次读取一行。再针对每一行，应用程序所指定的命令。awk程序的基本架构为：
```
pattern { action }
pattern { action }
...
```

对每一行记录，awk会测试程序里的每个pattern，若模式值为真，则awk会执行action内的程序代码。

pattern部分几乎可以是任何表达式，但在单命令行程序里它通常是由斜杠括起来的正则表达式。action部分为任意的awk语句，单在单命令行程序里它通常是一个直接明了的print语句。

pattern或action都能省略。省略pattern，则会对每一条输入记录执行action；省略action则等同于{ print }，将打印整行记录。

#### 使用细节

* awk将每一行记录内的字段数目，存储在内建变量NF中。

* $字符后接着一个数值常数n，即可取得第n个字段的值。例如：
```
awk '{ print $1}'             打印第1个字段
awk '{ print $1, $NF}'        打印第1个与最后一个字段
awk 'NF > 0  { print $0 }'    打印非空行
```

* 简单的打印可使用print语句（awk的print语句会自动在最后加上换行符）。例如：
```
awk -F: '{ print "User", $1, "is really", $5 }' /etc/passwd
```

* 若要使用格式控制符来控制输出，可使用awk版本的printf语句。例如：

```
awk -F: '{ printf "User %s is really %s\n", $1, $5 }' /etc/passwd
```

* 起始与清除

BEGIN与END这两个特殊的”模式“，它们提供awk程序起始与清楚操作。常见于大型awk程序中，且通常写在个别文件中，而不是在命令行上。模式如下：
```
BEGIN    { startup code }

pattern1 { action1 }

pattern2 { action2 }

END      { cleanup code }
```

## 文件处理工具

