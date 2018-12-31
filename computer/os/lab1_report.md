# 《ucore lab1》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1：理解通过make生成执行文件的过程

详见[《ucore lab1 exercise1》实验报告](lab1_exercise1_report.md)

## 练习2：使用qemu执行并调试lab1中的软件

详见[《ucore lab1 exercise2》实验报告](lab1_exercise2_report.md)

## 练习3：分析bootloader进入保护模式的过程

详见[《ucore lab1 exercise3》实验报告](lab1_exercise3_report.md)

## 实验指导书笔记

1. 对于Intel 80386的体系结构而言，PC机中的系统初始化软件由BIOS (Basic Input Output System，即基本输入/输出系统，其本质是一个固化在主板Flash/CMOS上的软件)和位于软盘/硬盘引导扇区中的OS BootLoader（在ucore中的bootasm.S和bootmain.c） 一起组成。BIOS实际上是被固化在计算机ROM（只读存储器） 芯片上的一个特殊的软件，为上层软件提供最底层的、最直接的硬件控制与支持。

2. 到了32位的80386 CPU时代，内存空间扩大到了4G，多了段机制和页机制，但Intel依然很好地保证了80386向后兼容8086。地址空间的变化导致无法直接采用8086的启动约定。如果把BIOS启动固件编址在0xF000起始的64KB内存地址空间内，就会把整个物理内存地址空间隔离成不连续的两段，一段是0xF000以前的地址，一段是1MB以后的地址，这很不协调。为此，intel采用了一个折中的方案：默认将执行BIOS ROM编址在32位内存地址空间的最高BIOS启动过程105端，即位于4GB地址的最后一个64KB内。

3. 保护模式的一个主要目标是确保应用程序无法对操作系统进行破坏。实际上，80386就是通过在实模式下初始化控制寄存器（如GDTR，LDTR，IDTR与TR等管理寄存器）以及页表，然后再通过设置CR0寄存器使其中的保护模式使能位置位，从而进入到80386的保护模式。

4. 分段机制将内存划分成以起始地址和长度限制这两个二维参数表示的内存块，这些内存块就称之为段（Segment）。而在分段存储管理机制的保护模式下，每个段由如下三个参数进行定义：段基地址(Base Address)、段界限(Limit)和段属性(Attributes)。

5. 数据段选择子的整个内容可由程序直接加载到各个段寄存器（如SS或DS等） 当中。这些内容里包含了请求特权级（Requested Privilege Level，简称RPL） 字段。然而，代码段寄存器（CS） 的内容不能由装载指令（如MOV） 直接设置，而只能被那些会改变程序执行顺序的指令（如JMP、INT、CALL） 间接地设置。而且CS拥有一个由CPU维护的当前特权级字段（Current Privilege Level，简称CPL） 。代码段寄存器中的CPL字段（2位） 的值总是等于CPU的当前特权级，所以只要看一眼CS中的CPL，你就可以知道此刻的特权级了。

6. RPL的值可自由设置，并不一定要求RPL>=CPL，但是当RPL\<CPL时，实际起作用的就是CPL了，因为访问时的特权级保护检查要判断：max(RPL,CPL)<=DPL是否成立。所以RPL可以看成是每次访问时的附加限制，RPL=0时附加限制最小，RPL=3时附加限制最大。

7. [激活A20地址线详解](http://wenku.baidu.com/view/d6efe68fcc22bcd126ff0c00.html)

