# 《程序员的自我修养》第6章读书笔记

## 6 可执行文件的装载与进程

1. ELF可执行文件引入了一个概念叫“Segment”，一个Segment包含一个或多个属性类似的“Section”。Segment的概念实际上是从装载的角度重新划分了ELF的各个段。在将目标文件链接成可执行文件时，链接器会尽量把相同权限属性的段分配在同一空间。这样做的好处是可以很明显地减少页面内部碎片，从而节省了内存空间。

2. 一个进程基本上可以分为如下几种VMA区域：
    - 代码VMA，权限只读、可执行；有映像文件
    - 数据VMA，权限可读写、可执行；有映像文件
    - 堆VMA，权限可读写、可执行；无映像文件，匿名，可向上扩展
    - 栈VMA，权限可读写、不可执行；无映像文件，匿名，可向下扩展
