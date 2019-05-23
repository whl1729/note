# 《程序员的自我修养》第3章读书笔记

## 3 目标文件里有什么

1. elf文件类型
    - 可重定位文件：.o, .obj
    - 可执行文件：/bin/bash, .exe
    - 共享目标文件：.so, .dll
    - 核心转储文件：core dump

2. 目标文件各个段的内容
    - `.text` 代码段，存放程序源代码编译后的机器指令
    - `.data` 数据段，存放已初始化的全局变量和局部静态变量
    - `.bss` 数据段，存放未初始化的全局变量和局部静态变量
    - `.rodata` 数据段，存放的是只读数据，一般是程序里的只读变量（如const修饰的变量）和字符串常量

3. `readelf` 打印ELF文件的信息
    - `-a` 打印所有信息
    - `-S` Displays the information contained in the file's section headers, if it has any.
    - `-h` Displays the information contained in the ELF header at the start of the file.

4. `objdump` 打印ELF文件的信息
    - `-d` 打印反汇编后的汇编代码
    - `-h` 打印ELF文件各个段的基本信息
    - `-S` 交替打印源代码和汇编代码
    - `-t` Print the symbol table entries of the file.  This is similar to the information provided by the nm program, although the display format is different. 
    - `-x` Display all available header information, including the symbol table and relocation entries.
    - `-i` Display a list showing all architectures and object formats available for specification with -b or -m.
    - `-s` Display the full contents of any sections requested.  By default all non-empty sections are displayed.

5. `size` 查看ELF文件的代码段、数据段、BSS段的长度

6. 如何将一个二进制文件（比如图片、MP3、词典等）作为目标文件中的一个段？答：可以使用objdump工具：`objcopy -I binary -O elf32-i386 -B i386 image.jpg image.o`
