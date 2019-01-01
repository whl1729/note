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

