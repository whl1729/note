# GRUB2 源码分析

## grub_main

`grub_main` 位于 `grub-core/kern/main.c`。

## Questions

1. grub2跳转到内核实模式代码中的哪个位置？

## References

1. [Linux启动流程：从启动到 GRUB](https://www.binss.me/blog/boot-process-of-linux-grub/)
2. [GRUB是怎么启动linux的?](http://heguangyu5.github.io/my-linux/html/6-GRUB%E6%98%AF%E6%80%8E%E4%B9%88%E5%90%AF%E5%8A%A8linux%E7%9A%84.html)

> 备注：参考资料2中貌似说grub跳到内核实模式代码的位置为1M，感觉有误？
