# Linux 系统启动流程

## 引导过程

1. Linux 引导过程综述
    - BIOS
    - Boot loader
    - 内核初始化（体系结构相关部分）
    - 内核初始化（体系结构无关部分）
    - 用户态初始化

### BIOS

1. BIOS的主要功能
    - POST(Power-On Self Test)：加电自检，检测CPU各寄存器、计时芯片、中断芯片、DMA 控制器等。
    - Initial: 枚举设备，初始化寄存器，分配中断、IO 端口、DMA 资源等。
    - Setup: 进行系统设置，存于 CMOS 中。
    - 常驻程序：INT 10h、INT 13h、INT 15h 等，提供给操作系统或应用程序调用。
    - 启动自举程序：在POST过程结束后，将调用 INT 19h，启动自举程序，自举程序将读取引导记录，装载操作系统。

2. POST
    - 当 PC 加电后，CPU 的寄存器被设为某些特定值。其中，指令指针寄存器（program counter）被设为 0xfffffff0。（注：0xFFFFFFF0 这个地址被映射到了 ROM，因此 CPU 执行的第一条指令来自于 ROM，而不是 RAM。）
    - CR1，一个32位控制寄存器，在刚启动时值被设为0。CR1 的 PE (Protected Enabled，保护模式使能) 位指示处理器是处于保护模式还是实模式。由于启动时该位为0，处理器在实模式中引导。在实模式中，线性地址与物理地址是等同的。
    - 在实模式下，0xfffffff0 不是一个有效的内存地址，计算机硬件将这个地址指向 BIOS 存储块。这个位置包含一条跳转指令，指向 BIOS 的 POST 例程。
    - POST（Power On Self Test，加电自检）过程包括内存检查、系统总线检查等。如果发现问题，主板会蜂鸣报警。在 POST 过程中，允许用户选择引导设备。

3. 自举过程
    - 自举过程即为执行中断 INT 0x19 的中断服务例程 INT19_VECT 的过程 (Bootrom.asm)
    - 主要功能为读取引导设备第一个扇区的前 512 字节（MBR），将其读入到内存 0x0000:7C00，并跳转至此处执行。

4. 可引导设备列表存储在在 BIOS 配置中, BIOS 将根据其中配置的顺序，尝试从不同的设备上寻找引导程序。对于硬盘，BIOS 将尝试寻找引导扇区。

### Boot loader

1. 硬盘第一个扇区的前 512 个字节是主引导扇区，由 446 字节的 MBR、64 字节的分区表和 2 字节的结束标志组成。
    - MBR（Master Boot Record）是 446 字节的引导代码，被 BIOS 加载到 0x00007C00 并执行。
    - 硬盘分区表占据主引导扇区的 64 个字节（0x01BE -- 0x01FD)，可以对四个分区的信息进行描述，其中每个分区的信息占据 16 个字节。
    - 结束标志字 55，AA（0x1FEH -- 0x1FFH）是主引导扇区的最后两个字节，是检验主引导记录是否有效的标志。

2. 一个分区记录有如下域：
    - 1字节 文件系统类型
    - 1字节 可引导标志
    - 6字节 CHS格式描述符
    - 8字节 LBA格式描述符

3. LBA和CHS两种描述符指示相同的信息，但是指示方式有所不同：
    - LBA (逻辑块寻址，Logical Block Addressing)指示分区的起始扇区和分区长度
    - CHS(柱面 磁头 扇区)指示首扇区和末扇区。

#### GRUB引导过程

1. GRUB 的引导过程分为 stage1、stage 1.5 和 stage 2。其中 stage1 和可能存在的 stage1.5 是为 stage2 做准备，stage2 像一个微型操作系统。

2. Stage 1
    - BIOS 加载 GRUB stage1（如果安装到 MBR）到 0x00007C00.
    - stage1 位于 stage1/stage1.S，汇编后形成 512 字节的二进制文件，写入硬盘的0面0道第1扇区。
    - stage1 将0面0道第2扇区上的 512 字节读到内存中的0x00007000处，然后调用 COPY_BUFFER 将其拷贝到 0x00008000 的位置上，然后跳至 0x00008000 执行。这 512 字节代码来自 stage2/start.S，作用是 stage1_5 或者 stage2（编译时决定加载哪个）的加载器。

3. Stage 1.5
    - Stage 1.5 能够读取文件系统（Stage 1.5包含有文件系统驱动），负责从文件系统中载入并执行 stage 2，即 GRUB 的核心映像。由于系统引导过程中不需要修改文件系统，因此只实现了文件系统的读取。
    - 可以说，stage 1.5 是 stage 1 与 stage 2 之间的桥梁，解决了文件系统这个“先有鸡还是先有蛋”的问题。

4. Stage 2
    - stage2 将系统切换到保护模式，设置 C 运行环境，寻找 config 文件，执行 shell 接受用户命令，载入选定的操作系统内核。

## 内核初始化过程

### Linux Insides

#### 1 内核设置

源码位于`arch/x86/boot/header.S`的`start_of_setup`

1. 设置段寄存器
2. 设置堆栈
3. 设置BSS段（静态变量区）
4. 跳转到main函数

#### 2 内核启动的第一步

1. 从实模式切换到保护模式
2. 


## 参考资料

1. [Linux源代码阅读——内核引导](http://home.ustc.edu.cn/~boj/courses/linux_kernel/1_boot.html)
2. [【译】计算机启动过程 – How Computers Boot Up](http://blog.kongfy.com/2014/03/%E8%AF%91%E8%AE%A1%E7%AE%97%E6%9C%BA%E5%90%AF%E5%8A%A8%E8%BF%87%E7%A8%8B-how-computers-boot-up/)
3. [《Linux内核修炼之道》第4章“系统初始化”](http://reader.epubee.com/books/mobile/bf/bf988d31c8fcba1f1ecdc622808256f4/text00013.html)
