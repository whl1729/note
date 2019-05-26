# 《ucore lab1 exercise3》实验报告

## 资源

1. [ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)
2. [我的ucore实验代码](https://github.com/whl1729/ucore_os_lab)

## 题目：分析bootloader进入保护模式的过程

BIOS将通过读取硬盘主引导扇区到内存，并转跳到对应内存中的位置执行bootloader。请分析bootloader是如何完成从实模式进入保护模式的。

提示：需要阅读小节“保护模式和分段机制”和lab1/boot/bootasm.S源码，了解如何从实模式
切换到保护模式，需要了解：

1. 为何开启A20，以及如何开启A20
2. 如何初始化GDT表
3. 如何使能和进入保护模式

## 解答

正如提示所言，bootloader从实模式切换到保护模式，需要做以下事情：

1. 开启A20门
2. 在内存中建立GDT表并初始化
3. 设置cr0寄存器的PE位为1，表示从实模式切换到保护模式

下面针对每一项具体展开描述。

### 开启A20门

#### 为何开启A20门？
一开始时A20地址线控制是被屏蔽的（总为0） ，直到系统软件通过一定的IO操作去打开它（参看bootasm.S） 。很显然，在实模式下要访问高端内存区，这个开关必须打开，在保护模式下，由于使用32位地址线，如果A20恒等于0，那么系统只能访问奇数兆的内存，即只能访问0--1M、2-3M、4-5M......，这样无法有效访问所有可用内存。所以在保护模式下，这个开关也必须打开。

#### 如何开启A20？
打开A20 Gate的具体步骤大致如下：

1. 等待8042 Input buffer为空
2. 发送Write 8042 Output Port （P2） 命令到8042 Input buffer
3. 等待8042 Input buffer为空
4. 将8042 Output Port（P2） 对应字节的第2位置1，然后写入8042 Input buffer

打开A20 Gate的功能是在boot/bootasm.S中实现的，下面结合相关代码来分析：代码分为seta20.1和seta20.2两部分，其中seta20.1是往端口0x64写数据0xd1，告诉CPU我要往8042芯片的P2端口写数据；seta20.2是往端口0x60写数据0xdf，从而将8042芯片的P2端口设置为1. 两段代码都需要先读0x64端口的第2位，确保输入缓冲区为空后再进行后续写操作。
```
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
```

### 初始化GDT表

1. boot/bootasm.S中的`lgdt gdtdesc`把全局描述符表的大小和起始地址共8个字节加载到全局描述符表寄存器GDTR中。从代码中可以看到全局描述符表的大小为0x17 + 1 = 0x18，也就是24字节。由于全局描述符表每项大小为8字节，因此一共有3项，而第一项是空白项，所以全局描述符表中只有两个有效的段描述符，分别对应代码段和数据段。
```
gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
```

2. 下面的代码给出了全局描述符表的具体内容。共有3项，每项8字节。第1项是空白项，内容为全0. 后面2项分别是代码段和数据段的描述符，它们的base都设置为0，limit都设置为0xffffffff，也就是长度均为4G. 代码段设置了可读和可执行权限，数据段设置了可写权限。（疑问：为什么数据段不设置可读权限？）
```
// Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel
```

3. SEG_ASM的定义如下
```
#define SEG_ASM(type,base,lim)                                  \
    .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);          \
    .byte (((base) >> 16) & 0xff), (0x90 | (type)),             \
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)
```

### 如何使能和进入保护模式

将cr0寄存器的PE位（cr0寄存器的最低位）设置为1，便使能和进入保护模式了。代码如下所示：
```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```
