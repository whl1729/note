# 《MIT 6.828 Homework 2: Shell》解题报告

Homework 2的网站链接：[MIT 6.828 Homework 2: shell](https://pdos.csail.mit.edu/6.828/2017/homework/xv6-shell.html)

## 题目
1. 下载[sh.c](https://pdos.csail.mit.edu/6.828/2017/homework/sh.c)文件，在文件中添加相应代码，以支持以下关于shell的功能：
    * 实现简单shell命令，比如cat/echo/grep/ls/sort/uniq/wc等
    * 实现I/O重定向
    * 实现管道

2. Optional challenge exercises:
    * Implement lists of commands, separated by ";"
    * Implement sub shells by implementing "(" and ")"
    * Implement running commands in the background by supporting "&" and "wait"

## 解答
我关于Homework 2的实现代码见[whl1729/mit_6.828](https://github.com/whl1729/mit_6.828/tree/master/src/hw2/sh.c)。简单说下我的完成情况。

### 已完成
1. 已实现cat/echo/grep/ls/rm/sort/uniq/wc等命令的基本功能。所谓基本功能是指实现了对应命令的默认选项，而还不支持更多选项。比如，真实shell环境中的sort支持-n（按数值排序）和-r（逆序）、grep支持正则表达式等，这些我都还不支持。
2. 已实现I/O重定向
3. 已实现管道

### 未完成
1. 尚未支持简单命令的更多选项。
2. 还没做challenge的功能。

### 已发现并解决的bug

#### Bug 1：执行`ls | sort | uniq`命令时始终只打印一行信息

1. 详细现象：执行各个普通命令及大部分多级管道命令时功能都正常，唯独当执行sort命令后接其他命令时有异常。比如当前目录下有5个文件，执行`ls | sort`是正常的，可以显示排序后的5行内容，但再后接uniq或grep等命令时，始终只打印一行信息。

2. 定位过程：
    * 一开始怀疑是多级管道的实现有问题，比如某个文件描述符忘记close、两个进程之间读写时序没同步等，将各种可能的情况尝试后问题仍存在。
    * 由于只有sort命令后接其他命令时存在问题，接下来怀疑是sort的实现有问题。首先怀疑排序算法有bug，但注释后问题仍然存在。
    * 将sort函数内的大部分代码注释掉，只保留读输入和写输出的几行代码，并参考其他简单命令的实现，最终发现是`write(fileno(stdout), plines[pos], LINE_NUM));`这一行出错，修改为`write(fileno(stdout), plines[pos], strlen(plines[pos]);`就可以了。

3. 问题根因：write函数原型是`ssize_t write(int fd, const void *buf, size_t count);`，我以为如果count > strlen(buf)，最多只会写strlen(buf)个字符，然而事实上并非如此！如果不出现信号中断、存储空间不够或count大于系统限制的字节数RLIMIT_FSIZE等情况（一般不会出现），write函数会写够count个字符！因此，我的sort函数每次调用write时，除了写文件名，还写了大量的null字符，于是下一个进程在第一次read的时候，就读到了文件结束符，导致永远只能打印一行。

4. 反思：这个问题定位了3天，累计约10个小时。定位效率太低了！原因是自己没搞懂原理，盲目乱试，最后还是靠不断注释代码来找到原因的。教训是定位问题前先把基本原理搞清楚，包括系统知识、函数用法等；定位过程中要合情推理，有依有据地排查。总之，还需要多总结反思、提高定位效率。

#### Bug 2：执行`cat < y | sort`命令时提示"unknown command"

定位过程：由于我之前测试管道命令时没试过同时使用重定向，我很快就怀疑到自己的代码可能不支持解析“管道+重定向”的情形，在梳理了一遍命令解析的过程后（见下文“函数调用关系”中parsecmd的笔记）发现已经支持。然后在检查管道的实现代码时，发现自己在执行每条命令时默认其为普通命令，没考虑到重定向的场景。修改后问题解决。
```
    if (cmds[pos]->type == ' ')
    {
        runecmd(cmds[pos]);
    }
    else
    {
        runrcmd((struct redircmd *)cmds[pos]);
    }
```

#### Bug 3: 通过`./a.out < p.sh`执行'ls > y'命令时y文件无内容

1. 详细现象：当我先运行`./a.out`，然后再输入`ls > y`时，y文件内容正常；而当我先新建p.sh文件、在里面输入`ls > y`并报错，然后执行`./a.out < p.sh`，发现y文件为空。

2. 定位过程：出现问题后，怀疑是ls的实现有问题。ls的实现是参考stackflow的问题[How do you get a directory listing in C?](https://stackoverflow.com/questions/12489/how-do-you-get-a-directory-listing-in-c)来写的，主要代码如下。我很快就怀疑到可能是puts函数没输出到正确的地方，于是改用write，结果问题就解决了。然而，根据[puts的Manual Page](http://man7.org/linux/man-pages/man3/puts.3.html)中的信息“puts() writes the string s and a trailing newline to stdout.”，puts也是将字符串输出到stdout，使用puts和write有啥区别？我还不知道根因是什么？

```
// the code in stackflow:
    while (ep = readdir(dp))
        puts(ep->d_name);

// the code after my modification:
    while (ep = readdir(dp))
    {
        len = strlen(ep->d_name);
        ep->d_name[len++] = '\n';
        ep->d_name[len] = 0;

        if (write(fileno(stdout), ep->d_name, len) < 0)
        {
            fprintf(stderr, "failed to write %s when ls\r\n", ep->d_name);
        }
    }
```

### 尚未解决的bug

#### Bug 4: 先执行管道命令再执行`rm y`时会重复删除y导致报错

1. 详细现象：通过'./a.out < t.sh'来执行t.sh脚本中的多条shell命令时，如果脚本中的`rm y`命令前面没有任何管道命令，则能正常删除文件y并无报错；如果`rm y`前面含有管道命令，比如`ls | uniq`，也会删除掉文件y，但是会报错，remove函数返回错误码-1.如果先运行`./a.out`，再依次输入`ls | grep`和`rm y`这两条命令，则不会报错。

2. 定位过程：
    * 将errno的值及其含义打印出来：`err=2(No such file or directory)`，居然是文件不存在。但是我在执行前明明已经创建了该文件。
    * 在函数入口增加打印，发现remove函数居然被调用了2次。
    * 怀疑是部分文件描述符忘记close，在runpcmd函数退出前增加遍历close所有文件符，但问题依然存在。
    * 进一步发现执行完管道命令后，后面的所有命令都会被执行2次，而且是执行完一遍所有后面的命令后再重新执行第2遍。问题的关键是第2遍执行的命令是从哪里读取的？究竟是怎样导致重复的？折腾了两天还是定位不出来，暂时放弃了，等以后有空再研究。

## sh.c源码剖析

### 函数调用关系

1. peek: 跳过输入字符串\*ps中开头的空白字符，然后读取一个非空字符，判断它是否在指定字符串toks中出现，若出现则返回非零值，否则返回0

2. gettoken: 读取一个单词或"<|>"这几个字符，将其起始和结束位置分别保存在q和eq中，读取后ps偏移到下一个非空字符串的起始处。如果读取结果为"<|>"或结束符，则返回对应字符的值，否则返回字符'a'的值（代表解析结果是普通字符串）。

3. parsecmd
```
parsecmd 
  |- parseline 解析本行的命令
       |- parsepipe 
            |- parseexec 解析普通命令或重定向命令
                 |- execcmd 申请struct execcmd所需内存并初始化
                 |- parseedirs 解析重定向命令并返回解析结果
                      |- peek 判断下一个非空字符是否为"<"或">"，若是，则继续执行下面的操作，否则直接返回
                      |- gettoken 获取字符"<"或">"
                      |- gettoken 获取文件名
                      |- redircmd 将命令名、重定向符和文件名组成redircmd结构体并返回
                 |- peek 若接下来的非空字符为"|"，则结束解析；否则继续解析
                 |- gettoken 读取一个单词（即命令名或输入选项），并保存在cmd中
                 |- parseredir 判断下一个非空字符是否为"<"或">"，若是则解析重定向命令，否则继续解析普通命令
            |- peek 判断下一个字符是否为"|"，若是则继续下面的操作，否则直接返回parseexec的解析结果
            |- gettoken 跳过字符"|"
            |- pipecmd 将当前已解析的命令cmd和下一个命令组成pcmd，注意此处递归调用parsepipe，最终得到一棵右倾斜树
  |- peek 解析完成后，判断本行后面是否还有多余字符，若有则报错
```

### 关于代码的疑问

1. Q：没理解peek函数返回时为什么还要`&&`一下？
   A：理解了。peek函数检查下一个非空白字符是否在目标字符串中，因此首先需要跳过接下来的空白字符后。跳过之后，判断下一个字符是否为字符串结束符0，若是则返回0，否则看下一个字符是否在toks出现，若是则返回非零值，若否则返回0.综上，相与的目的是为了让遇到字符串结束符和字符没在toks出现时都返回0.如果把字符串结束符作为第二个输入参数传给strchr，strchr会返回非零值，因为任何一个字符串都含有字符串结束符。
```
int peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}
```

2. Q: 使用管道时为什么要fork一个子进程？直接在原进程操作不可以吗？

3. Q: 以下代码为什么一定要close p[1]？
```
pipe(p);
if(fork() == 0) {
    close(0);
    dup(p[0]);
    close(p[0]);
    close(p[1]);
    exec("/bin/wc", argv);
} else {
    close(p[0]);
    write(p[1], "hello world\n", 12);
    close(p[1]);
}
```
### 读代码时的笔记

1. isatty:  test whether a file descriptor refers to a terminal. tty stands for TeleTYpewriter.
    * HEADER FILE: `#include <unistd.h>`
    * SYNOPSIS: `int isatty(int fd);`
    * DESCRIPTION: The isatty() function tests whether fd is an open file descriptor referring to a terminal.
    * RETURN VALUE: isatty() returns 1 if fd is an open file descriptor referring to a terminal; otherwise 0 is returned, and errno is set to indicate the error.
    * ERRORS: EBADF -- fd is not a valid file descriptor. EINVAL -- fd refers to a file other than a terminal. POSIX.1 specifies the error ENOTTY for this case.

2. The function fileno() examines the argument  stream  and  returns its integer file descriptor.

3. stdin: Originally I/O happened via a physically connected system console (input via keyboard, output via monitor), but standard streams abstract this. When a command is executed via an interactive shell, the streams are typically connected to the text terminal on which the shell is running, but can be changed with redirection or a pipeline. More generally, a child process will inherit the standard streams of its parent process.

4. `char * strchr (char * str, int character);`: Returns a pointer to the first occurrence of character in the C string str. If the character is not found, the function returns a null pointer.

### 写代码时的笔记

1. open
    * [man open](http://man7.org/linux/man-pages/man2/open.2.html)
    * header file: `sys/types.h, sys/stat.h, fcntl.h`
    * synopsis: `int open(const char *pathname, int flags);`
    * flags: The argument flags must include one of the following access modes: O_RDONLY, O_WRONLY, or O_RDWR. 
    * return: the return value of open() is a file descriptor. The file descriptor returned by a successful call will be the lowest-numbered file descriptor not currently open for the process.

2. read
    * [man read](http://man7.org/linux/man-pages/man2/read.2.html)
    * header file: `unistd.h`
    * synopsis: `ssize_t read(int fd, void *buf, size_t count);`
    * return: On success, the number of bytes read is returned (zero indicates end of file), and the file position is advanced by this number. On error, -1 is returned, and errno is set appropriately.

3. write
    * [man write](https://linux.die.net/man/2/write)
    * header file: `unistd.h`
    * synopsis: `ssize_t write(int fd, const void *buf, size_t count);`
    * return: On success, the number of bytes written is returned (zero indicates nothing was written). On error, -1 is returned, and errno is set appropriately.

4. sort: [Why does the UNIX sort utility ignore leading spaces without the option -b?](https://stackoverflow.com/questions/7168596/why-does-the-unix-sort-utility-ignore-leading-spaces-without-the-option-b)

5. [How do you get a directory listing in C?](https://stackoverflow.com/questions/12489/how-do-you-get-a-directory-listing-in-c)

6. `char *fgets(char *str, int n, FILE *stream)` reads a line from the specified stream and stores it into the string pointed to by str. It stops when either (n-1) characters are read, the newline character is read, or the end-of-file is reached, whichever comes first.

### 调试时的笔记

1. xv6书中说“every process has a private space of file descriptors starting at zero”，那么不同进程的文件描述符对应的文件对象是相互独立的吗？比如进程a的文件描述符1对应stdout，进程b的文件描述符1也对应stdout，这两个stdout是不同的对象还是相同的对象？它们会相互影响吗？如果进程a和b分别写stdout时会有问题吗？  
答：写了个测试代码如下所示，最终父进程和子进程打印的fd均为3，可见这两个fd对应的对象是不同文件。
```
    int fd = -1;

    if (fork() == 0)
    {
        fd = open("child.txt", O_RDWR | O_CREAT);
        printf("child fd=%d.\r\n", fd);
    }
    else
    {
        fd = open("parent.txt", O_RDWR | O_CREAT);
        printf("parent fd=%d.\r\n", fd);
    }
```
在xv6书中则有如下代码，用来解释“Although fork copies the file descriptor table, each underlying file offset is shared between parent and child.”。最终打印结果是“hello world”。这说明父进程和子进程的stdout都是对应同一个终端。
```
    if(fork() == 0) {
        write(1, "hello ", 6);
        exit();
    } else {
        wait();
        write(1, "world\n", 6);
    }
```
