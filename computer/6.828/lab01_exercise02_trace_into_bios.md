# 《MIT 6.828 Lab 1 Exercise 2》实验报告

本实验链接：[mit 6.828 lab1 Exercise2](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-2)。

## 题目

> Exercise 2. Use GDB's si (Step Instruction) command to trace into the ROM BIOS for a few more instructions, and try to guess what it might be doing. You might want to look at [Phil Storrs I/O Ports Description](http://web.archive.org/web/20040404164813/members.iweb.net.au/~pstorr/pcbook/book2/book2.htm), as well as other materials on the [6.828 reference materials page](https://pdos.csail.mit.edu/6.828/2017/reference.html). No need to figure out all the details - just the general idea of what the BIOS is doing first.

## 解答

使用si命令得到的前22条汇编指令如下。虽然能看懂每条指令的字面意思，但看不懂具体实现的功能，后来参考[myk的6.828 Lab1](https://zhuanlan.zhihu.com/p/36926462)大致理解了基本功能：设置ss和esp寄存器的值，打开A20门（为了后向兼容老芯片）、进入保护模式（需要设置cr0寄存器的PE标志）。
```
[f000:fff0]    0xffff0:	ljmp   $0xf000,$0xe05b
[f000:e05b]    0xfe05b:	cmpl   $0x0,%cs:0x6ac8
[f000:e062]    0xfe062:	jne    0xfd2e1
[f000:e066]    0xfe066:	xor    %dx,%dx
[f000:e068]    0xfe068:	mov    %dx,%ss
[f000:e06a]    0xfe06a:	mov    $0x7000,%esp
[f000:e070]    0xfe070:	mov    $0xf34c2,%edx
[f000:e076]    0xfe076:	jmp    0xfd15c
[f000:d15c]    0xfd15c:	mov    %eax,%ecx
[f000:d15f]    0xfd15f:	cli    
[f000:d160]    0xfd160:	cld    
[f000:d161]    0xfd161:	mov    $0x8f,%eax
[f000:d167]    0xfd167:	out    %al,$0x70
[f000:d169]    0xfd169:	in     $0x71,%al
[f000:d16b]    0xfd16b:	in     $0x92,%al
[f000:d16d]    0xfd16d:	or     $0x2,%al
[f000:d16f]    0xfd16f:	out    %al,$0x92
[f000:d171]    0xfd171:	lidtw  %cs:0x6ab8
[f000:d177]    0xfd177:	lgdtw  %cs:0x6a74
[f000:d17d]    0xfd17d:	mov    %cr0,%eax
[f000:d180]    0xfd180:	or     $0x1,%eax
[f000:d184]    0xfd184:	mov    %eax,%cr0
[f000:d187]    0xfd187:	ljmpl  $0x8,$0xfd18f
```

## 代码笔记
以下是阅读代码过程中整理出来的笔记。

1. 第一条指令：`[f000:fff0] 0xffff0:    ljmp   $0xf000,$0xe05b`
    * CS（CodeSegment）和IP（Instruction Pointer）寄存器一起用于确定下一条指令的地址。计算公式： physical address = 16 * segment + offset.
    * PC开始运行时，CS = 0xf000，IP = 0xfff0，对应物理地址为0xffff0.第一条指令做了jmp操作，跳到物理地址为0xfe05b的位置。

2. CLI：Clear Interupt，禁止中断发生。STL：Set Interupt，允许中断发生。CLI和STI是用来屏蔽中断和恢复中断用的，如设置栈基址SS和偏移地址SP时，需要CLI，因为如果这两条指令被分开了，那么很有可能SS被修改了，但由于中断，而代码跳去其它地方执行了，SP还没来得及修改，就有可能出错。

3. CLD: Clear Director。STD：Set Director。在字行块传送时使用的，它们决定了块传送的方向。CLD使得传送方向从低地址到高地址，而STD则相反。

4. 汇编语言中，CPU对外设的操作通过专门的端口读写指令来完成，读端口用IN指令，写端口用OUT指令。进一步理解“端口”的概念可以参考博客[理解“统一编址与独立编址、I/O端口与I/O内存”](https://my.oschina.net/wuying/blog/53419)。

5. LIDT: 加载中断描述符。LGDT：加载全局描述符。

6. 控制寄存器：控制寄存器（CR0～CR3）用于控制和确定处理器的操作模式以及当前执行任务的特性。CR0中含有控制处理器操作模式和状态的系统控制标志；CR1保留不用；CR2含有导致页错误的线性地址；CR3中含有页目录表物理内存基地址，因此该寄存器也被称为页目录基地址寄存器PDBR（Page-Directory Base address Register）。
    * CR0的4个位：扩展类型位ET、任务切换位TS、仿真位EM和数学存在位MP用于控制80x86浮点（数学）协处理器的操作。
    * CR0的位0是PE（Protection Enable）标志。当设置该位时即开启了保护模式；当复位时即进入实地址模式。这个标志仅开启段级保护，而并没有启用分页机制。若要启用分页机制，那么PE和PG标志都要置位。
    * CR0的位31是PG（Paging，分页）标志。当设置该位时即开启了分页机制；当复位时则禁止分页机制，此时所有线性地址等同于物理地址。在开启这个标志之前必须已经或者同时开启PE标志。即若要启用分页机制，那么PE和PG标志都要置位。

7. 地址卷绕：用两个 16 位的寄存器左移相加来得到 20 位的内存地址这里还是有问题。那就是两个 16 位数相加所得的最大结果是超过 20 位的。例如段基址 0xffff 左移变成 0xffff0 和偏移量 0xffff 相加得到 0x10ffef 这个内存地址是“溢出”的，怎么办？这里 CPU 被设计出来一个“卷绕”机制，当内存地址超过 20 位则绕回来。举个例子你拿 0x100001 来寻址，我就拿你当作 0x00001 。你超出终点我就把你绕回起点。

8. A20 gate：现代的 x86 计算机，无论你是 32 位的还是 64 位的，在开机的那一刻 CPU 都是以模拟 16 位模式运行的，地址卷绕机制也是有效的，所以无论你的电脑内存有多大，开机的时候 CPU 的寻址能力只有 1MB，就好像回到 8086 时代一样。那么什么时候才结束 CPU 的 16 位模式运行呢？这由你（操作系统）说了算，现代的计算机都有个“开关”叫 A20 gate，开机的时候 A20 gate 是关闭的，CPU 以 16 位模式运行，当 A20 gate 打开的时候“卷绕”机制失效，内存寻址突破 1MB 限制，我们就可以切换到正常的模式下运行了。

9. 分段式保护模式下的寻址
    * “保护模式”实现的两种内存管理方式：“分段式和分页式”。
    * 分段式简单来说就是将内存规划出不同的“片段”来分配给不同的程序（也包含操作系统自己）使用。分页式则是将内存规划成大小相同的“页”，再将这些页分配给各个程序使用。
    * 在分段模式下，内存里会有一个“表”，这个“表”里存放了每个内存“片段”的信息（如这个“片段”在内存中的地址，这个“片段”多长等），比如我们现在将内存分成 10 个片段，则这时我们有一个“表”，这个“表”有 10 项分别存放着对应这 10 个内存片段的描述信息。这时我有个数据存放在第 5 个片段中，在第 5 个片段的第 6 个位置上，所以当我们想要读取这个数据的时候，我们的数据段寄存器里存放的“段基址”是 5 这个数，代表要去第 5 个片段上找，对应的这时候的“偏移量”就是 6 这样我们就可以顺利的找到我们想要的数据里。
    * 而要想实现在分段式保护模式下成功的寻址，操作系统需要做的就是在内存中建立这个“表”，“表”里放好内存分段的描述信息，然后把这个“表”在内存的什么位置，以及这个“表”里有多少个内存分段的描述信息告诉 CPU。这个“表”有个学名叫 GDT 全局描述符表。
    * 在分段式的保护模式下，16 位的“段基址”不再表示内存的物理地址，而是表示 GDT 表的下标，用来根据“段基址”从 GDT 表中取得对应下标的“段描述符”，从“段描述符”中取得真实的内存物理地址后在配合“偏移量”来计算出最终的内存地址。

10. 从给 x86 通电的一刻开始，CPU 执行的第一段指令是 BIOS 固化在 ROM 上的代码，这个过程是硬件定死的规矩，就是这样。而 BIOS 在硬件自检完成后（你会听到“滴”的一声）会根据你在 BIOS 里设置的启动顺序（硬盘、光驱、USB）读取每个引导设备的第一个扇区 512字节的内容，并判断这段内容的最后 2 字节是否为 0xAA55，如果是说明这个设备是可引导的，于是就将这 512 字节的内容放到内存的 0x7C00 位置，然后告诉 CPU 去执行这个位置的指令。这个过程同样是硬件定死的规矩，就是这样。

> 备注：第7~10点来自参考文献3《【学习xv6】从实模式到保护模式》。

## 参考资料

1. [myk的6.828 Lab1](https://zhuanlan.zhihu.com/p/36926462)

2. [理解“统一编址与独立编址、I/O端口与I/O内存”](https://my.oschina.net/wuying/blog/53419)

3. [【学习xv6】从实模式到保护模式](http://leenjewel.github.io/blog/2014/07/29/%5B%28xue-xi-xv6%29%5D-cong-shi-mo-shi-dao-bao-hu-mo-shi/)
