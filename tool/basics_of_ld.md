# ld基础知识

## ld脚本中最基本的两个命令
The most fundamental command of the ld command language is the SECTIONS command (see section Specifying Output Sections). Every meaningful command script must have a SECTIONS command: it specifies a "picture" of the output file's layout, in varying degrees of detail. No other command is required in all cases.

The MEMORY command complements SECTIONS by describing the available memory in the target architecture. This command is optional; if you don't use a MEMORY command, ld assumes sufficient memory is available in a contiguous block for all output.

### SECTIONS命令
The SECTIONS command controls exactly where input sections are placed into output sections, their order in the output file, and to which output sections they are allocated.

You may use at most one SECTIONS command in a script file, but you can have as many statements within it as you wish. Statements within the SECTIONS command can do one of three things:
    - define the entry point;
    - assign a value to a symbol;
    - describe the placement of a named output section, and which input sections go into it.

### Memory命令
The linker's default configuration permits allocation of all available memory. You can override this configuration by using the MEMORY command. The MEMORY command describes the location and size of blocks of memory in the target. By using it carefully, you can describe which memory regions may be used by the linker, and which memory regions it must avoid. The linker does not shuffle sections to fit into the available regions, but does move the requested sections into the correct regions and issue errors when the regions become too full.

A command file may contain at most one use of the MEMORY command; however, you can define as many blocks of memory within it as you wish. 

## 链接脚本基础
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

3. PROVIDE关键字用于定义在目标文件内被引用，但没有在任何目标文件内被定义的符号。（伍注：换言之，PROVIDE关键字在ld脚本中定义了符号，而在目标文件中被引用）

4. `BYTE(EXPRESSION)` 在输出section中填入1字节数据

5. `ALIGN(EXP)`  返回定位符'.'的修调值，对齐后的值为`(. + EXP - 1) & ~(EXP - 1)`

## 参考资料

1. [Using LD, the GNU linker](ftp://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_mono/ld.html)

2. [GNU-ld Documents](https://sourceware.org/binutils/docs/ld/)

3. [GNU-ld链接脚本浅析](https://blog.csdn.net/yili_xie/article/details/5692007)
