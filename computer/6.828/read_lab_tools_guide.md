# 《6.828 lab tools guide》学习笔记

## 调试tips

### 调试内核

1. 使用`qemu-gdb`target让QEMU等待GDB来attach.

2. 使用`info mem`来调试虚拟内存。

3. 使用`thread`和`info threads`命令来调试多CPU程序。

### 调试用户环境

1. 使用`make run-time`让JOS以特定用户环境的方式启动，使用`make ran-name-gdb`让QEMU等待GDB来连接.

## 参考资料

### JOS makefile

JOS GNUmakefile提供多个targets来支持多种方式运行JOS，所有这些targets均配置QEMU等待GDB连接。一旦QEMU运行起来，在lab目录下执行`gdb`即可。我们提供`.gdbinit`文件来让GDB指向QEMU，加载kernel符号文件，并且在16位与32位两种模式间切换。

1. `make qemu`: 在新窗口通过VGA串口启动QEMU（没看见？），同时在终端串口也启动QEMU。使用`Ctrl-c`或`Ctrl-a x`退出VGA窗口（我试了不行？）

2. `make qemu-nox`: 只在终端串口启动QEMU。

3. `make qemu-gdb`: 与`make qemu`相似，但会在第一条机器指令停下来，等待GDB连接。

4. `make qemu-nox-gdb`: `qemu-nox`和`qemu-gdb`的结合。

5. `make run-name`: 运行用户程序name。例如`make run-hello`会运行`user/hello.c`

6. `make run-name-nox, run-name-gdb, run-name-gdb-nox`: 与qemu target类似。

### GDB

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

### QEMU

1. QEMU包含一个build-in的监控器，可以监控和修改机器状态。通过在终端输入`Ctrl-a c`进入或退出监控器。

2. 了解monitor命令可以查阅QEMU手册：[QEMU version 3.0.0 User Documentation](https://qemu.weilnetz.de/doc/qemu-doc.html)

3. `xp/Nx paddr`: 以16进制的格式显示起始地址为paddr的N个word

4. `info registers`: 显示完整的机器内部寄存器状态

5. `info mem`: 显示映射后的虚拟内存及权限

6. `info pg`: 显示当前页的表结构
