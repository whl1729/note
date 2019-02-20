# 《ucore lab4》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1：分配并初始化一个进程控制块

### 题目
alloc_proc函数（位于kern/process/proc.c中） 负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

> 【提示】 在alloc_proc函数的实现中，需要初始化的proc_struct结构中的成员变量至少包括：state/pid/runs/kstack/need_resched/parent/mm/context/tf/cr3/flags/name。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
请说明proc_struct中 struct context context 和 struct trapframe \*tf 成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

### 解答

#### 我的设计实现过程

alloc_proc函数主要是初始化进程控制块，亦即初始化proc_struct结构体的各成员变量。

- state：进程所处的状态。由于分配进程控制块时，进程还处于创建阶段，因此设置其状态的PROC_UNINIT，表示尚未完成初始化。
- pid：先设置pid为无效值-1，用户调完alloc_proc函数后再根据实际情况设置pid。
- cr3：设置为前面已经创建好的页目录表boot_pgdir的物理地址。注意是物理地址，实际编码时应写成PADDR(boot_pgdir)。
- need_resched：标记是否需要调度其他进程。初始化为0，表示不需调度其他进程。
- kstack：内核栈地址，先初始化为0，后续根据需要来设置
- tf：中断帧，先初始化为NULL，后续根据需要来设置

#### 回答问题：context和tf的含义及作用是什么

1. context是进程上下文，即进程执行时各寄存器的取值。用于进程切换时保存进程上下文比如本实验中，当idle进程被CPU切换出去时，可以将idle进程上下文保存在其proc_struct结构体的context成员中，这样当CPU运行完init进程，再次运行idle进程时，能够恢复现场，继续执行。
```
struct context {
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};
```

2. tf是中断帧，具体定义如下。
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

3. trap_frame与context的区别是什么？
    - 从内容上看，trap_frame包含了context的信息，除此之外，trap_frame还保存有段寄存器、中断号、错误码err和状态寄存器eflags等信息。
    - 从作用时机来看，context主要用于进程切换时保存进程上下文，trap_frame主要用于发生中断或异常时保存进程状态。
    - 当进程进行系统调用或发生中断时，会发生特权级转换，这时也会切换栈，因此需要保存栈信息（包括ss和esp）到trap_frame，但不需要更新context。

4. trap_frame与context在创建进程时所起的作用：
    - 当创建一个新进程时，我们先分配一个进程控制块proc，并设置好其中的tf及context变量；
    - 然后，当调度器schedule调度到该进程时，首先进行上下文切换，这里关键的两个上下文信息是context.eip和context.esp，前者提供新进程的起始入口，后者保存新进程的trap_frame地址。
    - 上下文切换完毕后，CPU会跳转到新进程的起始入口。在新进程的起始入口中，根据trap_frame信息设置通用寄存器和段寄存器的值，并执行真正的处理函数。可见，tf与context共同用于进程的状态保存与恢复。
    - 综上，由上下文切换到执行新进程的处理函数fn，中间经历了多次函数调用：forkret() -> forkrets(current->tf) -> \_\_trapret -> kernel_thread_entry -> init_main.

## 练习2：为新创建的内核线程分配资源

### 题目

创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用do_fork函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中do_fork函数中的处理过程。它的大致执行步骤包括：
    - 调用alloc_proc，首先获得一块用户信息块。
    - 为进程分配一个内核栈。
    - 复制原进程的内存管理信息到新进程（但内核线程不必做此事）
    - 复制原进程上下文到新进程
    - 将新进程添加到进程列表
    - 唤醒新进程
    - 返回新进程号

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

### 解答

#### 我的设计实现过程

根据注释提供的步骤，很容易完成do_fork函数的实现。这里需要注意的是：如果前面的步骤失败，比如alloc_proc分配进程控制块失败或建立内核栈失败，那么需要释放已申请的资源。

#### 回答问题：ucore是否为每个新fork的线程提供唯一的pid？

首先，本实验不提供线程释放的功能，意味着pid只分配不回收。当fork的线程总数小于MAX_PID时，每个线程的pid是唯一的。当fork的线程总数大于MAX_PID时，后面fork的线程的pid可能与前面的线程重复（暂不确定）。

> 注：get_pid函数没完全看懂，next_safe的含义不理解？

#### 代码修改
对照答案时，发现自己的代码有几个优化的地方：

1. 没有设置proc->parent，应将其设置为current

2. 由于do_fork已经设置了标签，setup_kstack执行失败后直接跳转到bad_fork_cleanup_proc即可，copy_mm失败后直接跳转到bad_fork_cleanup_kstack即可。

3. copy_thread的第二个输入参数esp应该使用do_fork的第二个输入参数stack。

4. 将当前进程插入到proc_list和hash_list时需要去使能中断。（为什么？）

5. 我是将proc插入到proc_list的末尾，而答案是插入到proc_list的开头。为何？是不是因为插入到开头的话，schedule选择要执行的线程时会快些？

我的代码：
```
    if (NULL == (proc = alloc_proc())) {
        goto fork_out;
    }

    if (0 != setup_kstack(proc)) {
        kfree(proc);
        goto fork_out;
    }

    if (0 != copy_mm(clone_flags, proc)) {
        kfree((void *)proc->kstack);
        kfree(proc);
        goto fork_out;
    }

    proc->pid = get_pid();

    int esp = 0;
    asm volatile ("movl %%esp, %0" : "=r" (esp));

    copy_thread(proc, esp, tf);

    list_add_before(&proc_list, &proc->list_link);

    hash_proc(proc);

    wakeup_proc(proc);

    nr_process++;
```

答案的代码：
```
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }

    proc->parent = current;

    if (setup_kstack(proc) != 0) {
        goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);

    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        list_add(&proc_list, &(proc->list_link));
        nr_process ++;
    }
    local_intr_restore(intr_flag);

    wakeup_proc(proc);
```

## 练习3：阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的。

### 题目

请在实验报告中简要说明你对proc_run函数的分析。并回答如下问题：
    - 在本实验的执行过程中，创建且运行了几个内核线程？
    - 语句 local_intr_save(intr_flag);....local_intr_restore(intr_flag); 在这里有何作用?请说明理由。

完成代码编写后，编译并运行代码：`make qemu`，如果可以得到如附录A所示的显示内容（仅供参考，不是标准答案输出） ，则基本正确。

### 解答

#### 分析proc_run函数

1. 首先判断要切换到的进程是不是当前进程，若是则不需进行任何处理。

2. 调用local_intr_save和local_intr_restore函数去使能中断，避免在进程切换过程中出现中断。（疑问：进程切换过程中处理中断会有什么问题？）

3. 更新current进程为proc

4. 更新任务状态段的esp0的值（疑问：为什么更新esp0？）

5. 重新加载cr3寄存器，使页目录表更新为新进程的页目录表

6. 上下文切换，把当前进程的当前各寄存器的值保存在其proc_struct结构体的context变量中，再把要切换到的进程的proc_struct结构体的context变量加载到各寄存器。

7. 完成上下文切换后，CPU会根据eip寄存器的值找到下一条指令的地址并执行。根据copy_thread函数可知eip寄存器指向forkret函数，forkret函数的实现为`forkrets(current->tf);`

8. forkrets函数的实现如下。首先是把输入变量current->tf复制给%esp，此时栈上保存了tf的值，亦即各寄存器的值。然后在trapret函数中使用popal和popl指令将栈上的内容逐一赋值给相应寄存器。最后执行iret，把栈顶的数据（也就是tf_eip、tf_cs和tf_eflags）依次赋值给eip、cs和eflags寄存器。
```
.globl __trapret
__trapret:
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
    iret

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
    jmp __trapret
```

9. 根据kernel_thread函数，可知tf_eip指向kernel_thread_entry，其函数实现如下所示。由于kernel_thread函数中把要执行的函数地址fn保存在ebx寄存器，把输入参数保存到edx寄存器，因此kernel_thread_entry函数先通过`pushl %edx`将输入参数压栈，然后通过`call *%ebx`调用函数fn。
```
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
    call *%ebx              # call fn

    pushl %eax              # save the return value of fn(arg)
    call do_exit            # call do_exit to terminate current thread
```

10. 根据proc_init函数，可知调用kernel_thread时，输入的fn函数即init_main，输入参数为"Hello world!!"。init_main函数的功能是打印输入字符串及其他内容，其实现如下所示。
```
init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
    return 0;
}
```

#### 回答问题1：本实验创建且运行了几个内核线程

答：本实验创建且运行了两个内核线程，分别是idle和init线程。

#### 回答问题2：local_intr_save和local_intr_restore的作用

答：避免在进程切换过程中处理中断。

## 扩展练习Challenge：实现支持任意大小的内存分配算法（待完成）

这不是本实验的内容，其实是上一次实验内存的扩展，但考虑到现在的slab算法比较复杂，有必要实现一个比较简单的任意大小内存分配算法。可参考本实验中的slab如何调用基于页的内存分配算法（注意，不是要你关注slab的具体实现） 来实现first-fit/best-fit/worst-fit/buddy等支持任意大小的内存分配算法。

【注意】 下面是相关的Linux实现文档，供参考
    - [SLOB](http://en.wikipedia.org/wiki/SLOB http://lwn.net/Articles/157944/)
    - [SLAB](https://www.ibm.com/developerworks/cn/linux/l-linux-slab-allocator/)

