# 《ucore lab5》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1: 加载应用程序并执行（需要编码）

### 题目
do_execv函数调用load_icode（位于kern/process/proc.c中） 来加载并解析一个处于内存中的ELF执行文件格式的应用程序，建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好proc_struct结构中的成员变量trapframe中的内容，确保在执行此进程后，能够从应用程序设定的起始执行地址开始执行。需设置正确的trapframe内容。

请在实验报告中简要说明你的设计实现过程。

请在实验报告中描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

### 解答

#### 我的设计实现过程
根据注释的提示设置trapframe的内容即可。

1. tf_cs设置为用户态代码段的段选择子
2. tf_ds、tf_es、tf_ss均设置为用户态数据段的段选择子
3. tf_esp设置为用户栈的栈顶
4. tf_eip设置为ELF文件的入口e_entry
5. tf_eflags使能中断位

#### 用户态进程从被ucore选择到执行第一条指令的过程

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

## 练习2: 父进程复制自己的内存空间给子进程（需要编码）

### 题目
创建子进程的函数do_fork在执行中将拷贝当前进程（即父进程） 的用户内存地址空间中的合法内容到新进程中（子进程） ，完成内存资源的复制。具体是通过copy_range函数（位于kern/mm/pmm.c中） 实现的，请补充copy_range的实现，确保能够正确执行。

请在实验报告中简要说明如何设计实现”Copy on Write 机制“，给出概要设计，鼓励给出详细设计。

Copy-on-write（简称COW） 的基本概念是指如果有多个使用者对一个资源A（比如内存块） 进行读操作，则每个使用者只需获得一个指向同一个资源A的指针，就可以该资源了。若某使用者需要对这个资源A进行写操作，系统会对该资源进行拷贝操作，从而使得该“写操作”使用者获得一个该资源A的“私有”拷贝—资源B，可对资源B进行写操作。该“写操作”使用者对资源B的改变对于其他的使用者而言是不可见的，因为其他使用者看到的还是资源A。

### 解答

#### copy_range的实现

基本思路是遍历对父进程的每一块vma，逐页拷贝其内容给子进程。由于子进程目前只是设置好了mm和vma结构，尚未为虚拟页分配物理页。因此在拷贝过程中，需要申请物理页，拷贝好内容后，调用page_insert建立虚拟地址到物理地址的映射。

#### “Copy on Write机制”的设计实现（待完善）

如果要实现“Copy on Write机制”，可以在现有代码的基础上稍作修改。修改内容：
- 在执行do_fork时，子进程的页目录表直接拷贝父进程的页目录表，而不是拷贝内核页目录表；在dup_mmap，只需保留拷贝vma链表的部分，取消调用copy_range来为子进程分配物理内存。
- 将父进程的内存空间对应的所有Page结构的ref均加1，表示子进程也在使用这些内存
- 将父子进程的页目录表的写权限取消，这样一旦父子进程执行写操作时，就会发生页面访问异常，进入页面访问异常处理函数中，再进行内存拷贝操作，并恢复页目录表的写权限。

## 练习3: 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现（不需要编码）

### 题目
请在实验报告中简要说明你对 fork/exec/wait/exit函数的分析。并回答如下问题：

请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？

请给出ucore中一个用户态进程的执行状态生命周期图（包括执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用） 。（字符方式画即可）

执行：make grade。如果所显示的应用程序检测都输出ok，则基本正确。（使用的是qemu-1.0.1）

### 解答

#### fork的实现
fork的功能是创建一个新进程，具体地说是创建一个新进程所需的控制信息。在ucore中fork对应的函数是do_fork。

1. 分配一个进程控制块，设置其state为UNINIT

2. 为内核栈分配2页的内存空间，并将其地址记录在进程控制块的kstack字段中

3. 复制父进程的内存空间到新进程

4. 为新进程分配pid

5. 设置新进程的父进程、子进程等关系信息

6. 将新进程添加到进程链表proc_list和哈希表hash_list中

7. 设置新进程的state为RUNNABLE，从而将其唤醒。

#### exec的实现
exec的功能是在已经存在的进程的上下文中运行新的可执行文件，替换先前的可执行文件。在ucore中exec对应的函数是do_execve。

1. do_execve首先检查用户态虚拟内存空间是否合法，如果合法且目前只有当前进程占用，则释放虚拟内存空间，包括取消虚拟内存到物理内存的映射，释放vma，mm及页目录表占用的物理页等。

2. 调用load_icode函数来加载应用程序

3. 重新设置当前进程的名字，然后返回

#### wait的实现
wait的功能是等待子进程结束，从而释放子进程占用的资源。在ucore中wait对应的函数是do_wait。

1. 遍历进程链表proc_list，根据输入参数寻找指定pid或任意pid的子进程，如果没找到，直接返回错误信息。

2. 如果找到子进程，而且其状态为ZOMBIE，则释放子进程占用的资源，然后返回。

3. 如果找到子进程，但状态不为ZOMBIE，则将当前进程的state设置为SLEEPING、wait_state设置为WT_CHILD，然后调用schedule函数，从而进入等待状态。等再次被唤醒后，重复寻找状态为ZOMBIE的子进程。

#### exit的实现
exit的功能是释放进程占用的资源并结束运行进程。在ucore中exit对应的函数是do_exit。

1. 释放页表项记录的物理内存，以及mm结构、vma结构、页目录表占用的内存。

2. 将自己的state设置为ZOMBIE，然后唤醒父进程，并调用schedule函数，等待父进程回收剩下的资源，最终彻底结束子进程。

#### 系统调用的实现

ucore_os_docs在lab5中已经详细介绍了系统调用的实现，另外在我的[ucore源码分析](src_analysis_ucore.md) lab1中也有分析。简单来说，ucore实现系统调用分为以下几步：

1. 在idt_init函数中初始化系统调用对应的中断描述符。
2. 在user/libs/syscall.c中封装了syscall接口，简化应用程序访问系统调用的复杂性。
3. 在kernel/syscall/syscall.c中用函数数组来存储各系统调用对应的处理函数的地址，并封装了syscall接口，用于根据系统调用号索引函数数组，找到对应的处理函数来运行。

#### 画出userproc的执行状态生命周期图

      (alloc_proc)          (wakeup_proc)
    ---------------> NEW ----------------> READY
                                             |
                                             |
                                             | (proc_run)
                                             |
         (do_wait)            (do_exit)      V
   EXIT <---------- ZOMBIE <-------------- RUNNING

## 扩展练习 Challenge ：实现 Copy on Write （COW） 机制（待完成）

### 题目
给出实现源码,测试用例和设计报告（包括在cow情况下的各种状态转换（类似有限状态自动机）的说明）。

这个扩展练习涉及到本实验和上一个实验“虚拟内存管理”。在ucore操作系统中，当一个用户父进程创建自己的子进程时，父进程会把其申请的用户空间设置为只读，子进程可共享父进程占用的用户内存空间中的页面（这就是一个共享的资源）。当其中任何一个进程修改此用户内存空间中的某页面时，ucore会通过page fault异常获知该操作，并完成拷贝内存页面，使得两个进程都有各自的内存页面。这样一个进程所做的修改不会被另外一个进程可见了。请在ucore中实现这样的COW机制。

由于COW实现比较复杂，容易引入bug，请参考 https://dirtycow.ninja/ 看看能否在ucore的COW实现中模拟这个错误和解决方案。需要有解释。

这是一个big challenge.

