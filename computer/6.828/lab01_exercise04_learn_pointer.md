# 《MIT 6.828 Lab 1 Exercise 4》实验报告

本实验链接：[mit 6.828 lab1 Exercise 4](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-4)。

## 题目

> Exercise 4. Read about programming with pointers in C. The best reference for the C language is The C Programming Language by Brian Kernighan and Dennis Ritchie (known as 'K&R'). We recommend that students purchase this book (here is an Amazon Link) or find one of MIT's 7 copies.

> Read 5.1 (Pointers and Addresses) through 5.5 (Character Pointers and Functions) in K&R. Then download the code for pointers.c, run it, and make sure you understand where all of the printed values come from. In particular, make sure you understand where the pointer addresses in printed lines 1 and 6 come from, how all the values in printed lines 2 through 4 get there, and why the values printed in line 5 are seemingly corrupted.

## 解答
题目包括两部分：一是阅读《The C Programming Language》，二是运行pointers.c文件并理解其输出。

### 一、阅读《The C Programming Language》
已阅读完成《The C Programming Language》第5.1~5.5节的内容，并输出[学习笔记](read_the_c_programming_language.md)。

### 二、 运行pointers.c文件并理解其输出
```
void f(void)
{
    int a[4];
    int *b = malloc(16);
    int *c;
    int i;

    printf("1: a = %p, b = %p, c = %p\n", a, b, c);

    c = a;
    for (i = 0; i < 4; i++)
	a[i] = 100 + i;
    c[0] = 200;
    printf("2: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
	   a[0], a[1], a[2], a[3]);

    c[1] = 300;
    *(c + 2) = 301;
    3[c] = 302;
    printf("3: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
	   a[0], a[1], a[2], a[3]);

    c = c + 1;
    *c = 400;
    printf("4: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
	   a[0], a[1], a[2], a[3]);

    c = (int *) ((char *) c + 1);
    *c = 500;
    printf("5: a[0] = %d, a[1] = %d, a[2] = %d, a[3] = %d\n",
	   a[0], a[1], a[2], a[3]);

    b = (int *) a + 1;
    c = (int *) ((char *) a + 1);
    printf("6: a = %p, b = %p, c = %p\n", a, b, c);
}
```

运行前我先写出自己对6个输出的猜测，运行后发现第1和第5个输出猜错了，其他4个猜对了。

1. 第1个输出是打印3个局部变量的地址，我以为a,b,c的内存地址是紧挨着的，因此猜测b的地址比a的大16，c的地址比b的大4.运行结果却是：`1: a = 0x7ffc06689160, b = 0x556fb6ccc260, c = 0xf0b2ff`。问题出在哪里？后来我才意识到指针的值实质上是它所指向的内存地址，而不是指针本身的内存地址。要想获取指针本身的内存地址，要在指针前面加上取址符号&。于是我对指针b和c加上&后再编译运行，结果为`1: a = 0x7ffef6a4c1c0, &b = 0x7ffef6a4c1b0, &c = 0x7ffef6a4c1b8`。可见变量a,b,c的内存地址是在栈内紧挨着的。注意由于我用的是64位系统，指针是用8个字节存储。不过有个问题没想明白：定义局部变量的顺序是a -> b -> c，但在栈中的地址从小到大却是b -> c -> a，为什么不一致？有待研究。

2. 第2个输出是直接对数组元素赋值后再打印数组内容，很简单。此处的目的应该是展示最直接的访问数组元素的方式：数组名加下标。

3. 第3个输出是使用各种方式对数组元素赋值后再打印数组内容，也很简单。值得注意的是`3[c]`的写法居然也是合法的，因为C编译器直接将其转换成`*(3+c)`。

4. 第4个输出展示了：对指向数组的指针加上（或减去）N，相当于访问数组中当前元素的后面（或前面）第N个元素。

5. 第5个输出有点意思，指针c原来指向a[1]，接下来被修改为指向a[1]的第2个字节，然后再修改c的值，这时a[1]和a[2]的值都会受影响。修改前a[1]=0x00000190, a[2]=0x0000012b. 而500=0x000001f4，因此我猜测修改后a[1]=0x00000001，a[2]=0xf400012b.运行结果却是a[1]=0x0001f490, a[2]=0x00000100. 为什么？原来是字节序在作怪！我电脑是小端字节序，而我按照大端字节序来做了。

6. 第6个输出表明指针加减某个整数对应的内存偏移量取决于指针的类型。
