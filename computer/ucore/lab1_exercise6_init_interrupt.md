# 《ucore lab1 exercise6》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 题目：完善中断初始化和处理
请完成编码工作和回答如下问题：

1. 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。

3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。

完成这问题2和3要求的部分代码后，运行整个系统，可以看到大约每1秒会输出一次”100 ticks”，而按下的键也会在屏幕上显示。

【注意】除了系统调用中断(T_SYSCALL)使用陷阱门描述符且权限为用户态权限以外，其它中断均使用特权级(DPL)为0的中断门描述符，权限为内核态权限；而ucore的应用程序处于特权级3，需要采用｀int 0x80`指令操作（这种方式称为软中断，软件中断，Trap中断，在lab5会碰到） 来发出系统调用请求，并要能实现从特权级3到特权级0的转换，所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为3。

## 解答

### 问题1的回答

问题1：中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？
答：中断描述符表一个表项占8个字节，其结构如下：
- bit 63..48:  offset 31..16
- bit 47..32:  属性信息，包括DPL、P flag等
- bit 31..16:  Segment selector
- bit 15..0:   offset 15..0

其中第16~32位是段选择子，用于索引全局描述符表GDT来获取中断处理代码对应的段地址，再加上第0~15、48~63位构成的偏移地址，即可得到中断处理代码的入口。

### 完善idt_init函数

idt_init函数的功能是初始化IDT表。IDT表中每个元素均为门描述符，记录一个中断向量的属性，包括中断向量对应的中断处理函数的段选择子/偏移量、门类型（是中断门还是陷阱门）、DPL等。因此，初始化IDT表实际上是初始化每个中断向量的这些属性。

1. 题目已经提供中断向量的门类型和DPL的设置方法：除了系统调用的门类型为陷阱门、DPL=3外，其他中断的门类型均为中断门、DPL均为0.

2. 中断处理函数的段选择子及偏移量的设置要参考kern/trap/vectors.S文件：由该文件可知，所有中断向量的中断处理函数地址均保存在\_\_vectors数组中，该数组中第i个元素对应第i个中断向量的中断处理函数地址。而且由文件开头可知，中断处理函数属于.text的内容。因此，中断处理函数的段选择子即.text的段选择子GD_KTEXT。从kern/mm/pmm.c可知.text的段基址为0，因此中断处理函数地址的偏移量等于其地址本身。

3. 完成IDT表的初始化后，还要使用lidt命令将IDT表的起始地址加载到IDTR寄存器中。

根据以上分析，及注释中的提示，不难完成编码，如下所示。

```
extern uintptr_t __vectors[];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void) {
    uint32_t pos;
    uint32_t sel = GD_KTEXT;

    /* along: how to set istrap and dpl? */
    for (pos = 0; pos < 256; pos++) {
        SETGATE(idt[pos], 0, sel, __vectors[pos], 0);
    }
        
    SETGATE(idt[128], 1, sel, __vectors[128], 3);

    lidt(&idt_pd);
}
```

lab1_result中的代码如下所示。答案有几处地方比我写得好：
1. 我定义的sel变量是多余的，浪费内存，直接使用GD_KTEXT即可。
2. 设置DPL时使用DPL_KERNEL, DPL_USER代替0和3，可读性更好。
3. 将extern __vectors放在函数内部，使其仅在本函数内可见，结构上更合理。（是吗？）

不过这里有个问题：答案设置系统调用的门描述符时，中断向量为什么是T_SWITCH_TOK(121)而不是T_SYSCALL(128)？

```
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void) {
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
	// load the IDT
    lidt(&idt_pd);
}
```

### 完善trap函数

trap函数只是直接调用了trap_dispatch函数，而trap_dispatch函数实现对各种中断的处理，题目要求我们完成对时钟中断的处理，实现非常简单：定义一个全局变量ticks，每次时钟中断将ticks加1，加到100后打印"100 ticks"，然后将ticks清零重新计数。代码实现如下：

```
    case IRQ_OFFSET + IRQ_TIMER:
        if (((++ticks) % TICK_NUM) == 0) {
            print_ticks();
            ticks = 0;
        }
```
