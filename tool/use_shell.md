# shell使用笔记

## grep

### 匹配多个字符串
grep默认不支持”或“运算符（”|“），需要加上-E选项或使用egrep才能支持”或“运算符。
```
grep -E 'warning|error'
egrep 'warning|error'
```

## shell特殊变量

* `$#` 传递到shell脚本或函数的参数总数
* `$*, $@` 所有命令行参数
* `"$*"` 将所有命令行参数视为单个字符串，相当于“$1 $2 ...”
* `$?` 前一条命令的退出状态
* `$$` Shell进程的进程编号（process ID）
* `$0` Shell程序的名称

## test运算符

1. 文件判断
    * `-d file` file是目录
    * `-e file` file存在
    * `-f file` file为一般文件
    * `-h file` file为符号链接

2. 字符串判断
    * `-n string` string不为null
    * `-z string` string为null
    * `s1 = s2` 字符串s1与s2相同
    * `s1 != s2` 字符串s1与s2不相同

3. 整数判断
    * `n1 -eq n2` 整数n1等于n2
    * `n1 -ne n2` 整数n1不等于n2
    * `n1 -lt n2` 整数n1小于n2
    * `n1 -gt n2` 整数n1大于n2
    * `n1 -le n2` 整数n1小于或等于n2
    * `n1 -ge n2` 整数n1大于或等于n2

## bash配置
1. 使用`source ~/.bashrc`命令使对\.bashrc文件的修改立即生效。

## set
1. 在shell终端输入`help set`可以查看set选项。

2. `-u`: Treat unset variables as an error when substituting.

3. `-x`: Print commands and their arguments as they are executed.

## 获取执行路径或文件名

1. `${BASH_SOURCE}`: 取得当前执行的shell文件所在的相对路径及文件名。

2. `bin=$(cd -P -- "$(dirname -- "$this")" && pwd -P)`：取得当前执行的shell文件的绝对路径。

3. `${basename $0}`：取得当前执行脚本的文件名
   `${basename $0 .sh}`：取得当前执行脚本去掉后缀的文件名
