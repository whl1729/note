# 《ucore lab1 exercise2》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 题目：使用qemu执行并调试lab1中的软件
为了熟悉使用qemu和gdb进行的调试工作，我们进行如下的小练习：

1. 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。
2. 在初始化位置0x7c00设置实地址断点,测试断点正常。
3. 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和bootblock.asm进行比较。
4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试

## 解答

### 问题1：从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行

1. tools/gdbinit的内容如下。可见，这里是对内核代码进行调试，并且将断点设置在内核代码的入口地址，即kern_init函数
```
file bin/kernel
target remote :1234
break kern_init
continue
```

2. 为了从CPU加电后执行的第一条指令开始调试，需要修改tools/gdbinit的内容为：
```
set architecture i8086
file bin/bootblock
target remote :1234
break start
continue
```

3. 执行`make debug`，这时会弹出一个QEMU窗口和一个Terminal窗口，这是正常的，因为我们在makefile中定义了debug的操作正是启动QEMU、启动Terminal并在其中运行gdb。
```
debug: $(UCOREIMG)
	$(V)$(QEMU) -S -s -parallel stdio -hda $< -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
```

4. Terminal窗口此时停在0x0000fff0的位置，这是eip寄存器的值，而cs寄存器的值为0xf000. （遇到一个问题：此时无法正确反汇编出代码，使用x来查询内存0xfff0处的值时显示全0，不知道什么原因）
```
The target architecture is assumed to be i8086
0x0000fff0 in ?? ()
Breakpoint 1 at 0x7c00: file boot/bootasm.S, line 16.
```

5. 输入si，执行1步，程序会跳转到0xe05b的地方。查看寄存器也可以发现eip的值变为0xe05b，而cs的值不变，仍然是0xf000.

6. 反复输入si，以单步执行。（由于BIOS中全是汇编代码，看不懂其功能）。

### 问题2：在初始化位置0x7c00设置实地址断点,测试断点正常

1. 我直接在tools/gdbinit中设置了断点`break start`，由于boot loader的入口为start，其地址为0x7c00，因此这和`break *0x7c00`效果是相同的。

2. 设置断点后，输入continue或c，可以看到程序在0x7c00处停了下来，说明断点设置成功。

### 问题3：从0x7c00开始, 将反汇编代码与bootasm.S和bootblock.asm进行比较

1. 反汇编的代码与bootblock.asm基本相同，而与bootasm.S的差别在于：
    - 反汇编的代码中的指令不带指示长度的后缀，而bootasm.S的指令则有。比如，反汇编 的代码是`xor %eax, %eax`，而bootasm.S的代码为`xorw %ax, %ax`
    - 反汇编的代码中的通用寄存器是32位（带有e前缀），而bootasm.S的代码中的通用寄存器是16位（不带e前缀）。

### 问题4：自己找一个bootloader或内核中的代码位置，设置断点并进行测试

这个比较简单，不作记录。


## 解答

