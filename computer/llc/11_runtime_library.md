# 《程序员的自我修养》第11章读书笔记

## 11 运行库

### 11.1 入口函数和程序初始化

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

### 11.2 C/C++运行库

1. 为了保证最终输出文件中“.init”和“.fini”的正确性，我们必须保证在链接时，crti.o必须在用户目标文件之前，而crtn.o必须在用户目标文件和系统库之后。

2. 在默认情况下，ld链接器会将libc、crt1.o等这些CRT和启动文件与程序的模块链接起来，但有些时候我们可能不需要这些文件，或者希望使用自己的libc和crt1.o等启动文件，以替代系统默认的文件，这种情况在嵌入式系统或操作系统内核编译的时候很常见。GCC提供了两个参数“-nostartfile”和“-nostdlib”，分别用来取消默认的启动文件和C语言运行库。

3. 其实C++全局对象的构造函数和析构函数并不是直接放在.init和.fini段里面的，而是把一个执行所有构造/析构的函数的调用放在里面，由这个函数进行真正的构造和析构。

4. 除了全局对象构造和析构之外，.init和.fini还有其他的作用。由于它们的特殊性（在main之前/后执行），一些用户监控程序性能、调试等工具经常利用它们进行一些初始化和反初始化的工作。

5. crti.o和crtn.o中的“.init”和“.fini”提供一个在main()之前和之后运行代码的机制，而真正全局构造和析构则由crtbeginT.o和crtend.o来实现。

6. 微软提供了一套运行库的命名方法：`libc [p] [mt] [d] .lib`
    - p 表示 C Plusplus，即C++标准库
    - mt 表示Multi-Thread，即表示支持多线程
    - d 表示 Debug，即表示调试版本

#### 跟踪一个简单的C++程序的运行过程

1. 一个简单的C++程序
```
class Hello
{
public:
    Hello() 
    {
        data = new int(100);
        cout << "Hello World! " << *data << endl; 
    }
    ~Hello()
    {
        if (data)
            delete data;
    }

private:
    int *data;
};

Hello hi;

int main()
{
    int foo = 425;
    int bar = 620;
    cout << foo + bar << endl;
    return 0;
}
```

2. 首先在程序的第一条指令处打断点，方法是：使用`gdb a.out -tui`进入gdb调试界面后，输入`info files`，输出结果中"Entry point"的值或".text"起始值就是程序的第一条指令的地址。实验可知程序的第一条指令为\_start函数的入口，因此输入`b _start`也可以在程序入口打断点。

3. 入口函数\_start会把\_\_libc\_csu\_fini, \_\_libc\_csu\_init和main的地址加载到寄存器中，然后跳到\_\_libc\_start\_main运行。
```
00000000000008b0 <_start>:
 8b0:	31 ed                	xor    %ebp,%ebp
 8b2:	49 89 d1             	mov    %rdx,%r9
 8b5:	5e                   	pop    %rsi
 8b6:	48 89 e2             	mov    %rsp,%rdx
 8b9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 8bd:	50                   	push   %rax
 8be:	54                   	push   %rsp
 8bf:	4c 8d 05 ca 02 00 00 	lea    0x2ca(%rip),%r8        # b90 <__libc_csu_fini>
 8c6:	48 8d 0d 53 02 00 00 	lea    0x253(%rip),%rcx        # b20 <__libc_csu_init>
 8cd:	48 8d 3d e6 00 00 00 	lea    0xe6(%rip),%rdi        # 9ba <main>
 8d4:	ff 15 06 17 20 00    	callq  *0x201706(%rip)        # 201fe0 <__libc_start_main@GLIBC_2.2.5>
 8da:	f4                   	hlt    
 8db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
```

4. \_\_libc\_start\_main做了哪些事情（注：\_\_libc\_start\_main函数定义在glibc/csu/libc-start.c文件中，编译后打包在libc.a文件中，以下代码进行了删减，只保留我认为重要的流程）
    - 获取并设置环境变量
    - 初始化栈地址
    - 注册需要在main函数结束后调用的函数
    - 执行需要在main函数运行前调用的函数
    - 执行main函数
    - 调用exit函数，在exit函数里面会逐个调用之前注册的函数
```
/* Note: the fini parameter is ignored here for shared library.  It
   is registered with __cxa_atexit.  This had the disadvantage that
   finalizers were called in more than one place.  */
STATIC int
__libc_start_main(int (*main) (int, char **, char ** MAIN_AUXVEC_DECL),
		          int argc, char **argv,
		          __typeof (main) init,
		          void (*fini) (void),
		          void (*rtld_fini) (void), void *stack_end)
{
  char **ev = &argv[argc + 1];
  __environ = ev;

  __libc_stack_end = stack_end;

  /* Register the destructor of the dynamic linker if there is any.  */
  if (__glibc_likely (rtld_fini != NULL))
    __cxa_atexit ((void (*) (void *)) rtld_fini, NULL, NULL);

  /* Register the destructor of the program, if any.  */
  if (fini)
    __cxa_atexit ((void (*) (void *)) fini, NULL, NULL);

  if (init)
    (*init) (argc, argv, __environ MAIN_AUXVEC_PARAM);

  result = main (argc, argv, __environ MAIN_AUXVEC_PARAM);

  exit (result);
}
```

### 11.3 运行库与多线程

1. 多线程运行库
    - 对于C/C++标准库来说，线程相关的部分是不属于标准库的内容的，它跟网络、图形图像等一样，属于标准库之外的系统相关库。
    - “多线程相关”包括两方面，一方面是提供那些多线程操作的接口，比如创建线程、退出线程、设置线程优先级等函数接口；另外一方面是C运行库本身要能够在多线程的环境下正确运行。
