# ucore 源码剖析

## 系统调用

以read函数执行路程为例，分析系统调用流程。

### 用户态
执行流程如下所示：
```
safe_read(int fd, void *data, size_t len)  ->
	read(fd, data, len)  ->
        sys_read(fd, data, len)  ->
            syscall(SYS_read, fd, data, len)  ->
                "int %1;"
```

### 内核态
1. 执行流程如下所示：
```
vectors(中断向量表，存有所有中断向量的地址)  -> vector_k(第k个中断的入口处理函数) ->
    __alltraps  ->
        trap ->
            trap_dispatch
    __trapret
```

2. 代码如下，为什么在执行trap前先将ds, es, fs, gs压栈？
    - 首先，这里的ds/es/fs/gs都是段寄存器，里面装的是段选择子，其中ds存的是数据段的段地址，es存的是目的字符串的段地址，fs和gs存的是进程相关的信息。The segment selector can be specified either implicitly or explicitly. The most common method of specifying a segment selector is to load it in a segment register and then allow the processor to select the register implicitly, depending on the type of operation being performed. The processor automatically chooses a segment according to the rules given in Table 3-5.
    - FS and GS are commonly used by OS kernels to access thread-specific memory. In windows, the GS register is used to manage thread-specific memory. The linux kernel uses GS to access cpu-specific memory.
    - pusha: Push AX, CX, DX, BX, original SP, BP, SI, and DI
    - pushal: Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI
    - 伍注：alltrap接下来要调用trap函数，而trap函数可能会修改这些段寄存器的值，所以要先备份好？（事实上下面还有一句pushal，说明把大部分寄存器的值都备份了）
```
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal
```
