# 清华大学OS MOOC笔记

## 第一讲 操作系统概述

### 资源

1. [OS2018Spring课程资料首页](http://os.cs.tsinghua.edu.cn/oscourse/OS2018spring)

2. [MOOC OS习题集](https://xuyongjiande.gitbooks.io/os_exercises/content/index.html)

3. [OS课堂练习](https://chyyuu.gitbooks.io/os_course_exercises/content/)

### 1.3 什么是操作系统

1. 操作系统内核包括串口驱动、磁盘驱动、字符设备I/O、块设备I/O等。

2. 内核特征
    * 并发
    * 共享
    * 虚拟
    * 异步

## 第二讲 实验零 操作系统实验环境准备

1. 双向链表结构原理

2. [type \*)0)->member in C?](https://stackoverflow.com/questions/13723422/why-this-0-in-type0-member-in-c):   
The pointer to zero is used to get a proper instance, but as typeof is resolved at compile-time and not at run-time the address used in the pointer doesn't have to be a proper or valid address.

3. 比较文件差异：meld

## 第三讲 启动、中断、异常和系统调用

1. 实模式下地址总线只有20根，此时地址空间只有1MB。

2. BIOS启动固件
    * 基本输入输出的程序
    * 系统配置信息，比如从哪里启动（磁盘、U盘、光盘等）
    * 开机后自检程序
    * 系统自启动程序
    * 将加载程序BootLoader从磁盘的引导扇区加载到0x7c00

3. 为什么不直接由BIOS加载操作系统，而是先由BIOS加载BootLoader，而BootLoader再去加载操作系统？
    * 不同操作系统的文件系统不同，BIOS不可能全部能识别

4. BIOS在加载BootLoader前需进行的工作
    * BIOS读取主引导扇区代码，得到主引导记录
    * 主引导扇区代码读取活动分区的引导扇区代码

5. 硬件自检主要检测内存和显卡等关键部件的存在或工作状态

6. BIOS有一个ESCD表，扩展系统配置数据


