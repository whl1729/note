# 《MIT 6.828 Lab 1 Exercise 3》实验报告

本实验的网站链接：[mit 6.828 lab1 Exercise 3](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-3)。

## 题目

> Exercise 3. Take a look at the [lab tools guide](https://pdos.csail.mit.edu/6.828/2017/labguide.html), especially the section on GDB commands. Even if you're familiar with GDB, this includes some esoteric GDB commands that are useful for OS work.

> Set a breakpoint at address 0x7c00, which is where the boot sector will be loaded. Continue execution until that breakpoint. Trace through the code in boot/boot.S, using the source code and the disassembly file obj/boot/boot.asm to keep track of where you are. Also use the x/i command in GDB to disassemble sequences of instructions in the boot loader, and compare the original boot loader source code with both the disassembly in obj/boot/boot.asm and GDB.

> Trace into bootmain() in boot/main.c, and then into readsect(). Identify the exact assembly instructions that correspond to each of the statements in readsect(). Trace through the rest of readsect() and back out into bootmain(), and identify the begin and end of the for loop that reads the remaining sectors of the kernel from the disk. Find out what code will run when the loop is finished, set a breakpoint there, and continue to that breakpoint. Then step through the remainder of the boot loader.

> Be able to answer the following questions:
> * At what point does the processor start executing 32-bit code? What exactly causes the switch from 16- to 32-bit mode?
> * What is the last instruction of the boot loader executed, and what is the first instruction of the kernel it just loaded?
> * Where is the first instruction of the kernel?
> * How does the boot loader decide how many sectors it must read in order to fetch the entire kernel from disk? Where does it find this information?

## 解答

Exercise 3包含两部分：其一是使用GDB分析代码，其二是回答4个问题。

### 一、使用GDB分析代码

#### 阅读lab Tools指导材料
阅读完成，并输出[学习笔记](read_lab_tools_guide.md)。

#### 分析`boot/boot.S`的代码
```
00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	fc                   	cld    
    7c02:	31 c0                	xor    %eax,%eax
    7c04:	8e d8                	mov    %eax,%ds
    7c06:	8e c0                	mov    %eax,%es
    7c08:	8e d0                	mov    %eax,%ss
00007c0a <seta20.1>:
    7c0a:	e4 64                	in     $0x64,%al
    7c0c:	a8 02                	test   $0x2,%al
    7c0e:	75 fa                	jne    7c0a <seta20.1>
    7c10:	b0 d1                	mov    $0xd1,%al
    7c12:	e6 64                	out    %al,$0x64
00007c14 <seta20.2>:
    7c14:	e4 64                	in     $0x64,%al
    7c16:	a8 02                	test   $0x2,%al
    7c18:	75 fa                	jne    7c14 <seta20.2>
    7c1a:	b0 df                	mov    $0xdf,%al
    7c1c:	e6 60                	out    %al,$0x60
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64 7c 0f             	fs jl  7c33 <protcseg+0x1>
    7c24:	20 c0                	and    %al,%al
    7c26:	66 83 c8 01          	or     $0x1,%ax
    7c2a:	0f 22 c0             	mov    %eax,%cr0
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh
00007c32 <protcseg>:
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    7c36:	8e d8                	mov    %eax,%ds
    7c38:	8e c0                	mov    %eax,%es
    7c3a:	8e e0                	mov    %eax,%fs
    7c3c:	8e e8                	mov    %eax,%gs
    7c3e:	8e d0                	mov    %eax,%ss
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c45:	e8 cb 00 00 00       	call   7d15 <bootmain>
```
1. 在地址0x7c00处设置断点，这是boot loader第一条指令的位置。

2. 使用si命令跟踪代码，可见`boot.S`文件中主要做了以下事情：初始化段寄存器、打开A20门、从实模式跳到虚模式（需要设置GDT和cr0寄存器），最后调用bootmain函数。
    * seta20.1和seta20.2两段代码实现打开A20门的功能，其中seta20.1是向键盘控制器的0x64端口发送0x61命令，这个命令的意思是要向键盘控制器的 P2 写入数据；seta20.2是向键盘控制器的 P2 端口写数据了。写数据的方法是把数据通过键盘控制器的 0x60 端口写进去。写入的数据是 0xdf，因为 A20 gate 就包含在键盘控制器的 P2 端口中，随着 0xdf 的写入，A20 gate 就被打开了。
    * test对两个参数(目标，源)执行AND逻辑操作，并根据结果设置标志寄存器，结果本身不会保存。
    * GDT是全局描述符表，GDTR是全局描述符表寄存器。想要在“保护模式”下对内存进行寻址就先要有 GDT，GDT表里每一项叫做“段描述符”，用来记录每个内存分段的一些属性信息，每个段描述符占8字节。CPU使用GDTR寄存器来保存我们GDT在内存中的位置和GDT的长度。`lgdt gdtdesc`将源操作数的值（存储在gdtdesc地址中）加载到全局描述符表寄存器中。
    * x86一共有4个控制寄存器，分别为CR0～CR3，而控制进入“保护模式”的开关在CR0上，CR0上和保护模式有关的位是PE（标识是否开启保护模式）和PG（标识是否启用分页式）。
    * 关于A20门、GDT和cr0寄存器的详细介绍可以参考[【学习xv6】从实模式到保护模式](http://leenjewel.github.io/blog/2014/07/29/%5B%28xue-xi-xv6%29%5D-cong-shi-mo-shi-dao-bao-hu-mo-shi/)。。
    * `.byte`在当前位置插入一个字节；`.word`在当前位置插入一个字。

3. 题目中还要求我们比较`boot.S`，`boot.asm`与GDB的代码差异。我观察到的差异有： `boot.S`的指令含有表示长度的b,w,l等后缀，而`boot.asm`和GDB没有；同样一条指令，`boot.S`和GDB是操作ax寄存器，而`boot.asm`却是操作%eax。
```
    xorw %ax, %ax   // boot.S
    xor %eax, %eax  // boot.asm
    xor %ax, %ax    // GDB
```

4. 一个操作系统在计算机启动后到底应该做些什么：（摘自参考文献1《【学习xv6】从实模式到保护模式》）
    * 计算机开机，运行环境为 1MB 寻址限制带“卷绕”机制
    * 打开 A20 gate 让计算机突破 1MB 寻址限制
    * 在内存中建立 GDT 全局描述符表，并将建立好的 GDT 表的位置和大小告诉 CPU
    * 设置控制寄存器，进入保护模式
    * 按照保护模式的内存寻址方式继续执行

#### 分析`boot/main.c`的代码

1. 在bootmain函数的起始地址（0x7d15）处设置断点。bootmain函数开头定义了两个局部变量ph和eph，从汇编代码发现gcc分别用%ebx和%esi这两个寄存器来保存它们的值，而不是从栈中开辟空间来保存。从下面0x7d4c处的代码还可以发现ph指针加1对应地址偏移32个字节（Proghdr结构体占32个字节）。
```
    // C codes:
    // ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    // eph = ph + ELFHDR->e_phnum;
    7d3a:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d3f:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d46:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    7d4c:	c1 e6 05             	shl    $0x5,%esi
    7d4f:	01 de                	add    %ebx,%esi
```

2. 接下来分析readsect函数。这个函数主要做了三件事情：等待磁盘（waitdisk）、输出扇区数目及地址信息到端口（out）、读取扇区数据（insl）。
    * 等待磁盘。waitdisk的函数实现如下所示。它其实就做一件事情：不断地读端口0x1fc的bit_7和bit_6的值，直到bit_7=0和bit_6=1.结合参考文献1可知，端口1F7在被读的时候是作为状态寄存器使用，其中bit_7=0表示控制器空闲，bit_6=1表示驱动器就绪。因此，waitdisk在控制器空闲和驱动器就绪同时成立时才会结束等待。`
```
    // waitdisk:
    7c6a:	55                   	push   %ebp
    7c6b:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c70:	89 e5                	mov    %esp,%ebp
    7c72:	ec                   	in     (%dx),%al
    7c73:	83 e0 c0             	and    $0xffffffc0,%eax
    7c76:	3c 40                	cmp    $0x40,%al
    7c78:	75 f8                	jne    7c72 <waitdisk+0x8>
```
    * 输出数据到端口。根据参考文献1的介绍，IDE定义了8个寄存器来操作硬盘。PC 体系结构将第一个硬盘控制器映射到端口 1F0-1F7 处，而第二个硬盘控制器则被映射到端口 170-177 处。out函数主要是是把扇区计数、扇区LBA地址等信息输出到端口1F2-1F6，然后将0x20命令写到1F7，表示要进行读扇区的操作。
```
    // out:
    7c7c:	55                   	push   %ebp
    7c7d:	89 e5                	mov    %esp,%ebp
    7c7f:	57                   	push   %edi
    7c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    7c83:	e8 e2 ff ff ff       	call   7c6a <waitdisk>
    7c88:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c8d:	b0 01                	mov    $0x1,%al
    7c8f:	ee                   	out    %al,(%dx)
    7c90:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7c95:	88 c8                	mov    %cl,%al
    7c97:	ee                   	out    %al,(%dx)
    7c98:	89 c8                	mov    %ecx,%eax
    7c9a:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7c9f:	c1 e8 08             	shr    $0x8,%eax
    7ca2:	ee                   	out    %al,(%dx)
    7ca3:	89 c8                	mov    %ecx,%eax
    7ca5:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7caa:	c1 e8 10             	shr    $0x10,%eax
    7cad:	ee                   	out    %al,(%dx)
    7cae:	89 c8                	mov    %ecx,%eax
    7cb0:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cb5:	c1 e8 18             	shr    $0x18,%eax
    7cb8:	83 c8 e0             	or     $0xffffffe0,%eax
    7cbb:	ee                   	out    %al,(%dx)
    7cbc:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cc1:	b0 20                	mov    $0x20,%al
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	e8 a1 ff ff ff       	call   7c6a <waitdisk>
```
    * 读取扇区数据。主要用到insl函数，其实现是一个内联汇编语句。这个[stackflow网站](https://stackoverflow.com/questions/38410829/why-cant-find-the-insl-instruction-in-x86-document)解释了insl函数的作用：“That function will read cnt dwords from the input port specified by port into the supplied output array addr.”。关于内联汇编的介绍见[Brennan's Guide to Inline Assembly](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)和[GCC内联汇编基础](https://www.jianshu.com/p/1782e14a0766)。insl函数实质上就是从0x1F0端口连续读128个dword（即512个字节，也就是一个扇区的字节数）到目的地址。其中，0x1F0是数据寄存器，读写硬盘数据都必须通过这个寄存器。
```
    // insl:
    7cc9:	8b 7d 08             	mov    0x8(%ebp),%edi
    7ccc:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd1:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cd6:	fc                   	cld    
    7cd7:	f2 6d                	repnz insl (%dx),%es:(%edi)
    7cd9:	5f                   	pop    %edi
    7cda:	5d                   	pop    %ebp
    7cdb:	c3                   	ret    
```

3. 跟踪for循环
题目要求我们找出for循环的起始语句和结束语句。这个简单。首先看起始语句：esi寄存器装着eph的值，ebx寄存器装着ph的值，可见起始语句的用处是判断ph是否小于eph，若不小于则跳到循环结束处。
```
    // C Code:
	// for (; ph < eph; ph++)
	//	   readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d51:	39 f3                	cmp    %esi,%ebx
    7d53:	73 16                	jae    7d6b <bootmain+0x56>
```
接着看结束语句：ebx寄存器装着ph的值，三个pushl语句将调用readseg所需的三个参数从右到左依次压栈，注意第三句将ebx寄存器自增32，对应ph指针加1.调用完readseg函数后，将esp寄存器自增12，相当于清除栈中那3个输入参数。最后跳回到循环起始处，判断是否继续下一轮循环。
```
    // C Code:
	// for (; ph < eph; ph++)
	//	   readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d55:	ff 73 04             	pushl  0x4(%ebx)
    7d58:	ff 73 14             	pushl  0x14(%ebx)
    7d5b:	83 c3 20             	add    $0x20,%ebx
    7d5e:	ff 73 ec             	pushl  -0x14(%ebx)
    7d61:	e8 76 ff ff ff       	call   7cdc <readseg>
    7d66:	83 c4 0c             	add    $0xc,%esp
    7d69:	eb e6                	jmp    7d51 <bootmain+0x3c>
```
循环结束后，执行以下语句，即调用ELF文件中的入口函数。
```
    // C code:
	// ((void (*)(void)) (ELFHDR->e_entry))();
    7d6b:	ff 15 18 00 01 00    	call   *0x10018
```
使用gdb继续跟踪，发现会进入kern目录下的`entry.S`和`init.c`文件：
```
=> 0x10000c:	movw   $0x1234,0x472
=> 0x100015:	mov    $0x110000,%eax
=> 0x10001a:	mov    %eax,%cr3
=> 0x10001d:	mov    %cr0,%eax
=> 0x100020:	or     $0x80010001,%eax
=> 0x100025:	mov    %eax,%cr0
=> 0x100028:	mov    $0xf010002f,%eax
=> 0x10002d:	jmp    *%eax
=> 0xf010002f <relocated>:	mov    $0x0,%ebp
relocated () at kern/entry.S:74
74		movl	$0x0,%ebp			# nuke frame pointer
=> 0xf0100034 <relocated+5>:	mov    $0xf0110000,%esp
relocated () at kern/entry.S:77
77		movl	$(bootstacktop),%esp
=> 0xf0100039 <relocated+10>:	call   0xf0100094 <i386_init>
80		call	i386_init
=> 0xf0100094 <i386_init>:	push   %ebp
i386_init () at kern/init.c:24
```

### 二、回答问题

1. 问：处理器从哪里开始执行32位代码？是什么导致了16位代码到32位代码的切换？ 答：
    * 处理器应该是从`boot.S`文件中的`.code32`伪指令开始执行32位代码。补充：ljmp语句使得处理器从real mode切换到protected mode，地址长度从16位变为32位。
    ```
      ljmp    $PROT_MODE_CSEG, $protcseg
      .code32                     # Assemble for 32-bit mode
    protcseg:
      movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    ```
    * 处理器由16位代码到32位代码的切换，主要是通过设置cr0寄存器的PE位（是否开启保护模式）和PG位（启用分段式还是分页式）来触发的。

2. 问：boot loader执行的最后一条指令是什么？boot loader加载内核后，内核的第一条指令是什么？ 答：
    * boot loader的最后一条指令是`7d6b:	ff 15 18 00 01 00    	call   *0x10018`
    * 内核的第一条指令是`0x10000c:  movw   $0x1234,0x472`

3. 问：内核的第一条指令的地址在哪里？
答： 根据gdb调试结果，内核的第一条指令的地址为0x10000c.

4. 问：boot loader怎么知道为了从磁盘中读取整个内核的内容需要加载多少扇区？它从哪里获得这个信息？
答：ELF文件头中包含有段数目、每个段的偏移和字节数。根据这些信息，boot loader可以知道加载多少扇区。
```
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
```

## 备注
以下是阅读代码过程中查阅网上资料而整理的笔记。

1. x86 EFLAGS寄存器各状态标志的含义：
    * CF(bit 0) [Carry flag]: 若算术操作产生的结果在最高有效位(most-significant bit)发生进位或借位则将其置1，反之清零。这个标志指示无符号整型运算的溢出状态，这个标志同样在多倍精度运算(multiple-precision arithmetic)中使用。
    * PF(bit 2) [Parity flag]: 如果结果的最低有效字节(least-significant byte)包含偶数个1位则该位置1，否则清零。
    * AF(bit 4) [Adjust flag]: 如果算术操作在结果的第3位发生进位或借位则将该标志置1，否则清零。这个标志在BCD(binary-code decimal)算术运算中被使用。
    * ZF(bit 6) [Zero flag]: 若结果为0则将其置1，反之清零。
    * SF(bit 7) [Sign flag]: 该标志被设置为有符号整型的最高有效位。(0指示结果为正，反之则为负)
    * OF(bit 11) [Overflow flag]: 如果整型结果是较大的正数或较小的负数，并且无法匹配目的操作数时将该位置1，反之清零。这个标志为带符号整型运算指示溢出状态。

## 疑问

1. 如何查看某个地址对应的符号（函数名或变量名）？网上说使用`info symbol addr`命令，但我使用时提示"No symbol matches 0x7d15."

## 参考资料

1. [【学习xv6】从实模式到保护模式](http://leenjewel.github.io/blog/2014/07/29/%5B%28xue-xi-xv6%29%5D-cong-shi-mo-shi-dao-bao-hu-mo-shi/)

2. [【学习Xv6】加载并运行内核](http://leenjewel.github.io/blog/2015/05/26/%5B%28xue-xi-xv6%29%5D-jia-zai-bing-yun-xing-nei-he/)

3. [资源向导之 JOS 计划 MIT 6.828（JasonLeaster）](https://blog.csdn.net/cinmyheart/article/details/45150461)

4. [MIT 6.828 JOS 操作系统学习笔记（fatsheep9146）](http://www.cnblogs.com/fatsheep9146/category/769143.html)

