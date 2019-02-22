# ucore 源码剖析

## ucore 总体处理流程

### 一、BIOS启动

### 二、Bootloader启动

### 三、内核启动

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

### 中断初始化

1. 调用pic_init函数，初始化8259A可编程中断控制器芯片，包括主片和从片，需要严格按照一定的顺序写入ICW1～ICW4这四个初始化命令字

2. 调用idt_init函数，首先设置IDT表中256个门描述符的信息，包括每个中断向量的中断服务例程地址及DPL等，除了系统调用的DPL设置为3外，其他中断向量的DPL均设置为0.
```
    for (pos = 0; pos < 256; pos++) {
        SETGATE(idt[pos], 0, GD_KTEXT, __vectors[pos], DPL_KERNEL);
    }

    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
```

3. 然后通过`lidt(&idt_pd);`加载IDT的地址到IDTR寄存器中

### 中断处理流程

1. 无论是外部中断、异常还是系统调用，都统一采用了中断机制进行处理。简言之，就是CPU检查到有中断发生后，根据中断号索引中断向量表，得到中断处理例程的地址，跳到中断处理例程中进行处理。

2. 中断处理例程统一定义在vectors.S文件中，而且所有中断处理例程除了开头压入的中断号不一样，其他的处理流程完全一致：都是先压入中断号，然后跳到\_\_alltraps函数；\_\_alltraps函数创建一个trap frame后，再跳到trap函数，trap函数则直接调用trap_dispatch函数。trap_dispatch函数，顾名思义，就是根据中断号，分发到不同的函数进行处理。
```
vectors (kern/trap/vectors.S 中断向量表，存有所有中断向量的地址)  ->
    vector[k] (第k个中断的入口处理函数) ->
        __alltraps (kern/trap/trapentry.S)  ->
            trap (kern/trap/trap.c) ->
                trap_dispatch
        __trapret
```

3. trap frame的构造是由硬件和软件共同完成的。
    - 当硬件检测到中断时，就会把一些现场信息压入栈中。这里要分两种情况讨论。如果是在内核态发生中断，则不需要切换特权级和栈，这时直接将eflags/cs/eip压入内核栈即可；如果是在用户态发生中断，则需要将特权级由3切换到0，用户栈切换到内核栈，这时需要将ss/esp/eflags/cs/eip压入内核栈。注意：硬件根据TSS段的内容找到内核栈的地址。
    - 硬件将一些现场信息压入栈后，根据中断号找到对应的中断处理例程入口（定义在vectors.S文件中），入口处将err code（设置为0）和trap no压入栈中，然后跳到\_\_alltraps
    - \_\_alltraps将段寄存器和通用寄存器压栈，从而构造出一个完整的trap frame.
    - 整个构造过程，和trap frame的定义是完全吻合的：
```
struct trapframe {
    struct pushregs tf_regs;
    uint16_t tf_gs;
    uint16_t tf_padding0;
    uint16_t tf_fs;
    uint16_t tf_padding1;
    uint16_t tf_es;
    uint16_t tf_padding2;
    uint16_t tf_ds;
    uint16_t tf_padding3;
    uint32_t tf_trapno;
    /* below here defined by x86 hardware */
    uint32_t tf_err;
    uintptr_t tf_eip;
    uint16_t tf_cs;
    uint16_t tf_padding4;
    uint32_t tf_eflags;
    /* below here only when crossing rings, such as from user to kernel */
    uintptr_t tf_esp;
    uint16_t tf_ss;
    uint16_t tf_padding5;
} __attribute__((packed));
```

4. 中断处理完成后，进入\_\_trapret。此函数先把栈中保存的trap frame恢复到各寄存器中，然后跳过trap no和error code，执行iret，返回到中断发生时的下一条指令继续执行。

### 系统调用

1. 系统调用初始化：在idt_init函数实现中，可以看到在执行加载中断描述符表lidt指令前，专门设置了一个特殊的中断描述符idt[T_SYSCALL]，它的特权级设置为DPL_USER，中断向量处理地址在\_\_vectors[T_SYSCALL]处。这样建立好这个中断描述符后，一旦用户进程执行“INTT_SYSCALL”后，由于此中断允许用户态进程产生（注意它的特权级设置为DPL_USER） ，所以CPU就会从用户态切换到内核态，保存相关寄存器，并跳转到\_\_vectors[T_SYSCALL]处开始执行。

2. 系统调用接口封装：在操作系统中初始化好系统调用相关的中断描述符、中断处理起始地址等后，还需在用户态的应用程序中初始化好相关工作，简化应用程序访问系统调用的复杂性。为此在用户态建立了一个中间层，即简化的libc实现，在user/libs/ulib.[ch]和user/libs/syscall.[ch]中完成了对访问系统调用的封装。用户态最终的访问系统调用函数是syscall。

3. 下面以read函数执行过程为例，分析系统调用的处理流程。首先在用户态下执行：
```
safe_read(int fd, void *data, size_t len)  ->
	read(fd, data, len)  ->
        sys_read(fd, data, len)  ->
            syscall(SYS_read, fd, data, len)  ->
                "int %1;"
                : "=a" (ret)
                : "i" (T_SYSCALL),
                  "a" (num),
                  "d" (a[0]),
                  "c" (a[1]),
                  "b" (a[2]),
                  "D" (a[3]),
                  "S" (a[4])
                : "cc", "memory");
```

4. 执行int指令后，硬件检测到中断，保存ss/esp/eflags/cs/eip后，进入软件处理流程（详见上节）：vectors.S -> \_\_alltraps -> trap -> trap_dispatch，最终进入trap_dispatch函数。

5. 在trap_dispatch函数中，检查到trapno为系统调用对应的中断号0x80，因此调用syscall函数（注意用户态和内核态下各自定义了同名的syscall函数，但两者实现不同）。syscall函数主要设置好输入参数，然后根据系统调用号（保存在tf的reg_eax字段中），索引函数数组syscalls，找到对应的函数来运行。
```
    int num = tf->tf_regs.reg_eax;
    if (num >= 0 && num < NUM_SYSCALLS) {
        if (syscalls[num] != NULL) {
            arg[0] = tf->tf_regs.reg_edx;
            arg[1] = tf->tf_regs.reg_ecx;
            arg[2] = tf->tf_regs.reg_ebx;
            arg[3] = tf->tf_regs.reg_edi;
            arg[4] = tf->tf_regs.reg_esi;
            tf->tf_regs.reg_eax = syscalls[num](arg);
            return ;
        }
    }
```

### 时钟中断

1. 时钟中断初始化：初始化可编程定时器/计数器8253芯片，使其每10ms产生一次时钟中断。
```
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);
```

2. 时钟中断响应：在trap_dispatch函数中，当检查到trap no等于时钟中断对应的中断号32时，说明发生了时钟中断，此时将全局变量ticks计数加1，并判断其是否能被100整除，若能则说明满1秒了，打印提示信息，并将ticks清零。

### 键盘中断

1. 在80386系统中，通常采用Intel 8042（或8742）单片机作为主机的键盘接口安置在主机上。8042内部含有1个8位的CPU、2个8位的并行端口、2KB ROM、128B RAM、1个输入缓冲寄存器、1个输出缓冲寄存器、1个状态缓冲寄存器、1个命令缓冲寄存器。其中，输出并行端口有一位是输出缓冲器满IRQ，用来向主机发中断请求。

2. 键盘中断初始化，主要是使能键盘中断对应的掩码。

3. 键盘中断响应：在trap_dispatch函数中，当检查到trap no等于键盘中断对应的中断号33时，说明发生了键盘中断，此时读取键盘输入的字符并打印。

### lab 1 知识点

1. I/O端口： 参考[io端口与io内存详解](https://blog.csdn.net/wangkaiming123456/article/details/79422927)
    - 定义：CPU与外设之间通过接口部件相连，每个接口部件中都包含一组寄存器，用于CPU与外设之间的数据传输，这些寄存器叫做I/O端口。
    - 分类：根据存放内容，可将端口分为数据端口、状态端口和控制端口三类。
    - 统一内存空间 vs 独立内存空间：前者是内存和I/O接口统一编址，后者是内存和I/O接口分别编址
    - CPU写接口部件的数据端口或状态端口：首先把地址送到地址总线，将确定的控制信息送到控制总线，再把数据送到数据总线。
    - CPU读接口部件的数据端口或状态端口：首先把地址送到地址总线，将确定的控制信息送到控制总线，然后等待接口部件将数据送到数据总线。
    - 一个双向工作的接口芯片通常有4个端口：数据输入端口、数据输出端口、状态端口和控制端口。由于数据输入端口和状态端口是“只读”的，数据输出端口和控制端口是“只写”的，为节省内存空间，通常将数据输入端口和数据输出端口对应同一个端口地址，状态端口和控制端口对应同一个端口地址。

2. 段寄存器：
    - The segment selector can be specified either implicitly or explicitly. The most common method of specifying a segment selector is to load it in a segment register and then allow the processor to select the register implicitly, depending on the type of operation being performed. The processor automatically chooses a segment according to the rules given in Table 3-5.
    - FS and GS are commonly used by OS kernels to access thread-specific memory. In windows, the GS register is used to manage thread-specific memory. The linux kernel uses GS to access cpu-specific memory.

3. push many register:
    - pusha: Push AX, CX, DX, BX, original SP, BP, SI, and DI
    - pushal: Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI

## lab2 源码分析

### 探测可用的物理内存空间（boot/bootasm.S的probe_memory函数）

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

### 页目录表和页表的建立（kern/init/entry.S）

1. bootloader加载完内核OS后，进入到内核OS的入口kern_entry

2. 创建一个页目录表boot_pgdir。一个页目录表刚好占用一个物理页，其中每个页目录项占用4字节，共有1K个页目录项。在kern/init/entry.S文件中只设置了两个有效页目录项，分别将0 ~ 0x00400000， 0xc0000000 ~ 0xc0400000映射到0 ~ 0x00400000.

3. 创建一个页表boot_pt1。在kern/init/entry.S文件中创建了一个页表boot_pt1，并且初始化其中每一个页表项：将其物理地址设置为0~4M物理内存中对应的物理页的地址，并且标记对应物理页的属性为已存在（PTE_P）并且可写（PTE_W）。

4. kern_entry的开头将页目录表的地址加载到cr3寄存器，并设置cr0寄存器以使能保护模式。

5. 设置好cr0和cr3寄存器后，将页目录表的第一项清零，以取消虚拟地址0~4M到物理地址0~4M的映射。（为什么要取消这个映射？）

### 物理内存初始化(pmm_init)

1. 通过查看memmap结构体的内容，来确认最大可用物理内存地址maxpa。gdb调试时观察到maxpa = 0x07fe0000.

2. 创建一个pages数组，其起始位置为内核文件的.bss段的后面（亦即end对应的地址），元素数目npage为0~maxpa这段内存空间对应的页数。并且将freemem设置为空闲内存的起始位置。gdb调试观察到npage=0x7fe0，freemem=0x001bc000.

3. 将pages数组的每个元素的reserved标志位均设置为1，即将每一页初始化为预留给内核使用，后面会重新设置可用的物理页的reserved标志位为0.

4. 从freemem对应的地址开始寻找所有可用的空闲内存块。由上文可知探测到的可用物理内存共2块，范围分别为0x0~0x0009fc00和0x00100000~0x07fe0000.由于第一个内存块在freemem前面，因此实际上只找到一块空闲物理内存，范围是0x00100000~0x07fe0000。在这块空闲物理内存的第一页对应的Page结构中设置页数等属性，并添加到空闲列表free_list中。

### 页表项的创建与删除

1. pmm_init中调用boot_map_segment函数，为0xc0000000~0xf8000000这段虚拟地址的每个虚拟页创建对应的页目录项和页表项，从而将0～0x38000000这段物理内存映射到0xc0000000～0xf8000000.由于entry.S只创建了一个页表，当一个虚拟页的起始地址找不到对应的页表时，需要分配一个物理页来建立对应的页表。这个是在get_pte函数中实现的。

2. get_pte函数根据虚拟地址返回对应的页表项。首先根据虚拟地址的最高10位索引页目录表，确认对应的页表是否存在。若存在，则根据虚拟地址的中间10位，返回该页表中对应页表项的地址；若不存在，则先分配一个物理页作为页表，再返回该页表项的地址。

3. page_remove_pte根据虚拟地址删除对应的页表项。如果对应的页表项指向的物理页的引用计数减至0，则释放对应物理页。然后将对应页表项清零以表示无效。

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

### lab2 疑问

1. load_esp0的作用是啥？esp0是啥？gdt_init中为啥要load_esp0？
    - load_esp0的实现是`ts.ts_esp0 = esp0;`，可见是设置trap frame中的esp0字段。esp0是指内核态下（此时特权级为0）的esp寄存器的值。如果在用户态下发生中断，会将特权级由3切换到0，这时CPU需要知道特权级0下的内核栈在哪里，而trap frame提供了这个信息。因此需要提前初始化trap frame，并在gdt中设置好TSS段描述符，方便找到trap frame；为了加速寻找trap frame的过程，CPU还专门提供一个寄存器TR来保存TSS的段地址，因此在初始化时也要提前将TSS的段地址加载到TR寄存器中。

## lab3 源码分析

### alloc_pages

疑问：为什么判断到n > 1或swap_init_ok == 0时退出while循环？
```
    if (page != NULL || n > 1 || swap_init_ok == 0) break;
```

### check_vma_struct

1. mm_struct
```
// the control struct for a set of vma using the same PDT
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 // the count of these vma
    void *sm_priv;                   // the private data for swap manager
};
```

2. vma_struct
```
// the virtual continuous memory area(vma), [vm_start, vm_end), 
// addr belong to a vma means  vma.vm_start<= addr <vma.vm_end 
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT 
    uintptr_t vm_start;      // start addr of vma      
    uintptr_t vm_end;        // end addr of vma, not include the vm_end itself
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma
};
```

3. vma_struct是一个连续的虚拟内存块，mm_struct是一系列连续的内存块的集合，而且这些内存块使用的是同一个页目录表。通过往mm_struct的mmap_list链表添加或删除vma_struct的list_link来实现对vma的管理。

4. insert_vma_struct实现以下功能：在mm->mmap_list链表中找到vm_start不大于vma的vm_start的最后一个节点，把vma插到该节点后面，以保证mmap_list仍然按照地址从小到大排序。此外，在插入时还要检查vma之间地址不重叠。

### check_pgfault

1. 创建一个mm，将其页目录表地址设置为boot_pgdir的地址

2. 创建一个vma，虚拟地址范围为0~4M，然后将其插入到mm的mmap_list中

3. 访问虚拟地址为0x100~0x163的内存空间，这时由于页目录表中不存在虚拟地址为0~4M的页目录项，换言之尚未建立虚拟地址为0~4M到物理地址的映射，因此会导致缺页异常。

### 缺页异常处理流程

1. CPU访问的虚拟地址尚未与物理地址建立映射，从而导致缺页异常。比如check_pgfault中访问虚拟地址0x100.

2. 缺页异常对应的中断向量号为14，CPU根据中断向量表得到中断向量号14对应的中断处理例程。

3. 其实所有中断处理例程都是先将中断号入栈，然后跳转到alltraps函数。alltraps函数只是将通用寄存器和段寄存器等入栈，然后调用trap函数。trap函数直接调用trap_dispatch函数。

4. trap_dispatch函数根据不同中断号trapno进行不同的处理。当判断到中断号为T_PGFLT（14）时，则调用pgfault_handler函数。

5. pgfault_handler先调用print_pgfault打印缺页异常信息，包括
    - 缺页原因：no page found（找不到物理页面）、protection fault（比如特权级检查失败）
    - 是在读内存还是写内存时出现缺页异常
    - 是在内核态还是用户态下访问内存时出现缺页异常

6. pgfault_handler然后调用do_pgfault进行具体的缺页异常处理。注意cr2寄存器保存引起缺页异常的内存地址。

### check_swap

1. 备份内存环境变量，包括空闲内存块数目count、空闲页面数目total。

2. 创建mm和vma，其中vma对应的虚拟地址范围为0x1000~0x6000，共5个虚拟页面。

3. 为虚拟地址0x1000建立页表，其间需要申请一个物理页。
    ```
    setup Page Table for vaddr 0X1000, so alloc a page
    setup Page Table vaddr 0~4MB OVER!
    ```

4. 申请分配4个物理页，然后又将其释放。

5. check_content_set：分别访问a,b,c,d等4个虚拟页，每个虚拟页访问两个地址。访问每个虚拟页的第一个地址时，由于该虚拟页尚未与物理页建立映射，导致缺页异常。在缺页异常处理函数中，申请分配物理页，填写页表，建立虚拟页到物理页的映射后，重新访问一次虚拟页就能成功了。
    ```
    set up init env for check_swap begin!
    page fault at 0x00001000: K/W [no page found].
    page fault at 0x00002000: K/W [no page found].
    page fault at 0x00003000: K/W [no page found].
    page fault at 0x00004000: K/W [no page found].
    set up init env for check_swap over!
    ```

6. 检查页表项是否正确建立

7. fifo_check_swap：检查页面置换是否成功。依次访问页面c,a,d,b，e等5个虚拟页，当访问到虚拟页e时，同样由于该虚拟页尚未与物理页建立映射，导致缺页异常。在缺页异常处理函数，申请分配物理页。但由于物理页只有4个，且已经分别与虚拟页a,b,c,d建立映射，无法为虚拟页e申请物理页，这时需要将一个物理页换出到磁盘中。
    ```
    write Virt Page c in fifo_check_swap
    write Virt Page a in fifo_check_swap
    write Virt Page d in fifo_check_swap
    write Virt Page b in fifo_check_swap
    write Virt Page e in fifo_check_swap
    page fault at 0x00005000: K/W [no page found].
    ```

8. swap_out：首先选出要置换的页面，将其内容写回到磁盘（疑问：无论页面是否修改都进行写回，这样是否必要？）。根据FIFO算法，将最早进入物理内存的虚拟页a写到swap区域2.
    ```
    swap_out: i 0, store page in vaddr 0x1000 to disk swap entry 2
    ```

9. swap_in：当再次访问虚拟页a时，发现物理页已用完且找不到a对应的物理页。因此首先根据FIFO算法，将当前最早进入物理内存的虚拟页b写到swap区域3（疑问：怎么确保swap区域3尚未被占用？），再从swap区域2将虚拟页a读入到物理内存。

### 页面置换流程

1. alloc_pages函数中当申请物理页失败，而且申请页数为1（不明白为什么设置这个条件？）、swap区域初始化完成时，需要调用swap_out将部分物理页换出到磁盘。

## lab4 源码分析

### 第一个内核线程idleproc的创建过程

1. idleproc线程其实直接沿用正在运行的内核程序。当然，要让当前的内核程序名正言顺地成为一个线程，需要做些注册之类的事情：分配一个线程控制块，并设置好其中的信息，包括标识信息、控制信息等。比如，
    - 将pid设置为0，表明这是第一个线程
    - name设置为“idle”
    - state设置为RUNNABLE，因为当前正在运行的进程就是idleproc
    - kstack设置为bootstack
    - need_resched设置为1，表示需要调度，因为idleproc的任务就是不断检查是否有可以运行的进程，一旦发现有的话立即让CPU运行该进程。

2. 为什么idleproc不需要设置进程现场保存信息（context和tf）？

3. 为什么idleproc不需要添加到进程链表proc_list和哈希链表hash_list中？

### 第二个内核线程init_main的创建过程

1. 第二个内核线程initproc是由idleproc线程在proc_init函数中调用kernel_thread函数来创建的，调用kernel_thread函数时，传入的前两个参数分别为init_main线程的处理函数地址init_main及其输入参数"Hello world!!"

2. 同理，initproc的创建过程首先也是调用alloc_proc申请分配一个线程控制块，然后可以设置各种信息：
    - state设置为UNINIT，因为initproc此时正在初始化过程中
    - cr3设置为内核页目录表boot_pgdir，mm暂时不用设置，因为所有内核线程共用相同的虚拟地址空间，因此直接使用已经建立好的内核虚拟内存空间即可
    - need_resched设置为0，表示不需要调度，为什么？（猜想：need_resched设置为1实际上意味着主动让出CPU，一般内核线程不会主动让出CPU，而是等到阻塞、分配的时间片用完或执行完毕后才让出CPU）
    - parent设置为idleproc，表明initproc是由idleproc fork出来的
    - 申请分配2个物理页作为内核栈空间，并将其地址赋给kstack
    - 设置context和trap frame变量（有点复杂，下面再展开论述）
    - 调用get_pid来分配一个pid，其值为1
    - name设置为“init”

3. 设置context和tf：这两个变量用于线程状态保存与恢复。注意：由于initproc仍然在内核态运行，因此tf的cs设置为内核代码段的段选择子，tf的ds/es/ss均设置为内核数据段的段选择子。
```
    // kernel_thread:
    tf.tf_cs = KERNEL_CS;
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
    tf.tf_regs.reg_ebx = (uint32_t)fn;
    tf.tf_regs.reg_edx = (uint32_t)arg;
    tf.tf_eip = (uint32_t)kernel_thread_entry;

    // copy_thread:
    proc->tf->tf_regs.reg_eax = 0;
    proc->tf->tf_esp = esp;
    proc->tf->tf_eflags |= FL_IF;

    proc->context.eip = (uintptr_t)forkret;
    proc->context.esp = (uintptr_t)(proc->tf);
```

4. 加入proc_list和hash_list：后面调度器是通过遍历proc_list来挑选下一个要运行的线程的，因此需要将initproc先插入到proc_list和hash_list中。注：hash_list用于find_proc函数中根据pid快速找到对应的进程控制块，因此这里也要将initproc加入hash_list。

5. 完成初始化后，将proc->state设置为RUNNABLE，从而唤醒该进程。

### 第一次线程切换 idleproc -> initproc

1. 当内核线程idleproc从kern_init的开头运行到最后一个函数cpu_idle时，发生第一次线程切换，由idleproc切换到initproc

2. 首先看cpu_idle的实现，其实就是在死循环里不断查询当前线程是否需要调度，如果需要，则进入schedule函数进行调度，即选择其他线程来运行。
```
    while (1) {
        if (current->need_resched) {
            schedule();
        }
    }
```

3. 为什么schedule函数开头要设置`current->need_resched = 0;`？答：避免循环调用schedule函数。

4. schedule按照FIFO的顺序来选择下一个将要运行的线程。具体而言，如果当前正在运行的线程是idleproc，则从线程链表的开头开始搜索；否则从当前线程的下一个元素开始搜索，一旦找到一个state为RUNNABLE，立即退出搜索，并运行之。如果找不到，则继续运行idleproc。

5. 来看看找不到RUNNABLE的线程时会发生什么：
    - 假设ucore内核中只有一个线程idleproc，idleproc一路运行到cpu_idle。
    - 由于idleproc的need_resched标志设置为1，因此进入schedule函数。
    - schedule函数开头将idleproc的need_resched标志设置为0，然后搜索proc_list，没搜到目标，因此退出schedule。
    - 返回到cpu_idle后，由于cpu_idle是个死循环，而且current->need_resched已经设置为0，因此ucore会一直在cpu_idle函数中执行死循环。
    - 刚测试了一下，把wakeup initproc的语句注释后再执行，确实是死循环，不过每隔100 ticks会触发一次时钟中断，并在控制台上打印“100 ticks”

6. 如果前面成功创建了initproc线程，schedule从proc_list中搜索第一个元素便能找到initproc，然后调用proc_run来运行新进程，具体分为3步：设置新进程的栈指针esp、加载新进程的页目录表地址到cr3、切换进程上下文。
```
    load_esp0(next->kstack + KSTACKSIZE);
    lcr3(next->cr3);
    switch_to(&(prev->context), &(next->context));
```

7. 切换上下文时，把eip和esp的值分别设置为initproc->context.eip和initproc->context.esp，然后跳转到context.eip指定的函数地址，也就是forkret

8. forkret把栈指针指向initproc->tf，然后通过pop指令将tf保存的内容依次赋给各寄存器，接着通过iret指令跳转到tf_eip指定的入口kernel_thread_entry

9. kernel_thread_entry先将输入变量压栈，然后通过call指令跳转到ebx指向的函数fn，也就是init_main。init_main函数主要是打印一些字符串信息。执行完init_main后，回到kernel_thread_entry函数，先将返回值压栈，然后调用do_exit函数。
```
kernel_thread_entry:        # void kernel_thread(void)
    pushl %edx              # push arg
    call *%ebx              # call fn

    pushl %eax              # save the return value of fn(arg)
    call do_exit            # call do_exit to terminate current thread
```

10. do_exit函数调用panic函数，panic函数打印调用栈信息，然后循环调用kmonitor函数，进入内核调试界面，不断等待用户输入命令并执行。
```
    cprintf("kernel panic at %s:%d:\n    ", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");
    
    cprintf("stack trackback:\n");
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
    while (1) {
        kmonitor(NULL);
    }
```

11. 因此，从idleproc线程切换到initproc线程后，最终会一直停留在到内核调试界面，不会再进行线程切换。

## lab5 源码分析

### 第二次进程切换 initproc -> userproc
1. 内核线程initproc在创建完成用户态进程userproc后，调用do_wait函数，do_wait函数在确认存在RUNNABLE的子进程后，调用schedule函数。

2. schedule函数通过调用proc_run来运行新线程，proc_run做了三件事情：
    - 设置userproc的栈指针esp为userproc->kstack + 2 * 4096，即指向userproc申请到的2页栈空间的栈顶
    - 加载userproc的页目录表。用户态的页目录表跟内核态的页目录表不同，因此要重新加载页目录表
    - 切换进程上下文，然后跳转到userproc->context.eip指向的函数，即forkret

3. forkret函数直接调用forkrets函数，forkrets先把栈指针指向userproc->tf的地址，然后跳到\_\_trapret

4. \_\_trapret先将userproc->tf的内容pop给相应寄存器，然后通过iret指令，跳转到userproc->tf.tf_eip指向的函数，即kernel_thread_entry

5. kernel_thread_entry先将edx保存的输入参数（NULL）压栈，然后通过call指令，跳转到ebx指向的函数，即user_main

6. user_main先打印userproc的pid和name信息，然后调用kernel_execve

7. kernel_execve执行exec系统调用，CPU检测到系统调用后，会保存eflags/ss/eip等现场信息，然后根据中断号查找中断向量表，进入中断处理例程。这里要经过一系列的函数跳转，才真正进入到exec的系统处理函数do_execve中：vector128 -> \_\_alltraps -> trap -> trap_dispatch -> syscall -> sys_exec -> do_execve

8. do_execve首先检查用户态虚拟内存空间是否合法，如果合法且目前只有当前进程占用，则释放虚拟内存空间，包括取消虚拟内存到物理内存的映射，释放vma，mm及页目录表占用的物理页等。

9. 调用load_icode函数来加载应用程序
    - 为用户进程创建新的mm结构
    - 创建页目录表
    - 校验ELF文件的魔鬼数字是否正确
    - 创建虚拟内存空间，即往mm结构体添加vma结构
    - 分配内存，并拷贝ELF文件的各个program section到新申请的内存上
    - 为BSS section分配内存，并初始化为全0
    - 分配用户栈内存空间
    - 设置当前用户进程的mm结构、页目录表的地址及加载页目录表地址到cr3寄存器
    - 设置当前用户进程的tf结构

10. load_icode返回到do_exevce，do_execve设置完当前用户进程的名字为“exit”后也返回了。这样一直原路返回到\_\_alltraps函数时，接下来进入\_\_trapret函数

11. \_\_trapret函数先将栈上保存的tf的内容pop给相应的寄存器，然后跳转到userproc->tf.tf_eip指向的函数，也就是应用程序的入口（exit.c文件中的main函数）。注意，此处的设计十分巧妙：\_\_alltraps函数先将各寄存器的值保存到userproc->tf中，接着将userproc->tf的地址压入栈后，然后调用trap函数；trap返回后再将current->tf的地址出栈，最后恢复current->tf的内容到各寄存器。这样看来中断处理前后各寄存器的值应该保存不变。但事实上，load_icode函数清空了原来的current->tf的内容，并重新设置为应用进程的相关状态。这样，当\_\_trapret执行iret指令时，实际上跳转到应用程序的入口去了，而且特权级也由内核态跳转到用户态。接下来就开始执行用户程序（exit.c文件的main函数）啦。

12. 执行完用户程序后，继续原路返回到kernel_thread_entry函数。接下来将保存在eax的返回值压栈，然后调用do_exit。

### 第三次进程切换 userproc -> initproc

1. 上文说到userproc调用do_exit函数，接着往下分析。do_exit函数首先释放userproc占用的内存空间，包括取消虚拟地址到物理地址的映射，释放mm、vma、pgdir等占用的内存。然后唤醒内核线程initproc，接着调用schedule函数，这时由于userproc的state已经设置为ZOMBIE，因此只能选择initproc来运行。

2. 切换进程上下文后，会回到initproc之前执行的do_wait函数。do_wait函数返回到repeat标签，重新找到子进程userproc，检查到其状态为ZOMBIE后，将其从hash_list和proc_list中删除，并释放userproc对应的内核栈空间和进程控制块空间，此时用户进程userproc彻底over了。最后do_wait返回0.

3. 由于do_wait返回0，init_main再次执行schedule，由于proc_list中只有initproc，因此还是继续调用do_wait，这次由于找不到子进程，最终返回-E_BAD_PROC，从而退出init_main中的while循环。

4. init_main打印一些字符串信息，然后返回。

5. 执行完init_main函数后，会返回到kernel_thread_entry，先将保存在eax的返回值压栈，然后调用do_exit。

6. do_exit判断到当前进程为initproc后，调用panic函数打印一些字符串，然后停留在内核调试界面，等待用户输入命令。

### 创建新进程时的内存拷贝过程（copy_mm）

1. 调用mm_create分配一个mm结构体并初始化

2. 调用setup_pgdir分配一个物理页，作为页目录表的内存空间，并拷贝内核页目录表的内容到新页目录表，从而建立内核虚拟地址空间。

3. 调用dup_mmap，首先复制父进程的vma链表到子进程的mm->mmap_list中，然后调用copy_range将父进程使用到的虚拟内存空间的全部内容拷贝到子进程。

### lab5 疑问
1. 为什么用户进程需要加载ELF文件来执行，内核线程则不需要？

2. user_main执行的binary文件是什么？
    - 执行`sudo make qemu`时，不会定义TEST，因此走的是else分支，KERNEL_EXECVE宏中又包含\_\_KERNEL_EXECVE宏，exit在这个宏中被修饰为\_binary_obj___user_exit_out_start，也就是说用户进程将要执行的程序的地址保存在\_binary_obj___user_exit_out_start中。可是，我找遍整个目录下的所有文件，都找不到这个变量被定义的地方，why？
    - 经过分析Makefile内容、make生成结果以及ucore_os_docs的以下说明：“且ld命令会在kernel中会把\__user_hello.out的位置和大小记录在全局变量\_binary_obj___user_hello_out_start和\_binary_obj___user_hello_out_size中”，终于明白了：首先Makefile中定义的命令会将user目录下的代码文件编译并链接到kernel中，并且ld链接器还会将这些文件的地址记录在相应的变量中，比如obj/\_\_user\_exit.out文件的地址记录在\_binary_obj___user_exit_out_start中。这个变量名为啥这么奇怪？这应该是链接器ld的名字修饰机制决定的。
```
#define KERNEL_EXECVE(x) ({                                             \
            extern unsigned char _binary_obj___user_##x##_out_start[],  \
                _binary_obj___user_##x##_out_size[];                    \
            __KERNEL_EXECVE(#x, _binary_obj___user_##x##_out_start,     \
                            _binary_obj___user_##x##_out_size);         \
        })
```

3. exit.c文件中的main函数为啥子进程反复七次调用yield？

4. proc.c文件中load_icode函数在拷贝ELF的section时为啥不一次性拷完，而是逐页拷贝？是因为本来就只设计了分配一页的接口吗？

5. kfree函数看不明白？spin_lock, slob是什么？

6. do_exit尚未看明白？cptr，optr和yptr的设置？

7. lock_mm和unlock_mm看不明白？

### lab5 知识点

1. TSS: The processor switches to a new stack to execute the called procedure. Each privilege level has its own stack. The segment selector and stack pointer for the privilege level 3 stack are stored in the SS and ESP registers, respectively, and are automatically saved when a call to a more privileged level occurs. The segment selectors and stack pointers for the privilege level 2, 1, and 0 stacks are stored in a system segment called the task state segment (TSS).
    - 为什么TSS中只有ESP和SS区分特权级，而其他寄存器不用区分？
    - 为什么特权级切换时需要切换栈？为什么要区分用户栈和内核栈？

2. 中断帧的指针，总是指向内核栈的某个位置：当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。除此之外，uCore内核允许嵌套中断。因此为了保证嵌套中断发生时tf 总是能够指向当前的trapframe，uCore 在内核栈上维护了 tf 的链，可以参考trap.c::trap函数做进一步的了解。

## lab6 源码分析

### Round Robin 调度器

1. kern_init在调用vmm_init来初始化虚拟内存后，调用sched_init来初始化调度器。sched_init的主要作用是设置选择哪种调度器，这里选择的是default_sched_class，即Round Robin调度器。选择好调度器后，接着调用调度器的init函数来初始化。
```
    sched_class = &default_sched_class;

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
```

2. 每次创建新进程时，会调用到wakeup_proc（调用链：kernel_thread -> do_fork -> wakeup_proc），wakeup_proc会调用sched_class_enqueue将新进程添加到调度队列中，供后面调度使用。

## 参考资料

1. 《微型计算机技术及应用（戴梅萼）》
