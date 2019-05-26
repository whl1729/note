# 汇编语言使用笔记

## 常用指令

1. `movl $0, 0x8000` 将地址为0x8000的内存中的数值设置为零；
   `incl 0x8000` 将地址为0x8000的内存中的数值加1

2. call, ret and iret
    - call: 将返回地址（即当前call指令的下一条指令的地址）入栈，然后跳转到被调用过程的起始处。
    - ret: pops the last value from the stack, which supposed to be the returning address, and assigned it to IP register.
    - iret: In Real Address Mode, iret pops CS, the flags register, and the instruction pointer from the stack and resumes the routine that was interrupted. In Protect Address Mode,  the action of the IRET instruction depends on the settings of the NT (nested task) and VM flags in the EFLAGS register and the VM flag in the EFLAGS image stored on the current stack. [Reference](http://faydoc.tripod.com/cpu/iret.htm)

3. pusha vs pushal
    - pusha: Push AX, CX, DX, BX, original SP, BP, SI, and DI
    - pushal: Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI

4. push vs pop（伍注：%esp指向栈顶元素，所以记住%esp指向的内存是已被占用的）
```
push %ebp  // is equivalent to
sub $4, %esp
mov %ebp, (%esp)

pop %eax // is equivalent to
mov (%esp), %eax
add $4, %esp
```

## 伪指令

1. [Assembler Directives](http://web.mit.edu/gnu/doc/html/as_7.html)

2. `.set symbol, expression`
    - Set the value of symbol to expression. This changes symbol's value and type to conform to expression. If symbol was flagged as external, it remains flagged. (See section Symbol Attributes.)
    - You may .set a symbol many times in the same assembly.
    - If you .set a global symbol, the value stored in the object file is the last value stored into it.

3. `.space size , fill` This directive emits size bytes, each of value fill. Both size and fill are absolute expressions. If the comma and fill are omitted, fill is assumed to be zero.

4. `.rept count` Repeat the sequence of lines between the .rept directive and the next .endr directive count times.

5. hello world编译后出现的一些伪指令
    - `.LC0` local constant, e.g string literal.
    - `.LFB0` local function beginning.
    - `.LFE0` local function ending.

## 内联汇编

参考资料：
1. [Linux 中 x86 的内联汇编](https://www.ibm.com/developerworks/cn/linux/sdk/assemble/inline/index.html)

2. [GCC-Inline-Assembly-HOWTO](http://www.ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO.html)

### GCC简单内联汇编

1. GCC处理简单内联汇编：把asm(...)的内容“打印”到汇编文件中，所以格式控制字符是必要的
   
2. 简单内联汇编的缺陷：由于我们在内联汇编中改变了 edx 和 ebx 的值，但是由于 gcc 的特殊的处理方法，即先形成汇编文件，再交给 GAS 去汇编，所以 GAS 并不知道我们已经改变了edx和ebx 的值，如果程序的上下文需要 edx 或 ebx 作其他内存单元或变量的暂存，就会产生没有预料的多次赋值，引起严重的后果。对于变量\_boo也存在一样的问题。

3. 简单内联汇编只包括指令，而扩展内联汇编包括操作数。

### GCC扩展内联汇编

```
int a=10, b;
    asm ("movl %1, %%eax;
        movl %%eax, %0;"
        :"=r"(b)  /* output */    
        :"r"(a)       /* input */
        :"%eax"); /* clobbered register */
```
1. 输出操作数约束应该带有一个约束修饰符 "="，指定它是输出操作数。

2. 要在 "asm" 内使用寄存器 %eax，%eax 的前面应该再加一个 %，换句话说就是 %%eax，因为 "asm" 使用 %0、%1 等来标识变量。任何带有一个 % 的数都看作是输入/输出操作数，而不认为是寄存器。

3. 第三个冒号后的修饰寄存器 %eax 告诉将在 "asm" 中修改 GCC %eax 的值，这样 GCC 就不使用该寄存器存储任何其它的值。

4. 每个操作数都由操作数约束字符串指定，后面跟用括弧括起的 C 表达式，例如："constraint" (C expression)。操作数约束的主要功能是确定操作数的寻址方式。

5. 在汇编程序模板内部，操作数由数字引用。如果总共有 n 个操作数（包括输入和输出），那么第一个输出操作数的编号为 0，逐项递增，最后那个输入操作数的编号为 n -1。总操作数的数目限制在 10，如果机器描述中任何指令模式中的最大操作数数目大于 10，则使用后者作为限制。

