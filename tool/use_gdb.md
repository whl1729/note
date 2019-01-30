# GDB使用笔记

## 常用命令

* `c (or continue)`: 连续执行命令直到遇到下一个断点或Ctrl-c.
* `si (or stepi)`: 执行一条机器指令
* `b function or b file:line (or breakpoint)`: 在指定函数或代码行设置一个断点
* `b *addr (or breakpoint)`: 在指定内存地址设置断点
* `info breakpoints`: 打印所有设置的断点信息
* `delete b_id1, b_id2`：删除指定编号的断点
* `set print pretty`: 将数组和结构体的打印格式设置得更pretty
* `info registers`: 打印通用寄存器、eip、eflags和segment selector的值
* `x/Nx addr`: 以16进制格式打印起始地址为addr的N个word.
* `x/Ni addr`: 打印起始地址为addr的N条汇编指令。
* `symbol-file file`: 切换到符号文件file。当GDB连接到QEMU时，它不知道VM中的进程边界，因此需要我们告诉它使用什么符号。
* `thread n`: GDB默认只关注一个线程，此命令可以让GDB关注线程n.
* `info threads`: 列出所有线程的状态和所在的函数。

## Tsinghua os实验课提供的gdb命令
* `info win `显示窗口的大小
* `layout next `切换到下一个布局模式
* `layout prev `切换到上一个布局模式
* `layout src `只显示源代码
* `layout asm `只显示汇编代码
* `layout split `显示源代码和汇编代码
* `layout regs `增加寄存器内容显示
* `focus cmd/src/asm/regs/next/prev `切换当前窗口
* `refresh `刷新所有窗口
* `tui reg next `显示下一组寄存器
* `tui reg system `显示系统寄存器
* `update `更新源代码窗口和当前执行点
* `winheight name +/- line `调整 name窗口的高度
* `tabset nchar `设置tab为nchar个字符
* `where` 命令查看程序出错的地方
* `list` 查看调用 gets 函数附近的代码
* `backtrace ` 显示所有的调用栈帧。该命令可用来显示函数的调用顺序
* `where continue ` 继续执行正在调试的程序
* `display EXPR ` 每次程序停止后显示表达式的值,表达式由程序定义的变量组成，使用undisplay取消显示。
* `file FILENAME ` 装载指定的可执行文件进行调试
* `help CMDNAME ` 显示指定调试命令的帮助信息
* `info break ` 显示当前断点列表，包括到达断点处的次数等
* `info files ` 显示被调试文件的详细信息
* `info func ` 显示被调试程序的所有函数名称
* `info prog ` 显示被调试程序的执行状态
* `info local ` 显示被调试程序当前函数中的局部变量信息
* `info var ` 显示被调试程序的所有全局和静态变量名称
* `kill ` 终止正在被调试的程序
* `list ` 显示被调试程序的源代码
* `quit ` 退出 gdb

## 基础知识

### Stepping

1. step runs one line of code at a time. When there is a function call, it steps into the called function. 

2. next does the same thing, except that it steps over function calls
    
3. stepi and nexti do the same thing for assembly instructions rather than lines of code.

4. All take a numerical argument to specify repetition.

5. Pressing the enter key repeats the previous command.

### Running

1. continue runs code until a breakpoint is encountered or you interrupt it with Control-C.

2. finish runs code until the current function returns.

3. `advance <location>` runs code until the instruction pointer gets to the specified location.

### Breakpoints

1. `break <location>` sets a breakpoint at the specified location. Locations can be memory addresses (\*0x7c00") or names (\mon backtrace", \monitor.c:71").

2. Modify breakpoints using delete, disable, enable.

### Watchpoints

1. Like breakpoints, but with more complicated conditions. `watch <expression>` will stop execution whenever the expression’s value changes

2. `watch -l <address>` will stop execution whenever the contents of the specified memory address change.

### Examining

1. x prints the raw contents of memory in whatever format you specify (x/x for hexadecimal, x/i for assembly, etc).

2. print evaluates a C expression and prints the result as its proper type. It is often more useful than x. 

3. The output from `p \*((struct elfhdr \*) 0x10000)` is much nicer than the output from `x/13x 0x10000`.

4. `info registers` prints the value of every register.

5. `info frame` prints the current stack frame.

6. `list <location>` prints the source code of the function at the specified location.

### Other tricks

1. You can use the set command to change the value of a variable during execution.

2. You have to switch symbol files to get function and variable names for environments other than the kernel. For example, when debugging JOS:
```
symbol-file obj/user/<name>
symbol-file obj/kern/kernel
``
