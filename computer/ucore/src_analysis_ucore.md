# ucore 源码剖析

## lab1 源码剖析

### 从实模式到保护模式

1. 初始化ds，es和ss等段寄存器为0

2. 使能A20门，其中seta20.1写数据到0x64端口，表示要写数据给8042芯片的Output Port;seta20.2写数据到0x60端口，把Output Port的第2位置为1，从而使能A20门。

3. 建立gdt，此处只设置了两个段描述符，分别对应代码段和数据段
```
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel
```

4. 使用`lgdt gdtdesc`将gdt的地址加载到GDTR寄存器中

5. 设置cr0寄存器的最低位为1，从而使能保护模式
```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```

6. 执行`ljmp $PROT_MODE_CSEG, $protcseg`从而进入保护模式，其中PROT_MODE_CSEG为8，即代码段的段选择子，执行ljmp时会将cs寄存器设置为PROT_MODE_CSEG=8.

7. protcseg的开头先将除CS外的段寄存器设置为数据段的段选择子，然后调用bootmain来执行bootmain。
```
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment
```

### bootloader加载内核

详见[bootloader如何加载ELF格式的OS](lab1_exercise4_load_os.md)

1. ucore内核文件共有几个段？
    - 共有2个段，如下所示：
```
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0xc0100000 0xc0100000 0x15650 0x15650 R E 0x1000
  LOAD           0x017000 0xc0116000 0xc0116000 0x05000 0x05f28 RW  0x1000
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10
```

2. bootloader将内核加载到内存中哪个位置？
    - 根据代码语句`readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);`以及内核文件的program headers信息，可知bootloader分别将代码段和数据段加载到物理地址为0x100000和0x116000的位置。

### 中断初始化和处理

1. 调用pic_init函数，初始化8259A可编程中断控制器芯片，包括主片和从片，需要严格按照一定的顺序写入ICW1～ICW4这四个初始化命令字

2. 调用idt_init函数，首先设置IDT表中256个门描述符的信息，包括每个中断向量的中断服务例程地址及DPL等，除了系统调用的DPL设置为3外，其他中断向量的DPL均设置为0.
```
    for (pos = 0; pos < 256; pos++) {
        SETGATE(idt[pos], 0, GD_KTEXT, __vectors[pos], DPL_KERNEL);
    }

    SETGATE(idt[128], 1, GD_KTEXT, __vectors[128], DPL_USER);
```

3. 然后通过`lidt(&idt_pd);`加载IDT的地址到IDTR寄存器中

### 系统调用

以read函数执行过程为例，分析系统调用流程。

1. 首先在用户态下执行：
```
safe_read(int fd, void *data, size_t len)  ->
	read(fd, data, len)  ->
        sys_read(fd, data, len)  ->
            syscall(SYS_read, fd, data, len)  ->
                "int %1;"
```

2. 然后转到内核态下执行：
```
vectors (kern/trap/vectors.S 中断向量表，存有所有中断向量的地址)  ->
    vector[k] (第k个中断的入口处理函数) ->
        __alltraps (kern/trap/trapentry.S)  ->
            trap (kern/trap/trap.c) ->
                trap_dispatch
        __trapret
```

3. 为什么\_\_alltraps在调用trap前先将ds, es, fs, gs压栈？
    - 首先，这里的ds/es/fs/gs都是段寄存器，里面装的是段选择子，其中ds存的是数据段的段地址，es存的是目的字符串的段地址，fs和gs存的是进程相关的信息。The segment selector can be specified either implicitly or explicitly. The most common method of specifying a segment selector is to load it in a segment register and then allow the processor to select the register implicitly, depending on the type of operation being performed. The processor automatically chooses a segment according to the rules given in Table 3-5.
    - FS and GS are commonly used by OS kernels to access thread-specific memory. In windows, the GS register is used to manage thread-specific memory. The linux kernel uses GS to access cpu-specific memory.
    - pusha: Push AX, CX, DX, BX, original SP, BP, SI, and DI
    - pushal: Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI
    - 伍注：alltrap接下来要调用trap函数，而trap函数可能会修改这些段寄存器的值，所以要先备份好？（事实上下面还有一句pushal，说明把大部分寄存器的值都备份了）
```
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal
```

## lab2 源码分析

### 探测可用的物理内存空间
通过BIOS中断调用`INT 15`来探测可用的物理内存空间，中断调用时需要设置eax等寄存器，返回值也保存在这些寄存器中。最终探测到的物理内存空间如下所示：
```
e820map:
  memory: 0009fc00, [00000000, 0009fbff], type = 1.
  memory: 00000400, [0009fc00, 0009ffff], type = 2.
  memory: 00010000, [000f0000, 000fffff], type = 2.
  memory: 07ee0000, [00100000, 07fdffff], type = 1.
  memory: 00020000, [07fe0000, 07ffffff], type = 2.
  memory: 00040000, [fffc0000, ffffffff], type = 2.
```

### 物理内存初始化(pmm_init)

1. 通过查看memmap结构体的内容，来确认最大可用物理内存地址maxpa。gdb调试时观察到maxpa = 0x07fe0000.

2. 创建一个pages数组，其起始位置为内核文件的.bss段的后面（亦即end对应的地址），元素数目npage为0~maxpa这段内存空间对应的页数。并且将freemem设置为空闲内存的起始位置。gdb调试观察到npage=0x7fe0，freemem=0x001bc000.

3. 将pages数组的每个元素的reserved标志位均设置为1，即将每一页初始化为预留给内核使用，后面会重新设置可用的物理页的reserved标志位为0.

4. 从freemem对应的地址开始寻找所有可用的空闲内存块。由上文可知探测到的可用物理内存共2块，范围分别为0x0~0x0009fc00和0x00100000~0x07fe0000.由于第一个内存块在freemem前面，因此实际上只找到一块空闲物理内存，范围是0x00100000~0x07fe0000。在这块空闲物理内存的第一页对应的Page结构中设置页数等属性，并添加到空闲列表free_list中。

### 采用FFMA算法的物理内存管理器

#### 分配内存 alloc_pages

1. 首先判断待申请的页数n是否大于空闲页的总数nr_free，若是则返回NULL

2. 遍历空闲列表free_list，若无法找到一个页数不小于n的空闲内存块，则返回NULL

3. 若找到的空闲块的页数刚好等于n，则直接从free_list删除当前空闲块的page_link；若空闲的页数大于n，则在free_list中当前空闲块的Page_link后面先插入一个新的page_link，其对应的内存块的页数为当前空闲块的页数减去n，然后再删除当前空闲块的page_link。
> 注：这里先插入新page_link再删除当前page_link的原因是：为了保证空闲列表中的内存块按照地址从小到大排序，需要将当前空闲块分配n页剩余的空闲块仍插回到原位置，如果先删除当前空闲块，将无法直接得到插入位置，因此先插入再删除。

4. 找到空闲块后，还要将其Property属性清零，并更新空闲页的数目nr_free（减少n页）

#### 释放内存 free_pages

1. 遍历待释放内存块的每一页，将其flags和property清零

2. 遍历空闲列表，若找到与待释放内存块相邻的内存块，则将它们合并。注意一共有4种情况：仅左边有相邻空闲块、仅右边有相邻空闲块、左右均有相邻空闲块、左右均无相邻空闲块。

3. 释放内存块后，还需要更新空闲页的数目nr_free（增加n页）

### 页目录表和页表的建立

1. 创建一个页目录表boot_pgdir。一个页目录表刚好占用一个物理页，其中每个页目录项占用4字节，共有1K个页目录项。在kern/init/entry.S文件中只设置了两个有效页目录项，分别将0 ~ 0x00400000， 0xc0000000 ~ 0xc0400000映射到0 ~ 0x00400000.

2. 创建一个页表boot_pt1。在kern/init/entry.S文件中创建了一个页表boot_pt1，并且初始化其中每一个页表项：将其物理地址设置为0~4M物理内存中对应的物理页的地址，并且标记对应物理页的属性为已存在（PTE_P）并且可写（PTE_W）。

3. pmm_init中调用boot_map_segment函数，为0xc0000000~0xf8000000这段虚拟地址的每个虚拟页创建对应的页目录项和页表项，从而将0～0x38000000这段物理内存映射到0xc0000000～0xf8000000.由于entry.S只创建了一个页表，当一个虚拟页的起始地址找不到对应的页表时，需要分配一个物理页来建立对应的页表。这个是在get_pte函数中实现的。

### 页表项的创建与删除

1. get_pte函数根据虚拟地址返回对应的页表项。首先根据虚拟地址的最高10位索引页目录表，确认对应的页表是否存在。若存在，则根据虚拟地址的中间10位，返回该页表中对应页表项的地址；若不存在，则先分配一个物理页作为页表，再返回该页表项的地址。

2. page_remove_pte根据虚拟地址删除对应的页表项。如果对应的页表项指向的物理页的引用计数减至0，则释放对应物理页。然后将对应页表项清零以表示无效。

## 附录

1. I/O端口
    - 定义：CPU与外设之间通过接口部件相连，每个接口部件中都包含一组寄存器，用于CPU与外设之间的数据传输，这些寄存器叫做I/O端口。
    - 分类：根据存放内容，可将端口分为数据端口、状态端口和控制端口三类。
    - 统一内存空间 vs 独立内存空间：前者是内存和I/O接口统一编址，后者是内存和I/O接口分别编址
    - CPU写接口部件的数据端口或状态端口：首先把地址送到地址总线，将确定的控制信息送到控制总线，再把数据送到数据总线。
    - CPU读接口部件的数据端口或状态端口：首先把地址送到地址总线，将确定的控制信息送到控制总线，然后等待接口部件将数据送到数据总线。
    - 一个双向工作的接口芯片通常有4个端口：数据输入端口、数据输出端口、状态端口和控制端口。由于数据输入端口和状态端口是“只读”的，数据输出端口和控制端口是“只写”的，为节省内存空间，通常将数据输入端口和数据输出端口对应同一个端口地址，状态端口和控制端口对应同一个端口地址。

## 疑问

1. 为什么`sudo make gdb`进入调试界面后，使用print语句打印变量的值是错误的？

## 参考资料

1. [io端口与io内存详解](https://blog.csdn.net/wangkaiming123456/article/details/79422927)

2. 《微型计算机技术及应用（戴梅萼）》

