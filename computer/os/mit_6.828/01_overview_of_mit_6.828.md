# MIT 6.828学习笔记1：课程介绍（Overview）

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
