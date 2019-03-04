# 《ucore lab8》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1: 完成读文件操作的实现（需要编码）

### 题目
首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，编写在sfs_inode.c中sfs_io_nolock读文件中数据的实现代码。

请在实验报告中给出设计实现“UNIX的PIPE机制”的概要设计方案，鼓励给出详细设计方案。

### 解答

#### 了解打开文件的处理流程
已对打开文件的代码流程进行了详细分析，见[lab8 源码分析：用户执行open的详细流程](src_analysis_ucore.md)

#### 实现sfs_io_nolock读文件数据的功能

根据提示不难完成编码。原代码中提供两个接口sfs_rbuf和sfs_rblock，分别用于以字节和文件块（实际上就是页面大小）为单位来读取文件。主要需要考虑到读文件时的起始和结束位置可能没与block起始位置对齐，对于不足一个block的部分调用sfs_rbuf来读取内容，对于中间多个block的部分则调用sfs_rblock来读取。

#### 设计实现“UNIX的PIPE机制”（待完成）

## 练习2: 完成基于文件系统的执行程序机制的实现（需要编码）

### 题目
改写proc.c中的load_icode函数和其他相关函数，实现基于文件系统的执行程序机制。执行：make qemu。如果能看看到sh用户程序的执行界面，则基本成功了。如果在sh用户界面上可以执行“ls”、“hello”等其他放置在sfs文件系统中的其他执行程序，则可以认为本实验基本成功。

请在实验报告中给出设计实现基于“UNIX的硬链接和软链接机制”的概要设计方案，鼓励给出详细设计方案。

### 解答

#### 实现基于文件系统的执行程序机制

1. 首先要获取ELF文件的大小len，方法是：使用fd索引fd_array，得到对应的file，根据file->inode->sfs_inode->sfs_disk_inode->size得到ELF文件大小。

2. 然后申请大小为len的缓冲区buf，接下来调用load_icode_read来读取ELF文件的内容并复制到buf，接下来解析ELF文件内容并复制相应section，这部分操作与之前的实验相同。

3. 接下来还需要拷贝输入参数argc和kargv到用户栈顶，并根据输入参数所占的内存大小修改tf_esp的值。这样当程序沿着load_icode -> do_execve -> sys_exec -> syscall -> trap_dispatch -> trap -> trapret一路返回并执行iret时，就能从栈顶上面的几个位置获取到argc和argv的值。

#### 设计实现基于“UNIX的硬链接和软链接机制”（待完成）

#### Bug 1：运行用户程序sh时内存访问异常

##### 问题描述

编码完成后，执行`sudo make qemu`，查看输出日志，发现没有进入sh界面，提示错误信息：“not valid addr b0000000, and  can not find it in vma”。

##### 定位流程

1. 首先确认0xb0000000这个地址是何时被访问的。印象中这是用户栈顶的地址，查看load_icode的实现，果然发现在结尾处把tf_esp设置为USTACKTOP 0xb0000000，后面沿着do_execve -> sys_exec -> syscall -> trap_dispatch -> trap -> trapret一路返回，在trapret的结尾处执行iret，由于发生特权级转换，这时会把esp寄存器设置为0xb0000000.使用gdb调试发现，在进入用户程序的开头，会访问esp所指的内存，这时就发生缺页异常。

2. 分析可能的原因：
    - USTACKTOP这个地址本来就不能访问？
    - 内核态到用户态的切换不成功？
    - 页目录表和页表设置有误？
    - 用户程序sh有问题？
    - 用户程序的输入参数没设置？

3. 使用gdb调试，在执行iret的地方使用si逐步调试，发现执行iret后，首先跳到地址为0x008004e9的位置运行，打开sh.asm查看对应位置的汇编代码，发现0x008004e9是start的起始位置，start的第二条指令`movl (%esp), ebx`会访问到0xb0000000，目的是加载argc参数。那么原因大概确定了，应该是我在load_icode函数中没设置好输入参数，导致现在访问输入参数失败。
```
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  8004e9:	bd 00 00 00 00       	mov    $0x0,%ebp

    # load argc and argv
    movl (%esp), %ebx
  8004ee:	8b 1c 24             	mov    (%esp),%ebx
    lea 0x4(%esp), %ecx
  8004f1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    
    # move down the esp register since it may cause page fault in backtrace
    subl $0x20, %esp
  8004f5:	83 ec 20             	sub    $0x20,%esp

    # save argc and argv on stack
    pushl %ecx
  8004f8:	51                   	push   %ecx
    pushl %ebx
  8004f9:	53                   	push   %ebx

    # call user-program function
    call umain
  8004fa:	e8 9d 04 00 00       	call   80099c <umain>
```

4. 那么为什么lab7不会有问题呢？于是回头看lab7的代码，首先查看lab7用户程序的start的汇编代码，发现果然有区别：lab8需要加载argc和argv，lab7则不需要加载。为什么会有这个差别？
```
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  8003fb:	bd 00 00 00 00       	mov    $0x0,%ebp

    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  800400:	83 ec 20             	sub    $0x20,%esp

    # call user-program function
    call umain
  800403:	e8 f9 00 00 00       	call   800501 <umain>
```

5. 查看两个lab的umain的实现，终于找到原因：lab8的umain函数定义含有argc和argv两个输入参数，lab7的umain函数定义无输入参数。
```
// lab8
void umain(int argc, char *argv[]) {
    int fd;
    if ((fd = initfd(0, "stdin:", O_RDONLY)) < 0) {
        warn("open <stdin> failed: %e.\n", fd);
    }
    if ((fd = initfd(1, "stdout:", O_WRONLY)) < 0) {
        warn("open <stdout> failed: %e.\n", fd);
    }
    int ret = main(argc, argv);
    exit(ret);
}

// lab7
void umain(void) {
    int ret = main();
    exit(ret);
}
```

6. 但还是有疑问：即使我没在栈顶设置好argc和argv，也应该能访问栈顶吧？只是说访问到的数据是不确定的而已啊。会不会是0xb0000000刚好是禁止访问的边界地址？我试着将0xb0000000 - 16赋值给tf_esp，再运行，竟然不报错了！这时可以进入sh界面，输入ls没反应，输入hello或forktest等命令则正常运行。总之，这基本证明了我的猜想是正确的。

7. 接下来不难得到正确解法：0xb0000000是用户地址边界，如果要存储argc和argv，则需要减去相应的值，在0xb0000000的前面来存储。修改后再运行，果然能正常进入sh界面，而且执行ls也能正常输出了。

8. 最后的疑问：步骤6只是避免了访问地址边界，但没有正确设置argc和argv（使用gdb调试时发现此时argc和argv都设置为0了），为什么大部分命令也能正常运行，唯独ls运行异常（无输出）？查看ls.c文件，发现当输入argc为0时，确实不会执行任何操作；argc为1时，则会执行`ls .`.
