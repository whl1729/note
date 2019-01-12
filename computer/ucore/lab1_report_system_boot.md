# 《ucore lab1》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 练习1：理解通过make生成执行文件的过程

详见[《ucore lab1 exercise1》实验报告](lab1_exercise1_make_ucore.md)

## 练习2：使用qemu执行并调试lab1中的软件

详见[《ucore lab1 exercise2》实验报告](lab1_exercise2_use_gdb.md)

## 练习3：分析bootloader进入保护模式的过程

详见[《ucore lab1 exercise3》实验报告](lab1_exercise3_real2protect.md)

## 练习4：分析bootloader加载ELF格式的OS的过程

详见[《ucore lab1 exercise4》实验报告](lab1_exercise4_load_os.md)

## 练习5：实现函数调用堆栈跟踪函数

详见[《ucore lab1 exercise5》实验报告](lab1_exercise5_print_stackframe.md)

## 练习6：完善中断初始化和处理

详见[《ucore lab1 exercise6》实验报告](lab1_exercise6_init_interrupt.md)

## 扩展练习1：增加一用户态函数（待完成）

扩展proj4,增加syscall功能，即增加一用户态函数（可执行一特定系统调用：获得时钟计数值），当内核初始完毕后，可从内核态返回到用户态的函数，而用户态的函数又通过系统调用得到内核态的服务。

## 扩展练习2：用键盘实现用户模式内核模式切换（待完成）

用键盘实现用户模式内核模式切换。具体目标是：“键盘输入3时切换到用户模式，键盘输入0时切换到内核模式”。 基本思路是借鉴软中断(syscall功能)的代码，并且把trap.c中软中断处理的设置语句拿过来。
