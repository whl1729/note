# ucores 抓虫记

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

### 【2019-1-3】Bug 2：lab1运行到pmm_init时失败

1. 解决Bug1后，再次执行`make qemu`仍然失败，提示以下信息：
```
ebp:0x00007bf8 eip:0x00007d6e args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d6d --
qemu-system-i386: Trying to execute code outside RAM or ROM at 0x457e0000
This usually means one of the following happened:

(1) You told QEMU to execute a kernel for the wrong machine type, and it crashed on startup (eg trying to run a raspberry pi kernel on a versatilepb QEMU machine)
(2) You didn't give QEMU a kernel or BIOS filename at all, and QEMU executed a ROM full of no-op instructions until it fell off the end
(3) Your guest kernel has a bug and crashed by jumping off into nowhere

This is almost always one of the first two, so check your command line and that you are using the right type of kernel for this machine.
If you think option (3) is likely then you can try debugging your guest with the -d debug options; in particular -d guest_errors will cause the log to include a dump of the guest register state at this point.

Execution cannot continue; stopping here.
```

2. 使用gdb单步跟踪，发现是在pmm_init函数中加载完gdt表后，执行`mov %ax, %gs`时异常结束了。我尝试将gs寄存器改为dx，则没有问题。这意味着gs等段寄存器此时不能被访问。

3. 问题比较像是某些权限没设置好，导致无法访问段寄存器。应该是前面的步骤哪里没做好。发散思路：
    - [x] 梳理一遍从BIOS启动到pmm_init之间要做哪些事情，检查各个步骤是否OK，比如保护模式是否设置成功
        - [x] bootloader打开A20门、加载gdt、使能PE（没问题）
        - kern_init在执行pmm_init之前初始化(edata, end)这段内存
        - [x] kern_init在执行pmm_init之前打印字符串及调试信息（没影响）
    - 查找段寄存器无法访问的可能原因
    - 确认加载全局描述符表需要哪些操作，是否有遗漏操作或操作有误
    - 对比lab1和lab2，看下哪些步骤有区别
        - lab1的kernel加载地址为0x100000，lab2的kernel加载地址为0xC0100000
        - [x] lab1和lab2的`movl %cr0, %eax`对应的汇编代码不一致（使用gdb调试发现没问题，应该是objdump文件将二进制代码翻译成汇编代码时出现的问题）

4. 最终发现是初始化(edata, end)这段内存导致的问题。这段内存包括.got.plt，.data.rel.local，.bss和.data.rel.ro.local四个段，我缩小为只初始化.bss段就没问题了。这个问题之前在做mit 6.828 lab时也遇到过，现在才想起来。
```
bin/kernel:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00003955  00100000  00100000  00001000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .rodata       000008a0  00103958  00103958  00004958  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .stab         00007bc1  001041f8  001041f8  000051f8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .stabstr      000020cf  0010bdb9  0010bdb9  0000cdb9  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .data         00000950  0010e000  0010e000  0000f000  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  5 .got.plt      0000000c  0010e950  0010e950  0000f950  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .data.rel.local 000000c6  0010e960  0010e960  0000f960  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  7 .data.rel.ro.local 0000006c  0010ea40  0010ea40  0000fa40  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  8 .bss          00001300  0010eac0  0010eac0  0000faac  2**5
                  ALLOC
  9 .comment      0000002a  00000000  00000000  0000faac  2**0
                  CONTENTS, READONLY
```

5. 那么为什么初始化.got.plt及data.rel.ro.local这些段会有问题？我从[RELRO(Relocation Read Only)](https://hardenedlinux.github.io/2016/11/25/RelRO.html)这个网页中找到了答案：.data.rel.ro.local这个段顾名思义就知道是只读的，现在想将其memset为0，自然会导致问题。

6. 那么为什么lab2没有问题？对比两个lab的tools/kernel.ld文件，发觉lab2的链接脚本汇总在定义edata前，先用ALIGN命令将位置设置在能被0x1000整除的位置，这样恰好将.got.plt, data.rel.ro.local这些段跳过了，因此(edata, end)这段内存恰好只包含.bss段，这时memset就没问题了！
```
    . = ALIGN(0x1000);
    .data.pgdir : {
        *(.data.pgdir)
    }

    PROVIDE(edata = .);
```

顺便贴上lab2的bin/kernel的这几个段的信息：
```
 5 .got.plt      0000000c  c0118950  c0118950  00019950  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .data.rel.local 000000c6  c0118960  c0118960  00019960  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  7 .data.rel.ro.local 00000088  c0118a40  c0118a40  00019a40  2**5
                  CONTENTS, ALLOC, LOAD, DATA
  8 .data.rel     00000004  c0118ac8  c0118ac8  00019ac8  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  9 .data.pgdir   00002000  c0119000  c0119000  0001a000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 10 .bss          00000f28  c011b000  c011b000  0001c000  2**5
                  ALLOC
```

7. 总结：定位问题的常规方法：收集信息、理解原理、推测原因（将所有可能的原因都列举出来，逐一排查）。如果不是之前做mit 6.828 lab遇到过同样的Bug，估计定位起来更艰难，因为我差别就放弃怀疑memset语句有问题了。这个问题的棘手之处也在于：memset时没立即出错，等到后面初始化GDT时才出错。总之，经验很重要，以及不能随便放过任何一个可能。

### 【2019-1-3】Bug 1：bootblock链接失败

1. 从陈渝老师的github代码库clone了一份干净的代码到本地，进入labcodes_answer/lab1_result目录，执行`make qemu`时失败了，提示以下信息：
```
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
600 >> 510!!
'obj/bootblock.out' size: 600 bytes
make: \*\*\* [bin/bootblock] Error 255
```

2. 根据提示信息，可知是链接后的obj/bootblock.out文件大于512字节，导致检查不通过。这个检查是在哪里设置的呢？在代码库里搜索，发现是在tools/sign.c中设置的：
```
    printf("'%s' size: %lld bytes\n", argv[1], (long long)st.st_size);
    if (st.st_size > 510) {
        fprintf(stderr, "%lld >> 510!!\n", (long long)st.st_size);
        return -1;
    }
```

3. 怎么解决？先确认一下是不是每个lab都有这个问题。进入labcodes_answer/lab2_result目录，执行`make qemu`成功了，说明lab2是正常的。

4. 为什么lab1和lab2的现象不一样呢？有两种可能：一是链接脚本不同，lab2增加了某些链接选项，使得链接后的文件可以变小；二是代码文件不同，lab1的代码文件比lab2大。于是首先比较两个lab的链接脚本，发现基本相同。然后比较两个lab的diamante文件，发现boot/nootmain.c有以下两处差异：
```
// lab1
unsigned int    SECTSIZE  =      512 ;
struct elfhdr * ELFHDR    =      ((struct elfhdr *)0x10000) ;     // scratch space

// lab2
#define SECTSIZE        512
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space
```

5. 可以推测lab2的写法是比lab1省内存的，因为使用宏代替了全局变量。但这点差异足够大到lab1链接不通过吗？先将lab2的写法同步到lab1，再make一把，发现果然可以了，boot/bootblock.out的size由600字节减少到488字节，少了112字节。真神奇，两个全局变量竟会导致增加了112字节！

6. 总结：定位问题的一种思路：如果有两份代码，一份有问题，另一份正常，那么可以使用对比法。
