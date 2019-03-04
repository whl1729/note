# 《ucore lab3》实验报告

## 资源

1. [ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)
2. [我的ucore实验代码](https://github.com/whl1729/ucore_os_lab)

## 练习1：给未被映射的地址映射上物理页

### 题目
完成do_pgfault（mm/vmm.c）函数，给未被映射的地址映射上物理页。设置访问权限的时候需要参考页面所在 VMA 的权限，同时需要注意映射物理页时需要操作内存控制结构所指定的页表，而不是内核的页表。注意：在LAB3 EXERCISE 1处填写代码。执行make qemu后，如果通过check_pgfault函数的测试后，会有“check_pgfault() succeeded!”的输出，表示练习1基本正确。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

1. 请描述页目录项（Page Directory Entry） 和页表项（Page Table Entry） 中组成部分对ucore实现页替换算法的潜在用处。
2. 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

### 解答

#### 我的设计实现过程
do_pgfault函数已经完成了参数检查及错误检查等流程，根据注释不难完成剩下的流程。

1. 检查页面异常发生时的错误码的最低两位，即存在位和读/写位，如果发现错误则打印相关提示信息并返回。导致错误的原因有：读没有读权限的内存、写没有写权限的内存、所读内容在内存中却读失败等。（原代码中已实现）

2. 用虚拟地址addr索引页目录表和页表，得到对应的页表项。这时要分两种情况讨论。

3. 如果页表项为0，说明系统尚未为虚拟地址addr分配物理页，因此首先需要申请分配一个物理页；然后设置页目录表和页表，以建立虚拟地址addr到物理页的映射；最后，设置该物理页为swappable，并且把它插入到可置换物理页链表的末尾。

4. 如果页表项不为0，而又出现缺页异常，说明系统已建立虚拟地址addr到物理页的映射，但对应物理页已经被换出到磁盘中。这时同样需要申请分配一个物理页，把换出到磁盘中的那个页面的内容写到该物理页中；接下来和步骤3类似，同样需要建立虚拟地址addr到物理页的映射，同样需要把该物理页插入到可置换页链表的末尾。

#### 问题1：页目录项和页表项对页替换算法的用处

答：页替换涉及到换入换出，换入时需要将某个虚拟地址vaddr对应于磁盘的一页内容读入到内存中，换出时需要将某个虚拟页的内容写到磁盘中的某个位置。而页表项可以记录该虚拟页在磁盘中的位置，为换入换出提供磁盘位置信息。页目录项则是用来索引对应的页表。

#### 问题2：缺页服务例程出现页访问异常时，硬件需要做哪些事情

答：
1. 关中断
2. 保护现场。包括：将页访问异常的错误码压入内核栈的栈顶、将导致页访问异常的虚拟地址记录在cr2寄存器中、保存状态寄存器PSW及断点等。
3. 根据中断源，跳转到缺页服务例程

#### 代码优化

对照答案对代码进行优化。

1. do_pgfault调用get_pte时没有检查返回值。
我的代码：
```
pte_t *ptep = get_pte(mm->pgdir, addr, 1);
```

答案的代码：
```
pte_t *ptep=NULL;
// try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
// (notice the 3th parameter '1')
if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
    cprintf("get_pte in do_pgfault failed\n");
    goto failed;
}
```

2. do_pgfault调用pgdir_alloc_page和swap_in失败后没打印错误信息以方便定位。
我的代码：
```
    if (*ptep == 0) {
        if (page = pgdir_alloc_page(mm->pgdir, addr, perm)) {
            ret = 0;
        }
    }
    else if (swap_init_ok) {
        swap_in(mm, addr, &page);

        if (0 == page_insert(mm->pgdir, page, addr, perm)) {
            swap_map_swappable(mm, addr, page, 0);
            ret = 0;
        }
    }
```

答案的代码：
```
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
            struct Page *page=NULL;
            if ((ret = swap_in(mm, addr, &page)) != 0) {
                cprintf("swap_in in do_pgfault failed\n");
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
            swap_map_swappable(mm, addr, page, 1);
            page->pra_vaddr = addr;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
    }
```

## 练习2：补充完成基于FIFO的页面替换算法（需要编程）

### 题目
完成vmm.c中的do_pgfault函数，并且在实现FIFO算法的swap_fifo.c中完成map_swappable和swap_out_victim函数。通过对swap的测试。注意：在LAB3 EXERCISE 2处填写代码。执行make qemu后，如果通过check_swap函数的测试后，会有“check_swap() succeeded!”的输出，表示练习2基本正确。

请在实验报告中简要说明你的设计实现过程。

请在实验报告中回答如下问题：

1. 如果要在ucore上实现"extended clock页替换算法"，请给出你的设计方案，现有的swap_manager框架是否足以支持在ucore中实现此算法？如果是，请给出你的设计方案。如果不是，请给出你的新的扩展和基此扩展的设计方案。并需要回答如下问题：
    - 需要被换出的页的特征是什么？
    - 在ucore中如何判断具有这样特征的页？
    - 何时进行换入和换出操作？

### 解答

#### 我的设计实现过程

练习1中结合do_pgfault函数大致分析了缺页异常处理的流程，但对换入换出只作了简略讨论。这里结合swap_fifo.c的map_swappable和swap_out_victim函数进一步讨论换入换出流程。

1. 为支持换入换出，在lab 2的基础上主要修改了两个地方：一是当虚拟页被换出到磁盘时，用对应页表项的高24位记录磁盘地址；二是在Page结构体中增加了pra_page_link和pra_vaddr两个字段，前者用于将可换出的物理页保存在一个链表中，后者用于记录当前物理页对应的虚拟页地址（由于可以换入换出，同一个物理页在不同时刻可能被映射到不同的虚拟页，因此有必要增加一个字段记录当前映射到的虚拟页地址）。

2. map_swappable函数根据FIFO置换算法，将一个物理页添加到可换出物理页链表的末尾，同时更新物理页对应的虚拟页地址。

3. swap_out_victim函数根据FIFO置换算法，选择可换出物理页链表的首元素，作为将被换出的物理页。

#### 回答问题（待完成）

## Challenge 1：实现识别dirty bit的 extended clock页替换算法（待完成）

## Challenge 2：实现不考虑实现开销和效率的LRU页替换算法（待完成）

