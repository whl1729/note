# 《ucore lab1 exercise5》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 题目：实现函数调用堆栈跟踪函数
我们需要在lab1中完成kdebug.c中函数print_stackframe的实现，可以通过函数print_stackframe来跟踪函数调用堆栈中记录的返回地址。如果能够正确实现此函数，可在lab1中执行 “make qemu”后，在qemu模拟器中得到类似如下的输出：
```
ebp:0x00007b28 eip:0x00100992 args:0x00010094 0x00010094 0x00007b58 0x00100096
kern/debug/kdebug.c:305: print_stackframe+22
ebp:0x00007b38 eip:0x00100c79 args:0x00000000 0x00000000 0x00000000 0x00007ba8
kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b58 eip:0x00100096 args:0x00000000 0x00007b80 0xffff0000 0x00007b84
kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b78 eip:0x001000bf args:0x00000000 0xffff0000 0x00007ba4 0x00000029
kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b98 eip:0x001000dd args:0x00000000 0x00100000 0xffff0000 0x0000001d
kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007bb8 eip:0x00100102 args:0x0010353c 0x00103520 0x00001308 0x00000000
kern/init/init.c:63: grade_backtrace+34
ebp:0x00007be8 eip:0x00100059 args:0x00000000 0x00000000 0x00000000 0x00007c53
kern/init/init.c:28: kern_init+88
ebp:0x00007bf8 eip:0x00007d73 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
<unknow>: -- 0x00007d72 –
```

请完成实验，看看输出是否与上述显示大致一致，并解释最后一行各个数值的含义。

提示：可阅读小节“函数堆栈”，了解编译器如何建立函数调用关系的。在完成lab1编译后，查看lab1/obj/bootblock.asm，了解bootloader源码与机器码的语句和地址等的对应关系；查看lab1/obj/kernel.asm，了解 ucore OS源码与机器码的语句和地址等的对应关系。

要求完成函数kern/debug/kdebug.c::print_stackframe的实现，提交改进后源代码包（可以编译执行） ，并在实验报告中简要说明实现过程，并写出对上述问题的回答。

补充材料：
由于显示完整的栈结构需要解析内核文件中的调试符号，较为复杂和繁琐。代码中有一些辅助函数可以使用。例如可以通过调用print_debuginfo函数完成查找对应函数名并打印至屏幕的功能。具体可以参见kdebug.c代码中的注释。

## 解答

### 代码实现
1. 编程前，首先了解下当前情况：在Terminal下输入`make qemu`，发现打印以下信息后就退出了：
```
along:~/src/ucore/labcodes/lab1$ sudo make qemu
WARNING: Image format was not specified for 'bin/ucore.img' and probing guessed raw.
         Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
         Specify the 'raw' format explicitly to remove the restrictions.
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0x00100000 (phys)
  etext  0x001036f3 (phys)
  edata  0x0010e950 (phys)
  end    0x0010fdc0 (phys)
Kernel executable memory footprint: 64KB
```

2. 分析print_stackframe的函数调用关系
```
kern_init ->
    grade_backtrace ->
        grade_backtrace0(0, (int)kern_init, 0xffff0000) ->
                grade_backtrace1(0, 0xffff0000) ->
                    grade_backtrace2(0, (int)&0, 0xffff0000, (int)&(0xffff0000)) ->
                        mon_backtrace(0, NULL, NULL) ->
                            print_stackframe ->
                                
```

3. 找到print_stackframe函数，发现函数里面的注释已经提供了十分详细的步骤，基本上按照提示来做就行了。代码如下所示。
    - 首先定义两个局部变量ebp、esp分别存放ebp、esp寄存器的值。这里将ebp定义为指针，是为了方便后面取ebp寄存器的值。
    - 调用read_ebp函数来获取执行print_stackframe函数时ebp寄存器的值，这里read_ebp必须定义为inline函数，否则获取的是执行read_ebp函数时的ebp寄存器的值。
    - 调用read_eip函数来获取当前指令的位置，也就是此时eip寄存器的值。这里read_eip必须定义为常规函数而不是inline函数，因为这样的话在调用read_eip时会把当前指令的下一条指令的地址（也就是eip寄存器的值）压栈，那么在进入read_eip函数内部后便可以从栈中获取到调用前eip寄存器的值。
    - 由于变量eip存放的是下一条指令的地址，因此将变量eip的值减去1，得到的指令地址就属于当前指令的范围了。由于只要输入的地址属于当前指令的起始和结束位置之间，print_debuginfo都能搜索到当前指令，因此这里减去1即可。
    - 以后变量eip的值就不能再调用read_eip来获取了（每次调用获取的值都是相同的），而应该从ebp寄存器指向栈中的位置再往上一个单位中获取。
    - 由于ebp寄存器指向栈中的位置存放的是调用者的ebp寄存器的值，据此可以继续顺藤摸瓜，不断回溯，直到ebp寄存器的值变为0
```
void print_stackframe(void) {
    uint32_t *ebp = 0;
    uint32_t esp = 0;

    ebp = (uint32_t *)read_ebp();
    esp = read_eip();

    while (ebp)
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
        
        print_debuginfo(esp - 1);

        esp = ebp[1];
        ebp = (uint32_t *)*ebp;
    }
     /* LAB1 YOUR CODE : STEP 1 */
     /* (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
      * (2) call read_eip() to get the value of eip. the type is (uint32_t);
      * (3) from 0 .. STACKFRAME_DEPTH
      *    (3.1) printf value of ebp, eip
      *    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
      *    (3.3) cprintf("\n");
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
```

4. 编码完成后，执行`make qemu`，打印结果如下所示，与实验指导书的结果类似。

```
ebp:0x00007b38 eip:0x00100bf2 args:0x00010094 0x0010e950 0x00007b68 0x001000a2
    kern/debug/kdebug.c:297: print_stackframe+48
ebp:0x00007b48 eip:0x00100f40 args:0x00000000 0x00000000 0x00000000 0x0010008d
    kern/debug/kmonitor.c:125: mon_backtrace+23
ebp:0x00007b68 eip:0x001000a2 args:0x00000000 0x00007b90 0xffff0000 0x00007b94
    kern/init/init.c:48: grade_backtrace2+32
ebp:0x00007b88 eip:0x001000d1 args:0x00000000 0xffff0000 0x00007bb4 0x001000e5
    kern/init/init.c:53: grade_backtrace1+37
ebp:0x00007ba8 eip:0x001000f8 args:0x00000000 0x00100000 0xffff0000 0x00100109
    kern/init/init.c:58: grade_backtrace0+29
ebp:0x00007bc8 eip:0x00100124 args:0x00000000 0x00000000 0x00000000 0x0010379c
    kern/init/init.c:63: grade_backtrace+37
ebp:0x00007be8 eip:0x00100066 args:0x00000000 0x00000000 0x00000000 0x00007c4f
    kern/init/init.c:28: kern_init+101
ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d6d --
```

### 解释最后一行各个参数的含义

最后一行是` ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8`，共有ebp，eip和args三类参数，下面分别给出解释。

1. `ebp:0x0007bf8` 此时ebp的值是kern_init函数的栈顶地址，从obj/bootblock.asm文件中知道整个栈的栈顶地址为0x00007c00，ebp指向的栈位置存放调用者的ebp寄存器的值，ebp+4指向的栈位置存放返回地址的值，这意味着kern_init函数的调用者（也就是bootmain函数）没有传递任何输入参数给它！因为单是存放旧的ebp、返回地址已经占用8字节了。

2. `eip:0x00007d6e` eip的值是kern_init函数的返回地址，也就是bootmain函数调用kern_init对应的指令的下一条指令的地址。这与obj/bootblock.asm是相符合的。
```
    7d6c:	ff d0                	call   *%eax
    7d6e:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
```

3. `args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8` 一般来说，args存放的4个dword是对应4个输入参数的值。但这里比较特殊，由于bootmain函数调用kern_init并没传递任何输入参数，并且栈顶的位置恰好在boot loader第一条指令存放的地址的上面，而args恰好是kern_int的ebp寄存器指向的栈顶往上第2~5个单元，因此args存放的就是boot loader指令的前16个字节！可以对比obj/bootblock.asm文件来验证（验证时要注意系统是小端字节序）。
```
00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	fc                   	cld    
    7c02:	31 c0                	xor    %eax,%eax
    7c04:	8e d8                	mov    %eax,%ds
    7c06:	8e c0                	mov    %eax,%es
    7c08:	8e d0                	mov    %eax,%ss
    7c0a:	e4 64                	in     $0x64,%al
    7c0c:	a8 02                	test   $0x2,%al
    7c0e:	75 fa                	jne    7c0a <seta20.1>
```
