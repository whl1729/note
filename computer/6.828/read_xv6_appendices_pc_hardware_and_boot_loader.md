# 《xv6 Appendices: PC Hardware and Boot loader》学习笔记

[MIT 6.828 Lecture 2的preparation](https://pdos.csail.mit.edu/6.828/2017/schedule.html)要求阅读[《xv6 book》](https://pdos.csail.mit.edu/6.828/2017/xv6/book-rev10.pdf)的附录部分，附录包括“PC Hardware”和“The Boot loader”两部分，并且在附录最后还有3道练习题。下面先解答3道练习题，再摘录附录中的一些知识点。

## Exercise

### 问题1：为什么这样调用readseg不会出错？

> 1. Due to sector granularity, the call to readseg in the text is equivalent to readseg((uchar\*)0x100000, 0xb500, 0x1000). In practice, this sloppy behavior turns out not to be a problem Why doesn’t the sloppy readsect cause problems?

回答：首先我们使用gdb确认一下内核的程序段的数目、起始地址、长度等信息。在执行地址0x7d77的指令时，程序段的数目会被保存到esi寄存器中，设置断点并打印esi寄存器的值，发现为2，因此一共有两个程序段。
```
=> 0x7d77:	movzwl 0x1002c,%esi

Thread 1 hit Breakpoint 3, 0x00007d77 in ?? ()
1: /x $esp = 0x7be0
2: /x $esi = 0x0
3: /x $edi = 0x0
4: /x $ebx = 0x10034
(gdb) si
=> 0x7d7e:	shl    $0x5,%esi
0x00007d7e in ?? ()
1: /x $esp = 0x7be0
2: /x $esi = 0x2
3: /x $edi = 0x0
4: /x $ebx = 0x10034
```

在for循环中每次调用readseg的地方设置断点，并观察此时栈顶向上3个元素的值，即为3个输入参数的值。第一次调用时的栈中数据如下，可见是调用了`readseg(0x100000, 0xa516, 0x1000)`
```
(gdb) si
=> 0x7da0:	call   0x7cf8
0x00007da0 in ?? ()
1: /x $edi = 0x100000
2: /x $ebx = 0x10034
3: /x $esi = 0x10074
4: $esp = (void *) 0x7bd4
(gdb) x/4xw 0x7bd4
0x7bd4:	0x00100000	0x0000a516	0x00001000	0x00000000
```

第二次调用时的栈中数据如下，可见是调用了`readseg(0, 0, 0)`，这样进入readseg不会执行循环就返回，实际上相当于啥也没干。
```
(gdb) c
Continuing.
=> 0x7da0:	call   0x7cf8

Thread 1 hit Breakpoint 4, 0x00007da0 in ?? ()
1: /x $esp = 0x7bd4
2: /x $esi = 0x10074
3: /x $edi = 0x0
4: /x $ebx = 0x10054
(gdb) x/4xw 0x7bd4
0x7bd4:	0x00000000	0x00000000	0x00000000	0x00000000
```

因此，加载内核的操作是`readseg(0x100000, 0xa516, 0x1000)`，但是这为什么与`readseg(0x100000, 0xb500, 0x1000)`等价？尚未理解，有待研究。

### 问题2：修改加载地址后哪里会出错？

> 2. Suppose you wanted bootmain() to load the kernel at 0x200000 instead of 0x100000, and you did so by modifying bootmain() to add 0x100000 to the va of each ELF section. Something would go wrong. What?

回答：不会做。。后面掌握更多知识后再回头做。

### 问题3：为什么不通过malloc来获取所需内存？

> 3. It seems potentially dangerous for the boot loader to copy the ELF header to memory at the arbitrary location 0x10000. Why doesn’t it call malloc to obtain the memory it needs?

回答：按我的理解，malloc是C语言的库函数，需要依赖操作系统来实现，现在连内核都没加载，根本还用不了malloc函数。

## 摘录

1. A computer’s CPU (central processing unit, or processor) runs a conceptually simple loop: 
    * it consults an address in a register called the program counter,
    * reads a machine instruction from that address in memory, advances the program counter past the instruction, and executes the instruction. 
    * Repeat. 
    * If the execution of the instructiondoes not modify the program counter, this loop will interpret the memory pointed at by the program counter as a sequence of machine instructions to run one after theother. 
    * Instructions that do change the program counter include branches and function calls.

2. x86 register:
    * The modern x86 provides eight general purpose 32-bit registers—%eax, %ebx, %ecx, %edx, %edi, %esi, %ebp, and %esp—and a program counter %eip (the instruction pointer). The common e prefix stands for extended, as these are 32-bit extensions of the 16-bit registers %ax, %bx, %cx, %dx, %di, %si, %bp, %sp, and %ip. 
    * The two register sets are aliased so that, for example, %ax is the bottom half of %eax: writing to %ax changes the value stored in %eax and vice versa. 
    * The first four registers also have names for the bottom two 8-bit bytes: %al and %ah denote the low and high 8 bits of %ax; %bl, %bh, %cl, %ch, %dl, and %dh continue the pattern. 
    * In addition to these registers, the x86 has eight 80-bit floating-point registers as well as a handful of special purpose registers like the control registers %cr0, %cr2, %cr3, and %cr4; 
    * the debug registers %dr0, %dr1, %dr2, and %dr3; 
    * the segment registers %cs, %ds, %es, %fs, %gs, and %ss; 
    * and the global and local descriptor table pseudo-registers %gdtr and %ldtr. 
    * The control registers and segment registers are important to any operating system. The floating-point and debug registers are less interesting and not used by xv6.

3. modern x86 architectures use this technique, called memory-mapped I/O, for most high-speed devices such as network, disk, and graphics controllers. 

4. When an x86 PC boots, 
    * it starts executing a program called the BIOS (Basic Input/Output System), which is stored in non-volatile memory on the motherboard. The BIOS’s job is to prepare the hardware and then transfer control to the operating system. Specifically, it transfers control to code loaded from the boot sector, the first 512-byte sector of the boot disk. 
    * The boot sector contains the boot loader: instructions that load the kernel into memory. The BIOS loads the boot sector at memory address 0x7c00 and then jumps (sets the processor’s %ip) to that address.
    * When the boot loader begins executing, the processor is simulating an Intel 8088, and the loader’s job is to put the processor in a more modern operating mode, to load the xv6 kernel from disk into memory, and then to transfer control to the kernel. 

5. More commonly, kernels are stored in ordinary file systems, where they may not be contiguous, or are loaded over a network. These complications require the boot loader to be able to drive a variety of disk and network controllers and understand various file systems and network protocols. In other words, the boot loader itself must be a small operating system. 

6. Since such complicated boot loaders certainly won’t fit in 512 bytes, most PC operating systems use a two-step boot process. 
    * First, a simple boot loader like the one in this appendix loads a full-featured boot-loader from a known disk location, often relying on the less space-constrained BIOS for disk access rather than trying to drive the disk itself. 
    * Then the full loader, relieved of the 512-byte limit, can implement the complexity needed to locate, load, and execute the desired kernel. 

7. Modern PCs avoid many of the above complexities, because they support the Unified Extensible Firmware Interface (UEFI), which allows the PC to read a larger boot loader from the disk (and start it in protected and 32-bit mode).

8. In fact the BIOS does a huge amount of initialization in order to make the complex hardware of a modern computer look like a traditional standard PC. The BIOS is really a small operating system embedded in the hardware, which is present after the computer has booted.
