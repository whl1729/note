# 《ucore lab2》实验报告

## 资源

1. [ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)
2. [我的ucore实验代码](https://github.com/whl1729/ucore_os_lab)

## 练习1：实现 first-fit 连续物理内存分配算法

### 题目
在实现first fit 内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:
在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改default_pmm.c中的default_init，default_init_memmap，default_alloc_pages，default_free_pages等相关函数。请仔细查看和理解default_pmm.c中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：你的first fit算法是否有进一步的改进空间？

### 解答

#### 我的设计实现过程

1. 由于default_pmm.c文件中已经提供了一种内存分配算法的实现，因此我的设计是在default_pmm.c的基础上修改实现的。

2. 分配内存：default_pmm的现有算法在分配内存时和first fit基本相同，都是遍历空闲链表，找到第一个不小于待申请的物理页数目的空闲block。
    - 如果空闲block的物理页数目刚好等于待申请的数目，那么直接将该空闲block全部分配给申请者，具体而言需要将该空闲block对应的节点page_link从空闲链表中移除、更新空闲页面的总数nr_free、设置该空闲block的property以标识其已被分配。
    - 如果空闲block的物理页数目大于待申请的数目，那么将空闲block拆分成两个block，第一个block的物理页数目等于待申请的数目，第二个block的物理页数目为剩余的数目。具体而言，首先，和第一种情况类似，需要将第一个block对应的节点page_link从空闲链表移除、更新空闲页面的总数nr_free、设置第一个block的property以标识其已被分配。然后，需要将第二个block对应的节点Page_link插入到空闲链表中。此时，default_pmm的做法是把第二个block直接插在空闲列表的开头，这不符合first fit算法的要求，因为first fit要求空闲列表中的block需要按物理地址从小到大排列。因此这里需要修改。
    - 修改方案是：在搜索到第一个符合要求的空闲block，并且空闲block的页数大于待申请的页数时，就地拆分当前空闲block，并将第二个block插入到当前空闲block的后面，然后删除当前空闲block即可。

3. 释放内存：default_pmm的现有算法在释放内存时做法是：遍历空闲链表，如果发现空闲链表当前节点对应的空闲block和待释放block在物理地址上是连续的，则先将空闲链表中对应的空闲block删除，然后合并到待释放block中。遍历完毕后，将待释放block出入到空闲链表的开头即可。这里同样不符合first fit算法的要求，因为待释放的block未必是空闲链表中对应的block中物理地址最小的，将其插到开头，将破坏first fit要求的空闲block按物理地址从小到大排列的规则。
    - 修改方案：首先对default_pmm的遍历链表进行优化：当空闲链表中对应的block是按照物理地址排序时，我们可以很容易找到待释放block应该插入的位置：它应该插入到第一个物理地址比自己大的空闲block的前面。因此，我们的while循环不需要从头到尾遍历一遍空闲链表，而是找到上述位置即可停止。
    - 找到待插入位置时，还需要判断前后的空闲block的物理地址是否与自己相邻，共有4种可能，需要分类讨论。

#### 是否有进一步的改进空间
我的设计针对default_pmm的释放内存算法进行了优化，目前暂没发现其他改进空间。

## 练习2：实现寻找虚拟地址对应的页表项

### 题目
通过设置页表和对应的页表项，可建立虚拟内存地址和物理内存地址的对应关系。其中的get_pte函数是设置页表项环节中的一个重要步骤。此函数找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。本练习需要补全get_pte函数 in kern/mm/pmm.c，实现其功能。请仔细查看和理解get_pte函数中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
1. 请描述页目录项（Page Directory Entry） 和页表项（Page Table Entry） 中每个组成部分的含义以及对ucore而言的潜在用处。
2. 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

### 我的设计实现过程
get_pte函数中的详细注释已经给出了处理流程，这里结合我的代码简单描述一下。

1. 首先，输入参数pgdir是页目录表的起始逻辑地址，线性地址la的最高10位是页目录表的索引，两者结合得到对应的页目录项pde。

2. 页目录项的最低位是PTE_P，标记当前页目录项对应的页表空间是否存在。因此检查页目录项的最低位，若为1，则说明对应的页表空间存在，这时需要进一步找到对应的页表项pte的逻辑地址。页目录项pde将最低12位清零后即可得到对应页表的起始物理地址，加上0xC0000000后得到起始逻辑地址，又由于线性地址la的第21~12位是页表索引，两者结合得到对应的页表项pte的逻辑地址。

3. 若页目录项的最低位为0，则说明对应的页表空间不存在。这时检查输入参数create的值，若为0则直接返回NULL。

4. 若create的值为1，则需要进行以下处理
    - 为当前页表申请一个物理页，设置物理页的ref为1，表明目前只有一个逻辑地址被映射到当前物理页
    - 初始化对应物理页的内存空间为全0
    - 设置页目录项pde的值，注意除了设置页表物理地址外，还要设置PTE_P, PTE_W及PTE_U等标志位，表示对应的页表空间现在已经存在、具有可写权限、用户态下可访问
    - 最后，将对应物理页的起始物理地址加上0xc0000000得到起始逻辑地址，加上线性地址la中提供的页表索引，即可得到对应页表项pte的逻辑地址

### 回答问题1：页目录项和页表项各部分的含义及用途

1. 页目录项：页目录项各部分的含义见《Intel And IA-32 Architecture Software Developer's Manual》的以下表格，下面简述各部分的用途：
    - 第0位用来确认对应的页表是否存在，为1时表示存在，可以进一步查找对应的页表；为0时表示页表不存在，这时需要分配一个物理页给当前页表。
    - 第1位用来确认对应的页表是否可写，由于内存分配和释放时均需修改对应的页表项，因此第1位需要置位
    - 第2位用来确认用户态下是否可以访问，如果为0则该页目录项对应的4M物理空间均不能在用户态下访问。由于用户需要对物理空间具有读或写权限，因此第2位也需要置位。实验指导书中也有说明：“只有当一级二级页表的项都设置了用户写权限后，用户才能对对应的物理地址进行读写。 所以我们可以在一级页表先给用户写权限，再在二级页表上面根据需要限制用户的权限，对物理页进行保护。”
    - 第3~4位用于cache，暂不关注。
    - 第5位用来确认对应页表是否被使用。
    - 第31~12位是页表的起始物理地址，用于定位页表位置。

Bit | Contents
--- | --------
0 (P)   | Present; must be 1 to reference a page table
1 (R/W) | Read/write; if 0, writes may not be allowed to the 4-MByte region controlled by this entry 
2 (U/S) | User/supervisor; if 0, user-mode accesses are not allowed to the 4-MByte region controlled by this entry 
3 (PWT) | Page-level write-through; indirectly determines the memory type used to access the page table referenced by this entry 
4 (PCD) | Page-level cache disable; indirectly determines the memory type used to access the page table referenced by this entry 
5 (A)   | Accessed; indicates whether this entry has been used for linear-address translation 
6       | Ignored
7 (PS)  | If CR4.PSE = 1, must be 0 (otherwise, this entry maps a 4-MByte page; see Table 4-4); otherwise, ignored
11:8    | Ignored
31:12   | Physical address of 4-KByte aligned page table referenced by this entry

2. 页表项：页表项各部分的含义见《Intel And IA-32 Architecture Software Developer's Manual》的以下表格，下面简述各部分的用途：
    - 第0位用来确认页表项对应的物理页是否存在，为1时表示存在
    - 第1位用来确认对应的物理页是否可写，为0时表示不可写
    - 第2位用来确认用户态下是否可访问对应的物理页，为0时表示用户态下不可访问
    - 第3~4位用于cache，暂不关注。
    - 第5位用来确认对应页表是否被使用。
    - 第31~12位是对应物理页的起始物理地址，用于定位物理页位置。

Bit | Contents
--- | --------
0 (P)   | Present; must be 1 to map a 4-KByte page
1 (R/W) | Read/write; if 0, writes may not be allowed to the 4-KByte page referenced by this entry 
2 (U/S) | User/supervisor; if 0, user-mode accesses are not allowed to the 4-KByte page referenced by this entry 
3 (PWT) | Page-level write-through; indirectly determines the memory type used to access the 4-KByte page referenced by this entry 
4 (PCD) | Page-level cache disable; indirectly determines the memory type used to access the 4-KByte page referenced by this entry 
5 (A)   | Accessed; indicates whether software has accessed the 4-KByte page referenced by this entry 
6 (D)   | Dirty; indicates whether software has written to the 4-KByte page referenced by this entry 
7 (PAT) | If the PAT is supported, indirectly determines the memory type used to access the 4-KByte page referenced by this entry 
8 (G)   | Global; if CR4.PGE = 1, determines whether the translation is global ; ignored otherwise
11:9    | Ignored
31:12   | Physical address of the 4-KByte page referenced by this entry

### 回答问题2：出现页访问异常时硬件要做哪些事情
这个问题不太会。首先需要对页访问异常进行分类：缺页（虚拟地址无对应的物理页）、权限检查出错等。

## 练习3：释放某虚地址所在的页并取消对应二级页表项的映射

### 题目
当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。请仔细查看和理解page_remove_pte函数中的注释。为此，需要补全在kern/mm/pmm.c中的page_remove_pte函数。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
1. 数据结构Page的全局变量（其实是一个数组） 的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
2. 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ 鼓励通过编程来具体完成这个问题

### 我的设计实现过程
page_remove_pte函数中的详细注释已经给出了处理流程，下面简单介绍我的代码实现过程。

1. 检查页表项pte的最低位PTE_P的值，若为0，则说明对应的物理页不存在，此时直接返回即可
2. 若页表项pte的最低位为1，则说明对应的物理页存在。这时，首先将页表项的低12位清零得到物理页的起始地址，并据此得到对应的Page结构，将Page的ref字段减1，表明取消当前逻辑地址到此物理地址的映射。然后，判断Page的ref的值是否为0，若为0，则说明此时没有任何逻辑地址被映射到此物理地址，换句话说当前物理页已没人使用，因此调用free_page函数回收此物理页；若不为0，则说明此时仍有至少一个逻辑地址被映射到此物理地址，因此不需回收此物理页。
3. 将对应的页表项pte清零，表明此逻辑地址无对应的物理地址。
4. 调用tlb_invalidate函数去使能TLB中当前逻辑地址对应的条目。

### 回答问题1： pages与页目录项和页表项的对应关系

当页目录项或页表项有效时（即页目录项或页表项有具体的数值而非全0），数据结构pages与页目录项和页表项有对应关系。pages每一项记录一个物理页的信息，而每个页目录项记录一个页表的信息，每个页表项则记录一个物理页的信息。假设系统中共有N个物理页，那么pages共有N项，第i项对应第i个物理页的信息。而页目录项和页表项的第31~12位构成的20位数分别对应一个物理页编号，因此也就和pages的对应元素一一对应。

### 回答问题2：如何修改lab2使得虚拟地址与物理地址相等？

## 扩展练习1：buddy system（伙伴系统） 分配算法（待完成）

### 题目
Buddy System算法把系统中的可用存储空间划分为存储块(Block)来进行管理, 每个存储块的大小必须是2的n次幂(Pow(2, n)), 即1, 2, 4, 8, 16, 32, 64, 128...

参考伙伴分配器的一个极简实现， 在ucore中实现buddy system分配算法，要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

## 扩展练习2：任意大小的内存单元slub分配算法（待完成）

### 题目
slub算法，实现两层架构的高效内存单元分配，第一层是基于页大小的内存分配，第二层是在第一层基础上实现基于任意大小的内存分配。可简化实现，能够体现其主体思想即可。

参考linux的slub分配算法/，在ucore中实现slub分配算法。要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

## 疑问

1. 如何理解lab2中不同阶段的多次地址映射？

2. 如何理解lab2的内存布局？
```
/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *
 *     4G ------------------> +---------------------------------+
 *                            |                                 |
 *                            |         Empty Memory (*)        |
 *                            |                                 |
 *                            +---------------------------------+ 0xFB000000
 *                            |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT -----------------> +---------------------------------+ 0xFAC00000
 *                            |        Invalid Memory (*)       | --/--
 *     KERNTOP -------------> +---------------------------------+ 0xF8000000
 *                            |                                 |
 *                            |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                            |                                 |
 *     KERNBASE ------------> +---------------------------------+ 0xC0000000
 *                            |                                 |
 *                            |                                 |
 *                            |                                 |
 *                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 *
 * */
```

3. 为什么lab2的物理内存布局是这样的？
```
e820map:
  memory: 0009fc00, [00000000, 0009fbff], type = 1.
  memory: 00000400, [0009fc00, 0009ffff], type = 2.
  memory: 00010000, [000f0000, 000fffff], type = 2.
  memory: 07ee0000, [00100000, 07fdffff], type = 1.
  memory: 00020000, [07fe0000, 07ffffff], type = 2.
  memory: 00040000, [fffc0000, ffffffff], type = 2.
```
