# 理解字符编码

1. Unicode 定义了一个码空间（codespace），即每个字符对应的码位（code point）。码位是一个整数。换句话说，Unicode 定义了每个字符分别对应一个数字。比如，字符'A'对应的数字为65.

2. Unicode 没有规定码位的编码方式，因此导致了很多遵循Unicode标准的字符编码方案，如utf-8、utf-16、utf-32、GB18030等，它们的主要区别在于对码位的编码方式不一样。

## Questions

- Unicode 与 utf-8 有什么区别？
  - A: utf-8 是 Unicode 的一种实现。Unicode的其他实现还包括utf-16，utf-32和gb18030等。

- utf-8 如何表示各国文字？
  - A: Unicode 定义了各国文字对应的码位（code point），utf-8只需将码位按照自己的编码规则进行编码即可。

- utf-8 与 GB2312 有什么区别？
  - A: 对码位的编码方式不同。

- utf-8 如何实现变长编码？
  - A: 长度为1~4字节的数字时，第一个字节的特征不同。

- utf-8 如何解决拓展性问题？即如何表示一些未来新增的字符？
  - A: 这个问题应该是由Unicode来解决的，Unicode目前的码位应该未用完，支持新的字符。

- 听说Windows系统的记事本会在文件开头加上BOM字符，这样不是改变了文件内容吗？
  - A: Windows 10的记事本新建文件时默认是不带BOM的utf-8编码，但你也可以选择带BOM的utf-8编码。带BOM的话会在文件开头增加几个字节。但由于这些字节为不可打印字符，文件查看器不会显示这些字符，因此看不出差异，除非专门查看文件的二进制内容。

- 如何理解上次那个Python编码问题？（`print('你好，世界')` 直接运行可以正常打印字符，重定向到文件后查看文件是乱码的。）如何理解操作系统、编程语言、终端对字符编码的影响？
  - A: 这个问题主要是Python语言的特性导致的：On Windows, UTF-8 is used for the console device. Non-character devices such as disk files and pipes use the system locale encoding (i.e. the ANSI codepage).

- Windows/Linux 系统在哪里保存文件的编码格式？这些系统如何知道文件的编码方式？（比如file命令可以查询编码方式）
  - A: 不保持，靠猜。

- Linux 系统和 Windows 系统在换行时的区别？
  - A: Windows 系统的换行符为CR（Carriage Reture，字符表示为'\r'，ASCII值为0xD）+ LF（Line Feed，字符表示为'\n'，ASCII值为0xA），Linux 系统的换行符为CR。

- Windows 系统的记事本在文件另存为时，编码方式里有个ANSI的选项，ANSI是什么东西？
  - A: ANSI 是一类编码的统称，并不代表具体的编码方式。同样，使用file查看GBK编码的文件时，会显示"ISO-8859 test"，这个"ISO-8859"也不是具体的编码格式。

## 参考资料

1. [wiki: Unicode](https://en.wikipedia.org/wiki/Unicode)
2. [wiki: UTF-8](https://en.wikipedia.org/wiki/UTF-8)
3. [wiki: GB_18030](https://en.wikipedia.org/wiki/GB_18030)
4. [字符编码详解](https://blog.51cto.com/polaris/377468)
