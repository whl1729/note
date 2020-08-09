# 操作系统的历史

谁、什么时候、在哪里发明了操作系统？

## Wikipedia: History of Unix

### 1969

- On the PDP-7, in 1969, a team of Bell Labs researchers led by Thompson and Ritchie, including Rudd Canaday, implemented a hierarchical file system, the concepts of computer processes and device files, a command-line interpreter, and some small utility programs, modeled on the corresponding features in Multics, but simplified.
- In about a month's time, in August 1969, Thompson had implemented a self-hosting operating system with an assembler, editor and shell, using a GECOS machine for bootstrapping.

### 1970s

- In 1973, Version 4 Unix was **rewritten in the higher-level language C**.
- In 1973, AT&T released Version 5 Unix and licensed it to **educational institutions**, and licensed 1975's Version 6 to companies for the first time.
- Copies of the Lions' Commentary on UNIX 6th Edition, with **Source Code circulated widely**, which led to considerable use of Unix as an educational example.
- In 1973, development expanded, adding the concept of **pipes**.
- Version 7 Unix was released in 1979. In Version 7, the number of **system calls** was only around 50, although later Unix and Unix-like systems would add many more.

### 1980s

- In 1983, AT&T release Unix System V(called System V Release 1, or SVR1). SVR1 included features such as the **vi editor and curses** from 4.1 BSD. It also improved performance by adding **buffer and inode caches**, and added support for **inter-process communication using messages, semaphores, and shared memory**, developed earlier for the Bell-internal CB UNIX.
- In 1983, since the **breakup of the Bell System**, AT&T promptly introduced Unix System V into the market, **stifled the free exchanging of source code** and led to fragmentation and incompatibility.
- In 1983, the **GNU** Project was founded in the same year by Richard Stallman.
- Since 1983, the Berkeley researchers continued to develop **BSD** as an alternative to UNIX System III and V, included features such as C shell with job control, **TCP/IP network**. The accompanying **Berkeley sockets API** is a de facto standard for networking APIs and has been copied on many platforms.
- In 1984, SVR2 added **shell functions** and the SVID. SVR2.4 added **demand paging, copy-on-write, shared memory, and record and file locking**.
- In 1987, SVR3 included **STREAMS, Remote File Sharing (RFS), the File System Switch (FSS) virtual file system mechanism, a restricted form of shared libraries, and the Transport Layer Interface (TLI) network API**.
- In 1988, SVR4 included features such as TCP/IP support, sockets and the virtual file system interface.
- In the 1980s and early-1990s, UNIX System V and the Berkeley Software Distribution (BSD) were the two major version of UNIX. The rivalry between vendors was called the **Unix wars**.

### 1990s

- In 1995, POSIX became the unifying standard for Unix systems (and some other operating systems).
- In 1997, Apple sought a new foundation for its Macintosh operating system and chose **NeXTSTEP**, an operating system developed by NeXT. The core operating system, which was based on BSD and the Mach kernel, was renamed **Darwin** after Apple acquired it. The deployment of Darwin in Mac OS X makes it the most widely used Unix-based system in the desktop computer market.
- Meanwhile, Unix got competition from the copyleft Linux kernel.

#### 2000s

- Since the early 2000s, Linux is the leading Unix-like operating system, with other variants of Unix (apart from macOS) having only a negligible market share.

## 《现代操作系统》的观点

我们将分析连续几代的计算机，看看它们的操作系统是什么样的。

1. 第一代（1945～1955）：真空管和穿孔卡片
    - 第一代计算机主要用于简单的数字运算，如制作正弦、余弦以及对数表等
    - 没有程序设计语言（只有机器语言）
    - 没有操作系统

2. 第二代（1955～1965）：晶体管和批处理系统
    - 第二代大型计算机主要用于科学与工程计算，例如解偏微分方程。
    - 使用FORTRAN语言和汇编语言
    - 现代操作系统的前身：读取磁带上的每个作业并执行

3. 第三代（1965～1980）：集成电路芯片和多道程序设计
    - 第三代操作系统出现新技术：多道程序设计（基于在内存中存放多个作业来实现）、分时系统
    - IBM OS/360操作系统：一个庞大的又极其复杂的操作系统，同时支持科学计算和商业计算
    - MULTICS 分时系统，支持数百个用户
    - Ken Thompson发明UNIX
    - Linus Torvalds发明Linux

4. 第四代（1980年至今）：个人计算机
    - 用于8080的第一个操作系统：CP/M(Control Program for Microcomputer)
    - Windows操作系统：DOS(Disk Operating System) -> MS-DOS -> Windows（基于GUI）
