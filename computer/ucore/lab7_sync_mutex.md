# 《ucore lab7》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1: 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题（不需要编码）

### 题目

完成练习0后，建议大家比较一下（可用meld等文件diff比较软件） 个人完成的lab6和练习0完成后的刚修改的lab7之间的区别，分析了解lab7采用信号量的执行过程。执行 make grade ，大部分测试用例应该通过。

请在实验报告中给出内核级信号量的设计描述，并说明其大致执行流程。

请在实验报告中给出给用户态进程/线程提供信号量机制的设计方案，并比较说明给内核级提供信号量机制的异同。

### 解答

#### 1 描述内核级信号量的设计及执行流程

1. 信号量结构体的定义如下。可见，信号量结构体由共享变量value和等待队列wait_queue构成，其中wait_queue是一个链表（为简便起见，下文简称为wq）。
```
typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;
```

2. 信号量初始化。将value设置为输入的值，将wq初始化为空链表。
```
void sem_init(semaphore_t *sem, int value) {
    sem->value = value;
    wait_queue_init(&(sem->wait_queue));
}
```

3. 等待队列wq的每个元素均为wait_t结构，其中proc字段用来标记当前等待元素对应的进程，wait_queue用来标识当前等待元素所在的等待队列wq，wait_link用来建立当前等待元素与等待队列wq的链接。
```
typedef struct {
    struct proc_struct *proc;
    uint32_t wakeup_flags;
    wait_queue_t *wait_queue;
    list_entry_t wait_link;
} wait_t;
```

4. up操作。进行up操作前需要暂时屏蔽中断。如果等待队列wq没有元素，则将value加1然后返回，否则唤醒wq的首元素，即将其从wq中删除，然后将对应进程加入RUNNABLE队列。疑问：如果等待队列非空，为什么不需要将value加1？答：这和down是对称的。如果wq非空，意味着value <= 0，更具体地说，wq中的每个元素在执行down操作时value <= 0，根据down的实现，此时不会将value减1，因此up操作中唤醒一个wq中的元素也不需要将value加1.这和PPT中的实现不太相同，PPT中不管value是多少，up操作开头就加1，down操作开头就减1.但两种实现都是有效的。
```
    if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
        sem->value ++;
    }
    else {
        assert(wait->proc->wait_state == wait_state);
        wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
    }
```

5. down操作。进行down操作前同样暂时屏蔽中断。如果value大于0，则将其减1，然后返回。否则，设置当前进程的state为SLEEPING，并将当前进程加入等待队列，然后调用schedule让出CPU，进入睡眠，等到被唤醒时，再从wq中将其删除。
```
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
```

6. try_down操作。检查value，若大于0，则将value减1，并返回1；若不大于0，则返回0.
```
bool try_down(semaphore_t *sem) {
    bool intr_flag, ret = 0;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --, ret = 1;
    }
    local_intr_restore(intr_flag);
    return ret;
}
```

#### 2 描述基于内核级信号量的哲学家就餐问题的实现

1. 内核线程initproc执行init_main，init_main执行check_sync，check_sync内部测试哲学家就餐问题的解决方案。

2. check_sync分为两部分，初始化解决哲学家就餐问题需要用到的信号量和条件变量。现在只关注信号量部分。首先调用sem_init初始化信号量，将信号量的value设置为1、wq初始化为空，然后调用kernel_thread创建了5个使用信号量的内核线程。

3. 这5个使用信号量的内核线程的执行函数都是philosopher_using_semaphore。在philosopher_using_semaphore开头首先打印哲学家ID，然后进行4次循环，即进行4次思考和吃饭。首先哲学家思考10个ticks，这通过调用do_sleep来模拟。do_sleep首先将当前进程的state设置为SLEEPING，然后为进程创建一个expires为10 ticks的定时器，并添加到定时器列表中，最后调用schedule让出CPU给其他进程。

4. 10个ticks过去后，思考完毕，哲学家调用phi_take_forks_sema尝试拿起两把叉子。为了保护state_sema和s被互斥访问，设置了互斥量mutex。因此， phi_take_forks_sema对mutex执行down操作，进入临界区，然后将自己的state_sema标记为HUNGRY，接着调用phi_test_sema来检查是否能拿到两只叉子。若能拿到，则将自己的state_sema标记为EATING，然后离开临界区，开始吃饭，时间同样为10个ticks；若不能拿到，则通过对s[i]执行down操作而堵塞。

5. 10个ticks过去后，吃饭完毕，哲学家调用phi_put_forks_sema把两把叉子同时放回桌子。同样，为了保护state_sema和s被互斥访问，phi_put_forks_sema先对mutex执行down操作，进入临界区，然后将自己的state_sema标记为THINKING，接着两次调用phi_test_sema来检查左右邻居是否能进餐。若能就餐，则对s[i]执行up操作，这时会唤醒其他哲学家。等到哲学家离开临界区、进入下一次的思考后，会发生进程切换，使得其他哲学家可以就餐。

#### 3 输出结果
输出结果如下所示。下面简单分析下从开始到5位哲学家均完成第一次就餐的执行过程。

```
I am No.0 philosopher_sema
Iter 1, No.0 philosopher_sema is thinking
I am No.1 philosopher_sema
Iter 1, No.1 philosopher_sema is thinking
I am No.2 philosopher_sema
Iter 1, No.2 philosopher_sema is thinking
I am No.3 philosopher_sema
Iter 1, No.3 philosopher_sema is thinking
I am No.4 philosopher_sema
Iter 1, No.4 philosopher_sema is thinking
I am the child.
waitpid 8 ok.
exit pass.
Iter 1, No.0 philosopher_sema is eating
Iter 1, No.2 philosopher_sema is eating
Iter 2, No.0 philosopher_sema is thinking
Iter 1, No.4 philosopher_sema is eating
Iter 2, No.2 philosopher_sema is thinking
Iter 1, No.1 philosopher_sema is eating
Iter 2, No.4 philosopher_sema is thinking
Iter 1, No.3 philosopher_sema is eating
Iter 2, No.1 philosopher_sema is thinking
Iter 2, No.0 philosopher_sema is eating
Iter 2, No.3 philosopher_sema is thinking
Iter 2, No.2 philosopher_sema is eating
Iter 3, No.0 philosopher_sema is thinking
Iter 2, No.4 philosopher_sema is eating
Iter 3, No.2 philosopher_sema is thinking
Iter 2, No.1 philosopher_sema is eating
Iter 3, No.4 philosopher_sema is thinking
Iter 2, No.3 philosopher_sema is eating
Iter 3, No.1 philosopher_sema is thinking
Iter 3, No.0 philosopher_sema is eating
Iter 3, No.3 philosopher_sema is thinking
Iter 3, No.2 philosopher_sema is eating
Iter 4, No.0 philosopher_sema is thinking
Iter 3, No.4 philosopher_sema is eating
Iter 4, No.2 philosopher_sema is thinking
Iter 3, No.1 philosopher_sema is eating
Iter 4, No.4 philosopher_sema is thinking
Iter 3, No.3 philosopher_sema is eating
Iter 4, No.1 philosopher_sema is thinking
Iter 4, No.0 philosopher_sema is eating
Iter 4, No.3 philosopher_sema is thinking
Iter 4, No.2 philosopher_sema is eating
No.0 philosopher_sema quit
Iter 4, No.4 philosopher_sema is eating
No.2 philosopher_sema quit
Iter 4, No.1 philosopher_sema is eating
No.4 philosopher_sema quit
Iter 4, No.3 philosopher_sema is eating
No.1 philosopher_sema quit
No.3 philosopher_sema quit
```
1. check_sync调用kernel_thread创建了5个哲学家线程，它们依次进入RUNNABLE队列rq中，此时rq中的元素从头到尾依次是：0,1,2,3,4.

2. 哲学家0首先被执行，进入philosopher_using_semaphore，打印自己的ID，然后开始思考（调用do_sleep来延时）。哲学家1~4执行类似过程，最终rq为空，timer依次为0,1,2,3,4.

3. 哲学家0的延时最先结束，因此回到philosopher_using_semaphore继续执行，接下来是拿起两只叉子，由于哲学家0是第一个拿叉子的，可以畅通无阻地拿起叉子吃饭（调用do_sleep来延时）。此时只有哲学家0占用叉子，rq为空，timer依次为1,2,3,4,0.

4. 接着哲学家1的延时结束，同样试图拿起两把叉子，发现左边的叉子被哲学家0拿了，因此无法吃饭，只好把自己的state标志为SLEEPING，然后对s[1]执行down操作，把自己添加到s[1]->wq中，并调用schedule让出CPU。此时只有哲学家0占用叉子，rq为空，timer依次为2,3,4,0.

5. 哲学家2～4的过程类似，其中哲学家2可以拿起叉子吃饭，哲学家3和4吃不了饭，均通过down操作进入堵塞状态。此时哲学家0和2占用叉子，rq为空，timer依次为0,2.

6. 哲学家0的延时再次结束，这时他同时放下两把叉子，并且检查到左边的哲学家4满足就餐条件，因此对s[4]执行up操作，从而把哲学家4唤醒；检查到右边的哲学家1不满足就餐条件（1右边的叉子还被2占用），因此不做处理。最后哲学家0进行下一轮的思考。此时只有哲学家2占用叉子，rq为4，timer为2,0.

7. 由于哲学家4已被唤醒，哲学家1和3被堵塞，因此接下来是哲学家4继续运行，此时rq清空。这里会不会出现哲学家2的延时结束后先于哲学家4运行呢？不会，因为即使哲学家2的定时结束了，也要先加入rq等待调度。哲学家4拿起叉子，开始吃饭。此时哲学家2和4占用叉子，rq为空，timer为2,0,4.

8. 哲学家2的延时结束后重新执行，首先检查到左边的哲学家1满足就餐条件，因此对s[1]执行up操作，从而把哲学家1唤醒。然后检查到右边的哲学家3不满足就餐条件（3右边的叉子被4占用），因此不做处理。最后哲学家2进行下一轮的思考。此时只有哲学家4占用叉子，rq为1，timer为0,4,2.

9. 哲学家1被唤醒，开始拿起叉子吃饭。此时哲学家1和4在用叉子，rq为空，timer为0,4,2,1.

10. 哲学家0的延时结束后，试图拿起叉子吃饭，但左右叉子均被占用，因此被堵塞。此时哲学家1和4占用叉子，rq为空，timer为4,2,1.

11. 哲学家4的延时结束后，同时放下2个叉子，然后检查左边的哲学家3满足就餐条件，因此对s[3]执行up操作，从而把哲学家3唤醒。再检查右边的哲学家0，发现不满足就餐条件，因此不作处理。最后哲学家4进行下一轮的思考。此时只有哲学家1占用叉子，rq为3，timer为2,1,4.

12. 哲学家3被唤醒，开始拿起叉子吃饭。此时哲学家1和3在用叉子，rq为空，timer为2,1,4,3. 后续执行流程类似，不再赘述。

#### 4 描述给用户态进程/线程提供信号量机制的设计方案，并与内核级做对比（待完成）


## 练习2: 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题（需要编码）

### 题目
首先掌握管程机制，然后基于信号量实现完成条件变量实现，然后用管程机制实现哲学家就餐问题的解决方案（基于条件变量） 。执行： make grade 。如果所显示的应用程序检测都输出ok，则基本正确。如果只是某程序过不去，比如matrix.c，则可执行 make run-matrix命令来单独调试它。大致执行结果可看附录。

请在实验报告中给出内核级条件变量的设计描述，并说明其大致执行流程。

请在实验报告中给出给用户态进程/线程提供条件变量机制的设计方案，并比较说明给内核级提供条件变量机制的异同。

请在实验报告中回答：能否不用基于信号量机制来完成条件变量？如果不能，请给出理由，如果能，请给出设计说明和具体实现。

### 解答

#### 1 描述内核级条件变量的设计及执行流程

1. 条件变量的结构体定义如下。主要是一个信号量sem、一个表示等待条件变量的进程数目count，而owner用来寻找条件变量所属的管程。
```
typedef struct condvar {
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;
```

2. 条件变量的主要操作有2个：wait和signal。wait用于进程因无法获取所需的资源时而将自己堵塞，signal用于另一个进程释放或生成相关资源后通知之前处于wait状态的进程而解除堵塞。cond_wait的实现如下所示。首先将count加1，表示自己将要等待条件变量。然后判断管程的next_count是否大于0.此时未完全理解，大致分析一下：如果next_count大于0，说明是其他进程执行signal操作而将自己唤醒、并让出CPU给自己执行的，因此这里需要对管程的next信号量执行up操作，把发布signal信号的进程唤醒，不然对方将一直堵塞。如果next_count不大于0，说明没人因发布signal信号而堵塞，这时只需对管程的mutex执行up操作而退出临界区。接着对sem执行down操作，堵塞自己，让出CPU给其他进程。等到其他进程发布signal信号而唤醒本进程时，再将count减1，表示自己不再等待条件变量。
```
    cvp->count++;
    if (cvp->owner->next_count > 0)
    {
        up(&cvp->owner->next);
    }
    else
    {
        up(&cvp->owner->mutex);
    }

    down(&cvp->sem);
    cvp->count--;
```

3. cond_signal的实现如下所示。首先判断count是否大于0，若否则说明没有进程在等待条件变量，因此不作任何处理。若是，则说明有进程在等待条件变量，首先将管程的next_count加1，表示自己由于发布signal给其他进程解堵塞而将自己堵塞，然后对sem执行up操作，从而把之前等待信号量sem的进程唤醒，然后对管程的next执行down操作，从而将自己堵塞。等到其他进程唤醒本进程后，在将管程的next_count减1，表示自己不再等待next信号量。
```
    if (cvp->count > 0)
    {
        cvp->owner->next_count++;
        up(&cvp->sem);
        down(&cvp->owner->next);
        cvp->owner->next_count--;
    }
```

#### 2 用管程机制（基于条件变量）解决哲学家就餐问题

原代码中已经提供哲学家就餐问题的大部分实现，再结合注释不难完成剩下的编码。无论是用管程还是信号量，此问题的框架是相同的：哲学家都是先思考一段时间，然后拿起叉子吃饭，吃了一段时间后，放下叉子继续思考，如此反复。思考和吃饭的过程都通过do_sleep来实现，实际上就是利用定时器进行延时。因此，主要的差别在于拿叉子和放叉子两个功能的实现。

1. 拿叉子（phi_take_forks_condvar）：首先对管程的mutex执行down操作进入临界区，这是确保任何时候最多只有一个进程进入管程。然后将自己的state设置为HUNGRY。接着测试是否满足就餐条件：自己的state是HUNGRY，而且左右的哲学家的state都不是EATING。如果满足，则将自己的state设置为EATING，然后对管程的mutex执行up操作而退出临界区，从而完成拿叉子操作。如果不满足就餐条件，则调用cond_wait将自己堵塞。

2. 放叉子（phi_put_forks_condvar）：同样，首先对管程的mutex执行down操作进入临界区，然后将自己的state设置为THINKING。接下来测试左右哲学家是否满足就餐条件，若满足，则调用cond_signal将对应进程唤醒，而把自己堵塞。

#### 3 输出结果
输出结果如下所示。下面简单分析从开始到5位哲学家均完成第一次就餐的执行流程。
```
Iter 1, No.0 philosopher_condvar is thinking
I am No.1 philosopher_condvar
Iter 1, No.1 philosopher_condvar is thinking
I am No.2 philosopher_condvar
Iter 1, No.2 philosopher_condvar is thinking
I am No.3 philosopher_condvar
Iter 1, No.3 philosopher_condvar is thinking
I am No.4 philosopher_condvar
Iter 1, No.4 philosopher_condvar is thinking
Iter 1, No.0 philosopher_condvar is eating
Iter 1, No.2 philosopher_condvar is eating
Iter 1, No.4 philosopher_condvar is eating
Iter 2, No.0 philosopher_condvar is thinking
Iter 1, No.1 philosopher_condvar is eating
Iter 2, No.2 philosopher_condvar is thinking
Iter 1, No.3 philosopher_condvar is eating
Iter 2, No.4 philosopher_condvar is thinking
Iter 2, No.1 philosopher_condvar is thinking
Iter 2, No.0 philosopher_condvar is eating
Iter 2, No.2 philosopher_condvar is eating
Iter 2, No.3 philosopher_condvar is thinking
Iter 2, No.4 philosopher_condvar is eating
Iter 3, No.0 philosopher_condvar is thinking
Iter 2, No.1 philosopher_condvar is eating
Iter 3, No.2 philosopher_condvar is thinking
Iter 2, No.3 philosopher_condvar is eating
Iter 3, No.4 philosopher_condvar is thinking
Iter 3, No.0 philosopher_condvar is eating
Iter 3, No.1 philosopher_condvar is thinking
Iter 3, No.2 philosopher_condvar is eating
Iter 3, No.3 philosopher_condvar is thinking
Iter 3, No.4 philosopher_condvar is eating
Iter 4, No.0 philosopher_condvar is thinking
Iter 3, No.1 philosopher_condvar is eating
Iter 4, No.2 philosopher_condvar is thinking
Iter 3, No.3 philosopher_condvar is eating
Iter 4, No.4 philosopher_condvar is thinking
Iter 4, No.0 philosopher_condvar is eating
Iter 4, No.1 philosopher_condvar is thinking
Iter 4, No.2 philosopher_condvar is eating
Iter 4, No.3 philosopher_condvar is thinking
Iter 4, No.4 philosopher_condvar is eating
No.0 philosopher_condvar quit
Iter 4, No.1 philosopher_condvar is eating
No.2 philosopher_condvar quit
Iter 4, No.3 philosopher_condvar is eating
No.4 philosopher_condvar quit
No.1 philosopher_condvar quit
No.3 philosopher_condvar quit
```

1. 内核线程initproc调用check_sync检查使用管程来解决哲学家就餐问题的方案。check_sync首先调用monitor_init初始化管程，然后调用kernel_thread创建5个内核线程，分别对应5位哲学家，并先将5位哲学家的state初始化为THINKING。此时无人占用叉子，RUNNABLE队列rq的元素依次为0,1,2,3,4，timer为空。

2. 5个哲学家线程依次执行philosopher_using_condvar，打印自己的ID，然后开始思考（实际上是调用do_sleep进行延时）。此时无人占用叉子，rq为空，timer依次是0,1,2,3,4.

3. 哲学家0的延时最先结束，调用phi_take_forks_condvar试图拿起2把叉子就餐，整个过程如下：对mtp->mutex执行down操作进入临界区（以保证互斥执行此函数），将自己的state设置为HUNGRY，调用phi_test_condvar拿到2把叉子，将自己的state改为EATING，调用cond_signal唤醒之前由于执行cond_wait而堵塞的进程（由于没有，此处啥也没做）。然后对mtp->mutex执行up操作而离开临界区，开始吃饭（实际上是调用do_sleep来延时）。此时哲学家0占用叉子，rq为空，timer是1,2,3,4,0.

4. 接着哲学家1延时结束，同样调用phi_take_forks_condvar试图拿起2把叉子就餐，但由于左边的叉子正在被哲学家0占用，哲学家1只能调用cond_wait进行等待。具体而言包括3步：将mtp->cv[1]->count加1，表示自己要等待该条件变量，然后对mtp->mutex执行up操作而离开临界区，最后对mtp->cv[1]->sem执行down操作而堵塞。此时哲学家0占用叉子，rq为空，timer是2,3,4,0.

5. 哲学家2的执行过程与哲学家0相同，哲学家3、4的执行过程和哲学家1相同。最终，哲学家0和2占用叉子，rq为空，timer为0,2。

6. 哲学家0延时结束，调用phi_put_forks_condvar同时放下2把叉子。首先对mtp->mutex执行down操作而进入临界区，将自己的state修改为THINKING，然后调用phi_test_condvar检查左右的哲学家状态。首先检查到左边的哲学家4满足就餐条件，于是将哲学家4的state修改为EATING，并对mtp->cv[4]执行cond_signal以唤醒哲学家4.具体而言包括3步：将mtp->next_count加1，表示唤醒哲学家4后自己要进入等待状态，然后对mtp->cv[4]->sem执行up操作，这将唤醒哲学家4，最后对mtp->next执行down操作而堵塞。这时哲学家2占用叉子，rq为4，timer为2.

7. 哲学家4被唤醒后，退出cond_wait，对mtp->next执行up操作，从而将哲学家0唤醒。然后哲学家4开始吃饭。（这里可以看到管程的“临时退出临界区”的特点：上一步中哲学家0进入临界区，发现哲学家4满足就餐条件后，将其唤醒，让哲学家4临时进入临界区吃饭，最后哲学家4再把哲学家0唤醒，让哲学家0继续执行。）此时哲学家2和4占用叉子，rq为0，timer为2,4.

8. 哲学家0继续检查右边的哲学家1，发现其不满足就餐条件，不作处理，然后对mtp->mutex执行up操作而退出临界区。最后哲学家0进入下一轮的思考。此时哲学家2和4占用叉子，rq为空，timer为2,4,0.

9. 哲学家2延时结束，调用phi_put_forks_condvar同时放下2把叉子。其执行流程与步骤6类似，只是哲学家2唤醒的是哲学家1.此时哲学家4占用叉子，rq为1，timer为4,0.

10. 哲学家1被唤醒后的执行流程与步骤7类似：退出cond_wait，对mtp->next执行up操作，从而将哲学家2唤醒。然后哲学家1开始吃饭。此时哲学家1和4占用叉子，rq为2，timer为4,0,1.

11. 哲学家2被唤醒后的执行流程与步骤8类似：继续检查出右边的哲学家3，发现其不满足就餐条件，不作处理，然后对mtp->mutex执行up操作而退出临界区。最后哲学家2进入下一轮的思考。此时哲学家1和4占用叉子，rq为空，timer为4,0,1.

12. 哲学家4延时结束，调用phi_put_forks_condvar同时放下2把叉子，其执行流程与步骤6类似：首先检查到左边的哲学家3满足就餐条件，于是将其唤醒，并将自己堵塞。此时哲学家1占用叉子，rq为3，timer为0,1.

13. 哲学家3被唤醒后的执行流程与步骤7类似：退出cond_wait，对mtp->next执行up操作，从而将哲学家4唤醒。然后哲学家3开始吃饭。此时哲学家1和3占用叉子，rq为4，timer为0,1,3.

#### 4 描述给用户态进程/线程提供条件变量机制的设计方案，并与内核级做对比（待完成）

#### 5 回答问题：能否不用基于信号量机制来完成条件变量（待完成）

## 扩展练习 Challenge ： 在ucore中实现简化的死锁和重入探测机制（待实现）

### 题目
在ucore下实现一种探测机制，能够在多进程/线程运行同步互斥问题时，动态判断当前系统是否出现了死锁产生的必要条件，是否产生了多个进程进入临界区的情况。 如果发现，让系统进入monitor状态，打印出你的探测信息。

## 扩展练习 Challenge ： 参考Linux的RCU机制，在ucore中实现简化的RCU机制

### 题目
在ucore 下实现Linux的RCU同步互斥机制。可阅读相关Linux内核书籍或查询网上资料，可了解RCU的设计实现细节，然后简化实现在ucore中。 要求有实验报告说明你的设计思路，并提供测试用例。参考资料： [Linux 2.6内核中新的锁机制--RCU](http://www.ibm.com/developerworks/cn/linux/l-rcu/)

