# shell使用笔记

## grep

### 匹配多个字符串
grep默认不支持”或“运算符（”|“），需要加上-E选项或使用egrep才能支持”或“运算符。
```
grep -E 'warning|error'
egrep 'warning|error'
```

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
