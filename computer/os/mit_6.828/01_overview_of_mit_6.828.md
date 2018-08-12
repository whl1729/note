# MIT 6.828 课程介绍

本文是对MIT 6.828操作系统课程介绍的简单摘录，详细介绍见[6.828: Learning by doing](https://pdos.csail.mit.edu/6.828/2017/overview.html)以及朱佳顺的[推荐一门课：6.828](http://lifeofzjs.com/blog/2016/02/24/recommmend-6-dot-828/)。学习资源均可以在课程主页找到，包括课程讲义、源代码、工具使用、实验作业等。2017年的课程主页中没有教学视频，想看视频的可以在[2011年的课程主页](https://pdos.csail.mit.edu/6.828/2011/schedule.html)中找。（无字幕，再加上我英语听力很差，基本听不懂......）

## what you will learn

* virtual memory, kernel and user mode, system calls, threads, context switches, interrupts, interprocess communication, coordination of concurrent activities.
* the interface between software and hardware. 
* the interactions between these concepts, and how to manage the complexity introduced by the interactions.

## how 6.828 is organized
6.828 is organized in three parts: lectures, readings, and a sequence of programming labs. 

### lectures
The lectures are organized in two main blocks:
1. introduces one operating system, xv6 (x86 version 6), which is a re-implementation of Unix Version 6, which was developed in the 1970s. In each lecture we will take one part of xv6 and study its source code.

2. covers important operating systems concepts invented after Unix v6. We will study the more modern concepts by reading research papers and discussing them in lecture. You will also implement some of these newer concepts in your operating system.

### labs
The labs are split into 6 major parts that build on each other, culminating in a primitive operating system on which you can run simple commands through your own shell.
1. Booting
2. Memory management
3. User environments
4. Preemptive multitasking
5. File system, spawn, and shell
6. Network driver
