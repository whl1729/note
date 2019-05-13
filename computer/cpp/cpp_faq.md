# C++ FAQ

## Q7 2019/05/12 打开文件没释放会有什么后果？

1. 问题详述：程序运行过程中打开某个文件，程序结束时没释放该文件，会有什么后果？

## Q6 2019/05/12 C++ static成员变量是如何初始化的？初始化成员变量时需不需要调用构造函数？

## Q5 2019/05/12 C++的最新实现与《Inside the C++ Object Model》有何区别？

## Q4 2019/05/12 C++编译器是如何保存static成员变量、成员函数的地址？

## Q3 2019/05/12 C++语言、编译器和操作系统之间是怎么配合的？

1. C++开发中的层次结构是怎样的？接口调用关系是怎样的？
```
应用程序 -> API（位于library中）-> system call interface -> system call 
// Example:
user program -> fopen -> open -> sys_open
```

> 《Operating System Concepts》"2.3 System Calls": Typically, application developers design programs according to an application programming interface (API). Three of the most common APIs available to application programmers are the Windows API for Windows systems, the POSIX API for POSIX-based systems (which include virtually all versions of UNIX, Linux, and Mac OS X), and the Java API for programs that run on the Java virtual machine. A programmer accesses an API via a library of code provided by the operating system. In the case of UNIX and Linux for programs written in the C language, the library is called libc.

> 《Operating System Concepts》"2.3 System Calls": For most programming languages, the run-time support system (a set of functions built into libraries included with a compiler) provides a systemcall interface that serves as the link to system calls made available by the operating system. The system-call interface intercepts function calls in the API and invokes the necessary system calls within the operating system. Typically, a number is associated with each system call, and the system-call interface maintains a table indexed according to these numbers. The system call interface then invokes the intended system call in the operating-system kernel and returns the status of the system call and any return values.

2. C++标准库是用C++编写的，在Linux环境下，C++标准库最终应该需要调用Linux操作系统提供的系统调用接口。而Linux操作系统是用C编写的，那么C++标准库如何与C语言的系统调用接口适配的？

3. C++语言、编译器和操作系统之间是怎么配合的？答：我们可以参考Ubuntu环境来帮助理解这个问题：
    - 首先gcc编译器提供了C++标准库的头文件和二进制文件，头文件在/usr/include/c++/7目录下，二进制文件在/usr/lib/gcc/x86_64-linux-gnu/7目录下，包括libstdc++.a和libstdc++.so等。
    - linux系统

4. C++是如何做到支持多个操作系统的？

5. 从开发的角度来看，Windows系统和Linux系统的区别是什么？系统调用API不一样？
    - Windows和Linux创建进程的方式不一样？Windows下是createThread之类的接口，Linux下是fork + exec？
    - Linux系统主要使用C语言和汇编开发，Windows系统主要使用C和C++开发。
    - 操作系统一般通过系统调用来向上层提供服务。这些系统调用一般使用C或C++来编写，有些low-level tasks也可能使用汇编来编写。

6. 同一个C++程序，可以不作任何修改，就在多个操作系统上面编译运行吗？

7. operator new究竟是由标准库还是编译器实现？

8. 标准库与运行库的区别？
[c运行库、c标准库、windows API的区别和联系](https://www.cnblogs.com/renyuan/p/5031100.html)

## Q2 2019/05/12 编译型语言与解释型语言的区别有哪些？解释型语言是怎样运行的？

## Q1 2019/05/12 强类型与弱类型各有什么优劣之处？C++能否支持强类型？

1. 问题详述：C++的类型检查发生在编译阶段，而Python的类型检查发生在运行阶段，两者各有什么优缺点？

