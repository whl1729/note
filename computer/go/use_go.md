# Go 使用笔记

## 数据类型

### map

1. Go语言中，一个map就是一个哈希表的引用。

## 环境配置

1. 设置`go install`的默认安装路径：[What does go install do?](https://stackoverflow.com/questions/24069664/what-does-go-install-do/54429573)

2. 安装vim go插件
    - 安装ubuntu版vscode，使用vscode打开一个go工程，里面会提示missing插件，根据提示安装相应插件，对安装失败的插件进行手动安装。
    - 安装vim-go: 在.vimrc中添加`Plugin 'fatih/vim-go'`,然后输入`:PluginInstall`
    - 在vim中执行`:GoInstallBinaries`
    - 下载golang/tools: `git clone https://github.com/golang/tools.git`

3. 在vim中让go自动导入package:`let g:go_fmt_command = "goimports"`

## Beego

1. 获取配置信息：`beego.AppConfig.String("mysqluser")`

2. 将error类型转化为string类型：`err.Error()`

3. 单元测试
    - 测试函数以Test*开头。
    - 测试函数将*testing.T作为参数，可以在失败的情况下使用Errorf()方法。
    - 在包内使用`go test -v -count 1`来运行单元测试。（-v用于打印log日志，-count 1用于清除缓存）

4. 如果想在Beego中通过c.Ctx.Input.RequestBody来获取POST body，需要在conf/app.conf中配置`copyrequestbody = true`。否则c.Ctx.Input.RequestBody永远为空。

## 格式化字符串

详见[fmt](https://golang.org/pkg/fmt/)。

1. General:
```
%v	the value in a default format
	when printing structs, the plus flag (%+v) adds field names
%#v	a Go-syntax representation of the value
%T	a Go-syntax representation of the type of the value
%%	a literal percent sign; consumes no value
```

2. Boolean:
```
%t	the word true or false
```

3. Integer:
```
%b	base 2
%c	the character represented by the corresponding Unicode code point
%d	base 10
%o	base 8
%q	a single-quoted character literal safely escaped with Go syntax.
%x	base 16, with lower-case letters for a-f
%X	base 16, with upper-case letters for A-F
%U	Unicode format: U+1234; same as "U+%04X"
```

4. Floating-point and complex constituents:
```
%b	decimalless scientific notation with exponent a power of two,
	in the manner of strconv.FormatFloat with the 'b' format,
	e.g. -123456p-78
%e	scientific notation, e.g. -1.234456e+78
%E	scientific notation, e.g. -1.234456E+78
%f	decimal point but no exponent, e.g. 123.456
%F	synonym for %f
%g	%e for large exponents, %f otherwise. Precision is discussed below.
%G	%E for large exponents, %F otherwise
```

5. String and slice of bytes (treated equivalently with these verbs):
```
%s	the uninterpreted bytes of the string or slice
%q	a double-quoted string safely escaped with Go syntax
%x	base 16, lower-case, two characters per byte
%X	base 16, upper-case, two characters per byte
```

6. Slice:
```
%p	address of 0th element in base 16 notation, with leading 0x
```

7. Pointer:
```
%p	base 16 notation, with leading 0x
The %b, %d, %o, %x and %X verbs also work with pointers,
formatting the value exactly as if it were an integer.
```

8. The default format for %v is:
```
bool:                    %t
int, int8 etc.:          %d
uint, uint8 etc.:        %d, %#x if printed with %#v
float32, complex64, etc: %g
string:                  %s
chan:                    %p
pointer:                 %p
```

9. Other flags:
```
+	always print a sign for numeric values;
	guarantee ASCII-only output for %q (%+q)
-	pad with spaces on the right rather than the left (left-justify the field)
#	alternate format: add leading 0 for octal (%#o), 0x for hex (%#x);
	0X for hex (%#X); suppress 0x for %p (%#p);
	for %q, print a raw (backquoted) string if strconv.CanBackquote
	returns true;
	always print a decimal point for %e, %E, %f, %F, %g and %G;
	do not remove trailing zeros for %g and %G;
	write e.g. U+0078 'x' if the character is printable for %U (%#U).
' '	(space) leave a space for elided sign in numbers (% d);
	put spaces between bytes printing strings or slices in hex (% x, % X)
0	pad with leading zeros rather than spaces;
	for numbers, this moves the padding after the sign
```
