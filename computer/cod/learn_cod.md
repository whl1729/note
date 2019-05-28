# 《计算机组成原理》学习笔记

## 数字电路

1. SR锁存器的两个输入S和R不能同时为1，在此约束条件下，SR锁存器的输出Q和Q'的值必相反。触发器是基于锁存器而设计的，因此同样具有此特点。

2. 理解JK触发器，关键注意主触发器的输出与从触发器的输出有依赖关系。

## CPU的功能

1. 基本功能
    - 可以进行算术和逻辑运算
    - 可保存较少数数据
    - 能对指令进行译码并执行规定的操作
    - 能和存储器、外设交换数据
    - 提供整个系统所需要的定时和控制
    - 可以响应其他部件发来的中断请求

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

3. 计算机层次结构（参考《计算机组成：结构化方法》）
```
level 5: Problem-oriented language level
                | Translation (compiler)
level 4: Assembly language level
                | Translation (assembler)
level 3: Operating system machine level
                | Partial interpretation (operating system)
level 2: Instruction set architecture level
                | Interpretation (microprogram) or direct execution
level 1: Microarchitecture level
                | Hardware
level 0: Digital logic level
```

## CPU的工作原理

1. CPU如何进行算术和逻辑运算
    - 门电路：用来实现基本逻辑电路和复合逻辑电路的单元电路，包括与门、或门、非门、与非门、或非门、与或非门、异或门等。
    - 使用门电路可以实现与、或、非等逻辑运算
    - 使用加法器可以实现加减法（减去一个数可看做是加上其相反数）
    - 使用加法器、寄存器和移位寄存器可以实现乘除法

2. CPU如何进行访存操作
    - 读操作：首先将地址放到地址总线，然后向控制总线发出“读”信号，最后读出存储器指定地址的数据。
    - 写操作：首先将地址放在地址总线，将数据放在数据总线，然后向控制总线发出“写”信号，最后将数据写到存储器指定位置。

3. 单周期CPU在一个指令周期做的事情（参考《CPU芯片逻辑设计技术》第5章）
    - 取指：读指令寄存器得到指令地址，从存储器读取指令字，计算下一条指令的地址。
    - 译码：识别指令，根据不同的指令给出各种控制信号，根据指令从相应的源数据寄存器中取出操作数，为下一步的指令执行做好准备。
    - 执行：ALU执行四则运算，或计算存储器引用的有效地址，或增减栈指针。还可能设置条件码
    - 访存：将数据写入存储器，或从存储器读出数据
    - 写回：将运算结果写回到寄存器文件

4. 多周期CPU可以使用有限状态机的方式来实现。（参考《CPU芯片逻辑设计技术》第6章）

5.  Micro-op decode（参考《Computer Architecture: A Quantitative Approach》第3.12节）
    - Individual x86 instructions are translated into micro-ops. Micro-ops are simple RISC-V-like instructions that can be executed directly by the pipeline; this approach of translating the x86 instruction set into simple operations that are more easily pipelined was introduced in the Pentium Pro in 1997 and has been used since. 
    - Three of the decoders handle x86 instructions that translate directly into one micro-op. For x86 instructions that have more complex semantics, there is a microcode engine that is used to produce the micro-op sequence; it can produce up to four micro-ops every cycle and continues until the necessary micro-op sequence has been generated.

6. Intel CPU微体系结构（参考《计算机组成：结构化方法》第4章）
    - The front end is responsible for fetching instructions from the memory subsystem, decoding them into RISC-like micro-ops, and storing them into two instruction storage caches. 
    - All instructions fetched are placed into the L1 (level 1) instruction cache. The L1 cache is 32 KB in size, organized as an 8-way associative cache with 64-byte blocks. As instructions are fetched from the L1 cache, they enter the decoders which determine the sequence of micro-ops used to implement the instruction in the execution pipeline. This decoder mechanism bridges the gap between an ancient CISC instruction set and a modern RISC data path.

## CPU中断处理

1. 异常发生时CPU必须进行的基本操作是：在异常处理计数器（EPC）中保存出错指令的地址，并把控制权交给操作系统的特定地址。

2. 为了处理异常，操作系统除了要知道是哪条指令引起异常之外，还需要知道引起异常的原因。主要有两种方法表示引起异常的原因。
    - 设置一个状态寄存器，其中有一个字段表示引起异常的原因。（MIPS）
    - 使用向量中断。控制权被转移到由异常原因决定的地址处。（x86）

3. The interrupts of the entire Intel family of microprocessors include two hardware pins that request interrupts (INTR and NMI), and one hardware pin (INTA) that acknowledges the interrupt requested through INTR. In addition to the pins, the microprocessor also has software interrupts INT, INTO, INT 3, and BOUND. Two flag bits, IF (interrupt flag) and TF (trap flag), are also used with the interrupt structure and a special return instruction, IRET (or IRETD in the 80386, 80486, or Pentium–Pentium 4). 

4. When the microprocessor completes executing the current instruction, it determines whether an interrupt is active by checking (1) instruction executions, (2) single-step, (3) NMI, (4) coprocessor segment overrun, (5) INTR, and (6) INT instructions in the order presented. If one or more of these interrupt conditions are present, the following sequence of events occurs:
    - The contents of the flag register are pushed onto the stack.
    - Both the interrupt (IF) and trap (TF) flags are cleared. This disables the INTR pin and the trap or single-step feature.
    - The contents of the code segment register (CS) are pushed onto the stack.
    - The contents of the instruction pointer (IP) are pushed onto the stack.
    - The interrupt vector contents are fetched, and then placed into both IP and CS so that the next instruction executes at the interrupt service procedure addressed by the vector.

> 备注：条目3～4摘自《The Intel Microprocessors》

5. [Microprocessor Interrupts and Exceptions](https://www.warthman.com/ex-interrupt.htm)
    - The processor performs an interrupt by executing a microcode routine. In this sense, an interrupt acts like the execution of a complex instruction and the microcode routine has a completion boundary that acts like an instruction-retirement boundary. 
    - In effect, the microcode routine for an interrupt begins executing when the interrupt is recognized on an instruction boundary and it finishes executing when an associated interrupt service routine begins or the hardware aspect of the interrupt function otherwise completes.
