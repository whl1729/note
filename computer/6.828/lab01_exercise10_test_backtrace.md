# 《MIT 6.828 Lab 1 Exercise 10》实验报告

本实验的网站链接：[MIT 6.828 Lab 1 Exercise 10](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-10)。

## 题目

> Exercise 10. To become familiar with the C calling conventions on the x86, find the address of the test_backtrace function in obj/kern/kernel.asm, set a breakpoint there, and examine what happens each time it gets called after the kernel starts. How many 32-bit words does each recursive nesting level of test_backtrace push on the stack, and what are those words?

## 解答

题目要求我们在test_backtrace函数处设置断点，测试每次进入此函数时发生了什么事情，并观察每次将哪几个words压栈。首先贴上test_backtrace函数对应的C语言代码及汇编代码。

### test_backtrace函数对应的C代码
```
void test_backtrace(int x)
{
	cprintf("entering test_backtrace %d\n", x);
	if (x > 0)
		test_backtrace(x-1);
	else
		mon_backtrace(0, 0, 0);
	cprintf("leaving test_backtrace %d\n", x);
}
```

### test_backtrace函数对应的汇编代码
```
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	e8 5b 01 00 00       	call   f01001a5 <\_\_x86.get_pc_thunk.bx>
f010004a:	81 c3 be 12 01 00    	add    $0x112be,%ebx
f0100050:	8b 75 08             	mov    0x8(%ebp),%esi
f0100053:	83 ec 08             	sub    $0x8,%esp
f0100056:	56                   	push   %esi
f0100057:	8d 83 18 07 ff ff    	lea    -0xf8e8(%ebx),%eax
f010005d:	50                   	push   %eax
f010005e:	e8 cf 09 00 00       	call   f0100a32 <cprintf>
f0100063:	83 c4 10             	add    $0x10,%esp
f0100066:	85 f6                	test   %esi,%esi
f0100068:	7f 2b                	jg     f0100095 <test\_backtrace+0x55>
f010006a:	83 ec 04             	sub    $0x4,%esp
f010006d:	6a 00                	push   $0x0
f010006f:	6a 00                	push   $0x0
f0100071:	6a 00                	push   $0x0
f0100073:	e8 f4 07 00 00       	call   f010086c <mon\_backtrace>
f0100078:	83 c4 10             	add    $0x10,%esp
f010007b:	83 ec 08             	sub    $0x8,%esp
f010007e:	56                   	push   %esi
f010007f:	8d 83 34 07 ff ff    	lea    -0xf8cc(%ebx),%eax
f0100085:	50                   	push   %eax
f0100086:	e8 a7 09 00 00       	call   f0100a32 <cprintf>
}
f010008b:	83 c4 10             	add    $0x10,%esp
f010008e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100091:	5b                   	pop    %ebx
f0100092:	5e                   	pop    %esi
f0100093:	5d                   	pop    %ebp
f0100094:	c3                   	ret    
f0100095:	83 ec 0c             	sub    $0xc,%esp
f0100098:	8d 46 ff             	lea    -0x1(%esi),%eax
f010009b:	50                   	push   %eax
f010009c:	e8 9f ff ff ff       	call   f0100040 <test\_backtrace>
f01000a1:	83 c4 10             	add    $0x10,%esp
f01000a4:	eb d5                	jmp    f010007b <test\_backtrace+0x3b>
```

### 观察test\_backtrace函数调用栈

下面开始观察test_backtrace函数的调用栈。%esp存储栈顶的位置，%ebp存储调用者栈顶的位置，%eax存储x的值，这几个寄存器需要重点关注，因此我使用gdb的display命令设置每次运行完成后自动打印它们的值，此外我也设置了自动打印栈内被用到的那段内存的数据，以便清楚观察栈的变化情况。Let's go.

#### 进入test_backtrace(5)
```
f01000d1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000d8:	e8 63 ff ff ff       	call   f0100040 <test\_backtrace>
f01000dd:	83 c4 10             	add    $0x10,%esp
```

test_backtrace函数的调用发生在i386_init函数中，传入的参数x=5.我们将从这里开始跟踪栈内数据的变化情况。各寄存器及栈内的数据如下所示。可见，共有两个4字节的整数被压入栈：
1. 输入参数的值（也就是5）。
2. call指令的下一条指令的地址（也就是f01000dd）。

```
%esp = 0xf010ffdc
%ebp = 0xf010fff8
// stack info
0xf010ffe0: 0x00000005  // 第1次调用时的输入参数：5
0xf010ffdc: 0xf01000dd  // 第1次调用时的返回地址
```

进入test_backtrace函数后，涉及栈内数据修改的指令可以分为三部分：
1. 函数开头，将部分寄存器的值压栈，以便函数结束前可以恢复。
2. 调用cprintf前，将输入参数压入栈。
3. 在第2次调用test_backtrace前，将输入参数压入栈。
这里尚未弄明白f0100053对应的命令为啥要将esp寄存器的值减去8，感觉没有必要啊，有待研究。（伍注：大概明白了，应该是默认输入参数有4个4字节的word，不足4个的话也分配4个，这样从栈中清除输入参数很简单，直接将esp的值加上16即可）

```
// function start
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
// call cprintf
f0100053:	83 ec 08             	sub    $0x8,%esp
f0100056:	56                   	push   %esi
f0100057:	8d 83 18 07 ff ff    	lea    -0xf8e8(%ebx),%eax
f010005d:	50                   	push   %eax
f010005e:	e8 cf 09 00 00       	call   f0100a32 <cprintf>
f0100063:	83 c4 10             	add    $0x10,%esp
// call test_backtrace(x-1)
f0100095:	83 ec 0c             	sub    $0xc,%esp
f0100098:	8d 46 ff             	lea    -0x1(%esi),%eax
f010009b:	50                   	push   %eax
f010009c:	e8 9f ff ff ff       	call   f0100040 <test_backtrace>
```

#### 进入test_backtrace(4)

在即将进入test_backtrace(4)前，栈内数据如下所示。
```
%esp = 0xf010ffc0
%ebp = 0xf010ffd8
// stack info
0xf010ffe0: 0x00000005  // 第1次调用时的输入参数：5
0xf010ffdc: 0xf01000dd  // 第1次调用时的返回地址
0xf010ffd8: 0xf010fff8  // 第1次调用时寄存器%ebp的值
0xf010ffd4: 0x10094     // 第1次调用时寄存器%esi的值
0xf010ffd0: 0xf0111308  // 第1次调用时寄存器%ebx的值
0xf010ffcc: 0xf010004a  // 残留数据，不需关注
0xf010ffc8: 0x00000000  // 残留数据，不需关注
0xf010ffc4: 0x00000005  // 残留数据，不需关注
0xf010ffc0: 0x00000004  // 第2次调用时的输入参数
```

进入test_backtrace(3), test_backtrace(2), test_backtrace(1)和test_backtrace(0)的情况与test_backtrace(4)类似，不再赘述。下面直接给出进入mon_backtrace(0, 0, 0)时的栈内数据的情况。

#### 进入mon_backtrace(0, 0, 0)

在即将进入mon_backtrace(0, 0, 0)前，栈内数据如下所示。
```
%esp = 0xf010ff20
%ebp = 0xf010ff38
// stack info
0xf010ffe0: 0x00000005  // 第1次调用时的输入参数：5
0xf010ffdc: 0xf01000dd  // 第1次调用时的返回地址
0xf010ffd8: 0xf010fff8  // 第1次调用开始时寄存器%ebp的值
0xf010ffd4: 0x10094     // 第1次调用开始时寄存器%esi的值
0xf010ffd0: 0xf0111308  // 第1次调用开始时寄存器%ebx的值
0xf010ffcc: 0xf010004a  // 预留空间，不需关注
0xf010ffc8: 0x00000000  // 预留空间，不需关注
0xf010ffc4: 0x00000005  // 预留空间，不需关注
0xf010ffc0: 0x00000004  // 第2次调用时的输入参数：4
0xf010ffbc: 0xf01000a1  // 第2次调用时的返回地址
0xf010ffb8: 0xf010ffd8  // 第2次调用开始时寄存器%ebp的值
0xf010ffb4: 0x00000005  // 第2次调用开始时寄存器%esi的值
0xf010ffb0: 0xf0111308  // 第2次调用开始时寄存器%ebx的值
0xf010ffac: 0xf010004a  // 预留空间，不需关注
0xf010ffa8: 0x00000000  // 预留空间，不需关注
0xf010ffa4: 0x00000004  // 预留空间，不需关注
0xf010ffa0: 0x00000003  // 第3次调用时的输入参数：3
0xf010ff9c: 0xf01000a1  // 第3次调用时的返回地址
0xf010ff98: 0xf010ffb8  // 第3次调用开始时寄存器%ebp的值
0xf010ff94: 0x00000004  // 第3次调用开始时寄存器%esi的值
0xf010ff90: 0xf0111308  // 第3次调用开始时寄存器%ebx的值
0xf010ff8c: 0xf010004a  // 预留空间，不需关注
0xf010ff88: 0xf010ffb8  // 预留空间，不需关注
0xf010ff84: 0x00000003  // 预留空间，不需关注
0xf010ff80: 0x00000002  // 第4次调用时的输入参数：2
0xf010ff7c: 0xf01000a1  // 第4次调用时的返回地址
0xf010ff78: 0xf010ff98  // 第4次调用开始时寄存器%ebp的值
0xf010ff74: 0x00000003  // 第4次调用开始时寄存器%esi的值
0xf010ff70: 0xf0111308  // 第4次调用开始时寄存器%ebx的值
0xf010ff6c: 0xf010004a  // 预留空间，不需关注
0xf010ff68: 0xf010ff98  // 预留空间，不需关注
0xf010ff64: 0x00000002  // 预留空间，不需关注
0xf010ff60: 0x00000001  // 第5次调用时的输入参数：1
0xf010ff5c: 0xf01000a1  // 第5次调用时的返回地址
0xf010ff58: 0xf010ff78  // 第5次调用开始时寄存器%ebp的值
0xf010ff54: 0x00000002  // 第5次调用开始时寄存器%esi的值
0xf010ff50: 0xf0111308  // 第5次调用开始时寄存器%ebx的值
0xf010ff4c: 0xf010004a  // 预留空间，不需关注
0xf010ff48: 0xf010ff78  // 预留空间，不需关注
0xf010ff44: 0x00000001  // 预留空间，不需关注
0xf010ff40: 0x00000000  // 第6次调用时的输入参数：0
0xf010ff3c: 0xf01000a1  // 第6次调用时的返回地址
0xf010ff38: 0xf010ff58  // 第6次调用开始时寄存器%ebp的值
0xf010ff34: 0x00000001  // 第6次调用开始时寄存器%esi的值
0xf010ff30: 0xf0111308  // 第6次调用开始时寄存器%ebx的值
0xf010ff2c: 0xf010004a  // 预留空间，不需关注
0xf010ff28: 0x00000000  // 第7次调用时的第1个输入参数：0
0xf010ff24: 0x00000000  // 第7次调用时的第2个输入参数：0
0xf010ff20: 0x00000000  // 第7次调用时的第3个输入参数：0
```

mon_backtrace函数目前内部为空，不需关注。

#### 退出mon_backtrace(0, 0, 0)
通过`add $0x10, %esp`语句，将输入参数及预留的4字节从栈中清除。此时%esp = 0xf010ff30，%ebp = 0xf010ff38.

#### 退出test_backtrace(0)
连续3个pop语句将ebx, esi和ebp寄存器依次出栈，然后通过ret语句返回。其他1~5的退出过程类似，不再赘述。

### 回答问题

#### 问题1：每次调用test_backtrace时发生了什么事情？

答：每次调用test_backtrace时，主要做了如下事情：
1. 将返回地址（call指令的下一条指令的地址）压栈
2. 将ebp, esi, ebx三个寄存器的值压栈，以便退出函数前恢复它们的值
3. 调用cprintf函数打印"entering test_backtrace x"，其中x为输入参数的值
4. 将输入参数(x-1)压栈，再在栈中分配3个双字，共16字节，以方便清栈
5. 调用test_backtrace(x-1)
6. 调用cprintf函数打印"leaving test_backtrace x"，其中x为输入参数的值

最终QEMU窗口的打印信息如下所示。
```
6828 decimal is 15254 octal!
entering test_backtrace 5
entering test_backtrace 4
entering test_backtrace 3
entering test_backtrace 2
entering test_backtrace 1
entering test_backtrace 0
leaving test_backtrace 0
leaving test_backtrace 1
leaving test_backtrace 2
leaving test_backtrace 3
leaving test_backtrace 4
leaving test_backtrace 5
```

#### 问题2：每次调用test_backtrace时将多少个双字（32位）压栈？它们分别是什么？

答：结合第一问的回答，不难发现每次调用test_backtrace时共将8个双字压栈：
1. 返回地址
2. ebp, esi, ebx三个寄存器的值
3. 输入参数(x-1)的值
4. 3个预留双字（与输入参数构成4字节，方便清栈）

## 疑问

1. 在i386_init入口处设置断点并运行，发现执行`memset(edata, 0, end - edata);`时会异常结束，这是什么原因？暂时注释掉这一句后，运行到monitor函数时又会不断打印乱码以及“unknown command”，这又是什么原因？
答：见[《一个memset导致的血案》](lab01_bug01_memset.md).

2. 这段代码中多次出现"sub 0x8, %esp"或"add 0x10, %esp"等语句，不知道为啥要加减对应的值？
答：突然想明白了，这里应该是默认输入参数为4个4字节的word，不够4个的话也在栈中分配4个word的空间，这样清栈的时候会很简单，直接将%esp加上16即可。

3. cprintf中的格式化字符串存储在内存中的哪个位置？这个有什么规则的吗？

## 备注

1. `call   0xf01001bc <__x86.get_pc_thunk.bx>`的作用：
    * 根据[What is i686.get_pc_thunk.bx? Why do we need this call?](https://stackoverflow.com/questions/6679846/what-is-i686-get-pc-thunk-bx-why-do-we-need-this-call/30244270)的解释，这个指令是将代码的地址保存到ebx寄存器，这样全局对象可以通过ebx寄存器的值加上偏移量来访问。
    * 使用gdb调试时发现这个get_pc_thunk.bx函数的实现只是将esp寄存器保存的地址对应的值赋给ebx寄存器：
```
=> 0xf01001bc <__x86.get_pc_thunk.bx>:  mov    (%esp),%ebx
=> 0xf01001bf <__x86.get_pc_thunk.bx+3>:    ret    
```

2. call和ret：call指令先将下一条指令的地址压栈，然后跳到指定地址；ret指令设置eip地址为esp寄存器所指向的地址（也就是返回地址），然后将返回地址出栈。

3. `jmp *%eax` is AT&T syntax for `jmp eax`, which is one form of jmp r/m32. It will jump to the address contained in register eax.

4. 使用gdb设置断点时，需要填映射前的地址，如果填映射后的地址的话不会在对应位置停下来。比如：内核中将0xf01000a6映射到0x1000a6，设置断点时如果填0x1000a6不会生效，必须填0xf01000a6.具体原因有待研究。

5. MOVZ指令
    * `movzwl 0xf00b8000, %edx`是指将0xf00b8000这个地址所指向的一个word复制给寄存器%edx，而不是将0xf00b8000这个数字复制给寄存器%edx。
    * MOVZBW: Move Zero-Extended Byte to Word. For MOVZBW, the low 8 bits of the destination are replaced by the source operand. the top 8 bits are set to 0. The source operand is unaffected.
    * MOVZBL: Move Zero-Extended Byte to Long. For MOVZBL, the low 8 bits of the destination are replaced by the source operand. the top 24 bits are set to 0. The source operand is unaffected.
    * MOVZWL: Move Zero-Extended Word to Long. For MOVZBW, the low 16 bits of the destination are replaced by the source operand. the top 16 bits are set to 0. The source operand is unaffected.

6. `mov 0x8(%ebp),%esi`这句代码将输入参数赋值到%esi寄存器，为什么输入参数是在%ebp寄存器指向的地址加上8的位置呢？这是因为在调用该函数时，先将输入参数压栈后，然后执行call指令，此时会将下一条指令的地址压栈；在跳到函数入口后，又会将ebp寄存器的值压栈。因此，输入参数在栈中的位置与栈顶相差8：(%ebp)存储旧的%ebp寄存器的值，4(%ebp)存储返回地址的值，8(%ebp)才是输入参数的值。

7. gdb的print指令
    * `print $esp` 显示esp寄存器的值
    * `print *0xf010ffe0` 显示0xf010ffe0这个地址的值
    * `print/x *0xf010ffe0@8` 以16进制的形式显示0xf010ffe0这个地址往后8个整数的值

8. gdb的display命令：Print value of expression EXP each time the program stops. Use "undisplay" to cancel display requests previously made.
