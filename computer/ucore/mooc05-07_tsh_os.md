# 《Tsinghua OS MOOC》第五~七讲笔记

## 资源

1. [OS2018Spring课程资料首页](http://os.cs.tsinghua.edu.cn/oscourse/OS2018spring)

2. [uCore OS在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

3. [ucore实验基准源代码](https://github.com/chyyuu/ucore_os_lab)

4. [MOOC OS习题集](https://xuyongjiande.gitbooks.io/os_exercises/content/index.html)

5. [OS课堂练习](https://chyyuu.gitbooks.io/os_course_exercises/content/)

6. [Piazza问答平台](https://piazza.com/connect) 暂时无法注册

## 疑问

1. 段式内存管理中，逻辑地址由段选择子和段偏移量两部分组成？段选择子占16位，低3位为TI（指示是GDT还是LDT）和DPL，也就是说逻辑地址中含有TI和DPL信息？

## 第五讲 物理内存管理：连续内存分配

1. 源代码中的函数或变量的地址的最终确定，需要经历两次重定位：链接时和将程序加载到内存中时。通常在可执行文件的前面部分有个重定位表，记录需要重定位的符号。

2. 关于地址生成时机，在执行时生成比在编译和链接时生成的好处：后者在加载到内存前已经是绝对地址，不能再挪动，而有时本程序或其他程序内存空间不够而确实需要挪动，这时使用前者的方案可以适应这种场景。

3. 内部碎片 vs 外部碎片
    - 内部碎片：分配内存内部的未被使用内存
    - 外部碎片：分配单元之间的未被使用内存

4. 三种内存分配策略
    - 最先匹配
        - 原理：空闲分区列表按照地址顺序排序
        - 优点：简单、在高地址空间有大块的空闲分区
        - 缺点：外部碎片、分配大块时较慢
    - 最佳匹配
        - 原理：空闲分区列表按由小到大排序
        - 优点：大部分分配的尺寸较小时，效果很好
        - 缺点：外部碎片、容易产生很多无用的小碎片、释放分区较慢（判断合并时要搜索地址相邻的分区）
    - 最差匹配（这种分配策略有什么好处？）
        - 原理：空闲分区列表按由大到小排序
        - 优点：中等大小的分配较多时，效果最好；避免出现太多的小碎片
        - 缺点：释放分区较慢；外部碎片；容易破坏大的空闲分区，因此后续较难分配大的分区

> 问题：我们现在的操作系统使用连续内存分配吗？我的理解：应该不是。OS首先将内存划分成N个页，然后每次进程申请内存时，根据其申请大小分配k个页给它，这k个页可能是连续的也可能不连续。因此现代OS使用的策略都是非连续内存分配。

5. 碎片整理方案
    - 碎片紧凑：通过移动分配给进程的内存分区，来合并外部碎片。碎片紧凑的条件：所有的程序可动态重定位。
    - 分区对换（Swapping in/out）：通过抢占并回收处于等待状态的进程分区，来增大可用内存空间。回收的进程分区一般放在外存的swap区（对换区）中。

6. 伙伴系统（Buddy System）
    - 原理：一开始是一整块大小为2^n的内存，进程申请大小为M的内存时，先找到一块比M大的内存，如果该内存小于2M，则将这块内存分配给进程；否则将这块内存均分为两块，再作判断。
    - 用途：Linux和Unix系统中的内核内存分配都应用了伙伴系统

7. 地址检查：操作系统根据进程的逻辑地址访问物理内存前，需要检查逻辑地址对应的偏移量是否不大于段长度。

8. ucore的物理内存管理 
```
struct pmm_manager {
	const char *name;
	void (*init)(void);
	void (*init_memmap)(struct Page *base, size_t n);
	struct Page *(*alloc_pages)(size_t order);
	void (*free_pages)(struct Page *base, size_t n);
	size_t (*nr_free_pages)(void);
	void (*check)(void);
};
```

9. ucore的伙伴系统实现
```
const struct pmm_manager buddy_pmm_manager = {
	.name = "buddy_pmm_manager",
	.init = buddy_init,
	.init_memmap = buddy_init_memmap,
	.alloc_pages = buddy_alloc_pages,
	.free_pages = buddy_free_pages,
	.nr_free_pages = buddy_nr_free_pages,
	.check = buddy_check,
};
```

## 第六讲 物理内存管理 非连续内存分配

1. 连续内存分配的缺点
    - 分配给程序的物理内存必须连续
    - 存在外碎片和内碎片
    - 内存分配的动态修改困难
    - 内存利用率低

2. 段式存储管理和页式存储管理的一个区别：前者以段为单位，每个段内存较大；后者以页为单位，每页内存相对较小。
