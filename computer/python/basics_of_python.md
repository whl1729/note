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

使用`dir(object_name)`或`help(object_type)`可以查看对象的所有方法：
```
>>> d
{'food': 'egg', 'color': 'white', 'quantity': 4}
>>> dir(d)
['__class__', '__cmp__', '__contains__', '__delattr__', '__delitem__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__init__', '__iter__', '__le__', '__len__', '__lt__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'clear', 'copy', 'fromkeys', 'get', 'has_key', 'items', 'iteritems', 'iterkeys', 'itervalues', 'keys', 'pop', 'popitem', 'setdefault', 'update', 'values', 'viewitems', 'viewkeys', 'viewvalues']
```

### 动态类型

* 动态类型：类型是在运行过程中自动决定的，而不是通过代码声明。动态类型以及由它提供的多态性，是Python语言简洁性和灵活性的基础。

* 变量（名）：在Python内部，变量事实上是到对象内存空间的一个指针。变量没有类型可言。

* 对象：被分配的一块内存，以存储它们所代表的值。对象有类型的概念。每个对象都有两个标准的头部信息：一是类型标识符，去标识该对象的类型；二是引用的计数器，以决定是否可以回收该对象。

* 引用：从变量到对象的连接叫引用。

* 对象的垃圾回收：Python用一个计数器记录每个对象的引用次数，一旦该计数器被设置为零，这个对象的内存空间就会自动回收。

* 变量赋值：给变量赋一个新的值，并不是替换了原始的对象，而是让这个变量去引用完全不同的一个对象。因此，对变量赋值，仅仅会影响那个被赋值的变量。

* 在原处修改：在一个列表中对一个偏移进行赋值，会改变这个列表对象，而不是生成一个新的列表对象。对于支持原处修改的对象，共享引用时要注意对一个变量名的修改会影响其他的变量。如果想避免这样的情况，应该使用拷贝对象，而不是创建引用。
```
>>> L1 = [2, 3, 4]  # A mutable object
>>> L2 = L1         # Make a reference to the same object
>>> L1[0] = 24      # An in-place change
>>> L1              # L1 is different
[24, 3, 4]
>>> L2              # But so is L2
[24, 3, 4]
```

### 数字

#### 数字常量

* 整数。一般的Python整数在内部是以C语言的“long型”来实现的（因此至少32位）。
* 长整型数。Python的长整型数以l或L结尾（与C语言的long型不同），可以任意增大。当一个整数的值超过32位时，会自动变换为长整型数。
* 浮点数。Python的浮点数是以C语言的“double型”来实现的。
* 复数。Python的复数写成“实部+虚部”的形式，虚部以j或J结尾。Python的复数是通过一对浮点数来表示的，但是对复数的所有数字操作都会按照复数的运算法则来进行。

#### 内置数学工具

* 内置数学函数。包括pow, abs, int, round等
* 公用模块。
    * random。如random.random(), random.randint(), random.choice()等
    * math。如math.pi, math.e, math.sin, math.sqrt等
* 表达式操作符。
    * `yield x`  生成器函数发送协议
    * `lambda args: expression`  生成匿名函数
    * `x if y else z`  三元选择表达式
    * `x or y`  逻辑或
    * `x and y`  逻辑与
    * `not x`  逻辑非
    * `x is y, x is not y, x in y, x not in y`  序列成员测试
    * `x ** y`  幂运算，x的y次方
    * `x[i], x[i:j], x.attr, x(...)`  索引、分片、取属性、函数调用
    * `(...), [...], {...}, `...``  元祖、列表、字典、字符串转换

### 字符串

#### 常见字符串表达式

* `s1 = ''`             空字符串
* `s2 = "spam's"`       双引号
* `block = """..."""`   三重引号块
* `s3 = r'\temp\spam'`  Raw字符串，r出现在字符串第一个引号前会关闭转义机制
* `s4 = u'spam'`        Unicode字符串，“宽”字符串，可以支持更丰富的字符集
* `s1 + s2`             合并字符串
* `s2 * 3`              重复字符串
* `s2[i]`               索引
* `s2[i:j]`             分片，从下标i开始，到下标j-1结束
* `s2[i:j:k]`           扩展分片，k表示步进。步进-1表示分片将会从右到左进行（反转）。
* `len(s2)`       
* `"a %s parrot" % type` 字符串格式化
* `s2.find('pa')`
* `s2.rstrip`
* `s2.replace('pa', 'xx')`
* `s1.split(',')`
* `s1.isdigit()`
* int(s1)               将字符串转换为数字
* `s1.lower()`
* `for x in s2`         迭代
* `'spam' in s2`        成员关系

> 备注：
> 1. Python的字符串不允许原地修改。
> 2. Python没有单个字符这种类型，取而代之的是只含有一个字符的字符串。

#### 基于字典的字符串格式化
```
>>> "%(n)d %(x)s" % {"n":1, "x":"spam"}
'1 spam'
```

### 列表

#### 列表的主要属性

* 任意对象的有序集合。列表就是收集其他对象的地方，同时列表的每一项都保持了从左往右的位置顺序。
* 通过偏移读取。可以通过列表对象的偏移对其进行索引，以及执行诸如分片和合并等任务。
* 长度可变。列表可以实地的增长或缩短。
* 异构。列表可以包含任何类型的对象，而不仅仅是包含有单个字符的字符串。
* 嵌套。列表支持任意的嵌套，因此你可以创建列表的子列表的子列表等。
* 可变序列。列表支持在原处的修改，也支持所有针对字符串序列的操作，如索引、分片和合并等。
* 对象引用数组。从Python的列表中读取一个项的速度与索引一个C语言数组差不多。实际上，在标准Python解释器内部，列表就是C数组而非链表。

#### 列表的常用操作

* `L1 = []`                         一个空列表
* `L2 = [0, 1, 2, 3]`               四项，索引为0到3
* `L3 = ['abc', ['def', 'ghi']]`    嵌套列表
* `L2[i]`                           索引
* `L3[i][j]`                        索引的索引
* `L2[i:j]`                         分片
* `len(L2)`                         求长度
* `L1 + L2`                         合并 
* `L2 * 3`                          重复
* `for x in L2`                     迭代 
* `3 in L2`                         成员关系 
* `L2.append(4)`
* `L2.extend([5,6,7])`
* `L2.sort()`
* `L2.index(1)`
* `L2.insert(1,x)`
* `L2.reverse()`
* `del L2[k]`
* `del L2[i:j]`
* `L2.pop()`
* `L2.remove(2)`
* `L2[i] = 1`
* `L2[i:j] = [4,5,6]`
* `range(4)`                        生成整数列表/元组 
* `xrange(0,4)`
* `L4 = [x**2 for x in range(5)]`   列表解析

> 备注：
> 1. 在原处修改一个对象时，可能同时会影响到一个以上指向它的引用。如果不希望这样，使用拷贝而非引用。

### 字典

#### 字典的主要属性

* 通过键而不是偏移量来读取元素。字典有时又被称为关联数组或哈希表。Python采用 最优化的哈希算法来寻找键，搜索速度很快。
* 任意对象的无序集合。与列表不同，保存在字典中的项并没有特定的顺序。
* 可变长、异构、任意嵌套。与列表相似，字典可以在原处增长或缩短。它们可以包含任何类型的对象，而且支持任意深度的嵌套。
* 可变映射类型。通过给索引赋值，字典可以在原处修改，但不支持我们用于字符串和列表中的序列操作（如合并、分片操作）。

#### 字典的常用操作

* `D1 = {}`                              空字典 
* `D2 = {'spam': 2, 'egg': 3}`           两项目字典
* `D3 = {'food': {'ham': 1, 'egg': 2}}`  嵌套
* `D2['egg']`                            以键索引值 
* `D3['food']['ham']`                     
* `D2.has_key('eggs')`                   成员关系测试
* `'eggs' in D2`
* `D2.keys()`                            键列表 
* `D2.values()`                          值列表 
* `D2.items()`                           元素列表
* `D2.copy()`
* `D2.get(key, default)`                 返回键对应的值，若键不存在则返回None或默认值
* `D2.update(D1)`                        把一个字典的键和值合并到另一个，盲目地覆盖相同键的值
* `D2.pop(key)`                          删除一个键并返回它的值
* `len(D1)`
* `D2[key] = 42`                         新增/修改键     
* `del D2[key]`
* `D4 = dict.fromkeys(['a', 'b'])`
* `D5 = dict(zip(keylist, varlist))`
* `D6 = dict(name='Bob', age=42)`

#### 避免missing-key错误

* 在if语句中预先对键进行测试
```
>>> if Matrix.has_key((2,3,6)):
...     print Matrix[(2,3,6)]
... else:
...     print 0
...
0
```

* 使用try语句明确地捕获并修复这一异常
```
>>> try:
...     print Matrix[(2,3,6)]
... except KeyError:
...     print 0
...
0
```

* 使用get方法为不存在的键提供一个默认值
```
>>> Matrix.get((2,3,4), 0)
88
>>> Matrix.get((2,3,6), 0)
0
```

