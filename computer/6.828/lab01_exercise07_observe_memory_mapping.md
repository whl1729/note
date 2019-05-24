# 《MIT 6.828 Lab 1 Exercise 7》实验报告

本实验链接：[mit 6.828 lab1 Exercise 7](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-7)。

## 题目

> Exercise 7. Use QEMU and GDB to trace into the JOS kernel and stop at the movl %eax, %cr0. Examine memory at 0x00100000 and at 0xf0100000. Now, single step over that instruction using the stepi GDB command. Again, examine memory at 0x00100000 and at 0xf0100000. Make sure you understand what just happened.

> What is the first instruction after the new mapping is established that would fail to work properly if the mapping weren't in place? Comment out the movl %eax, %cr0 in kern/entry.S, trace into it, and see if you were right.

### 解答

题目包括两部分：一是观察内存地址映射瞬间的状态，二是分析内存地址映射失败的影响。

#### 一、观察内存地址映射瞬间的状态

题目首先要求观察执行命令`movl %eax, %cr0`前后0x00100000和0xf0100000两个地址的内容。我猜测执行前地址映射尚未完成，因此两个位置的内容不同；执行后地址映射完成，两个位置的内容将会相同。gdb调试结果也验证了我的猜测是正确的。

1. 启动qemu和gdb，在`mov %eax, %cr0`所在的地址0x100025处加断点，运行至此，使用`x/16xw`查看两个地址往后16个word的内容，发现两者不同（后者为全0），说明地址映射尚未完成。
```
(gdb) x/16xw 0x00100000
0x100000:   0x1badb002  0x00000000  0xe4524ffe  0x7205c766
0x100010:   0x34000004  0x2000b812  0x220f0011  0xc0200fd8
0x100020:   0x0100010d  0x002cb880  0xe0fff010  0x000000bd
0x100030:   0x0000bc00  0x68e8f011  0xeb000000  0xe58955fe
(gdb) x/16xw 0xf0100000
0xf0100000 <_start+4026531828>: 0x00000000  0x00000000  0x000000000x00000000
0xf0100010 <entry+4>:   0x00000000  0x00000000  0x00000000  0x00000000
0xf0100020 <entry+20>:  0x00000000  0x00000000  0x00000000  0x00000000
0xf0100030 <relocated+4>:   0x00000000  0x00000000  0x000000000x00000000
```

2. 继续往下执行一步，再查看两个地址往后16个word，发现内容完全相同，说明地址映射成功。
```
(gdb) x/16xw 0x00100000
0x100000:   0x1badb002  0x00000000  0xe4524ffe  0x7205c766
0x100010:   0x34000004  0x2000b812  0x220f0011  0xc0200fd8
0x100020:   0x0100010d  0xc0220f80  0x10002fb8  0xbde0fff0
0x100030:   0x00000000  0x110000bc  0x0068e8f0  0xfeeb0000
(gdb) x/16xw 0xf0100000
0xf0100000 <_start+4026531828>: 0x1badb002  0x00000000  0xe4524ffe0x7205c766
0xf0100010 <entry+4>:   0x34000004  0x2000b812  0x220f0011  0xc0200fd8
0xf0100020 <entry+20>:  0x0100010d  0xc0220f80  0x10002fb8  0xbde0fff0
0xf0100030 <relocated+1>:   0x00000000  0x110000bc  0x0068e8f00xfeeb0000
```

#### 二、分析内存地址映射失败的影响

题目第二个问题是判断内存地址失败后哪些指令会运行失败，我判断是下面两条指令`mov $relocated, %eax`和`jmp %eax`就会失败，我的推理过程：relocated这个地址是由段地址加上偏移地址得到的，段地址是0xf0100008，如果地址映射失败，那些`jmp %eax`就会跳到0xf010008加上偏移量的物理地址，导致出错。gdb调试结果恰好验证了我的猜测是正确的。

1. 将kern/entry.S的`movl %eax, %cr0`注释掉，重新启动qemu和gdb，在`jmp %eax`加断点，使用c命令运行到这里，使用`x/16xw`查看0x00100000和0xf0100000两个地址往后16个word的内容，发现两者不同，后者依然是全0（内容与第一节第1步的相同，此处不再提供）。可见地址映射确实失败了。

2. 继续往下执行一步，发现gdb报错。应该是因为0xf010002c地址后面的数据全为0，导致把空指针赋给寄存器而报错。
```
(gdb) si
=> 0xf010002c <relocated>:  add    %al,(%eax)
relocated () at kern/entry.S:74
74      movl    $0x0,%ebp           # nuke frame pointer
(gdb) 
Remote connection closed
```
此时QEMU那边也打印一堆错误信息并终止运行：
```
qemu: fatal: Trying to execute code outside RAM or ROM at 0xf010002c

EAX=f010002c EBX=00010094 ECX=00000000 EDX=000000a4
ESI=00010094 EDI=00000000 EBP=00007bf8 ESP=00007bec
EIP=f010002c EFL=00000086 [--S--P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
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
CR0=00000011 CR2=00000000 CR3=00112000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
CCS=00000084 CCD=80010011 CCO=EFLAGS  
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
GNUmakefile:165: recipe for target 'qemu-gdb' failed
make: *** [qemu-gdb] Aborted (core dumped)
```
