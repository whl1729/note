# 《程序员的自我修养》读书笔记

## 第3章 目标文件里有什么

1. elf文件类型
    - 可重定位文件：.o, .obj
    - 可执行文件：/bin/bash, .exe
    - 共享目标文件：.so, .dll
    - 核心转储文件：core dump

### 目标文件各个段的内容

1. `.text` 代码段，存放程序源代码编译后的机器指令

2. `.data` 数据段，存放已初始化的全局变量和局部静态变量

3. `.bss` 数据段，存放未初始化的全局变量和局部静态变量

4. `.rodata` 数据段，存放的是只读数据，一般是程序里的只读变量（如const修饰的变量）和字符串常量

### 目标文件的查询命令

1. `readelf` 打印ELF文件的信息
    - `-a` 打印所有信息
    - `-S` Displays the information contained in the file's section headers, if it has any.
    - `-h` Displays the information contained in the ELF header at the start of the file.

2. `objdump` 打印ELF文件的信息
    - `-d` 打印反汇编后的汇编代码
    - `-h` 打印ELF文件各个段的基本信息
    - `-S` 交替打印源代码和汇编代码
    - `-t` Print the symbol table entries of the file.  This is similar to the information provided by the nm program, although the display format is different. 
    - `-x` Display all available header information, including the symbol table and relocation entries.
    - `-i` Display a list showing all architectures and object formats available for specification with -b or -m.
    - `-s` Display the full contents of any sections requested.  By default all non-empty sections are displayed.


3. `size` 查看ELF文件的代码段、数据段、BSS段的长度

## 第6章 可执行文件的装载与进程

1. ELF可执行文件引入了一个概念叫“Segment”，一个Segment包含一个或多个属性类似的“Section”。Segment的概念实际上是从装载的角度重新划分了ELF的各个段。在将目标文件链接成可执行文件时，链接器会尽量把相同权限属性的段分配在同一空间。这样做的好处是可以很明显地减少页面内部碎片，从而节省了内存空间。

2. 一个进程基本上可以分为如下几种VMA区域：
    - 代码VMA，权限只读、可执行；有映像文件
    - 数据VMA，权限可读写、可执行；有映像文件
    - 堆VMA，权限可读写、可执行；无映像文件，匿名，可向上扩展
    - 栈VMA，权限可读写、不可执行；无映像文件，匿名，可向下扩展

## 第11章

1. 程序的入口点（Entry Point）实际上是一个程序的初始化和结束部分，它往往是运行库的一部分。

2. 一个典型的程序运行步骤大致如下：
    - 操作系统在创建进程后，把控制权交到了程序的入口，这个入口往往是运行库中的某个入口函数。
    - 入口函数对运行库和程序运行环境进行初始化，包括堆、I/O、线程、全局变量构造，等等。
    - 入口函数在完成初始化之后，调用main函数，正式开始执行程序主体部分。
    - main函数执行完毕以后，返回到入口函数，***入口函数进行清理工作，包括全局变量析构、堆销毁、关闭I/O等***，然后进行系统调用结束进程。（伍注：所以即使程序员忘记在程序中释放内存或者忘记关闭文件，离开main函数后这些资源会由运行库的入口函数释放。）


3. 运行时库（Runtime Library）：任何一个C程序，它的背后都有一套庞大的代码来进行支撑，以使得该程序能够正常运行。这套代码至少包括入口函数，其依赖的函数所构成的函数集合，以及各种标准库函数的实现。这样的一个代码集合称之为运行时库。C语言的运行库，称为C运行库（CRT）。

4. 一个C运行库大致包含了以下功能：
    - 启动与退出：包括入口函数及入口函数所依赖的其他函数
    - 标准函数：C语言标准库的函数实现
    - I/O：I/O功能的封装和实现
    - 堆：堆的封装和实现
    - 语言实现：语言中的一些特殊功能的实现
    - 调试：实现调试功能的代码

疑问：操作系统是如何把进程交到运行库的入口点的？

5. Linux和Windows平台下的两个主要C语言运行库分别为glibc(GNU C Library)和MSVCRT（MicroSoft Visual C Run-Time）。

6. [Why glibc is maintained separately from GCC?](https://softwareengineering.stackexchange.com/questions/348588/why-glibc-is-maintained-separately-from-gcc)

7. 为了保证最终输出文件中“.init”和“.fini”的正确性，我们必须保证在链接时，crti.o必须在用户目标文件之前，而crtn.o必须在用户目标文件和系统库之后。

8. 在默认情况下，ld链接器会将libc、crt1.o等这些CRT和启动文件与程序的模块链接起来，但有些时候我们可能不需要这些文件，或者希望使用自己的libc和crt1.o等启动文件，以替代系统默认的文件，这种情况在嵌入式系统或操作系统内核编译的时候很常见。GCC提供了两个参数“-nostartfile”和“-nostdlib”，分别用来取消默认的启动文件和C语言运行库。

9. 其实C++全局对象的构造函数和析构函数并不是直接放在.init和.fini段里面的，而是把一个执行所有构造/析构的函数的调用放在里面，由这个函数进行真正的构造和析构。

10. 除了全局对象构造和析构之外，.init和.fini还有其他的作用。由于它们的特殊性（在main之前/后执行），一些用户监控程序性能、调试等工具经常利用它们进行一些初始化和反初始化的工作。

11. crti.o和crtn.o中的“.init”和“.fini”提供一个在main()之前和之后运行代码的机制，而真正全局构造和析构则由crtbeginT.o和crtend.o来实现。

12. 微软提供了一套运行库的命名方法：`libc [p] [mt] [d] .lib`
    - p 表示 C Plusplus，即C++标准库
    - mt 表示Multi-Thread，即表示支持多线程
    - d 表示 Debug，即表示调试版本

13. 多线程运行库
    - 对于C/C++标准库来说，线程相关的部分是不属于标准库的内容的，它跟网络、图形图像等一样，属于标准库之外的系统相关库。
    - “多线程相关”包括两方面，一方面是提供那些多线程操作的接口，比如创建线程、退出线程、设置线程优先级等函数接口；另外一方面是C运行库本身要能够在多线程的环境下正确运行。
