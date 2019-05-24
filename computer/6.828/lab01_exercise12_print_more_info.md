# 《MIT 6.828 Lab 1 Exercise 12》实验报告

本实验的网站链接：[MIT 6.828 Lab 1 Exercise 12](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-12)。

## 题目

> Exercise 12. Modify your stack backtrace function to display, for each eip, the function name, source file name, and line number corresponding to that eip.

> In debuginfo\_eip, where do \_\_STAB\_\* come from? This question has a long answer; to help you to discover the answer, here are some things you might want to do:  

> * look in the file kern/kernel.ld for \_\_STAB\_\*  
> * run objdump -h obj/kern/kernel
> * run objdump -G obj/kern/kernel  
> * run gcc -pipe -nostdinc -O2 -fno-builtin -I. -MD -Wall -Wno-format -DJOS_KERNEL -gstabs -c -S kern/init.c, and look at init.s.
> * see if the bootloader loads the symbol table in memory as part of loading the kernel binary

> Complete the implementation of debuginfo_eip by inserting the call to stab_binsearch to find the line number for an address.

> Add a backtrace command to the kernel monitor, and extend your implementation of mon_backtrace to call debuginfo_eip and print a line for each stack frame of the form:

> K> backtrace  
Stack backtrace:  
  ebp f010ff78  eip f01008ae  args 00000001 f010ff8c 00000000 f0110580 00000000  
         kern/monitor.c:143: monitor+106  
  ebp f010ffd8  eip f0100193  args 00000000 00001aac 00000660 00000000 00000000  
         kern/init.c:49: i386_init+59  
  ebp f010fff8  eip f010003d  args 00000000 00000000 0000ffff 10cf9a00 0000ffff  
         kern/entry.S:70: <unknown>+0  
K>  

> Each line gives the file name and line within that file of the stack frame's eip, followed by the name of the function and the offset of the eip from the first instruction of the function (e.g., monitor+106 means the return eip is 106 bytes past the beginning of monitor).

> Be sure to print the file and function names on a separate line, to avoid confusing the grading script.  
Tip: printf format strings provide an easy, albeit obscure, way to print non-null-terminated strings like those in STABS tables.	printf("%.\*s", length, string) prints at most length characters of string. Take a look at the printf man page to find out why this works.

> You may find that some functions are missing from the backtrace. For example, you will probably see a call to monitor() but not to runcmd(). This is because the compiler in-lines some function calls. Other optimizations may cause you to see unexpected line numbers. If you get rid of the -O2 from GNUMakefile, the backtraces may make more sense (but your kernel will run more slowly).

## 解答

### 问题1：debuginfo_eip函数中的\_\_STAB\_\*来自哪里？

1. \_\_STAB\_BEGIN\_\_，\_\_STAB\_END\_\_，\_\_STABSTR\_BEGIN\_\_，\_\_STABSTR\_END\_\_等符号均在kern/kern.ld文件定义，它们分别代表.stab和.stabstr这两个段开始与结束的地址。
```
/* Include debugging information in kernel memory */
.stab : {
    PROVIDE(__STAB_BEGIN__ = .);
    *(.stab);
    PROVIDE(__STAB_END__ = .);
    BYTE(0)		/* Force the linker to allocate space
               for this section */
}

.stabstr : {
    PROVIDE(__STABSTR_BEGIN__ = .);
    *(.stabstr);
    PROVIDE(__STABSTR_END__ = .);
    BYTE(0)		/* Force the linker to allocate space
               for this section */
```

2. 执行`objdump -h obj/kern/kernel`命令，结果如下所示。为节省空间，这里只显示.text, .rodata, .stab, .stabstr和.data等5个段的信息。观察可知这5个段是从加载地址起点开始依次放置的。我猜测STAB_BEGIN=0xf0102204, STAB_END=0xf0102204 + 0x3cb5 - 1 = 0xf0105eb8，STABSTR_BEGIN=0xf0105eb9, STABSTR_END=0xf0105eb9 + 0x1974 - 1 = 0xf010772c.

```
along:~/src/6.828/lab$ objdump -h obj/kern/kernel

obj/kern/kernel:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00001ab9  f0100000  00100000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       00000744  f0101ac0  00101ac0  00002ac0  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         00003cb5  f0102204  00102204  00003204  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .stabstr      00001974  f0105eb9  00105eb9  00006eb9  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .data         00009300  f0108000  00108000  00009000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
```

3. 执行`objdump -G obj/kern/kernel`命令，显示出1294个stab的信息，为节省空间这里只给出其中一小部分。
```
along:~/src/6.828/lab$ objdump -G obj/kern/kernel

obj/kern/kernel:     file format elf32-i386

Contents of .stab section:

Symnum n_type n_othr n_desc n_value  n_strx String

-1     HdrSym 0      1294   00001973 1     
0      SO     0      0      f0100000 1      {standard input}
1      SOL    0      0      f010000c 18     kern/entry.S
2      SLINE  0      44     f010000c 0      
15     OPT    0      0      00000000 49     gcc2_compiled.
16     LSYM   0      0      00000000 64     int:t(0,1)=r(0,1);-2147483648;2147483647;
17     LSYM   0      0      00000000 106    char:t(0,2)=r(0,2);0;127;
108    FUN    0      0      f0100040 2946   test_backtrace:F(0,25)
118    FUN    0      0      f01000a6 2987   i386_init:F(0,25)
```

4. 执行`gcc -pipe -nostdinc -O2 -fno-builtin -I. -MD -Wall -Wno-format -DJOS_KERNEL -gstabs -c -S kern/init.c`，然后查看init.s文件。同样，为节省空间，这里只给出其中一部分。

```
.file	"init.c"
.stabs	"kern/init.c",100,0,2,.Ltext0
.text
.Ltext0:
.stabs	"gcc2_compiled.",60,0,0,0
.stabs	"int:t(0,1)=r(0,1);-2147483648;2147483647;",128,0,0,0
.stabs	"char:t(0,2)=r(0,2);0;127;",128,0,0,0
.stabs	"long int:t(0,3)=r(0,3);-0;4294967295;",128,0,0,0
.stabs	"unsigned int:t(0,4)=r(0,4);0;4294967295;",128,0,0,0
.stabs	"long unsigned int:t(0,5)=r(0,5);0;-1;",128,0,0,0
.stabs	"long double:t(0,16)=r(0,1);16;0;",128,0,0,0
.stabs	"_Float32:t(0,17)=r(0,1);4;0;",128,0,0,0
.stabs	"ssize_t:t(4,17)=(4,8)",128,0,0,0
.stabs	"off_t:t(4,18)=(4,8)",128,0,0,0
.stabn	162,0,0,0
.stabn	162,0,0,0
.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
.string	"entering test_backtrace %d\n"
.LC1:
.string	"leaving test_backtrace %d\n"
.text
.p2align 4,,15
.stabs	"test_backtrace:F(0,25)",36,0,0,test_backtrace
.stabs	"x:P(0,1)",64,0,0,3
.globl	test_backtrace
.type	test_backtrace, @function
test_backtrace:
.stabn	68,0,13,.LM0-.LFBB1
```

5. 确认boot loader在加载内核时是否把符号表也加载到内存中。怎么确认呢？使用gdb查看符号表的位置是否存储有符号信息就知道啦。首先，根据第3步的输出结果我们知道.stabstr段的加载内存地址为0xf0105eb9，使用`x/8s 0xf0105eb9`打印前8个字符串信息，结果如下所示。可见加载内核时符号表也一起加载到内存中了。
```
(gdb) x/8s 0xf0105eb9
0xf0105eb9:	""
0xf0105eba:	"{standard input}"
0xf0105ecb:	"kern/entry.S"
0xf0105ed8:	"kern/entrypgdir.c"
0xf0105eea:	"gcc2_compiled."
0xf0105ef9:	"int:t(0,1)=r(0,1);-2147483648;2147483647;"
0xf0105f23:	"char:t(0,2)=r(0,2);0;127;"
0xf0105f3d:	"long int:t(0,3)=r(0,3);-2147483648;2147483647;"
```

### 问题2：debuginfo\_eip函数实现根据地址寻找行号的功能

解决这个问题的关键是熟悉stabs每行记录的含义，我折腾了一两小时才搞清楚。首先，使用`objdump -G obj/kern/kernel > output.md`将内核的符号表信息输出到output.md文件，在output.md文件中可以看到以下片段：
```
Symnum n_type n_othr n_desc n_value  n_strx String
118    FUN    0      0      f01000a6 2987   i386_init:F(0,25)
119    SLINE  0      24     00000000 0      
120    SLINE  0      34     00000012 0      
121    SLINE  0      36     00000017 0      
122    SLINE  0      39     0000002b 0      
123    SLINE  0      43     0000003a 0      
```
这个片段是什么意思呢？首先要理解第一行给出的每列字段的含义：
* Symnum是符号索引，换句话说，整个符号表看作一个数组，Symnum是当前符号在数组中的下标
* n_type是符号类型，FUN指函数名，SLINE指在text段中的行号
* n_othr目前没被使用，其值固定为0
* n_desc表示在文件中的行号
* n_value表示地址。特别要注意的是，这里只有FUN类型的符号的地址是绝对地址，SLINE符号的地址是偏移量，其实际地址为函数入口地址加上偏移量。比如第3行的含义是地址f01000b8(=0xf01000a6+0x00000012)对应文件第34行。

理解stabs每行记录的含义后，调用stab\_binsearch便能找到某个地址对应的行号了。由于前面的代码已经找到地址在哪个函数里面以及函数入口地址，将原地址减去函数入口地址即可得到偏移量，再根据偏移量在符号表中的指定区间查找对应的记录即可。代码如下所示：
```
    stab_binsearch(stabs, &lfun, &rfun, N_SLINE, addr - info->eip_fn_addr);

    if (lfun <= rfun)
    {
        info->eip_line = stabs[lfun].n_desc;
    }
```

### 问题3：给内核模拟器增加backtrace命令，并在mon\_backtrace中增加打印文件名、函数名和行号

1. 给内核模拟器增加backtrace命令
很简单，在kern/monitor.c文件中模仿已有命令添加即可。
```
static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display a backtrace of the function stack", mon_backtrace },
};
```

2. 在mon_backtrace中增加打印文件名、函数名和行号
经过上面的探索，这个问题就很容易解决了。在mon\_backtrace中调用debuginfo_eip来获取文件名、函数名和行号即可。注意，返回的Eipdebuginfo结构体的eip_fn_name字段除了函数名外还有一段尾巴，比如`test_backtrace:F(0,25)`，需要将":F(0,25)"去掉，可以使用`printf("%.*s", length, string)`来实现。代码如下：
```
int mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
    uint32_t *ebp;
    struct Eipdebuginfo info;
    int result;

    ebp = (uint32_t *)read_ebp();

    cprintf("Stack backtrace:\r\n");

    while (ebp)
    {
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\r\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);

        memset(&info, 0, sizeof(struct Eipdebuginfo));

        result = debuginfo_eip(ebp[1], &info);
        if (0 != result)
        {
            cprintf("failed to get debuginfo for eip %x.\r\n", ebp[1]);
        }
        else
        {
            cprintf("\t%s:%d: %.*s+%u\r\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, ebp[1] - info.eip_fn_addr);
        }

        ebp = (uint32_t *)*ebp;
    }

	return 0;
}
```

输出结果如下：
```
Stack backtrace:
  ebp f010ff18  eip f0100078  args 00000000 00000000 00000000 f010004a f0111308
        kern/init.c:16: test_backtrace+56
  ebp f010ff38  eip f01000a1  args 00000000 00000001 f010ff78 f010004a f0111308
        kern/init.c:16: test_backtrace+97
  ebp f010ff58  eip f01000a1  args 00000001 00000002 f010ff98 f010004a f0111308
	    kern/init.c:16: test_backtrace+97
  ebp f010ff78  eip f01000a1  args 00000002 00000003 f010ffb8 f010004a f0111308
	    kern/init.c:16: test_backtrace+97
  ebp f010ff98  eip f01000a1  args 00000003 00000004 00000000 f010004a f0111308
	    kern/init.c:16: test_backtrace+97
  ebp f010ffb8  eip f01000a1  args 00000004 00000005 00000000 f010004a f0111308
	    kern/init.c:16: test_backtrace+97
  ebp f010ffd8  eip f01000dd  args 00000005 00001aac f010fff8 f01000bd 00000000
	    kern/init.c:43: i386_init+55
  ebp f010fff8  eip f010003e  args 00000003 00001003 00002003 00003003 00004003
	    {standard input}:0: <unknown>+0
```

## 备注

1. printf("%.\*s", length, string) prints at most length characters of string.

2. 转义字符：'\a'（响铃，bell），'\b'（退格，backspace）。

### stabs

1. STABS (Symbol TABle Strings) is a debugging data format for storing information about computer programs for use by symbolic and source-level debuggers.

2. The assembler creates two custom sections, a section named .stab which contains an array of fixed length structures, one struct per stab, and a section named .stabstr containing all the variable length strings that are referenced by stabs in the .stab section.

3. Symbol Table Format : see the following. Notice: If the stab has a string, the n_strx field holds the offset in bytes of the string within the string table. The string is terminated by a NUL character. If the stab lacks a string (for example, it was produced by a .stabn or .stabd directive), the n_strx field is zero.
```
struct internal_nlist {
  unsigned long n_strx;         /* index into string table of name */
  unsigned char n_type;         /* type of symbol */
  unsigned char n_other;        /* misc info (usually empty) */
  unsigned short n_desc;        /* description field */
  bfd_vma n_value;              /* value of symbol */
};
```

4. There are three overall formats for stab assembler directives, differentiated by the first word of the stab. The name of the directive describes which combination of four possible data fields follows. It is either .stabs (string), .stabn (number), or .stabd (dot).The overall format of each class of stab is:
```
.stabs "string",type,other,desc,value
.stabn type,other,desc,value
.stabd type,other,desc
```

### stabstr

1. The .stabstr section always starts with a null byte (so that string offsets of zero reference a null string), followed by random length strings, each of which is null byte terminated.

## 疑问

1. 如何理解stabs表中的符号冒号后面的字符？比如`test_backtrace:F(0,25)`和`char:t(0,2)=r(0,2);0;127;`

2. `printf("%.*s", length, string)`可以打印指定长度的字符串，具体是怎样实现的？

## 参考资料

1. [The "stabs" representation of debugging information](https://sourceware.org/gdb/onlinedocs/stabs/)
