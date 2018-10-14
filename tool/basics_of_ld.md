# ld链接脚本基础知识

1. 一个简单例子（摘自[GNU-ld链接脚本浅析](https://blog.csdn.net/yili_xie/article/details/5692007)）
    * `. = 0x10000;` 把定位器符号置为0x10000 (若不指定, 则该符号的初始值为0).
    * `.text : { *(.text) }` \*符号代表任意输入文件。将所有输入文件的.text section合并成一个.text section, 该section的地址由定位器符号的值指定, 即0x10000.

```
SECTIONS
{
    . = 0x10000;
    .text : { *(.text) }
    . = 0x8000000;
    .data : { *(.data) }
    .bss : { *(.bss) }
}
```

2. `ENTRY(SYMBOL)` : 将符号SYMBOL的值设置成入口地址。

3. PROVIDE关键字用于定义在目标文件内被引用，但没有在任何目标文件内被定义的符号。

4. `BYTE(EXPRESSION)` 在输出section中填入1字节数据

5. `ALIGN(EXP)`  返回定位符'.'的修调值，对齐后的值为`(. + EXP - 1) & ~(EXP - 1)`

## 参考资料

1. [GNU-ld链接脚本浅析](https://blog.csdn.net/yili_xie/article/details/5692007)

2. [GNU-ld Documents](https://sourceware.org/binutils/docs/ld/)
