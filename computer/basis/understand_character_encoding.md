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

## 参考资料

1. [wiki: Unicode](https://en.wikipedia.org/wiki/Unicode)
2. [wiki: UTF-8](https://en.wikipedia.org/wiki/UTF-8)
3. [wiki: GB_18030](https://en.wikipedia.org/wiki/GB_18030)
4. [字符编码详解](https://blog.51cto.com/polaris/377468)
