## Python简介

### 为什么使用Python

* 软件质量

Python注重可读性、一致性和软件质量。Python秉承了一种独特的简洁和可读性高的语法，以及一种高度一致的编程模式。Python采取极简主义的设计理念。这意味着尽管实现某一编程任务有多种方法，往往只有一种方法是显而易见的。以下是Python的设计原则：

```
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

* 开发者效率

Python的代码大小往往只有C++或Java代码的1/5到1/3。Python可以立即运行，无需编译及链接。

* 可移植性

绝大多数Python程序不做任何改变即可在所有主流计算机平台上运行。

* 支持众多的标准库

Python拥有从多的内置标准库及第三方标准库。

* 组件集成

Python脚本可通过灵活的集成机制与应用程序的其他部分进行通信，这种集成使Python成为产品定制和扩展的工具。如今，Python可以使用C/C++的库，可以被C/C++的程序调用，可以与Java组件集成，可以与COM和.NET等框架进行通信，并且可以通过SOAP、XML-RPC和CORBA等接口与网络进行交互。

* 享受乐趣

Python的易用性和强大内置工具使编程成为一种乐趣。

* 免费

Python的使用和分发是完全免费的。

### Python的缺点

* Python的执行速度还不够快。

### 使用Python可以做些什么

* 系统编程
* 用户图形接口
* Internet脚本
* 组件集成
* 数据库编程
* 数值计算和科学计算编程
* 游戏、图像、人工智能、XML、机器人等

### Python如何运行程序

执行Python程序时，Python内部会先将源代码编译成字节码，然后字节码被发送到Python虚拟机（Python Virtual Machine, PVM）上执行。

### Python的实现方式

* CPython

原始的、标准的Python实现方式通常称为Cython。它是由可移植的ANSI C语言代码编写而成。

* Jython

Jython的目标是让Python代码能够脚本化Java应用程序。Jython包含了Java类，这些类编译Python源代码、形成Java字节码，并将得到的字节码映射到Java虚拟机（JVM）上。

* IronPython

IronPython主要是为了满足在.NET组件中集成Python的开发者，其目标是让Python程序可以与Windows平台上的.NET框架以及与之对应的Linux上开源的Mono编写成的应用相集成。

### 如何运行Python程序

* 在交互模式下运行Python程序

TODO: 学习基本的交互命令

* 命令行下使用`python file.py`运行Python程序

* 类UNIX系统下以可执行脚本的方式运行

在类UNIX系统下，可以将Python程序设置为可执行程序，从而以可执行脚本的方式运行Python程序。这时，要在python程序的第一行注释python解释器的路径，如`#!/usr/local/bin/python`；并且使用`chmod +x file`来设置Python文件为可执行文件。

* Windows下点击文件图标运行

    * 在Windows下点击python文件图标时往往会产生一个一闪而过的黑色DOS终端窗口。可以简单地在脚本的最后添加`raw_input()`，其效果是让脚本暂停，直到读取到标准输入。

    * 点击文件图标来运行时，会看不到Python的错误信息，即使添加`raw_input()`也没用，因为早在调用`raw_input`之前脚本已经终止。因此最好将点击图标看做程序已经调试没问题后运行的一种方法。要想看到生成的错误信息，可以通过系统命令行或IDLE。

* 通过IDLE运行python程序

### Python程序的构成

1. 程序由模块构成。
2. 模块包含语句。
3. 语句包含表达式。
4. 表达式建立并处理对象。

## Python数据类型

### 内置数据类型

* 数字
* 字符串
* 列表
* 字典
* 元祖
* 文件
* 其他类型（集合、类型、None、布尔型等）

### 查看对象的所有方法

使用`dir(object_name)`可以查看对象的所有方法：
```
>>> d
{'food': 'egg', 'color': 'white', 'quantity': 4}
>>> dir(d)
['__class__', '__cmp__', '__contains__', '__delattr__', '__delitem__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__init__', '__iter__', '__le__', '__len__', '__lt__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'clear', 'copy', 'fromkeys', 'get', 'has_key', 'items', 'iteritems', 'iterkeys', 'itervalues', 'keys', 'pop', 'popitem', 'setdefault', 'update', 'values', 'viewitems', 'viewkeys', 'viewvalues']
```
### 数字


