# shell使用笔记

## 常用脚本

- 获取当前脚本的绝对路径

  ```sh
  SCRIPTPATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
  ```

## 输入命令

### 移动

- `Ctrl+l` 清屏
- `Ctrl+r` 然后输入若干字符，开始向上搜索包含该字符的命令，继续按Ctrl+r，搜索上一条匹配的命令 
- `Ctrl+f` 向前移动一个字符
- `Ctrl+b` 向后移动一个字符
- `Alt+f` 向前移动一个单词
- `Alt+b` 向后移动一个单词
- `Ctrl+a` 移动到当前行的开头
- `Ctrl+e` 移动到当前行的结尾
- `Esc+b` 移动到当前单词的开头
- `Esc+f` 移动到当前单词的结尾
- `Ctrl+u` 剪切光标所在处之前的所有字符（不包括自身）
- `Ctrl+w` 剪切光标所在处之前的一个词（以空格、标点等为分隔符）
- `Ctrl+k` 剪切光标所在处之后的所有字符（包括自身）
- `Ctrl+d` 删除光标所在处字符
- `Ctrl+h` 删除光标所在处前一个字符
- `Ctrl+y` 粘贴刚才所删除的字符
- `Ctrl+t` 颠倒光标所在处及其之前的字符位置，并将光标移动到下一个字符
- `Ctrl+c` 删除整行
- `Alt+u` 把当前词转化为大写
- `Alt+l` 把当前词转化为小写
- `Alt+c` 把当前词汇变成首字符大写

## 多标签页

- 在terminal中新建一个标签页：`Ctrl + Shift + t`

- 在多个标签页中切换：`Ctrl + PageUp`和`Ctrl + PageDown`

## 进制转换

```sh
echo "obase=2;15" | bc  // 1111
echo "obase=8;15" | bc  // 17
echo "obase=16;15" | bc // F
printf %x 15  // F
printf %d 0xf // 15
printf %o 15  // 17
```

## grep

### 匹配多个字符串

- grep默认不支持「或」运算符（`|`），需要加上 `-E` 选项或使用 egrep 才能支持「或」运算符。

  ```sh
  grep -E 'warning|error'
  egrep 'warning|error'
  ```

## sed

- 打印文件的指定行：`sed -n "2,5p" filename`

## awk

### build-in变量

- `NR`：Number of Record. 表示从awk开始执行后，按照记录分隔符读取的数据次数，默认的记录分隔符为换行符，因此默认的就是读取的数据行数。

- `FNR`：File Number of Record. awk处理多个输入文件的时候，在处理完第一个文件后，NR并不会从1开始，而是继续累加，因此就出现了FNR，每当处理一个新文件的时候，FNR就从1开始计数。

- `NF`：Number of Field. 表示目前的记录被分割的字段的数目。

## shell特殊变量

- `$#` 传递到shell脚本或函数的参数总数
- `$*, $@` 所有命令行参数
- `"$*"` 将所有命令行参数视为单个字符串，相当于“$1 $2 ...”
- `$?` 前一条命令的退出状态
- `$$` Shell进程的进程编号（process ID）
- `$0` Shell程序的名称

## test运算符

- 文件判断
  - `-d file` file是目录
  - `-e file` file存在
  - `-f file` file为一般文件
  - `-h file` file为符号链接

> 备注：Tilde Expansion （波浪号展开）要求波浪号没被引号括起来，否则不会正常展开。

  ```sh
  if [ -d "~/Downloads" ]; then echo exists; fi   # no output
  if [ -d ~/Downloads ]; then echo exists; fi     # outputs: exists
  ```

- 字符串判断
  - `-n string` string不为null
  - `-z string` string为null
  - `s1 = s2` 字符串s1与s2相同
  - `s1 != s2` 字符串s1与s2不相同

- 整数判断
  - `n1 -eq n2` 整数n1等于n2
  - `n1 -ne n2` 整数n1不等于n2
  - `n1 -lt n2` 整数n1小于n2
  - `n1 -gt n2` 整数n1大于n2
  - `n1 -le n2` 整数n1小于或等于n2
  - `n1 -ge n2` 整数n1大于或等于n2

## bash配置

- 使用`source ~/.bashrc`命令使对\.bashrc文件的修改立即生效。

## set

- 在shell终端输入`help set`可以查看set选项。

- `-u`: Treat unset variables as an error when substituting.

- `-x`: Print commands and their arguments as they are executed.

## 获取执行路径或文件名

- `${BASH_SOURCE}`: 取得当前执行的shell文件所在的相对路径及文件名。

- `bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)`：取得当前执行的shell文件的绝对路径。

- `${basename $0}`：取得当前执行脚本的文件名

- `${basename $0 .sh}`：取得当前执行脚本去掉后缀的文件名

## 调试

### strace

strace的最简单的用法就是执行一个指定的命令，在指定的命令结束之后它也就退出了。在命令执行的过程中，strace会记录和解析命令进程的所有系统调用以及这个进程所接收到的所有的信号值。

## 其他

- `sudo -s`：切换到root权限。
