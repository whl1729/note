# 《MIT 6.828 Lab 1 Exercise 11》实验报告

本实验的网站链接：[MIT 6.828 Lab 1 Exercise 11](https://pdos.csail.mit.edu/6.828/2017/labs/lab1/#Exercise-11)。

## 题目

> The above exercise should give you the information you need to implement a stack backtrace function, which you should call mon_backtrace(). A prototype for this function is already waiting for you in kern/monitor.c. You can do it entirely in C, but you may find the read_ebp() function in inc/x86.h useful. You'll also have to hook this new function into the kernel monitor's command list so that it can be invoked interactively by the user.

> The backtrace function should display a listing of function call frames in the following format:  
Stack backtrace:  
ebp f0109e58  eip f0100a62  args 00000001 f0109e80 f0109e98 f0100ed2 00000031  
ebp f0109ed8  eip f01000d6  args 00000000 00000000 f0100058 f0109f28 00000061  
...  
By studying kern/entry.S you'll find that there is an easy way to tell when to stop.  
Implement the backtrace function as specified above.   

## 解答

题目要求打印调用栈的信息，包括ebp和eip寄存器的值、输入参数的值等。

1. 按照提示，我们首先可以调用read\_ebp函数来获取当前ebp寄存器的值。ebp寄存器的值实际上是一个指针，指向当前函数的栈帧的底部（而esp寄存器指向当前函数的栈顶）。我们可以把整个调用栈看做一个数组，其中每个元素均为4字节的整数，并以ebp指针的值为数组起始地址，那么ebp[1]存储的就是函数返回地址，也就是题目中要求的eip的值，ebp[2]以后存储的是输入参数的值。由于题目要求打印5个输入参数，因此需要获取ebp[2]～ebp[6]的值。这样第一条栈信息便可打印出来。

2. 那么怎么打印下一条栈信息呢？还得从ebp入手。当前ebp指针存储的恰好是调用者的ebp寄存器的值，因此当前ebp指针又可以看做是一个链表头，我们通过链表头就可以遍历整个链表。举个例子：假设有A、B、C三个函数，A调用B，B调用C，每个函数都对应有一个栈帧，栈帧的底部地址均存储在当时的ebp寄存器中，不妨记为a_ebp, b_ebp和c_ebp，那么将有c_ebp -> b_ebp -> a_ebp，用程序语言表示就是：`a_ebp = (uint32_t *)*b_ebp`和`b_ebp = (uint32_t *)*c_ebp`。

3. 还有一个问题：怎么知道遍历何时结束呢？题目中提示可以参考`kern/entry.S`，于是我打开此文件，果然找打答案：内核初始化时会将ebp设置为0，因此当我们检查到ebp为0后就应该结束了。
```
	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
```

4. 代码实现
```
int mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
    uint32_t *ebp;

    ebp = (uint32_t *)read_ebp();

    cprintf("Stack backtrace:\r\n");

    while (ebp)
    {
        cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\r\n", 
                ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);

        ebp = (uint32_t *)*ebp;
    }

	return 0;
}
```

5. 输出结果
```
6828 decimal is 15254 octal!
entering test_backtrace 5
entering test_backtrace 4
entering test_backtrace 3
entering test_backtrace 2
entering test_backtrace 1
entering test_backtrace 0
Stack backtrace:
  ebp f010ff18  eip f0100078  args 00000000 00000000 00000000 f010004a f0111308
  ebp f010ff38  eip f01000a1  args 00000000 00000001 f010ff78 f010004a f0111308
  ebp f010ff58  eip f01000a1  args 00000001 00000002 f010ff98 f010004a f0111308
  ebp f010ff78  eip f01000a1  args 00000002 00000003 f010ffb8 f010004a f0111308
  ebp f010ff98  eip f01000a1  args 00000003 00000004 00000000 f010004a f0111308
  ebp f010ffb8  eip f01000a1  args 00000004 00000005 00000000 f010004a f0111308
  ebp f010ffd8  eip f01000dd  args 00000005 00001aac f010fff8 f01000bd 00000000
  ebp f010fff8  eip f010003e  args 00000003 00001003 00002003 00003003 00004003
leaving test_backtrace 0
leaving test_backtrace 1
leaving test_backtrace 2
leaving test_backtrace 3
leaving test_backtrace 4
leaving test_backtrace 5
```
