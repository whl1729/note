# 《MIT 6.828 Lab1: Booting a PC》实验报告

本实验的网站链接见：[Lab 1: Booting a PC](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/)。

## 实验内容

1. 熟悉x86汇编语言、QEMU x86仿真器、PC开机引导流程
2. 测试6.828 内核的启动加载器（boot loader）
3. 研究6.828 内核的初始化模板（JOS）

## 实验题目

注意：部分Exercise的解答过程较长，因此专门新建一个文档来记录解答过程，而在本文中给出其链接。

### Exercise 1：阅读汇编语言资料

> Exercise 1. Familiarize yourself with the assembly language materials available on the [6.828 reference page](https://pdos.csail.mit.edu/6.828/2017/reference.html). You don't have to read them now, but you'll almost certainly want to refer to some of this material when reading and writing x86 assembly.

> We do recommend reading the section "The Syntax" in [Brennan's Guide to Inline Assembly](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html). It gives a good (and quite brief) description of the AT&T assembly syntax we'll be using with the GNU assembler in JOS.

#### 解答

1. [PC Assembly Language Book](https://pdos.csail.mit.edu/6.828/2017/readings/pcasm-book.pdf)是一本学习x86汇编语言的好书，不过要注意此书的例子是为NASM汇编器而设计，而我们课程使用的是GNU汇编器。我的学习笔记：[《PC Assembly Language》读书笔记](read_pc_assembly_language.md)。

2. NASM汇编器使用Intel语法，而GNU汇编器使用AT&T语法。两者的语法差异可以参考[Brennan's Guide to Inline Assembly](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)。我的学习笔记：[《Brennan's Guide to Inline Assembly》学习笔记](read_brennans_guide_to_inline_assembly.md)。

### Exercise 2：使用GDB命令跟踪BIOS做了哪些事情

见[《MIT 6.828 Lab 1 Exercise 2》实验报告](lab01_exercise02_trace_into_bios.md)。

### Exercise 3: 使用GDB命令跟踪boot loader做了哪些事情

见[《MIT 6.828 Lab 1 Exercise 3》实验报告](lab01_exercise03_trace_into_boot_loader.md)。

### Exercise 4: 阅读C指针材料和pointer.c代码

见[《MIT 6.828 Lab 1 Exercise 4》实验报告](lab01_exercise04_learn_pointer.md)。

### Exercise 5: 修改链接地址并观察boot loader运行情况

> Exercise 5. Trace through the first few instructions of the boot loader again and identify the first instruction that would "break" or otherwise do the wrong thing if you were to get the boot loader's link address wrong. Then change the link address in boot/Makefrag to something wrong, run make clean, recompile the lab with make, and trace into the boot loader again to see what happens. Don't forget to change the link address back and make clean again afterward!

#### 解答

练习5包括两部分：一是阅读boot loader开头的代码，并找出修改链接地址后会导致指令出错的地方；二是动手实战，修改boot/Makeflag中的链接地址并观察boot loader运行情况。

2. 阅读代码时没找到会受链接地址影响的指令，因此直接实战。将`-Ttext 0x7C00`改为`-Ttext 0x1C00`后，重新编译，然后gdb调试。我在0x7C00和0x1C00这两个地址均设置了断点，然后敲c，发现仍然是在0x7C00停住，再敲一次c，会报异常：“Program received signal SIGTRAP, Trace/breakpoint trap.”我预期修改后boot loader的起始地址应该从0x1c00开始，而gdb调试显示并没跑到地址为0x1c00的地方，所以怀疑对链接地址的修改没生效。后来看了[fatsheep9146的博客](https://www.cnblogs.com/fatsheep9146/p/5220004.html)，才知道这是正常的：BIOS是默认把boot loader加载到0x7C00内存地址处，所以boot loader的起始地址仍然是0x7C00.修改链接地址后，会导致`lgdt gdtdesc`和`ljmp    $PROT_MODE_CSEG, $protcseg`两句指令出错，两者都需要计算地址，计算方法为链接地址加上偏移，因此将链接地址修改成与加载地址不一样后，会导致地址计算失败。比如这里的gdtdesc和$protcseg的正确地址为0x7c64和0x7c32，修改链接地址后两者的地址分别变为0x1c64和0x1c32。

### Exercise 6: 为什么当BIOS进入boot loader时，与当boot loader进入内核时，这两个时刻在地址为0x00100000的内存中的内容不相同？

> Exercise 6. Reset the machine (exit QEMU/GDB and start them again). Examine the 8 words of memory at 0x00100000 at the point the BIOS enters the boot loader, and then again at the point the boot loader enters the kernel. Why are they different? What is there at the second breakpoint? (You do not really need to use QEMU to answer this question. Just think.)

#### 解答
0x00100000这个地址是内核加载到内存中的地址。当BIOS进入boot loader时，还没将内核加载到这块内存，其内容是随机的；而当boot loader进入内核时，内核已经加载完成，其内容就是内核文件内容。因此这两个阶段对应的0x00100000地址的内容是不相同的。可以通过gdb来验证：

1. 当BIOS刚进入boot loader时，地址0x00100000往后的8个word取值均为0.
```
(gdb) c
Continuing.
[   0:7c00] => 0x7c00:  cli    
Breakpoint 1, 0x00007c00 in ?? ()

(gdb) x/8xw 0x00100000
0x100000:   0x00000000  0x00000000  0x00000000  0x00000000
0x100010:   0x00000000  0x00000000  0x00000000  0x00000000
```

2. 当boot loader进入内核时，地址0x00100000往后的8个word已经出现非零值。我们还可以多加几个断点，以观察此内存地址内容最早是什么时候被修改的。实验证明是在bootmain函数中的for循环第一次结束后被修改的，而for循环做的事情就是将内核中的各个program segment加载到内存中。

```
(gdb) c
Continuing.
=> 0x7d6b:  call   *0x10018
Breakpoint 4, 0x00007d6b in ?? ()

(gdb) x/8xw 0x00100000
0x100000:   0x1badb002  0x00000000  0xe4524ffe  0x7205c766
0x100010:   0x34000004  0x2000b812  0x220f0011  0xc0200fd8
```

### Exercise 7: 观察内存地址映射瞬间及分析地址映射失败的影响

见[《MIT 6.828 Lab 1 Exercise 7》实验报告](lab01_exercise07_observe_memory_mapping.md)。

### Exercise 8: 串口格式化打印

见[《MIT 6.828 Lab 1 Exercise 8》实验报告](lab01_exercise08_formatted_printing_to_the_console.md)。

### Exercise 9: 分析内核栈初始化

> Exercise 9. Determine where the kernel initializes its stack, and exactly where in memory its stack is located. How does the kernel reserve space for its stack? And at which "end" of this reserved area is the stack pointer initialized to point to?

#### 解答

首先从entry标签的位置往下阅读，在relocated标签下面有句指令：`movl	$(bootstacktop),%esp`，这句指令把栈指针的值赋给%esp寄存器。继续往下看，找到bootstack标签，其中`.space KSTKSIZE`语句申请了大小为KSTKSIZE = 8 * PGSIZE = 8 * 4096 字节、初始值全为0的栈空间。再往后定义了bootstacktop标签，可见栈顶位置处于栈的最高地址上，而栈指针指向栈顶，亦即指向栈的最高地址，这也说明栈是由上到下（高地址向低地址）生长的。栈顶的位置我不知道怎么确定的，通过gdb调试观察发现$bootstacktop的值为0xf0110000，这个是虚拟地址，实际的物理地址为0x00110000.

```
.data
	.p2align	PGSHIFT		# force page alignment
	.globl		bootstack
bootstack:
	.space		KSTKSIZE
	.globl		bootstacktop   
bootstacktop:
```

### Exercise 10: 研究test_backtrace函数

详见[《MIT 6.828 Lab 1 Exercise 10》实验报告](lab01_exercise10_test_backtrace.md)。

### Exercise 11: 实现mon_backtrace函数

详见[《MIT 6.828 Lab 1 Exercise 11》实验报告](lab01_exercise11_implement_mon_backtrace.md)。

### Exercise 12: backtrace函数增加打印文件名、函数名及行号等信息

详见[《MIT 6.828 Lab 1 Exercise 12》实验报告](lab01_exercise12_backtrace_print_more_info.md)。

## 实验笔记

### 环境部署

#### 安装编译工具链
参考[Tools Used in 6.828: Compiler Toolchain](https://pdos.csail.mit.edu/6.828/2017/tools.html##chain)。根据`objdump -i`和`gcc -m32 -print-libgcc-file-name`命令的输出结果，可以确认我的Ubuntu环境已经支持6.828所需的工具链，因此跳过这一环节。

#### 安装QEMU仿真器
参考[Tools Used in 6.828: QEMU Emulator](https://pdos.csail.mit.edu/6.828/2017/tools.html#qemu)以及[Xin Qiu: MIT 6.828 Lab 1](https://xinqiu.me/2016/10/15/MIT-6.828-1/)。

### Part 1: PC Bootstrap

#### 模拟x86

1. make命令
    * `make`：编译最小的6.828启动加载器和内核
    * `make qemu`：运行QEMU。控制台输出会同时打印在QEMU虚拟VGA显示和虚拟PC的虚拟串口
    * `make qemu-nox`：运行QEMU。控制台输出只会打印在虚拟串口

#### PC物理地址空间

1. 早期基于8088处理器的PC只支持1MB的物理地址寻址
    * 0x00000000 ~ 0x000A0000：640KB，Low Memory，早期PC能够使用的RAM地址。
    * 0x000A0000 ~ 0x000FFFFF：384KB，预留给硬件使用，比如视频显示缓存、存储固件等。
        * 0x000A0000 ~ 0x000C0000: 128KB，VGA显示
        * 0x000C0000 ~ 0x000F0000: 192KB，16-bit devices, expansion ROMs
        * 0x000F0000 ~ 0x00100000: 64KB，BIOS RAM

2. 后来80286和80386处理器出现，能够支持16MB乃至4GB的物理地址空间，但仍然预留最低的1MB物理地址空间，以便后向兼容已有软件。因此现代PC在0x000A0000和0x00100000这段内存空间中存在hole，把RAM划分成“low memory”（或“conventional memory”，最低的640KB内存）和“extend memory”（其他内存）两部分。

### Part 2: The Boot loader

1. 当BIOS发现一个可启动的硬盘时，会将512字节的启动扇区加载到地址为0x7c00到0x7dff的内存中，然后使用jmp指令将CS:IP设置为0000:7c00，从而将控制权交给boot loader。

2. 6.828的boot loader由`boot/boot.S`和`boot/main.c`两个文件组成。

3. boot loader主要完成两个任务：
    * 将处理器由实模式切换到虚模式。
    * 从硬盘中读取内核（通过直接访问IDE磁盘设备寄存器）

4. 使用`readelf -a`或`objdump -h|-x` 命令可以查看elf文件的信息。

5. load_addr（加载地址）和link_addr（链接地址）的区别：
    * 一个section的load_addr（或“LMA”）是指这个section加载到内存中的地址
    * 一个section的link_addr（或“VMA”）是指这个section预期在内存中的运行地址

### Part 3: The Kernel

1. 内核的VMA和LMA
    * 输入`objdump -h obj/kern/kernel`可以发现内核的VMA（链接地址）和LMA（加载地址）不同。
    * 一般倾向于将操作系统内核链接到很高的虚拟地址来运行，这是为了把低地址留给用户程序使用。
    * 很多机器不具有0xf0100000这个物理地址，我们不能指望一定可以将内核加载到那里。因此，我们使用处理器的内存管理硬件来进行地址映射，将0xf0100000映射到0x00100000.
    * lab1中我们只会映射最小的4MB物理内存，将0xf0000000~0xf0400000与0x00000000~0x00400000均映射到0x00000000~0x00400000，任何不在这两段范围的地址均会导致硬件异常。

2. `.space size , fill` This directive emits size bytes, each of value fill. Both size and fill are absolute expressions. If the comma and fill are omitted, fill is assumed to be zero.

3. 如果同一程序的所有函数开头都遵循“ebp压栈，然后将esp的值复制给ebp”的约定，那么沿着被保存的ebp指针这条链，将可以追踪整个调用栈。

## 问题汇总

1. Q：`make qemu`进入QEMU界面后如何退出？目前我只能通过关闭终端来退出。

2. Q：`make qemu-gdb`进入QEMU界面，然后通过关闭终端退出，再次`make qemu-gdb`时报错：“qemu-system-i386: -gdb tcp::25000: Failed to bind socket: Address already in use”，怎么解决？
   A: 发生这种问题是由于端口被程序绑定而没有释放造成。可以使用`netstat -lp`命令查询当前处于连接的程序以及对应的进程信息。然后用`ps pid`察看对应的进程，并使用`kill pid`关闭该进程即可。

3. Q: BIOS, boot_loader和kernel的区别是什么？它们做的事情分别是什么？

4. Q: lab1中我们将0xf0000000~0xf0400000与0x00000000~0x00400000均映射到0x00000000~0x00400000，这样不会造成冲突吗？还是说这两个地址段不会共存（一开始是0x00000000~0x00400000直接线性映射为自身，而此时程序中的虚拟地址始终也在0x00000000~0x00400000这个区间内；等到加载内核时，才将0xf0000000~0xf0400000映射到0x00000000~0x00400000，而内核程序中的虚拟地址始终也在0xf0000000~0xf0400000这个区间内）？

5. Q: 将boot loader或kernel加载到内存时，代码段和数据段分别加载到什么地方？两者是紧挨着的还是隔得很远？

6. Q: 理解call和ret指令？
