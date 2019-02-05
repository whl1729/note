# CPU学习笔记

## CPU的内部结构

1. 基础部件
    - ALU（算术逻辑部件）
    - 累加器
    - 通用寄存器组
    - 程序计数器
    - 指令寄存器
    - 译码器
    - 时序和控制部件

2. 32位的系统还集成了浮点运算器、存储管理器和高速缓存等部件。

## CPU的功能

1. 基本功能
    - 可以进行算术和逻辑运算
    - 可保存较少数数据
    - 能对指令进行译码并执行规定的操作
    - 能和存储器、外设交换数据
    - 提供整个系统所需要的定时和控制
    - 可以响应其他部件发来的中断请求

2. CPU如何进行算术和逻辑运算
    - 门电路：用来实现基本逻辑电路和复合逻辑电路的单元电路，包括与门、或门、非门、与非门、或非门、与或非门、异或门等。
    - 使用门电路可以实现与、或、非等逻辑运算
    - 使用加法器可以实现加减法（减去一个数可看做是加上其相反数）
    - 使用加法器、寄存器和移位寄存器可以实现乘除法

3. CPU如何进行访存操作
    - 读操作：首先将地址放到地址总线，然后向控制总线发出“读”信号，最后读出存储器指定地址的数据。
    - 写操作：首先将地址放在地址总线，将数据放在数据总线，然后向控制总线发出“写”信号，最后将数据写到存储器指定位置。

## CPU异常处理

1. 异常发生时CPU必须进行的基本操作是：在异常处理计数器（EPC）中保存出错指令的地址，并把控制权交给操作系统的特定地址。

2. 为了处理异常，操作系统除了要知道是哪条指令引起异常之外，还需要知道引起异常的原因。主要有两种方法表示引起异常的原因。
    - 设置一个状态寄存器，其中有一个字段表示引起异常的原因。（MIPS）
    - 使用向量中断。控制权被转移到由异常原因决定的地址处。（x86）