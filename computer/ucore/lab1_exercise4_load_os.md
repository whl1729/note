# 《ucore lab1 exercise4》实验报告

## 资源

1. [ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)
2. [我的ucore实验代码](https://github.com/whl1729/ucore_os_lab)

## 题目：分析bootloader加载ELF格式的OS的过程

通过阅读bootmain.c，了解bootloader如何加载ELF文件。通过分析源代码和通过qemu来运行并调试bootloader&OS，理解：

1. bootloader如何读取硬盘扇区的？
2. bootloader是如何加载ELF格式的OS？

## 解答

### 问题1：bootloader如何读取硬盘扇区

#### 分析原理
阅读材料其实已经给出了读一个扇区的大致流程：
1. 等待磁盘准备好
2. 发出读取扇区的命令
3. 等待磁盘准备好
4. 把磁盘扇区数据读到指定内存

实际操作中，需要知道怎样与硬盘交互。阅读材料中同样给出了答案：所有的IO操作是通过CPU访问硬盘的IO地址寄存器完成。硬盘共有8个IO地址寄存器，其中第1个存储数据，第8个存储状态和命令，第3个存储要读写的扇区数，第4~7个存储要读写的起始扇区的编号（共28位）。了解这些信息，就不难编程实现啦。

#### 分析代码
bootloader读取扇区的功能是在boot/bootmain.c的readsect函数中实现的，先贴代码：
```
static void readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
```

根据代码可以得出读取硬盘扇区的步骤：

1. 等待硬盘空闲。waitdisk的函数实现只有一行：`while ((inb(0x1F7) & 0xC0) != 0x40)`，意思是不断查询读0x1F7寄存器的最高两位，直到最高位为0、次高位为1（这个状态应该意味着磁盘空闲）才返回。

2. 硬盘空闲后，发出读取扇区的命令。对应的命令字为0x20，放在0x1F7寄存器中；读取的扇区数为1，放在0x1F2寄存器中；读取的扇区起始编号共28位，分成4部分依次放在0x1F3~0x1F6寄存器中。

3. 发出命令后，再次等待硬盘空闲。

4. 硬盘再次空闲后，开始从0x1F0寄存器中读数据。注意insl的作用是"That function will read cnt dwords from the input port specified by port into the supplied output array addr."，是以dword即4字节为单位的，因此这里SECTIZE需要除以4.

### 问题2： bootloader如何加载ELF格式的OS

#### 分析原理

首先从原理上分析加载流程。

1. bootloader要加载的是bin/kernel文件，这是一个ELF文件。其开头是ELF header，ELF Header里面含有phoff字段，用于记录program header表在文件中的偏移，由该字段可以找到程序头表的起始地址。程序头表是一个结构体数组，其元素数目记录在ELF Header的phnum字段中。

2. 程序头表的每个成员分别记录一个Segment的信息，包括以下加载需要用到的信息：
    - uint offset; // 段相对文件头的偏移值，由此可知怎么从文件中找到该Segment
    - uint va; // 段的第一个字节将被放到内存中的虚拟地址，由此可知要将该Segment加载到内存中哪个位置
    - uint memsz; // 段在内存映像中占用的字节数，由此可知要加载多少内容

3. 根据ELF Header和Program Header表的信息，我们便可以将ELF文件中的所有Segment逐个加载到内存中。

#### 分析代码

bootloader加载os的功能是在bootmain函数中实现的，先贴代码：
```
void bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
}
```

1. 首先从硬盘中将bin/kernel文件的第一页内容加载到内存地址为0x10000的位置，目的是读取kernel文件的ELF Header信息。（伍注：为什么加载到0x10000这个地址？）

2. 校验ELF Header的e_magic字段，以确保这是一个ELF文件。

3. 读取ELF Header的e_phoff字段，得到Program Header表的起始地址；读取ELF Header的e_phnum字段，得到Program Header表的元素数目。

4. 遍历Program Header表中的每个元素，得到每个Segment在文件中的偏移、要加载到内存中的位置（虚拟地址）及Segment的长度等信息，并通过磁盘I/O进行加载。

5. 加载完毕，通过ELF Header的e_entry得到内核的入口地址，并跳转到该地址开始执行内核代码。

#### 调试代码

1. 输入`make debug`启动gdb，并在bootmain函数入口处即0x7d0d设置断点，输入c跳到该入口。

2. 单步执行几次，运行到call readseg处，由于该函数会反复读取硬盘，为节省时间，可在下一条语句设置断点，避免进入到readseg函数内部反复执行循环语句。（或者直接输入n即可，不用这么麻烦）

3. 执行完readseg后，可以通过`x/xw 0x10000`查询ELF Header的e_magic的值，查询结果如下，确实与0x464c457f相等，所以校验成功。注意，我们的硬件是小端字节序（这从asm文件的汇编语句和二进制代码的对比中不难发现），因此0x464c45实际上对应字符串"elf"，最低位的0x7f字符对应DEL。

```
(gdb) x/xw 0x10000
0x10000:        0x464c457f
```

4. 继续单步执行，由`0x7d2f  mov    0x1001c,%eax`可知ELF Header的e_phoff字段将加载到eax寄存器，0x1001c相对0x10000的偏移为0x1c，即相差28个字节，这与ELF Header的定义相吻合。执行完0x7d2f处的指令后，可以看到eax的值变为0x34，说明program Header表在文件中的偏移为0x34，则它在内存中的位置为0x10000 + 0x34 = 0x10034.查询0x10034往后8个字节的内容如下所示：
```
(gdb) x/8xw 0x10034
0x10034:        0x00000001      0x00001000      0x00100000      0x00100000
0x10044:        0x0000dac4      0x0000dac4      0x00000005      0x00001000
```

可以结合代码中定义的Program Header结构来理解这8个字节的含义。
```
struct proghdr {
    uint32_t p_type;   // loadable code or data, dynamic linking info,etc.
    uint32_t p_offset; // file offset of segment
    uint32_t p_va;     // virtual address to map segment
    uint32_t p_pa;     // physical address, not used
    uint32_t p_filesz; // size of segment in file
    uint32_t p_memsz;  // size of segment in memory (bigger if contains bss）
    uint32_t p_flags;  // read/write/execute bits
    uint32_t p_align;  // required alignment, invariably hardware page size
};
```

还可以使用`readelf -l bin/kernel`来查询kernel文件各个Segment的基本信息，以作对比。查询结果如下所示，可见与gdb调试结果是一致的。
```
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00100000 0x00100000 0x0dac4 0x0dac4 R E 0x1000
  LOAD           0x00f000 0x0010e000 0x0010e000 0x00aac 0x01dc0 RW  0x1000
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10
```

5. 继续单步执行，由`0x7d34  movzwl 0x1002c,%esi`可知ELF Header的e_phnum字段将加载到esi寄存器，执行完x07d34处的指令后，可以看到esi的值变为3，这说明一共有3个segment。注意：由于GNU_STACK的MemSiz等于0，所以这个segment不会被加载，在代码中的体现就是readseg函数中的for循环没执行就返回了。这是正常的，因为GNU_STACK本来就是不可加载的，仅用于提供stack的控制信息（比如几字节对齐）。

6. 后面是通过磁盘I/O完成三个Segment的加载，不再赘述。
