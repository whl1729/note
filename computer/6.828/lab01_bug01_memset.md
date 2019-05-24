# 一个memset导致的血案

本文记录解答[MIT 6.828 Lab 1 Exercise 10](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-10)时遇到的一个Bug。

## 问题描述
在i386_init入口处设置断点并运行，发现执行`memset(edata, 0, end - edata);`时，QEMU窗口会打印以下日志并卡住，GDB窗口会异常结束。这是什么原因？

代码如下所示：
```
void i386_init(void)
{
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();

	cprintf("6828 decimal is %o octal!\n", 6828);

	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
}
```

QEMU窗口打印的错误日志：
```
EAX=00000000 EBX=00000000 ECX=000001a9 EDX=00000000
ESI=00000000 EDI=f0113000 EBP=f010ffd8 ESP=f010ffcc
EIP=f010171b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
FS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
GS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
GDT=     00007c4c 00000017
IDT=     00000000 000003ff
CR0=80010011 CR2=00000040 CR3=00112000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
Triple fault.  Halting for inspection via QEMU monitor.
```

GDB窗口打印的错误日志：
```
Program received signal SIGTRAP, Trace/breakpoint trap.
The target architecture is assumed to be i386
=> 0xf010171b <memset+73>:	Error while running hook_stop:
Cannot access memory at address 0xf010171b
0xf010171b in memset (
    v=<error reading variable: Cannot access memory at address 0xf010ffd0>, 
    c=<error reading variable: Cannot access memory at address 0xf010ffd4>, 
    n=<error reading variable: Cannot access memory at address 0xf010ffd8>) at lib/string.c:131
1: $ebp = (void *) 0xf010ffd8
2: $esp = (void *) 0xf010ffcc
3: /x $eax = 0x0
4: /x $ebx = 0x0
5: $ecx = 488
6: $edx = 0
8: /x $edi = 0xf0112f04
9: /x $esi = 0x0
10: *0xf0111300@10 = <error: Cannot access memory at address 0xf0111300>
11: *0xf0112f00@10 = <error: Cannot access memory at address 0xf0112f00>
12: *0xf01136a0@10 = <error: Cannot access memory at address 0xf01136a0>	asm volatile("cld; rep stosl\n"
```

## 定位过程

1. memset的汇编实现中是重复执行stosl命令，将0依次传到0xf0111300~0xf01136a4这段内存空间，每次传4字节，共需重复2281次。调试中发现，当执行到第2281-488=1793次时，也就是将0传给0xf0112f04这个地址时系统就报错了。

2. 从官方地址上下载一份干净的代码重新编译执行，发现同样在memset会崩溃，但我记得很早以前第一次下载代码来运行时是正常的，很奇怪。

3. 注释掉memset这一行，发现可以继续运行，但跑到monitor时会在QEMU窗口不断打印乱码与"unknown command."信息。使用gdb逐步执行时发现是readline时用户根本没输入但依然能读到数据，显示出来是乱码，因此解析输入内容时会报“Unknown command”。

4. 下午使用gdb跟踪readline及getchar的代码，最终跟踪到通过IN指令来获取输入数据的地方，但只能观察到用户没输入IN指令也能返回，确认不了原因。我怀疑是前面注释了memset语句，导致I/O需要用到的内存空间没初始化，进而出错。因此只能继续定位memset为什么出错。

5. 晚上决定先确认下是否只有0xf0112f04这个地址的初始化才会有问题，于是memset时避开这个地址，发现果然memset可以成功，但跑到monitor时会崩溃。
```
	memset(edata, 0, 0xf0112f04 - edata);
	memset(0xf0112f08, 0, end - 0xf0112f08);
```

6. 后来看代码注释时，发现memset语句的目的是初始化BSS段。
```
	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
```
通过`objdump -h obj/kern/kernel`命令查看发现，bss段的地址范围是0xf0113060~0xf01136a4，而我们要memset的地址范围却是0xf0111300~0xf0113604！这样除了初始化.bss段之外，还会初始化.got，.got.plt，.data.rel.local和.data.rel.ro.local等4个段。
```
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  5 .got          00000008  f0111300  00111300  00012300  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .got.plt      0000000c  f0111308  00111308  00012308  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .data.rel.local 00001000  f0112000  00112000  00013000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
  8 .data.rel.ro.local 00000044  f0113000  00113000  00014000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  9 .bss          00000644  f0113060  00113060  00014044  2**5
                  ALLOC
```

7. 我尝试将memset的地址范围改为bss段的地址范围（0xf0113060~0xf01136a4），结果memset和monitor都正常运行了。先记录至此，以后再回头分析一下。
