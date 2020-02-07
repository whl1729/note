# Go 使用笔记

## 易错点

1. 指针和指针所指向的对象只有在索引成员时是可以混淆的，其他情况下不可混淆。为避免犯错，按照C语言的方式来使用指针吧。

2. go build 出错：
```
along:~/work/C1-InterfaceServer$ GOARCH=arm64 go build tests/mockadasserver/mockadasserver.go 
# github.com/hujia-team/C1-InterfaceServer/controllers/utils
controllers/utils/utils.go:126:2: undefined: RunLed
controllers/utils/utils.go:129:2: undefined: PlayStartupSound
controllers/utils/utils.go:132:2: undefined: RunTakePhoto
controllers/utils/utils.go:135:2: undefined: InitRecord
```

3. for-select-case 结构中，注意break和return的区别，避免误用return而过早退出goroutine。

## 经验

1. package的设计要考虑模块间的依赖。不应将内聚性低的模块放在同一个package。

2. beego http超时时间大约为6分钟。（待确认）

## 数据类型

1. Go语言变量声明后的默认值
    - 整型：0
    - 浮点型：0.0
    - 布尔型：false
    - 复数类型：0+0i
    - 字符串型：""
    - 错误类型err: nil
    - interfaces, slices, channels, maps, pointers and functions: nil

2. 在Go中使用C的类型
    - C.char
    - C.schar (signed char)
    - C.uchar (unsigned char)
    - C.short
    - C.ushort
    - C.int
    - C.uint
    - C.long
    - C.ulong
    - C.longlong
    - C.ulonglong
    - C.float
    - C.double

3. Go string convert to C char*
    ```
    cs := C.CString("Hello from stdio")
	defer C.free(unsafe.Pointer(cs))
	C.myprint(cs)
    ```

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

4. 下载go package时，如果是golang网站下的安装包，需要翻墙才能下载，可以通过以下命令设置代理。
```
export http_proxy=socks5://127.0.0.1:1080
export https_proxy=socks5://127.0.0.1:1080
```


## 包

1. 使用某个包中的某个类型时，需要注明包名，比如：`websocket.Conn`

2. 使用`json.Unmarshal`来解析json文件到某个结构体时
    - 对应结构体的相关字段首字母必须大写，否则无法获取到json文件的真实值（因此该字段的值为原来的默认值）
    - 如果对应结构体含有json文件的key中不包含的字段，unmarshal不会因此报错。

## 调试

1. 使用gdb调试Go程序：[Debugging Go Code with GDB](https://golang.org/doc/gdb)
    - 编译时要增加编译选项：`go build -gcflags=all="-N -l"`
    - 调试go test也要增加编译选项：`go test -c`

2. 只跑指定的测试用例：`go test -run regexp`

3. delve
```
dlv debug main.go
b main.main
b main.go:28
print：输出变量信息
args：打印所有的方法参数信息
locals: 打印所有的本地变量
```

4. [stack-traces-in-go](https://www.ardanlabs.com/blog/2015/01/stack-traces-in-go.html)

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
