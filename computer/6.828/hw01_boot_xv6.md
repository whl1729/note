# 《MIT 6.828 Homework 1: boot xv6》解题报告

本作业的网站链接：[MIT 6.828 Homework 1: boot xv6](https://pdos.csail.mit.edu/6.828/2017/homework/xv6-boot.html)

## 问题

> Exercise: What is on the stack?  
While stopped at the above breakpoint, look at the registers and the stack contents:  
(gdb) info reg  
...  
(gdb) x/24x $esp  
...  
(gdb)  
    Write a short (3-5 word) comment next to each non-zero value on the stack explaining what it is. Which part of the stack printout is actually the stack?
    
> Here are some questions to help you along:  
> * Begin by restarting qemu and gdb, and set a break-point at 0x7c00, the start of the boot block (bootasm.S). Single step through the instructions (type si at the gdb prompt). Where in bootasm.S is the stack pointer initialized? (Single step until you see an instruction that moves a value into %esp, the register for the stack pointer.)  
> * Single step through the call to bootmain; what is on the stack now?  
> * What do the first assembly instructions of bootmain do to the stack? Look for bootmain in bootblock.asm.  
> * Continue tracing via gdb (using breakpoints if necessary -- see hint below) and look for the call that changes eip to 0x10000c. What does that call do to the stack? (Hint: Think about what this call is trying to accomplish in the boot sequence and try to identify this point in bootmain.c, and the corresponding instruction in the bootmain code in bootblock.asm. This might help you set suitable breakpoints to speed things up.)

## 解答

本题目要求解释内核启动时栈中的数据。由于PC启动顺序是BIOS -> boot loader -> kernel，要想知道内核启动时栈中数据的来源，需要知道前面BIOS和boot loader如何使用栈。因此，下面先解答文中提出的早期BIOS和boot loader启动的问题，再来解释内核启动时栈中的数据。

### 问题1：栈指针的初始值是什么？
在地址0x7c00处设置断点，使用c命令运行至此，然后使用si命令执行一步，最后查看寄存器信息，结果如下所示。可知栈指针的初始值为0x6f20，并且地址0x6f20存的数据为0xf000d239.
```
(gdb) b *0x7c00
Breakpoint 1 at 0x7c00
(gdb) c
Continuing.
[   0:7c00] => 0x7c00:	cli    

Thread 1 hit Breakpoint 1, 0x00007c00 in ?? ()
(gdb) si
[   0:7c01] => 0x7c01:	xor    %ax,%ax
0x00007c01 in ?? ()
(gdb) info reg
eax            0xaa55	43605
ecx            0x0	0
edx            0x80	128
ebx            0x0	0
esp            0x6f20	0x6f20
ebp            0x0	0x0
esi            0x0	0
edi            0x0	0
eip            0x7c01	0x7c01
eflags         0x2	[ ]
cs             0x0	0
ss             0x0	0
ds             0x0	0
es             0x0	0
fs             0x0	0
gs             0x0	0
(gdb) x/xw 0x6f20
0x6f20:	0xf000d239
```

### 问题2：当调用bootmain时栈中数据是什么？

单步执行到`call bootmain`处，发现esp寄存器的值为0x7c00，也就是boot block的起始地址。当执行完call指令后，esp寄存器的值变为0x7bfc，call指令的下一条指令的地址，也是bootmain函数的返回地址。
```
(gdb) si
=> 0x7c43:	mov    $0x7c00,%esp
0x00007c43 in ?? ()
1: /x $ebp = 0x0
2: /x $esp = 0x6f20
(gdb) si
=> 0x7c48:	call   0x7d3b
0x00007c48 in ?? ()
1: /x $ebp = 0x0
2: /x $esp = 0x7c00
(gdb) si
=> 0x7d3b:	push   %ebp

Thread 1 hit Breakpoint 2, 0x00007d3b in ?? ()
1: /x $ebp = 0x0
2: /x $esp = 0x7bfc
```

### 问题3：bootmain的第一条指令做了什么？

从bootblock.asm文件可以看到bootmain的第一条指令将ebp寄存器的值压栈。
```
    7d3b:	55                   	push   %ebp
```
这导致esp寄存器的值减4，由0x7bfc变为0x7bf8，而栈顶存储的元素也就是ebp寄存器的值，亦即为0.

### 问题4：那个修改eip的值为0x10000c的call语句对栈做了什么？

修改eip的值为0x10000c的语句是`call *0x10018`，其中地址0x10018处存储的内容为0x10000c，所以此语句做的事情是：先将返回地址0x7d8d压栈，然后跳到0x10000c的位置。

### 问题5：解释内核启动时栈中的数据

按照题目要求，执行gdb后，在地址0x0010000c处设置断点。然后

1. 查看寄存器信息
```
(gdb) info reg
eax            0x0	0
ecx            0x0	0
edx            0x1f0	496
ebx            0x10074	65652
esp            0x7bdc	0x7bdc
ebp            0x7bf8	0x7bf8
esi            0x10074	65652
edi            0x0	0
eip            0x10000c	0x10000c
eflags         0x46	[ PF ZF ]
cs             0x8	8
ss             0x10	16
ds             0x10	16
es             0x10	16
fs             0x0	0
gs             0x0	0
```

2. 查看栈中数据
```
(gdb) x/24x $esp
0x7bdc:	0x00007d8d	0x00000000	0x00000000	0x00000000
0x7bec:	0x00000000	0x00000000	0x00000000	0x00000000
0x7bfc:	0x00007c4d	0x8ec031fa	0x8ec08ed8	0xa864e4d0
0x7c0c:	0xb0fa7502	0xe464e6d1	0x7502a864	0xe6dfb0fa
0x7c1c:	0x16010f60	0x200f7c78	0xc88366c0	0xc0220f01
0x7c2c:	0x087c31ea	0x10b86600	0x8ed88e00	0x66d08ec0
```

3. 解释栈中数据
注意，栈实际上从0x7c00向下增长，大于0x7c00的地址存储的是BIOS和boot loader的代码。
```
0x7bdc:	0x00007d8d	// function return address after calling kernel
0x7be0: 0x00000000	// reserved value
0x7be4: 0x00000000	// reserved value
0x7be8: 0x00000000  // reserved value
0x7bec:	0x00000000	// reserved value
0x7bf0: 0x00000000	// ebx's value when calling bootmain
0x7bf4: 0x00000000	// esi's value when calling bootmain
0x7bf8: 0x00000000  // edi's value when calling bootmain
0x7bfc:	0x00007c4d	// function return address after calling bootmain
0x7c00: 0x8ec031fa	// cli (The following is instructions of bootblock)
0x7c04: 0x8ec08ed8	
0x7c08: 0xa864e4d0
0x7c0c:	0xb0fa7502	
0x7c10: 0xe464e6d1	
0x7c14: 0x7502a864	
0x7c18: 0xe6dfb0fa
0x7c1c:	0x16010f60	
0x7c20: 0x200f7c78	
0x7c24: 0xc88366c0	
0x7c28: 0xc0220f01
0x7c2c:	0x087c31ea	
0x7c30: 0x10b86600	
0x7c34: 0x8ed88e00	
0x7c38: 0x66d08ec0
```

## 备注

1. 第一次执行gdb时，没能运行到.gdbinit文件，有以下打印信息：
```
warning: File "/home/along/src/6.828/src/xv6-public/.gdbinit" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load".
To enable execution of this file add
	add-auto-load-safe-path /home/along/src/6.828/src/xv6-public/.gdbinit
line to your configuration file "/home/along/.gdbinit".
```
按照提示，在/home/along/.gdbinit文件中增加以上语句后，再运行gdb就正常了。
