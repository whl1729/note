# 《Tsinghua os mooc》第17~20讲 同步互斥、信号量、管程、死锁

## 第十七讲 同步互斥

1. 进程并发执行
    - 好处1：共享资源。比如：多个用户使用同一台计算机。
    - 好处2：加速。I/O操作和CPU计算可以重叠（并行）。
    - 好处3：模块化。
        - 将大程序分解成小程序。以编译为例，gcc会调用cpp，cc1，cc2，as，ld。
        - 使系统易于复用和扩展。程序可划分成多个模块放在多个处理器上并行执行。

2. 原子操作
    - 原子操作是指一次不存在任何中断或失败的操作。要么操作成功完成，或者操作没有执行，不会出现部分执行的状态。
    - 操作系统需要利用同步机制在并发执行的同时，保证一些操作是原子操作。

3. 由于不是原子操作而带来错误的一个例子：并发创建新进程时的标识分配。如下面，标识分配用C语言表达是一个语句，翻译成机器指令后是4条机器指令。假设next_pid开始是100，有两个进程A和B，如果进程A执行完前2条机器指令后，CPU切换到进程B执行完4条机器指令，再切回A执行完后2条指令。那么，进程A和B分配到的new_pid都是101，而next_pid最后也被更新为101，显然出现了Bug。
```
// C code
new_pid = next_pid++

// Machine Code
LOAD next_pid Reg1
STORE Reg1 new_pid
INC Reg1
STORE Reg1 next_pid
```

4. 利用两个原子操作实现一个锁(lock)
    - Lock.Acquire()：在锁被释放前一直等待，然后获得锁；如果两个线程都在等待同一个锁，并且同时发现锁被释放了，那么只有一个能够获得锁。
    - Lock.Release()：解锁并唤醒任何等待中的进程。
```
breadlock.Acquire();  // 进入临界区
if (nobread) {        // 临
  buy bread;          // 界
 }                    // 区
breadlock.Release();  // 退出临界区
```

5. 进程的交互关系：相互感知程度
    - 相互不感知（完全不了解其它进程的存在）：进程之间相互独立，一个进程的操作对其他进程的结果无影响
    - 间接感知（双方都与第三方交互，如共享资源）：进程之间通过共享来协作，一个进程的结果依赖于共享资源的状态
    - 直接感知（双方直接交互，如通信）：进程之间通过通信来协作，一个进程的结果依赖于从其他进程获得的信息

6. 进程的交互关系
    - 互斥 ( mutual exclusion ) ：一个进程占用资源，其它进程不能使用
    - 死锁（deadlock）：多个进程各占用部分资源，形成循环等待
    - 饥饿（starvation）：其他进程可能轮流占用资源，一个进程一直得不到资源

7. 临界区(Critical Section)
    - 临界区(critical section)：进程中访问临界资源的一段需要互斥执行的代码
    - 进入区(entry section)：检查可否进入临界区的一段代码。如可进入，设置相应"正在访问临界区"标志
    - 退出区(exit section)：清除“正在访问临界区”标志
    - 剩余区(remainder section)：代码中的其余部分
```
entry section
   critical section
exit section
   remainder section
```

8. 临界区的访问规则
    - 空闲则入：没有进程在临界区时，任何进程可进入
    - 忙则等待：有进程在临界区时，其他进程均不能进入临界区
    - 有限等待：等待进入临界区的进程不能无限期等待
    - 让权等待（可选）：不能进入临界区的进程，应释放CPU（如转换到阻塞状态）

9. 临界区的实现方法
    - 禁用中断（仅适用于单处理器）
    - 软件方法（复杂）
    - 更高级的抽象方法（单处理器或多处理器均可）

10. 临界区的硬件实现方法：禁用硬件中断
    - 没有中断，没有上下文切换，因此没有并发。硬件将中断处理延迟到中断被启用之后，现代计算机体系结构都提供指令来实现禁用中断
    - 进入临界区：禁止所有中断，并保存标志 
    - 离开临界区：使能所有中断，并恢复标志
    - 缺点：禁用中断后，进程无法被停止，整个系统都会为此停下来，可能导致其他进程处于饥饿状态；临界区可能很长，无法确定响应中断所需的时间（可能存在硬件影响）
    - 要小心地用
```
local_irq_save(unsigned long flags);
critical section
local_irq_restore(unsigned long flags);
```

11. 临界区的软件实现方法之一：Peterson算法
    - 共享变量
    ```
    int turn;  // 表示该谁进入临界区
    boolean flag[];  // 表示进程是否准备好进入临界区
    ```
    - 代码实现
```
do {
    flag[i] = true;
    turn = j;
    while ( flag[j] && turn == j);
        CRITICAL SECTION

    flag[i] = false;

        REMAINDER SECTION
   } while (true);
```

12. 临界区的软件实现方法之二（支持多个进程）：Dekkers算法
```
flag[0]:= false; flag[1]:= false; turn:= 0;//or1

do {
    flag[i] = true;
    while flag[j] == true {
        if turn ≠ i {
            flag[i] := false
            while turn ≠ i { }
            flag[i] := true
        }
    }
    CRITICAL SECTION
    turn := j
    flag[i] = false;
    EMAINDER SECTION
   } while (true);
```

13. 临界区的软件实现方法之三：N线程的软件方法（Eisenberg和McGuire）
    - 线程Ti要等待从turn到i-1的线程都退出临界区后访问临界区
    - 线程Ti退出时，把turn改成下一个请求线程

14. 基于软件的解决方法的分析
    - 复杂：需要两个进程间的共享数据项
    - 需要忙等待：浪费CPU时间

15. 临界区的更高级的抽象实现方法：操作系统提供更高级的编程抽象来简化进程同步，例如锁、信号量，而它们是基于硬件提供的同步原语来构建的，比如中断禁用、原子操作指令等。

16. 锁是一个抽象的数据结构
    - 一个二进制变量（锁定/解锁）
    - Lock::Acquire()：原子操作。锁被释放前一直等待，然后得到锁
    - Lock::Release()：原子操作。释放锁，唤醒任何等待的进程
    - 使用锁来控制临界区访问
```
lock_next_pid->Acquire();
new_pid = next_pid++ ;
lock_next_pid->Release();
```

17. 原子操作指令
    - 现代CPU体系结构都提供一些特殊的原子操作指令
    - 测试和置位（Test-and-Set ）指令：从内存单元中读取值，测试该值是否为1（然后返回真或假），将内存单元值设置为1
    ```
    boolean TestAndSet (boolean *target)
    {
        boolean rv = *target;
        *target = true;
        return rv:
    }
    ```
    - 交换指令（exchange）：交换内存中的两个值
    ```
    void Exchange (boolean *a, boolean *b)
    {
        boolean temp = *a;
        *a = *b;
        *b = temp:
    }
    ```

18. 使用TS指令实现自旋锁(spinlock)
    - 如果锁被释放，那么TS指令读取0并将值设置为1，锁被设置为忙并且需要等待完成
    - 忙则等待。如果锁处于忙状态，那么TS指令读取1并将值设置为1，不改变锁的状态并且需要循环
    - 线程在等待的时候消耗CPU时间
    ```
    class Lock {
        int value = 0;
    }

    Lock::Acquire() {
       while (test-and-set(value))
          ; //spin
    }

    Lock::Release() {
        value = 0;
    }
    ```

19. 无忙等待锁
    ```
    class Lock {
       int value = 0;
       WaitQueue q;
    }

    Lock::Acquire() {
       while (test-and-set(value)) {
          add this TCB to wait queue q;
          schedule();
       }
    }

    Lock::Release() {
       value = 0;
       remove one thread t from q;
       wakeup(t);
    }
    ```

20. 原子操作指令锁的特征
    - 优点
        - 适用于单处理器或者共享主存的多处理器中任意数量的进程同步
        - 简单并且容易证明
        - 支持多临界区
    - 缺点
        - 忙等待消耗处理器时间
        - 可能导致饥饿、进程离开临界区时有多个等待进程的情况
        - 死锁：拥有临界区的低优先级进程请求访问临界区，而高优先级进程获得处理器并等待临界区

## 第十八讲 信号量与管程

1. 自旋锁、互斥锁、条件变量、信号量
    - 自旋锁：一直尝试加锁，只要没有锁上，就不断尝试。
    - 互斥锁：尝试加锁，如果没有锁上，则让出CPU给其他进程使用，等到锁的状态发生变化时再唤醒该进程。涉及到上下文切换，因此操作开销比自旋锁大。
    - 条件变量：与互斥锁不同，条件变量是用来等待而不是用来上锁的。条件变量用来自动阻塞一个线程，直到某特殊情况发生为止。条件变量是在多线程程序中用来实现“等待->唤醒”逻辑常用的方法。通常条件变量和互斥锁同时使用。
    - 信号量：是一种更高级的同步机制，mutex可以说是semaphore在仅取值0/1时的特例。Semaphore可以有更多的取值空间，用来实现更加复杂的同步，而不单单是线程间互斥。信号量的主要用途是调度线程，具体而言就是：一些线程生产（increase）同时另一些线程消费（decrease），semaphore可以让生产和消费保持合乎逻辑的执行顺序。
    - [互斥锁，同步锁，临界区，互斥量，信号量，自旋锁之间联系是什么？ - Tim Chen的回答 - 知乎](https://www.zhihu.com/question/39850927/answer/83409955)
    - [如何理解互斥锁、条件锁、读写锁以及自旋锁？ - 邱昊宇的回答 - 知乎](https://www.zhihu.com/question/66733477/answer/246535792)
    - [semaphore和mutex的区别？ - 二律背反的回答 - 知乎](https://www.zhihu.com/question/47704079/answer/135859188)

2. 信号量 vs 软件同步
    - 信号量是操作系统提供的一种协调共享资源访问的方法。OS是管理者，地位高于进程。
    - 软件同步是平等线程间的一种同步协商机制。

3. 信号量
    - 早期的操作系统的主要同步机制，现在已很少使用。
    - 信号量是一种抽象数据类型，由一个整形 (sem)变量和两个原子操作组成。
    - P()：Prolaag （荷兰语尝试减少），sem减1，如sem<0, 进入等待, 否则继续
    - V()：(Verhoog （荷兰语增加）)，sem加1
    - 信号量是被保护的整数变量，初始化完成后，只能通过P()和V()操作修改，由操作系统保证，P/V操作是原子操作
    - P() 可能阻塞，V()不会阻塞
    - 通常假定信号量是“公平的”，线程不会被无限期阻塞在P()操作，假定信号量等待按先进先出排队

4. 信号量的实现
```
classSemaphore {
    int sem;
    WaitQueue q;
}

Semaphore::P() {
    sem--;
    if (sem < 0) {
        Add this thread t to q;
        block(p);
    }
}

Semaphore::V() {
    sem++; 
    if (sem<=0) {
        Remove a thread t from q;
        wakeup(t);        
    }
}
```

5. 信号量分类
    - 二进制信号量：资源数目为0或1
    - 资源信号量:资源数目为任何非负值
    - 两者等价，基于一个可以实现另一个

6. 信号量的使用
    - 互斥访问：临界区的互斥访问控制
        - 每个临界区设置一个信号量，其初值为1
        - 必须成对使用P()操作和V()操作，P()操作保证互斥访问临界资源，V()操作在使用后释放临界资源，P/V操作不能次序错误、重复或遗漏
    - 条件同步：线程间的事件等待
        - 每个条件同步设置一个信号量，其初值为0

7. 生产者-消费者问题
    - 一个或多个生产者在生成数据后放在一个缓冲区里
    - 单个消费者从缓冲区取出数据处理
    - 任何时刻只能有一个生产者或消费者可访问缓冲区

8. 用信号量解决生产者-消费者问题
```
Class BoundedBuffer {
    mutex = new Semaphore(1);  // 二进制信号量
    fullBuffers = new Semaphore(0);   // 资源信号量
    emptyBuffers = new Semaphore(n);  // 资源信号量
}

BoundedBuffer::Deposit(c) {
    emptyBuffers->P();
    mutex->P();
    Add c to the buffer;
    mutex->V();
    fullBuffers->V();
}

BoundedBuffer::Remove(c) {
    fullBuffers->P();
    mutex->P();
    Remove c from buffer;
    mutex->V();
    emptyBuffers->V();
}
```

9. 使用信号量的困难
    - 读/开发代码比较困难，程序员需要能运用信号量机制
    - 容易出错，如使用的信号量已经被另一个线程占用、忘记释放信号量等
    - 不能够处理死锁问题

3. 管程
    * 采用面向对象方法，简化了线程间的同步控制
    * 任一时刻最多只有一个线程执行管程代码
    * 正在管程中的线程可临时放弃管程的互斥访问，等待事件出现时恢复

5. 哲学家问题

## 第二十讲 死锁与进程通信

1. 目前大多数操作系统不负责死锁处理，因其开销较大。

