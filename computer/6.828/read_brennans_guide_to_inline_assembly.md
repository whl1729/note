# 《Brennan's Guide to Inline Assembly》学习笔记

原文见[Brennan's Guide to Inline Assembly](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)。

## AT&T语法 vs Intel语法
DJGPP是基于GCC的，因此它使用AT&T/UNIT语法，这和Intel语法存在一些差异。下面将介绍其差异点。

* 寄存器命名：AT&T需要在寄存器名字前加"%"，而Intel直呼其名。比如访问eax寄存器：
```
AT&T:  %eax
Intel: eax
```

* 源/目的书写顺序：AT&T先写源再写目的，而Intel先写目的再写源。比如将eax寄存器的值加载到ebx寄存器：
```
AT&T: mov %eax, %ebx
Intel: mov ebx, eax 
```

* 比较命令的书写顺序：比较命令实际上是两数相减看结果的正负性。AT&T先写减数再写被减数，Intel先写被减数再写减数。比如比较eax和ebx寄存器的大小：
```
AT&T:  cmp %ebx, %eax
Intel: cmp eax, ebx
```

* 常量/立即数格式：AT&T需要在常量或立即数前加"$"，而Intel直呼其名。比如将C语言变量booga的地址加载到eax寄存器：
```
AT&T:  movl $_booga, %eax
Intel: mov eax, _booga
```
将常量0xd00d的值加载到ebx寄存器：
```
AT&T:  movl $0xd00d, %ebx
Intel: mov ebx, d00dh
```

* 操作符类型说明：AT&T要求在指令后面带上b、w或l等后缀来说明目的寄存器的宽度，而Intel无此要求。
```
AT&T:  movw %ax, %bx
Intel: mov bx, ax
```

* 内存访问：AT&T的内存访问语法与Intel的不一样。
``
AT&T:  immed32(basepointer, indexpointer, indexscale)
Intel: [basepointer + indexpointer * indexscale + immed32]
```

