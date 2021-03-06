# 912往届真题笔记

## 数据结构

### 2018年
1. 判断
    * 对长度为m=4k+3素数的散列表双平方探测一定能访问其全部元素
    * 没改进的next算法时间复杂度也是O(n)
    * Fib查找时以前后黄金分割点作为轴点的常系数相同
    * PFC(最优前缀编码)互换不同深度节点位置一定会破坏其性质

2. 选择
    * 7阶B-树根节点常驻内存，则对规模为2017的B-树最多需要几次访问
    * 散列长为2017，采用单平方探测，已经存入1000个元素，问此时最多有()个懒惰删除的桶单元
    * 分别按照递增和递减的顺序依次向平衡二叉树插入元素，则存在常数k使n=2^k-1是二者生成的平衡二叉树相等的（充要性）
    * gs[0]=1的概率

3. 给定一个整数序列，求出连续子序列和的最大值
    * 说明算法思路
    * 伪代码描述算法
    * 说明时间复杂度和空间复杂度

### 2017年

1. 请利用图的广度优先遍历找出图中的最小环，若不存在环则输出+oo,要求时间复杂度为o（n\*e）空间复杂度为o（n），最小环即环中边数最少的环。
    * 请描述你的算法思想。
    * 请用伪代码写出算法。
    * 说明你的算法的时间复杂度和空间复杂度。

### 2016年

1. 给出一个程序（应该是 prim 算法），问是否能够构成最小生成树

2. 设计一个算法，把一个中序遍历 ABCD-\*+EF??(后面三个符号忘记了不过不重要)构造成如下图所示的二叉树

3. 求一个数组 A 中连续相同数字的和等于 s 的最长子数组长度，例如 A={1,1,2,1,1,1,2,1}，s=3，则所求子数组长度为 3，要求算法时间复杂度不超过 O(n)， 空间复杂度不超过 O(1)

## 计算机组成原理

### 2018年
1. 判断
    * 提高cpu主频可以加快程序执行速度
    * raid6坏两个磁盘也可以工作	
    * c语言若int x,y 若x>y，则-x<-y

2. 填空
    * -2017的32位补码表示\_\_(16进制或2进制)。
    * -2017的IEEE单精度浮点表示\_\_。
    * 高速缓存器的几种映射方式\_\_、\_\_、\_\_。
    * 处理机\_\_逻辑电路进行算术运算，\_\_逻辑电路用于数据暂存，\_\_逻辑电路用于分支选择。

3. 选择
    * 以下关于五段流水线的处理机说法错误的是 
        * A.多个处理器不会发生结构冲突 
        * B.每个周期执行一个功能
        * C.可以采用微程序或者硬连线设计
        * D.不同的指令执行时间相同
    * 以下说法正确的是
        * A.缓存越大程序执行速度越快
        * B.TLB也是一种缓存数据和指令的缓存器
    * 以下哪个不是响应异常的处理 A.保存pc  B.保存通用寄存器 C.保存异常原因  D.恢复pc
    * 以下哪种不可以解决数据冲突 A.暂停流水线 B.分支预测 C.调整指令顺序 D.数据旁路

4.五段流水线，每段10ns，每个寄存器5ns，以下一段程序(4句)，问执行时间是多少
```
lw xxx
sub xxx
and xxx
or xxx
```

### 2017年
1. DMA使用总线的方式是哪两种？

2. IEEE规格化单精度浮点数能表示的最小正数是什么？

3. 3.30位虚拟地址，28位物理地址，一级页表，页表大小16KB，访问5ns，cache采用直接相连映射，大小64KB,块大小4B，访问5ns，主存访问50ns。访问次序为：访问页表—》访问cache—》访问内存。
    * 虚拟页表脏位1位，有效位1位，问页表大小？
    * cache标志位，索引位，块内地址各多少位？
    * 一次cache命中访问时间，cache失效访问时间，命中率为90%平均访问时间各为多少？
    * 系统进程切换时以下操作是否需要，说明原因
        * 清除cache有效位
        * 将已经调入页表清空
    * 注意到页表访问和cache访问时间相同，能否修改访问方式，使cache和页表一同访问？说明原因，可以的话做出相应设计，并计算cache90%命中率的时候的平均访问时间。

4. 指令流水线可能发生的冲突分类，以及原因。

### 2016年

1. 流水线
    * 要形成一个 4 级流水，应该将三个寄存器安插在那些位置？问该四级流水的延迟和最大吞吐率
    * 为达到最大的吞吐率应该设计成几级流水？ 寄存器应该安插在哪些位置？ 问该流水的延迟和最大吞吐率
    * 如果将上面的部件形成五级流水， 分为取指（F）， 分析（D），执行（E），访存（M），写回（W）五个阶段，每个阶段占一个时钟周期， %edx, %edy %edz %edv 为寄存器。以下三个指令按指令流水进行，为了获得最大吞吐率应进行哪些操作？三条指令一共用了多少个时钟周期？ （每条指令所需要的上一条结果的数据都要等到上一条运算的结果才能进行）
    ```
    MOV 100, %edx
    MOV 200, %edy
    ADD %edx, %edy(具体最后一条实在想不起来)
    ```

## 操作系统

### 2018年
1. 选择题
    * 子进程执行exit()，若未检测到父进程执行wait()，则子进程进入\_\_状态。
    * 当某子进程调用exit()时唤醒父进程，将exit()返回值作为父进程中wait()的返回值
    * 高响应比调度算法的分子是\_\_，分母是\_\_。
    * 优先级反置指的是\_\_抢占了\_\_的资源，\_\_时低优先级进程能动态改变优先级
    * \_\_支持暂时放弃互斥资源访问权，等待信号


2. 判断题
    * 管程就是一个黑箱子，程序员往里面扔函数，同一时间只有一个函数在执行
    * Buddy算法中，释放一个空间后可以根据起始长度和大小与相邻空闲空间合并
    * 如果用户强制使用任务管理器kill一个进程，那么即使它处于就绪状态/阻塞状态，操作系统也要把它变成运行状态
    * 操作系统采用copy on write机制时，fork()函数会复制进程的页目录表
    * 使用自旋锁不能保证进程按先来后到的顺序使用cpu资源
    * 管程和信号量在功能上等价
    * 管程将资源抽象成条件变量，通过变量值的增减来控制进程的访问

3. LRU、BEST、CLOCK、FIFO页面置换算法是否能产生belady异常，若可以举出例子，不可以给出证明(6’)

4. ucore(6’)
    * le2page(\*page,page\_link)语句都需要展开那些宏定义？说明这个语句的含义。

5. 页面4kB，页表项32bit，最大能支持4GB的内存空间，现在有一种新技术能支持64GB空间，这时页表项变成64bit，重新设计页表结构

6. 哲学家就餐问题
    * 上述算法会不会死锁，如果会请举例
    * 算法是否允许两个哲学家同时进餐，若可以请举例

### 2017年

1. 选择题
    * 以下算法会产生很多不必要的小碎片的分区
    * 能够有效避免产生小碎片的算法
    * 关于线程和管程
    * 以下会发生belady异常的是
        * FIFO算法
        * LRU算法
        * CLOCK算法
        * LFU算法
        * 改进CLOCK算法
    * 以下哪种磁盘阵列存取速度快：RAID 0、1、4、5

2. 一道关于ucore的题目

3. 一台计算机虚拟空间8KB，物理空间4KB，二级页表，页表项32B,页目录项1B，页表大小32B，求进程页面大小有多少B

### 2016年

1. 一个文件系统采用索引结点方式存储文件，一个索引结点包括两个直接文件指针，一个一级间接文件指针表（糟糕，忘记是索引表还是指针表了）一个存储块为 8KB，一个指针 4B，问理论上这个文件系统能存放的最大文件是多大？用 TB+GB+MB+KB+B 表示

## 计算机网络

### 2018年
1. 滑动窗口协议
    * 停等式ARQ(Auto Repeat reQuest，自动重传请求)
    * GBN ARQ(Go-Back-N，后退N帧)
    * SR ARQ(Selective Repeat，选择性重传)

2. DNS协议

3. 透明网桥建立转发表：两个网桥三段子网，建立转发表，要求填表

4. 路由器：两个路由器，三段网络的最大帧长度分别为1024,512,912，报头长度分别为14,12,12(数据不一定准确)。拓扑结构：A—R1—R2—B（R1、R2的e0接口分别连A、B，e1接口互连），
    * 分配给这个网络一个192.166.1.0/24的ip，划分子网，使A，B子网中主机数量尽可能多,写出子网以及R1，R2的e0、e1接口的ip地址和子网掩码
    * 现在要发送一个长度为900B的tcp数据段，tcp首部20B，ip首部20B，identification值为X，问这个数据段经过A-R1、R1-R2、R2-B三段子网的时候total\_length、identification、DF、MF、offset值分别为多少
    * A要给B发7个数据段，建立了一个TCP连接，已知往返时间为RTT，问从建立连接开始到发送结束共持续了多长时间

### 2017年

1. SNMP协议
    * A.SNMP协议具有性能管理，故障管理，配置管理，记账管理和安全管理
    * B.SNMP采用TCP协议进行管理

2. 滑动窗口
    * 太空站的128kbps，发送512字节帧，端到端的传输延迟300ms，确认帧长度忽略不计，接收窗口足够大
    * 问发送窗口分别为1，15，27时，吞吐率为多少
    * 若要使信道利用率达到最大，则帧序号至少为多少？

3. 路由算法
    * 若采用距离向量算法和水平分裂算法，写出D节点收到的信息
    * 使用RIP算法写出D收敛后的转发表
    * 若采用链路状态协议，写出D收到的链路状态

4. 子网划分：若局域网1到4分别有78，38，14，4台主机，请将网路202.1.5.0/24分配给图中局域网和路由器间网段，写出划分后的网络，以及路由器端口IP地址及掩码

### 2016年

1. SMTP协议

2. 路由
    * RIP协议
    * NAT算法
    * DNS
    * IPv4到IPv6的转换
