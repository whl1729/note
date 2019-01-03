# 《ucore lab1 exercise6》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 题目：完善中断初始化和处理
请完成编码工作和回答如下问题：

1. 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。

3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。

完成这问题2和3要求的部分代码后，运行整个系统，可以看到大约每1秒会输出一次”100 ticks”，而按下的键也会在屏幕上显示。

【注意】除了系统调用中断(T_SYSCALL)使用陷阱门描述符且权限为用户态权限以外，其它中断均使用特权级(DPL)为0的中断门描述符，权限为内核态权限；而ucore的应用程序处于特权级3，需要采用｀int 0x80`指令操作（这种方式称为软中断，软件中断，Trap中断，在lab5会碰到） 来发出系统调用请求，并要能实现从特权级3到特权级0的转换，所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为3。

> 没看懂？

## 解答

### 问题1的回答

问题1：中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？
答：中断描述符表一个表项占8个字节，其结构如下：
- bit 63..48:  offset 31..16
- bit 47..32:  属性信息，包括DPL、P flag等
- bit 31..16:  Segment selector
- bit 15..0:   offset 15..0

其中第16~32位是段选择子，用于索引全局描述符表GDT来获取中断处理代码对应的段地址，再加上第0~15、48~63位构成的偏移地址，即可得到中断处理代码的入口。

### 完善idt_init函数

```
qemu-system-i386: Trying to execute code outside RAM or ROM at 0x457e0000
This usually means one of the following happened:

(1) You told QEMU to execute a kernel for the wrong machine type, and it crashed on startup (eg trying to run a raspberry pi kernel on a versatilepb QEMU machine)
(2) You didn't give QEMU a kernel or BIOS filename at all, and QEMU executed a ROM full of no-op instructions until it fell off the end
(3) Your guest kernel has a bug and crashed by jumping off into nowhere

This is almost always one of the first two, so check your command line and that you are using the right type of kernel for this machine.
If you think option (3) is likely then you can try debugging your guest with the -d debug options; in particular -d guest_errors will cause the log to include a dump of the guest register state at this point.

Execution cannot continue; stopping here.
```
