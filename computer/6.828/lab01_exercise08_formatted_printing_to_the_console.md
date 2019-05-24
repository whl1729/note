# 《MIT 6.828 Lab 1 Exercise 8》实验报告

本实验的网站链接：[MIT 6.828 Lab 1 Exercise 8](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-8)。

## 题目

> Exercise 8. Read through kern/printf.c, lib/printfmt.c, and kern/console.c, and make sure you understand their relationship.We have omitted a small fragment of code - the code necessary to print octal numbers using patterns of the form "%o". Find and fill in this code fragment. And be able to answer the following questions.

## 解答

### 补全打印八进制整数的代码
参考打印10进制和16进制整数的代码即可。
```
case 'o':
    num = getuint(&ap, lflag);
    base = 8;
    goto number;
```

### 问题1：解释printf.c和console.c之间的接口关系

> Explain the interface between printf.c and console.c. Specifically, what function does console.c export? How is this function used by printf.c?

解答：printf.c中的putch函数调用了console.c中的cputchar函数，具体调用关系：`cprintf -> vcprintf -> putch -> cputchar`。

### 问题2：解释console.c的以下代码
```
1 if (crt_pos >= CRT_SIZE) {
2     int i;
3     memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
4     for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
          crt_buf[i] = 0x0700 | ' ';
5     crt_pos -= CRT_COLS;
6 }
```

解答：联系代码上下文，可以理解这段代码的作用。首先，CRT(cathode ray tube)是阴极射线显示器。根据console.h文件中的定义，CRT_COLS是显示器每行的字长（1个字占2字节），取值为80；CRT_ROWS是显示器的行数，取值为25；而`#define CRT_SIZE	(CRT_ROWS * CRT_COLS)`是显示器屏幕能够容纳的字数，即2000。当crt_pos大于等于CRT_SIZE时，说明显示器屏幕已写满，因此将屏幕的内容上移一行，即将第2行至最后1行（也就是第25行）的内容覆盖第1行至倒数第2行（也就是第24行）。接下来，将最后1行的内容用黑色的空格塞满。将空格字符、0x0700进行或操作的目的是让空格的颜色为黑色。最后更新crt_pos的值。总结：这段代码的作用是当屏幕写满内容时将其上移1行，并将最后一行用黑色空格塞满。

### 问题3：逐步跟踪以下代码并回答问题

> Trace the execution of the following code step-by-step:
> * In the call to cprintf(), to what does fmt point? To what does ap point?
> * List (in order of execution) each call to cons_putc, va_arg, and vcprintf. For cons_putc, list its argument as well. For va_arg, list what ap points to before and after the call. For vcprintf list the values of its two arguments.
```
    int x = 1, y = 3, z = 4;
    cprintf("x %d, y %x, z %d\n", x, y, z);
```

解答：
1. fmt指向格式化字符串"x %d, y %x, z %d\n"的内存地址（这个字符串是存储在栈中吗？），ap指向第一个要打印的参数的内存地址，也就是x的地址。

2. 列出每次调用cons_putc, va_arg和vcprintf的状态：
    * cprintf首先调用vcprintf，调用时传入的第1个参数fmt的值为格式化字符串"x %d, y %x, z %d\n"的地址，第2个参数ap指向x的地址。
    * vcprintf调用vprintfmt，vprintfmt函数中多次调用va_arg和putch，putch调用cputchar，而cputchar调用cons_putc，putch的第一个参数最终会传到cons_putc.接下来按代码执行顺序列出每次调用这些函数的状态。
    * 第1次调用cons_putc: printfmt.c第95行，参数为字符'x'.
    * 第2次调用cons_putc: printfmt.c第95行，参数为字符' '.
    * 第1次调用va_arg: printfmt.c第75行，lflag=0，调用前ap指向x，调用后ap指向y.
    * 第3次调用cons_putc: printfmt.c第49行，参数为字符'1'.此处传给putch的第一个参数的表达方式比较新奇、简洁：`"0123456789abcdef"[num % base]`。注意双引号及其内部实际上定义了一个数组，其元素依次为16进制的16个字符。
    * 第4次调用cons_putc: printfmt.c第95行，参数为字符','.
    * 第5次调用cons_putc: printfmt.c第95行，参数为字符' '.
    * 第6次调用cons_putc: printfmt.c第95行，参数为字符'y'.
    * 第7次调用cons_putc: printfmt.c第95行，参数为字符' '.
    * 第2次调用va_arg: printfmt.c第75行，lflag=0，调用前ap指向y，调用后ap指向z.
    * 第8次调用cons_putc: printfmt.c第49行，参数为字符'3'.
    * 第9次调用cons_putc: printfmt.c第95行，参数为字符','.
    * 第10次调用cons_putc: printfmt.c第95行，参数为字符' '.
    * 第11次调用cons_putc: printfmt.c第95行，参数为字符'z'.
    * 第12次调用cons_putc: printfmt.c第95行，参数为字符' '.
    * 第3次调用va_arg: printfmt.c第75行，lflag=0，调用前ap指向z，调用后ap指向z的地址加4的位置。
    * 第13次调用cons_putc: printfmt.c第49行，参数为字符'4'.
    * 第14次调用cons_putc: printfmt.c第95行，参数为字符'\n'.

### 问题4：判断以下代码的输出

> Run the following code.

> What is the output? Explain how this output is arrived at in the step-by-step manner of the previous exercise. Here's an ASCII table that maps bytes to characters.

> The output depends on that fact that the x86 is little-endian. If the x86 were instead big-endian what would you set i to in order to yield the same output? Would you need to change 57616 to a different value?
```
    unsigned int i = 0x00646c72;
    cprintf("H%x Wo%s", 57616, &i);
```

解答：
1. 输出为“He110 World”。哈哈，这道题很有意思，不过我看见H和Wo就基本猜到是“Hello World”了，不过疑惑l和o不是16进制字符，怎么能表示出来呢？结果是使用1来代替l，使用0来代替o，有创意！简单解释一下：57616转换成16进制就是0xe110.根据ASCII码，i的4个字节从低到高依次为'r', 'l', 'd', '\0'.这里要求主机是小端序才能正常打印出“World”这个单词。

2. 如果是大端字节序，i的值要修改为0x726c6400，而57616这个值不用修改。因为根据printnum函数实现，打印整数时，总是按照从高位到低位来打印的。

### 问题5：当打印的参数数目小于格式化字符串中需要的参数个数时会怎样？

> In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?
```
cprintf("x=%d y=%d", 3);
```

解答：打印出来的y的值应该是栈中存储x的位置后面4字节代表的值。因为当打印出x的值后，va_arg函数的ap指针指向x的最后一个字节的下一个字节。因此，不管调用cprintf传入几个参数，在解析到"%d"时，va_arg函数就会取当前指针指向的地址作为int型整数的指针返回。

### 问题6：如果将GCC的调用约定改为参数从左到右压栈，为支持参数数目可变需要怎样修改cprintf函数？

> Let's say that GCC changed its calling convention so that it pushed arguments on the stack in declaration order, so that the last argument is pushed last. How would you have to change cprintf or its interface so that it would still be possible to pass it a variable number of arguments?

解答：有两种方法。一种是程序员调用cprintf函数时按照从右到左的顺序来传递参数，这种方法不符合我们的阅读习惯、可读性较差。第二种方法是在原接口的最后增加一个int型参数，用来记录所有参数的总长度，这样我们可以根据栈顶元素找到格式化字符串的位置。这种方法需要计算所有参数的总长度，也比较麻烦。。。

## 疑问

1. 做问题3有个疑问：cprintf的第一个参数（也就是格式化字符串）存储在内存中的哪个位置？

