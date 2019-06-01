# ucore lab1复习笔记

## lab1 系统软件启动过程

### 遗留问题

1. 分析bin/kernel文件中的.data.rel.local, .data.rel.ro.local, .got.plt等段的内容和作用。

### 深入探索启动扇区文件bootblock

1. 启动扇区文件生成过程
    - 汇编bootasm.S生成bootasm.o
    - 编译bootmain.c生成bootmain.o
    - 链接bootasm.o和bootmain.o生成bootblock.o
    - 使用`objcopy -S -O binary`将bootblock.o复制到bootblock.out，不复制重定位信息和符号信息。这使得bootblock.out的长度变为488字节，远远小于bootblock.o的5532字节。
    - 使用sign工具将bootblock.out用零填充至512字节，再将最后2字节设置为magic number.
```
along:~/src/ucore/labcodes/lab1$ ll obj/boot obj/bootblock.o

-rwxr-xr-x 1 root root 5532 5月  20 15:47 obj/bootblock.o
-rwxr-xr-x 1 root root 488  5月  20 15:47 obj/bootblock.out

obj/boot:
-rw-r--r-- 1 root root 1808 5月  20 15:47 bootasm.o
-rw-r--r-- 1 root root 5332 5月  20 15:47 bootmain.o
```

2. 使用`readelf -h`查看bootblock.o的ELF文件头信息。
```
along:~/src/ucore/labcodes/lab1$ readelf -h obj/bootblock.o

ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x7c00
  Start of program headers:          52 (bytes into file)
  Start of section headers:          5172 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         2
  Size of section headers:           40 (bytes)
  Number of section headers:         9
  Section header string table index: 8  // 段表字符串表所在的段在段表中的下标
```

3. 使用`hexdump -C`直接查看bootblock.o的具体内容（以十六进制的形式），目前只关注ELF文件头，因此只显示bootblock.o的前52字节。
```
00000000  7f 45 4c 46 01 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
00000010  02 00 03 00 01 00 00 00  00 7c 00 00 34 00 00 00  |.........|..4...|
00000020  34 14 00 00 00 00 00 00  34 00 20 00 02 00 28 00  |4.......4. ...(.|
00000030  09 00 08 00
```

4. 查看lab1/libs/elf.h中对于ELF文件头的定义。可以看到，ELF文件头的长度为52字节，这与上面的"Start of program headers"相等，说明ELF文件头之后紧跟着的就是program headers。
```
struct elfhdr {
    uint32_t e_magic;     // must equal ELF_MAGIC
    uint8_t e_elf[12];
    uint16_t e_type;      // 1=relocatable, 2=executable, 3=shared object, 4=core image
    uint16_t e_machine;   // 3=x86, 4=68K, etc.
    uint32_t e_version;   // file version, always 1
    uint32_t e_entry;     // entry point if executable
    uint32_t e_phoff;     // file position of program header or 0
    uint32_t e_shoff;     // file position of section header or 0
    uint32_t e_flags;     // architecture-specific flags, usually 0
    uint16_t e_ehsize;    // size of this elf header
    uint16_t e_phentsize; // size of an entry in program header
    uint16_t e_phnum;     // number of entries in program header or 0
    uint16_t e_shentsize; // size of an entry in section header
    uint16_t e_shnum;     // number of entries in section header or 0
    uint16_t e_shstrndx;  // section number that contains section name strings
};
```

5. 使用`readelf -S`查看bootblock.o的段表
    - 为什么不直接查看bootblock.out呢？因为bootblock.out不再是ELF文件，无法使用objdump命令查看。
    - .eh_frame段用于exception unwinding（异常回溯）
    - .stab段：用于调试（伍注：未理解其原理）
    - .stabstr段：用于调试
    - .comment段：注释
    - .symtab段：符号表（Symbol Table）
    - .strtab段：字符串表（String Table）
    - .shstrtab段：段表字符串表（Section Header String Table）
```
along:~/src/ucore/labcodes/lab1/obj$ readelf -S bootblock.o

Section Headers:
  [Nr] Name          Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]               NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text         PROGBITS        00007c00 000074 000180 00 WAX  0   0  4
  [ 2] .eh_frame     PROGBITS        00007d80 0001f4 000068 00   A  0   0  4
  [ 3] .stab         PROGBITS        00000000 00025c 0007a4 0c      4   0  4
  [ 4] .stabstr      STRTAB          00000000 000a00 0007bb 00      0   0  1
  [ 5] .comment      PROGBITS        00000000 0011bb 000029 01  MS  0   0  1
  [ 6] .symtab       SYMTAB          00000000 0011e4 000170 10      7  18  4
  [ 7] .strtab       STRTAB          00000000 001354 00009c 00      0   0  1
  [ 8] .shstrtab     STRTAB          00000000 0013f0 000043 00      0   0  1
```

6. 使用`objdump -G`查看bootblock.o的.stab段（这些只显示部分输出）
```
along:~/src/ucore/labcodes/lab1$ objdump obj/bootblock.o -G


/home/along/src/ucore/labcodes/lab1/obj/bootblock.o:     file format elf32-i386

Contents of .stab section:

Symnum n_type n_othr n_desc n_value  n_strx String

-1     HdrSym 0      162    000007bb 1     
0      SO     0      0      00007c00 1      /tmp/ccPFlqVN.s
1      SOL    0      0      00007c00 17     boot/bootasm.S
2      SLINE  0      16     00007c00 0      
33     SO     0      2      00007c72 32     boot/bootmain.c
34     OPT    0      0      00000000 48     gcc2_compiled.
35     LSYM   0      0      00000000 63     int:t(0,1)=r(0,1);-2147483648;2147483647;
36     LSYM   0      0      00000000 105    char:t(0,2)=r(0,2);0;127;
37     LSYM   0      0      00000000 131    long int:t(0,3)=r(0,3);-2147483648;2147483647;
38     LSYM   0      0      00000000 178    unsigned int:t(0,4)=r(0,4);0;4294967295;
39     LSYM   0      0      00000000 219    long unsigned int:t(0,5)=r(0,5);0;4294967295;
40     LSYM   0      0      00000000 265    __int128:t(0,6)=r(0,6);0;-1;
41     LSYM   0      0      00000000 294    __int128 unsigned:t(0,7)=r(0,7);0;-1;
```

7. 使用`hexdump -s -n -C`查看bootblock.o的.stabstr段（这里只显示前10行）
```
along:~/src/ucore/labcodes/lab1$ hexdump obj/bootblock.o -s 0xa00 -n 1979 -C

00000a00  00 2f 74 6d 70 2f 63 63  50 46 6c 71 56 4e 2e 73  |./tmp/ccPFlqVN.s|
00000a10  00 62 6f 6f 74 2f 62 6f  6f 74 61 73 6d 2e 53 00  |.boot/bootasm.S.|
00000a20  62 6f 6f 74 2f 62 6f 6f  74 6d 61 69 6e 2e 63 00  |boot/bootmain.c.|
00000a30  67 63 63 32 5f 63 6f 6d  70 69 6c 65 64 2e 00 69  |gcc2_compiled..i|
00000a40  6e 74 3a 74 28 30 2c 31  29 3d 72 28 30 2c 31 29  |nt:t(0,1)=r(0,1)|
00000a50  3b 2d 32 31 34 37 34 38  33 36 34 38 3b 32 31 34  |;-2147483648;214|
00000a60  37 34 38 33 36 34 37 3b  00 63 68 61 72 3a 74 28  |7483647;.char:t(|
00000a70  30 2c 32 29 3d 72 28 30  2c 32 29 3b 30 3b 31 32  |0,2)=r(0,2);0;12|
00000a80  37 3b 00 6c 6f 6e 67 20  69 6e 74 3a 74 28 30 2c  |7;.long int:t(0,|
00000a90  33 29 3d 72 28 30 2c 33  29 3b 2d 32 31 34 37 34  |3)=r(0,3);-21474|
```

8. 使用`readelf -s`或者`objdump -t`查看bootblock的.symtab段
```
along:~/src/ucore/labcodes/lab1$ readelf -s obj/bootblock.o

Symbol table '.symtab' contains 23 entries:
   Num:    Value  Size Type    Bind   Vis      Ndx Name
     0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 00007c00     0 SECTION LOCAL  DEFAULT    1 
     2: 00007d80     0 SECTION LOCAL  DEFAULT    2 
     3: 00000000     0 SECTION LOCAL  DEFAULT    3 
     4: 00000000     0 SECTION LOCAL  DEFAULT    4 
     5: 00000000     0 SECTION LOCAL  DEFAULT    5 
     6: 00000000     0 FILE    LOCAL  DEFAULT  ABS obj/boot/bootasm.o
     7: 00000008     0 NOTYPE  LOCAL  DEFAULT  ABS PROT_MODE_CSEG
     8: 00000010     0 NOTYPE  LOCAL  DEFAULT  ABS PROT_MODE_DSEG
     9: 00000001     0 NOTYPE  LOCAL  DEFAULT  ABS CR0_PE_ON
    10: 00007c0a     0 NOTYPE  LOCAL  DEFAULT    1 seta20.1
    11: 00007c14     0 NOTYPE  LOCAL  DEFAULT    1 seta20.2
    12: 00007c6c     0 NOTYPE  LOCAL  DEFAULT    1 gdtdesc
    13: 00007c32     0 NOTYPE  LOCAL  DEFAULT    1 protcseg
    14: 00007c4f     0 NOTYPE  LOCAL  DEFAULT    1 spin
    15: 00007c54     0 NOTYPE  LOCAL  DEFAULT    1 gdt
    16: 00000000     0 FILE    LOCAL  DEFAULT  ABS bootmain.c
    17: 00007c72   155 FUNC    LOCAL  DEFAULT    1 readseg
    18: 00007d0d   115 FUNC    GLOBAL DEFAULT    1 bootmain
    19: 00007de8     0 NOTYPE  GLOBAL DEFAULT    2 __bss_start
    20: 00007de8     0 NOTYPE  GLOBAL DEFAULT    2 _edata
    21: 00007de8     0 NOTYPE  GLOBAL DEFAULT    2 _end
    22: 00007c00     0 NOTYPE  GLOBAL DEFAULT    1 start
```

9. 使用`hexdump -s -n -C`查看.comment段的内容
```
along:~/src/ucore/labcodes/lab1$ hexdump obj/bootblock.o -s 0x11bb -n 41 -C

000011bb  47 43 43 3a 20 28 55 62  75 6e 74 75 20 37 2e 34  |GCC: (Ubuntu 7.4|
000011cb  2e 30 2d 31 75 62 75 6e  74 75 31 7e 31 38 2e 30  |.0-1ubuntu1~18.0|
000011db  34 29 20 37 2e 34 2e 30  00                       |4) 7.4.0.|
```

10. 使用`hexdump -s -n -C`查看.strtab段的内容
```
along:~/src/ucore/labcodes/lab1$ hexdump obj/bootblock.o -s 0x1354 -n 156 -C

00001354  00 6f 62 6a 2f 62 6f 6f  74 2f 62 6f 6f 74 61 73  |.obj/boot/bootas|
00001364  6d 2e 6f 00 50 52 4f 54  5f 4d 4f 44 45 5f 43 53  |m.o.PROT_MODE_CS|
00001374  45 47 00 50 52 4f 54 5f  4d 4f 44 45 5f 44 53 45  |EG.PROT_MODE_DSE|
00001384  47 00 43 52 30 5f 50 45  5f 4f 4e 00 73 65 74 61  |G.CR0_PE_ON.seta|
00001394  32 30 2e 31 00 73 65 74  61 32 30 2e 32 00 67 64  |20.1.seta20.2.gd|
000013a4  74 64 65 73 63 00 70 72  6f 74 63 73 65 67 00 73  |tdesc.protcseg.s|
000013b4  70 69 6e 00 67 64 74 00  62 6f 6f 74 6d 61 69 6e  |pin.gdt.bootmain|
000013c4  2e 63 00 72 65 61 64 73  65 67 00 62 6f 6f 74 6d  |.c.readseg.bootm|
000013d4  61 69 6e 00 5f 5f 62 73  73 5f 73 74 61 72 74 00  |ain.\__bss_start.|
000013e4  5f 65 64 61 74 61 00 5f  65 6e 64 00              |_edata._end.|
```

11. 使用`hexdump -s -n -C`查看.shstrtab段的内容
```
along:~/src/ucore/labcodes/lab1$ hexdump obj/bootblock.o -s 0x13f0 -n 67 -C

000013f0  00 2e 73 79 6d 74 61 62  00 2e 73 74 72 74 61 62  |..symtab..strtab|
00001400  00 2e 73 68 73 74 72 74  61 62 00 2e 74 65 78 74  |..shstrtab..text|
00001410  00 2e 65 68 5f 66 72 61  6d 65 00 2e 73 74 61 62  |..eh_frame..stab|
00001420  00 2e 73 74 61 62 73 74  72 00 2e 63 6f 6d 6d 65  |..stabstr..comme|
00001430  6e 74 00    
```

11. 使用`readelf -l`查看bootblock.o程序头的内容。可见，在装载时会把.text和.eh_frame这两个section合并为一个segment。
```
along:~/src/ucore/labcodes/lab1$ readelf obj/bootblock.o -l

Elf file type is EXEC (Executable file)
Entry point 0x7c00
There are 2 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000074 0x00007c00 0x00007c00 0x001e8 0x001e8 RWE 0x4
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10

 Section to Segment mapping:
  Segment Sections...
   00     .text .eh_frame 
   01     
```

12. 根据以上信息，可知bootblock.o这个ELF文件的结构如下所示。
```
|--------------------|
|     ELF Header     |
|--------------------|
|  program headers   |
|--------------------|
|        .text       |
|--------------------|
|     .eh_frame      |
|--------------------|
|        .stab       |
|--------------------|
|      .stabstr      |
|--------------------|
|      .comment      |
|--------------------|
|       .symtab      |
|--------------------|
|       .strtab      |
|--------------------|
|      .shstrtab     |
|--------------------|
|  section headers   |
|--------------------|
```

### 深入探索kernel文件

1. 使用`ls -al`查看kernel文件的大小为74K
```
along:~/src/ucore/labcodes/lab1$ ls -al bin/kernel

-rwxr-xr-x 1 root root 75744 5月  20 15:47 bin/kernel
```

2. 使用`size`查看kernel文件的代码段、数据段和bss段的大小。
```
along:~/src/ucore/labcodes/lab1$ ls -al bin/kernel

   text	   data	    bss	    dec	    hex	filename
  57125	   2702	   4864	  64691	   fcb3	bin/kernel
```

3. 使用`readelf -h`查看kernel的ELF文件头信息。
```
along:~/src/ucore/labcodes/lab1$ readelf -h bin/kernel

ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x100000
  Start of program headers:          52 (bytes into file)
  Start of section headers:          75184 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         3
  Size of section headers:           40 (bytes)
  Number of section headers:         14
  Section header string table index: 13
```

4. 使用`readelf -S`查看kernel文件各个段的信息。相对bootblock而言，kernel少了.eh_frame段，但多出了6个段，下面逐一分析。
```
along:~/src/ucore/labcodes/lab1$ readelf -S bin/kernel

There are 14 section headers, starting at offset 0x125b0:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00100000 001000 003965 00  AX  0   0  1
  [ 2] .rodata           PROGBITS        00103968 004968 0008a0 00   A  0   0  4
  [ 3] .stab             PROGBITS        00104208 005208 007c51 0c   A  4   0  4
  [ 4] .stabstr          STRTAB          0010be59 00ce59 0020cf 00   A  0   0  1
  [ 5] .data             PROGBITS        0010e000 00f000 000950 00  WA  0   0 32
  [ 6] .got.plt          PROGBITS        0010e950 00f950 00000c 04  WA  0   0  4
  [ 7] .data.rel.local   PROGBITS        0010e960 00f960 0000c6 00  WA  0   0 32
  [ 8] .data.rel.ro.loca PROGBITS        0010ea40 00fa40 00006c 00  WA  0   0 32
  [ 9] .bss              NOBITS          0010eac0 00faac 001300 00  WA  0   0 32
  [10] .comment          PROGBITS        00000000 00faac 000029 01  MS  0   0  1
  [11] .symtab           SYMTAB          00000000 00fad8 001ac0 10     12 102  4
  [12] .strtab           STRTAB          00000000 011598 000f9f 00      0   0  1
  [13] .shstrtab         STRTAB          00000000 012537 000078 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  p (processor specific)
```

5. 先看常见的数据段，包括.data, .rodata和.bss。.data段存放已初始化的全局变量和局部静态变量；.rodata段存放只读数据，包括程序中的只读变量（如const修饰的变量）和字符串常量（如printf使用的格式化输出字符串）；.bss段存放未初始化的全局变量和局部静态变量。

> 疑问：编译器是如何找到这些变量的？比如：你定义了一个全局变量g_foo，编译器如何根据g_foo这个符号找到它在.data段的位置？  
> 答：符号表中记录有符号的详细信息，其中value字段就是符号的地址。因此查找符号表即可找到符号的位置。
> 疑问：那么编译器使用什么算法来搜索符号表从而找到对应的符号信息呢？（待研究）

6. ***.data.rel.local和.data.rel.ro.local保存的应该是数据段的重定位表，待研究。***

7. ***.got.plt保存的是动态链接的信息，待研究。***

8. 使用`readelf -l`打印kernel文件的程序头信息
    - VirtAddr(VMA)和PhysAddr(LMA)的含义和区别是什么？答：前者是虚拟内存地址，后者是加载内存地址，一般情况下两者相等。但在有些嵌入式系统中，特别是在那些程序放在ROM的系统中，LMA和VMA是不相同的。也就是说程序加载在一个地方，运行时要复制到另一个地方。参考[VMA和LMA](https://blog.csdn.net/crtnawwan9623/article/details/8153206)和[VMA vs LMA?](https://www.embeddedrelated.com/showthread/comp.arch.embedded/77071-1.php)
    - FileSiz指segment在文件中的大小，MemSiz指segment在内存中所分配的内存大小，MemSiz减去FileSiz的值实际上是.bss段的大小。（MemSiz - FileSiz = 0x1314，而.bss的大小为0x1300，估计是由于对齐导致多了0x14字节。使用`readelf -S`查看各Section的信息时也可以看到.data和.bss的Align均为0x20字节）
    - 从输出信息可以看出，kernel文件有3个segment，前2个是可加载（loadable）的，第1个是以.text段为代表的、权限为可读可执行的section组成的segment，第2个是以.data段为代表的，权限为可读可写的section组成的segment，第3个segment是GNU_STACK，不可加载，仅用于tells the system how to control the stack when the ELF is loaded into memory.
    - 注意：kernel的segment中不含有.comment, .symtab, .strtab, .shstrtab等section，因为这些段是用作调试的辅助段，没必要把它们加载到内存中。
```
along:~/src/ucore/labcodes/lab1$ readelf bin/kernel -l

Elf file type is EXEC (Executable file)
Entry point 0x100000
There are 3 program headers, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00100000 0x00100000 0x0df28 0x0df28 R E 0x1000
  LOAD           0x00f000 0x0010e000 0x0010e000 0x00aac 0x01dc0 RW  0x1000
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10

 Section to Segment mapping:
  Segment Sections...
   00     .text .rodata .stab .stabstr 
   01     .data .got.plt .data.rel.local .data.rel.ro.local .bss 
   02     
```

### 中断处理

1. 中断的产生
    - 外部中断：键盘输入、鼠标点击、定时器等。外部中断一般由中断控制器8259A芯片来管理。8259A芯片的IR0~IR7可以接键盘后鼠标等中断源，当有键盘输入或鼠标点击时，经过8259A处理后（需要仲裁或确认是否屏蔽），向CPU发出中断请求。CPU每个指令周期都会检查是否有中断请求产生，一旦检查到有中断请求后，就要求8259A芯片发送中断向量，获取到中断向量后，根据IDT找到对应的中断处理例程进行处理。
    - 软件中断：包括系统调用、异常、调试等。内部中断最终都是通过中断指令"INT n"触发。
        - 系统调用（或陷阱）："INT 0x80"
        - 异常：CPU的某些运算错误，包括除零（INT 0）和溢出错误（INT 4）等
        - 由调试程序Debug设置的中断，比如单步中断（INT 1）和断点中断（INT 3）。单步中断可以通过软件将TF设置为1或0予以允许或禁止。
        - INT指令的处理流程又是怎样的呢？答：具体流程比较长，可以参考intel manual。简单地说，就是CPU把eflags/cs/eip压栈，

2. 中断的处理
    - 对外部中断而言，CPU通过与8259A芯片交互得到中断向量号；对内部中断而言，CPU根据"INT n"指令中的n得到中断向量号。接下来两种中断的处理流程相同。
    - 保护现场：CPU将[ss/esp/]eflags/cs/eip压栈（如果中断发生在用户态，则需要压入ss/esp，内核态则不用）
    - 跳到中断处理地点: 根据中断号从中断向量表中找到中断处理例程的地址，并跳到该地址
    - 执行中断处理例程
        - 首先将err/trap_no/段寄存器/通用寄存器的值等压栈，构造出一个trap frame.
        - 从trap frame中的通用寄存器字段获取输入参数，比如read/write系统调用需要获取文件名。
    - 离开中断处理地点并恢复现场：将通用寄存器/段寄存器/trap_no/err等出栈，然后执行iret返回现场，这时会恢复cs/eip/eflags的值。

3. 特权级
    - 什么是特权级？DPL、CPL、RPL分别是什么？
    - 特权级与用户态、内核态有什么关系吗？
    - 啥时候需要进行特权级的切换？特权级的切换就是用户态与内核态的切换吗？
    - 特权级对中断处理的影响？

4. 内核栈 vs 用户栈
    - 为什么要区分内核栈和用户栈？

5. TSS
    - 什么是TSS？

6. 描述符表
    - 全局段描述符表（GDT）是什么？
    - 中断描述符表（IDT）是什么？
