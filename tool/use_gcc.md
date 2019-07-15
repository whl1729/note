# gcc 使用笔记

## gcc 常用选项

1. `-E` 只进行预编译，比如`gcc -E hello.c -o hello.i`

2. You could compile with `gcc -v -H` to understand more precisely which actual programs are run (since gcc is a driver, running the cc1 compiler, the ld & collect2 linkers, the as assembler, etc...) and which headers are included, which libraries and object files are linked (even implicitly, including the C standard library and the crt0).

## ELF

### 查看ELF文件

1. `readelf` 打印ELF文件的信息
    - `-a` 打印所有信息
    - `-l` 打印segment信息
    - `-s` 打印符号表信息
    - `-S` 打印段表信息。Displays the information contained in the file's ***section headers***, if it has any.（伍注：打印section headers，所以选项为首字母S）
    - `-h` Displays the information contained in the ELF header at the start of the file.

2. `objdump` 打印ELF文件的信息
    - `-a` If any of the objfile files are archives, display the archive header information（如果输入文件是一个包，则打印包中的所有文件信息，比如可以显示一个.a文件中含有哪些.o文件）
    - `-d` 打印反汇编后的汇编代码
    - `-f` 打印文件的格式、硬件架构及入口地址等基本信息
    - `-h` 打印ELF文件各个段的基本信息。输出的每个段的第二行表示段的各种属性，"CONTENTS"表示该段在文件中存在，"ALLOC"
    - `-r` 打印目标文件的重定位表，可以查看目标文件中需要重定位的地方
    - `-s` 打印所有非空段的全部内容，可打印字符会显示在右侧
    - `-s -j .text` 打印.text段的全部内容
    - `-S` 交替打印源代码和汇编代码
    - `-t` Print the symbol table entries of the file.  This is similar to the information provided by the nm program, although the display format is different. 
    - `-x` Display all available header information, including the symbol table and relocation entries.
    - `-i` Display a list showing all architectures and object formats available for specification with -b or -m.

> 注：`objdump -h`只显示关键的段，而省略了其他辅助性的段，比如符号表、字符串表、段名字符串表、重定位表等。而`readelf -S`则显示所有的段。

3. `size` 查看ELF文件的代码段、数据段、BSS段的长度

4. `hexdump` 查看文件的十六进制编码
    - `-C` 每行以16进制的方式打印16个字符，右边显示对应的字符

5. `nm` 查看ELF文件的符号表

6. `strip` 去掉ELF文件中的调试信息

7. `ar` 创建、修改或解压archives
    - `-x` 把.a文件中的所有目标文件“解压”到当前目录
    - `-t` 查看.a文件中包含哪些.o文件

### ELF文件结构

1. ELF文件头
    - 前4个字节是所有ELF文件都必须相同的标识码（称为ELF魔数），分别为0x7F、0x45、 0x4c和0x46，依次对应DEL控制符及ELF的ASCII码。
    - 第5个字节标识文件类：0表示无效文件，1表示32位ELF文件，2表示64位ELF文件。
    - 第6个字节标识字节序：0表示无效格式，1表示小端，2表示大端。
    - 第7个字节标识ELF的主版本号，一般为1，因为ELF标准自1.2版以后再无更新。
    - 第8～16字节没有定义，一般填0，有些平台会用作扩展标志。
    - 第17～18字节标识文件类型，主要有3类
        - ET_REL: 值为1，表示可重定位文件，一般为.o文件
        - ET_EXEC: 值为2，表示可执行文件
        - ET_DYN: 值为3，表示共享目标文件，一般为.so文件
```
struct elfhdr {
    uint32_t e_magic;     // must equal ELF_MAGIC
    uint8_t e_elf[12];
    uint16_t e_type;      // 1=relocatable, 2=executable, 3=shared object, 4=core image
    uint16_t e_machine;   // 3=x86, 4=68K, etc.
    uint32_t e_version;   // file version, always 1
    uint32_t e_entry;     // entry point if executable
    uint32_t e_phoff;     // file position of program header or 0
    uint32_t e_shoff;     // file position of section header or 0
    uint32_t e_flags;     // architecture-specific flags, usually 0
    uint16_t e_ehsize;    // size of this elf header
    uint16_t e_phentsize; // size of an entry in program header
    uint16_t e_phnum;     // number of entries in program header or 0
    uint16_t e_shentsize; // size of an entry in section header
    uint16_t e_shnum;     // number of entries in section header or 0
    uint16_t e_shstrndx;  // section number that contains section name strings
};
```

> 疑问：什么是program header？什么是section header？
> 答：program header是描述segment的结构，section header是描述section的结构。一个segment包含一个或多个属性类似的“Section”。

2. 段的类型：对于编译器和链接器而言，主要决定段的属性的是段的类型和段的标志位。
    - NULL: 无效段
    - PROGBITS: 程序段。代码段和数据段都属于这种类型
    - SYMTAB: 表示该段的内容为符号表
    - STRTAB: 表示该段的内容为字符串表
    - NOBITS: 表示该段在文件中没内容
    - RELA: 重定位表，包含了重定位信息
    - REL: 该段包含了重定位信息
    - HASH: 符号表的哈希表
    - DYNAMIC: 动态链接信息
    - DNYSYM: 动态链接的符号表
    - NOTE: 提示性信息

> 疑问：符号表和字符串表的区别是什么？ 
> 答：符号表记录函数、变量等符号的信息，字符串表保存字符串。符号表中每个符号的名字也是保存在字符串表中的，符号表通过记录符号名在字符串表中的偏移来访问符号名。

3. 字符串表
    - 定义：ELF文件中用到段名、变量名等字符串，为便于管理，ELF文件将字符串集中起来存放在一个表，然后使用字符串在表中的偏移来引用字符串。这个表便是字符串表。
    - 一般字符串表在ELF文件中也以段的形式来保存，常见的段名为".strtab"和".shstrtab"，分别代表字符串表和段表字符串表（Section Header String Table）。顾名思义，字符串表保存普通的字符串，比如符合的名字；段表字符串表保存段表中用到的字符串，比如段名。

> 伍注：让我们分析一下如何找到段表字符串表：首先，从ELF文件头的shoff字段可以知道段表在文件中的偏移，从ELF文件头的shstrndx字段可以知道段表字符串表所在的段在段表中的下标；根据段表的起始位置及下标可以找到段表字符串表。

4. 链接的接口——符号
    - 在链接中，我们将函数和变量统称为符号，函数名或变量名就是符号名。每个符号有一个对应的值，叫做符号值。对变量和函数而言，符号值就是它们的地址。
    - 我们可以将符号看做是连接中的粘合剂，整个链接过程正是基于符号才能正确完成。链接过程中很关键的一部分就是符号的管理。每一个目标文件都有一个相应的符号表，记录了目标文件中所用到的所有符号。
    - 符号表中的符号分类
        - 在本目标文件中定义的全局符号
        - 在本目标文件中声明而没定义的全局符号，一般叫做外部符号
        - 段名，往往由编译器产生，它的值就是该段的起始地址
        - 局部符号，只在编译单元内部可见，比如static变量
        - 行号信息
    - 特殊符号：当我们使用ld来链接生产可执行文件时，它会为我们定义很多特殊符号。链接器会在将程序最终链接成可执行文件的时候将其解析成正确的值。
        - `_executable_start` 程序起始地址（不是入口地址）
        - `_etext` 代码段结束地址
        - `_edata` 数据段结束地址
        - `_end` 程序结束地址

> 伍注：我理解经过编译链接后，所有的符号都会翻译成地址及指令，所以对于最终的可执行文件而言，符号名不是必须的，因此strip掉它们也没关系。但是，程序中的一些字符串常量又是存放在哪里的？如果是存放在字符串表，那么字符串表就不能strip掉，这样会造成不必要的空间浪费。我理解应该不是放在字符串表的。

5. `extern "C"`的作用：C++编译器具有符号修饰机制，而C语言不具有。如果在C++程序中调用C语言的函数，会因为C++编译器对函数名进行符号修饰而链接不到C语言的函数。为避免这个问题，可以把C语言的函数声明放在`extern "C"`的大括号内部，C++编译器会将在`extern "C"`大括号内部的代码当做C语言代码处理。

6. eh_frame
    - eh_frame contains exception unwinding and source language information. Each entry in this section is represented by single CFI (call frame information).
    - eh_frame_hdr, is used by c++ runtime code to access the eh_frame. That means, it contains the pointer and binary search table to efficiently retrieve the information from eh_frame.

7. 重定位表
    - 在ELF文件中，有一个叫重定位表（Relocation Table）的结构专门用来保存与重定位相关的信息。它在ELF文件中往往是一个或多个段。
    - 如果代码段".text"有要被重定位的地方，那么就会有一个对应的".rel.text"段保存了代码段的重定位表；如果数据段".data"有要被重定位的地方，那么就会有一个对应的".rel.data"段保存了数据段的重定位表。
    - 使用`objdump -r`可以查看目标文件的重定位表。

#### stabs

1. stabs
    - For some object file formats, the debugging information is encapsulated in assembler directives known collectively as ***stab (symbol table)*** directives.
    - The assembler adds the information from stabs to the symbol information it places by default in the ***symbol table and the string table*** of the .o file it is building. The linker consolidates the .o files into one executable file, with one symbol table and one string table. Debuggers use the symbol and string tables in the executable as a source of debugging information about the program.

2. There are three overall formats for stab assembler directives, differentiated by the first word of the stab. The name of the directive describes which combination of four possible data fields follows. It is either .stabs (string), .stabn (number), or .stabd (dot). IBM’s XCOFF assembler uses .stabx (and some other directives such as .file and .bi) instead of .stabs, .stabn or .stabd. The overall format of each class of stab is:
```
.stabs "string",type,other,desc,value
.stabn type,other,desc,value
.stabd type,other,desc
.stabx "string",value,type,sdb-type
```

3. Symbol Table Format（stabs格式）
```
struct internal_nlist {
  unsigned long n_strx;         /* index into string table of name */
  unsigned char n_type;         /* type of symbol */
  unsigned char n_other;        /* misc info (usually empty) */
  unsigned short n_desc;        /* description field */
  bfd_vma n_value;              /* value of symbol */
};
```

4. n_type
    - N_FUN: Function name (see Procedures) or text segment variable
    - N_LSYM: Stack variable 
    - N_SLINE: Line number in text segment
    - N_SO: Path and name of source file; see Source Files.
    - N_SOL: Name of include file

5. [STABS](https://sourceware.org/gdb/onlinedocs/stabs/index.html#Top)

## 预处理

参考资料：[Preprocessor Output](https://gcc.gnu.org/onlinedocs/cpp/Preprocessor-Output.html)

1. Source file name and line number information is conveyed by lines of the form `# linenum filename flags` These are called linemarkers. They mean that the following line originated in file filename at line linenum. 

2. After the file name comes zero or more flags, which are ‘1’, ‘2’, ‘3’, or ‘4’. If there are multiple flags, spaces separate them. Here is what the flags mean:
    - `1` This indicates the start of a new file.
    - `2` This indicates returning to a file (after having included another file).
    - `3` This indicates that the following text comes from a system header file, so certain warnings should be suppressed.
    - `4` This indicates that the following text should be treated as being wrapped in an implicit extern "C" block.

3. 经过预编译后的.i文件不包含任何宏定义，因为所有的宏已经被展开，并且包含的文件也已经被插入到.i文件。所以当我们无法判断宏定义是否正确或头文件包含是否正确时，可以查看预编译后的文件来确定问题。

## 编译

1. 观察编译阶段做了什么事情（注：gcc使用cc1的程序来完成编译，其中有个默认编译选项`-quiet`，会导致不显示编译各阶段的执行时间。如果我们想观察这个信息，可以手动调用cc1工具来编译，别带上`-quiet`选项即可）
```
along:~/src/exercise/lll/02$ /usr/lib/gcc/x86_64-linux-gnu/7/cc1 -v -imultiarch x86_64-linux-gnu -H hello.c

Execution times (seconds)
 phase setup             :   0.02 (33%) usr   0.00 ( 0%) sys   0.02 (11%) wall    1179 kB (68%) ggc
 phase parsing           :   0.01 (17%) usr   0.02 (100%) sys   0.09 (50%) wall     488 kB (28%) ggc
 phase opt and generate  :   0.03 (50%) usr   0.00 ( 0%) sys   0.07 (39%) wall      55 kB ( 3%) ggc
 preprocessing           :   0.00 ( 0%) usr   0.01 (50%) sys   0.04 (22%) wall     152 kB ( 9%) ggc
 lexical analysis        :   0.00 ( 0%) usr   0.01 (50%) sys   0.01 ( 6%) wall       0 kB ( 0%) ggc
 parser (global)         :   0.01 (17%) usr   0.00 ( 0%) sys   0.03 (17%) wall     320 kB (18%) ggc
 parser struct body      :   0.00 ( 0%) usr   0.00 ( 0%) sys   0.01 ( 6%) wall      12 kB ( 1%) ggc
 tree PHI insertion      :   0.01 (17%) usr   0.00 ( 0%) sys   0.00 ( 0%) wall       0 kB ( 0%) ggc
 final                   :   0.00 ( 0%) usr   0.00 ( 0%) sys   0.01 ( 6%) wall       1 kB ( 0%) ggc
 initialize rtl          :   0.02 (33%) usr   0.00 ( 0%) sys   0.05 (28%) wall      12 kB ( 1%) ggc
 repair loop structures  :   0.00 ( 0%) usr   0.00 ( 0%) sys   0.01 ( 6%) wall       0 kB ( 0%) ggc
 TOTAL                 :   0.06             0.02             0.18               1731 kB
```

## 链接

### 基础知识

1. 设置共享库路径：`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/SD0/c1/lib`

### collect2

1. 使用`gcc -v -H`编译hello.c文件时，发现链接过程中用到的是collect2而不是ld，那么collect2是什么玩意？以下来自[gcc collect2的说明文档](https://gcc.gnu.org/onlinedocs/gccint/Collect2.html)

2. GCC uses a utility called collect2 on nearly all systems to arrange to call various initialization functions at start time.

3. The program collect2 works by linking the program once and looking through the linker output file for symbols with particular names indicating they are constructor functions. If it finds any, it creates a new temporary ‘.c’ file containing a table of them, compiles it, and links the program a second time including that file.

4. The actual calls to the constructors are carried out by a subroutine called \_\_main, which is called (automatically) at the beginning of the body of main (provided main was compiled with GNU CC). Calling \_\_main is necessary, even when compiling C code, to allow linking C and C++ object code together. (If you use -nostdlib, you get an unresolved reference to \_\_main, since it’s defined in the standard GCC library. Include -lgcc at the end of your compiler command line to resolve this reference.)

### 动态链接

1. ELF可执行文件引入了一个概念叫“Segment”，一个Segment包含一个或多个属性类似的“Section”。Segment的概念实际上是从装载的角度重新划分了ELF的各个段。在将目标文件链接成可执行文件时，链接器会尽量把相同权限属性的段分配在同一空间。这样做的好处是可以很明显地减少页面内部碎片，从而节省了内存空间。

2. 一个进程基本上可以分为如下几种VMA区域：
    - 代码VMA，权限只读、可执行；有映像文件
    - 数据VMA，权限可读写、可执行；有映像文件
    - 堆VMA，权限可读写、可执行；无映像文件，匿名，可向上扩展
    - 栈VMA，权限可读写、不可执行；无映像文件，匿名，可向下扩展
