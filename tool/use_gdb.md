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
```
