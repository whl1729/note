# 《ucore lab6》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1: 使用 Round Robin 调度算法（不需要编码）

### 题目
完成练习0后，建议大家比较一下（可用kdiff3等文件比较软件） 个人完成的lab5和练习0完成后的刚修改的lab6之间的区别，分析了解lab6采用RR调度算法后的执行过程。执行make grade，大部分测试用例应该通过。但执行priority.c应该过不去。

请在实验报告中完成：

请理解并分析sched_calss中各个函数指针的用法，并结合Round Robin 调度算法描ucore的调度执行过程。

请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计。

### 解答

## 练习2: 实现 Stride Scheduling 调度算法（需要编码）

### 题目
首先需要换掉RR调度器的实现，即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride度器的相关描述，完成Stride调度算法的实现。后面的实验文档部分给出了Stride调度算法的大体描述。这里给出Stride调度算法的一些相关的资料（目前网上中文的资料比较欠缺）。你也可GOOGLE “Stride Scheduling” 来查找相关资料。
[strid-shed paper location1](http://wwwagss.informatik.uni-kl.de/Projekte/Squirrel/stride/node3.html)
[strid-shed paper location2](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.138.3502&rank=1)

执行：make grade。如果所显示的应用程序检测都输出ok，则基本正确。如果只是priority.c过不去，可执行 make run-priority 命令来单独调试它。大致执行结果可看附录。（使用的是qemu-1.0.1 ） 。

请在实验报告中简要说明你的设计实现过程。

### 解答

## 扩展练习 Challenge 1 ：实现 Linux 的 CFS 调度算法（待完成）
在ucore的调度器框架下实现下Linux的CFS调度算法。可阅读相关Linux内核书籍或查询网上资料，可了解CFS的细节，然后大致实现在ucore中。

## 扩展练习 Challenge 2 ：实现更多基本调度算法（待完成）
在ucore上实现尽可能多的各种基本调度算法(FIFO, SJF,...)，并设计各种测试用例，能够定量地分析出各种调度算法在各种指标上的差异，说明调度算法的适用范围。
