# 《ucore lab6》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1: 使用 Round Robin 调度算法（不需要编码）

### 题目
完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件） 个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。执行make grade，大部分测试用例应该通过。但执行priority.c应该过不去。

请在实验报告中完成：

请理解并分析sched_class中各个函数指针的用法，并结合Round Robin 调度算法描述ucore的调度执行过程。

请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计。

### 解答

#### 分析sched_class中各个函数指针的用法

1. 首先，kern_init在调用vmm_init初始化完虚拟内存后，调用sched_init来初始化调度器。在sched_init函数中将sched赋值为default_sched_class。
```
    sched_class = &default_sched_class;
```

2. default_sched_class的成员如下所示，接下来分析其中各个函数指针。
```
struct sched_class default_sched_class = {
    .name = "RR_scheduler",
    .init = RR_init,
    .enqueue = RR_enqueue,
    .dequeue = RR_dequeue,
    .pick_next = RR_pick_next,
    .proc_tick = RR_proc_tick,
};
```

3. RR_init初始化RUNNABLE进程链表run_list，并将RUNNABLE进程的数目proc_num设置为0
```
    list_init(&(rq->run_list));
    rq->proc_num = 0;
```

4. RR_enqueue将一个新进程添加到RUNNABLE进程链表run_list的末尾，并将RUNNABLE进程数目proc_num加1。并且检查该进程的时间片，如果为0，重新为它分配时间片max_time_slice。此外还要保证进程的时间片不超过max_time_slice，如果超过了，将其修正为max_time_slice。
```
    list_add_before(&(rq->run_list), &(proc->run_link));
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num ++;
```

5. RR_dequeue从RUNNABLE进程链表run_list中删除指定进程，并将RUNNABLE进程数目proc_num减1.
```
    list_del_init(&(proc->run_link));
    rq->proc_num --;
```

6. RR_pick_next从RUNNABLE进程链表run_list中取出首元素，然后返回。
```
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
        return le2proc(le, run_link);
    }
    return NULL;
```

7. RR_proc_tick将指定进程的时间片减1，如果减1后时间片数值为0，说明该进程的时间片用完了，需要被调度出去，因此将其need_resched标志设置为1.
```
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
```

#### 结合Round Robin调度算法描述ucore的调度执行过程

下面结合Round Robin调度算法来分析ucore系统的进程调度执行过程。

1. 上文已经提到，ucore内核初始化总入口kern_init调用sched_init来初始化调度器sched_class，接下来调用proc_init来初始化进程。

2. proc_init首先为当前正在运行的ucore程序分配一个进程控制块，并将其命名为idle，因此第一个内核线程idleproc应运而生。

3. idleproc调用kernel_thread来创建一个新的内核线程initproc，kernel_thread进一步调用do_fork来完成具体的进程初始化操作，完成后调用wakeup_proc来唤醒新进程，并将内核线程initproc放在RUNNABLE队列rq的末尾。这时rq队列有了第一个进程在等待调度。

4. proc_init结束后，继续一路运行到cpu_idle，在cpu_idle中，不断判断当前进程是否需要调度，如果需要则调用schedule进行调度。由于当前进程是idleproc，其need_resched设置为1，因此进入schedule进行调度。

5. schedule首先判断当前进程是否RUNNABLE，以及是不是idleproc，如果当前进程不是idleproc而且RUNNABLE，则将其加入到rq队列的末尾。由于当前进程是idleproc，因此不会将其加入rq队列。

6. 接下来从RUNNABLE队列中取出队首的进程（此时是initproc），通过调用proc_run来运行initproc进程。这时rq队列已空。

7. initproc进程运行init_main，init_main调用kernel_thread来创建第三个进程userproc。同理，在完成userproc的初始化后，会调用wakeup_proc将其唤醒，并将其加入到rq队列的末尾。这时rq队列有一个进程userproc在等待调度。

8. initproc进程接下来调用do_wait来等待子进程结束运行，其中搜索到其子进程userproc的state不为ZOMBIE，因此调用schedule来试图调度子进程来运行。由于rq队列只有一个进程initproc在排队，因此会调用idleproc来运行。这时rq队列又空了。另外注意，由于initproc进程在调用schedule之前将自己的state设置为SLEEPING，因此在进入schedule后，不会再次将其加入到rq队列，也就是说initproc需要睡眠了。什么时候睡醒呢？等子进程userproc运行结束后再将其唤醒。

9. userproc进程运行user_main，加载ELF文件并运行之。运行完毕，则调用do_exit，在do_exit中，将自己的state设置为Zombie，然后调用wakeup_proc来唤醒initproc，这时会将initproc加入到rq队列，因此rq队列又有一个进程在等待了。接着调用schedule，选择刚加入的initproc来运行，rq队列再次变空。

10. initproc回收子进程userproc的资源后，打印一些字符串信息，然后退出init_main，接下来进入do_exit，do_exit调用panic，panic停留在kmonitor界面一直等待用户输入。

#### 设计实现“多级反馈队列调度算法”
暂时不会做。。

## 练习2: 实现 Stride Scheduling 调度算法（需要编码）

### 题目
首先需要换掉RR调度器的实现，即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride调度器的相关描述，完成Stride调度算法的实现。后面的实验文档部分给出了Stride调度算法的大体描述。这里给出Stride调度算法的一些相关的资料（目前网上中文的资料比较欠缺）。你也可GOOGLE “Stride Scheduling” 来查找相关资料。
[strid-shed paper location1](http://wwwagss.informatik.uni-kl.de/Projekte/Squirrel/stride/node3.html)
[strid-shed paper location2](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.138.3502&rank=1)

执行：make grade。如果所显示的应用程序检测都输出ok，则基本正确。如果只是priority.c过不去，可执行 make run-priority 命令来单独调试它。大致执行结果可看附录。（使用的是qemu-1.0.1 ） 。

请在实验报告中简要说明你的设计实现过程。

### 解答

#### 我的设计实现过程

1. 为了保留Round Robin和Stride两种调度算法，我并没有用default_sched_stride_c覆盖default_sched.c，而是保留两个文件，只是修改sched_init中绑定调度器的地方，将调度器绑定为stride_sched_class。

2. stride_init：初始化RUNNABLE链表run_list（其实Stride Scheduling如果使用优先级队列时，不需要用到run_list，但这里还是一并初始化），初始化运行队列的运行池lab6_run_pool为空，初始化RUNNABLE进程数目为0.

3. stride_enqueue：该函数将一个进程添加到运行队列。调用skew_heap_insert，将运行队列rq的运行进程池与新进程proc合并；将新进程的时间片初始化为最大值，关联proc->rq到rq，最后将rq的进程数目加1.

4. stride_dequeue：该函数从运行队列中删除一个进程。只需调用skew_heap_remove，将进程proc从运行队列rq中删除，并取消proc->rq到rq的关联，最后将rq的进程数目减1.

5. stride_pick_next：选择下一个要调度的进程，其实就保存在运行队列的头部。因此只需要调用le2proc根据rq->lab6_run_pool找到对应进程的地址，然后要更新对应进程的stride。

6. stride_proc_tick：如果进程的时间片大于0，则将其减1。减1后如果等于0，则设置need_resched为1，表示该进程需要被调度出去。

#### 代码优化

答案的代码中用调试宏开关来同时提供优先级队列和链表两种实现方式，可以参考。

## 扩展练习 Challenge 1 ：实现 Linux 的 CFS 调度算法（待完成）
在ucore的调度器框架下实现下Linux的CFS调度算法。可阅读相关Linux内核书籍或查询网上资料，可了解CFS的细节，然后大致实现在ucore中。

## 扩展练习 Challenge 2 ：实现更多基本调度算法（待完成）
在ucore上实现尽可能多的各种基本调度算法(FIFO, SJF,...)，并设计各种测试用例，能够定量地分析出各种调度算法在各种指标上的差异，说明调度算法的适用范围。
