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

### 数据类型概述

#### 内置数据类型

* 数字
* 字符串
* 列表
* 字典
* 元祖
* 文件
* 其他类型（集合、类型、None、布尔型等）

#### 查看对象的所有方法

使用`dir(object_name)`或`help(object_type)`可以查看对象的所有方法：
```
>>> d
{'food': 'egg', 'color': 'white', 'quantity': 4}
>>> dir(d)
['__class__', '__cmp__', '__contains__', '__delattr__', '__delitem__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__gt__', '__hash__', '__init__', '__iter__', '__le__', '__len__', '__lt__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__setitem__', '__sizeof__', '__str__', '__subclasshook__', 'clear', 'copy', 'fromkeys', 'get', 'has_key', 'items', 'iteritems', 'iterkeys', 'itervalues', 'keys', 'pop', 'popitem', 'setdefault', 'update', 'values', 'viewitems', 'viewkeys', 'viewvalues']
```

#### 动态类型

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

#### 拷贝

* 没有限制条件的分片表达式（L[:]）能够复制序列
* 字典copy方法（D.copy()）能够复制字典
* 有些内置函数能够生成拷贝（list(L)）
* copy标准库模块能够生成完整拷贝
* 无条件值的分片以及字典copy方法只能做顶层复制，不能复制嵌套的数据结构。如果需要一个深层嵌套的数据结构的完整的、完全独立的拷贝，那么就要使用标准的copy模块：首先`import copy`，然后使用`x = copy.deepcopy(y)`对任意嵌套对象y做完整复制。

#### 比较
Python中不同类型的比较方法：

* 数字通过相对大小进行比较
* 字符串按照字典顺序进行比较
* 列表和元组从左到右对每部分的内容进行比较
* 字典通过排序之后的（键、值）列表进行比较


#### 相等性

* "==" 操作符测试值的相等性
* "is" 表达式测试对象的同一性（即测试二者是否同一个对象）

#### python中真和假的含义

* 数字如果非零，则为真
* 其他对象如果非空，则为真
* 特殊数据类型None永远为假（None类似于C语言中的NULL指针）

#### 循环数据结果
如果一个复合对象包含指向自身的引用，就称之为循环对象。无论何时Python在对象中检测到循环，都会打印成[...]，而不会陷入无限循环。
```
>>> L = ['grail']
>>> L.append(L)
>>> L
['grail', [...]]
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
* `s2.rstrip`           去掉行终止符，如换行符等
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

### 元祖

#### 元祖的主要属性

* 任意对象的有序集合。元祖可以嵌入到任何类别的对象中。
* 通过偏移存取。元祖支持所有基于偏移的操作，如索引和分片。
* 属于不可变序列类型。元祖不支持任何原处修改操作。
* 固定长度、异构、任意嵌套。
* 对象引用的数组。元祖存储指向其他对象的引用，并且对元祖进行索引操作的速度相对较快。

> 备注：
> 1. 元组的不可变性只适用于元祖本身顶层而非其内容。例如，元组内部的列表是可以像平时那样修改的。

#### 元祖的常见操作

* `()                           `   空元祖
* `t1 = (0,)                    `   单个元素的元祖（逗号表示这是元祖，而非表达式）
* `t2 = (0, 'Ni', 1.2, )        `   四个元素的元祖
* `t3 = ('abc', ('def', 'ghi')) `   嵌套元祖
* `t1[i]                        `   索引
* `t3[i][j]                     `   索引的索引
* `t1[i:j]                      `   分片
* `len(t1)                      `   长度
* `t1 + t2                      `   合并
* `t2 * 3                       `   重复
* `for x in t                   `   迭代
* `'spam' in t2                 `   成员关系

#### 为什么有了列表还要元祖

1. 元组的角色类似于其他语言中的“常数”声明，你可以确保元祖在程序中不会被另一个引用修改。
2. 元祖可以用在列表无法使用的地方。例如作为字典键。一些内置操作可能也要求或暗示使用元祖而不是列表。

### 文件

#### 文件的常见操作

* `output = open('/tmp/spam', 'w')`    创建输出文件（'w'指写入）
* `input = open('data', 'r')`          创建输入文件（'r'指读写）
* `input = open('data')`               创建输入文件（默认是'r'）
* `aString = input.read()`             读取整个文件到进单一字符串
* `aString = input.read(N)`            读取之后的N个字节到单一字符串
* `aString = input.readline()`         读取下一行（包括行末标示符）到一个字符串
* `aList = input.readlines()`          读取整个文件到字符串列表
* `output.write(aString)`              写入字节字符串到文件
* `output.writelines(aString)`         写入列表中所有字符串到文件
* `output.close()`                     手动关闭
* `output.flush()`                     把输出缓冲区刷到硬盘中，但不关闭文件
* `anyFile.seek(N)`                    修改文件位置到偏移量N处以便进行下一个操作
* `eval(aString)`                      把字符串当做可执行程序来执行
* `pickle.dump(), pickle.load()`       直接在文件中存储几乎任何Python对象

> 备注：
> 1. 手动进行文件close方法调用是我们需要养成的一个好习惯。

## Python语句

### Python语句简介

#### Python语句集

* 赋值：创建引用值
```a, b, c = 'good', 'bad', 'ugly'```

* 调用：执行函数
```log.write("it's been a long day without you my friend")```

* print：打印对象
```print 'The killer', joke```

* if/elif/else：选择动作
```
if "python" in text:
    print x
```

* for/else：序列迭代
```
for x in mylist:
    print x
```

* while/else：一般循环
```
while X > Y:
    print 'hello'
```

* pass：空占位符
```
while True:
    pass
```

* break, continue：循环跳跃
```
while True:
    if not line: break
```

* try/except/finally：捕捉异常
```
try:
    action()
except:
    print 'action error'
```

* raise：触发异常
`raise endSearch, location`

* import, from：模块读取
```
import sys
from sys import stdin
```

* def, return, yield：创建函数
```
def func(a, b, c=1, *d):
    return a+b+c+d[0]
def gen(n):
    for i in n, yield i*2
```

* class：创建对象
```
class subclass(Superclass):
    staticData = []
```

* global：命名空间
```
def func():
    global x, y
    x = 'new'
```

* del：删除引用
```
del data[k]
del data[i:j]
del obj.attr
del variable
```

* exec：执行代码字符串
```
exec "import " + modName
exec code in gdict, ldict
```

* assert：调试检查
```assert X > Y```

* with/as：环境管理器
```
with open('data') as myfile:
    process(myfile)
```

#### Python增加了什么

Python中新的语法成分是冒号（:）。所有Python的复合语句都有相同的一般形式：首行以冒号结尾，下一行嵌套的代码往往按照缩进的格式书写。
```
Header line:
    Nested statement block
```

#### Python删除了什么

* 括号是可选的。例如if语句中不需要括号：`if x < y`
* 终止行就是终止语句。一行的结束会自动终止出现在该行的语句，不需使用分号。
* 缩进的结束就是代码块的结束。不需像类C语言那样，在嵌套块前后输入begin/end、then/endif或者大括号。取而代之的是，在Python中一致把嵌套块里所有的语句向右缩进相同的距离，以缩进来确定代码块的开头与结尾。

> 备注：
> 1. 根据逻辑结构将代码对齐是令程序具有可读性的主要部分，因而具备了可重用性和可维护性。
> 2. Python允许一行中出现多个简单语句，这时需要使用分号来隔开：`a = 1; b = 2; print a + b`
> 3. Python允许一个语句横跨多行，这时需要用括号（括号、方括号或大括号）把语句括起来。
```
mlist = [111,
         222,
         333]
```
> 4. Python允许简单语句（比如赋值操作、打印和函数调用）紧跟在冒号后面：`if x > y: print x`。但较复杂的语句仍然必须单独编辑放在自己的行里。

#### 用try语句处理错误
```
reply = raw_input('Enter number:')
try:
    num = int(reply)
except:
    print 'Bad!' * 8
else:
    print num ** 2
```

### 赋值语句

#### 赋值语句的一些特性

* 赋值语句建立对象引用值。Python赋值语句会把对象引用值存储在变量名或数据结构的元素内。
* 变量名在首次赋值时会被创建。
* 变量名在引用前必须先赋值。使用未赋值的变量名是一种错误，会引发异常。
* 隐式赋值语句：import、from、def、class、for、函数参数。

#### 赋值语句的形式

* `spam = 'Spam'`                   基本形式
* `spam, ham = 'yum', 'YUM'`        元祖赋值运算（位置性）
* `[spam, ham] = ['yum', 'YUM']`    列表赋值运算（位置性）
* `a, b, c, d = 'spam'`             序列赋值运算（通用性）：赋值为's'，b赋值为'p'等
* `spam = ham = 'lunch'`            多重目标赋值
* `spams += 42`                     自增赋值语句

#### 序列赋值语句

* 元组赋值语句经常会省略括号。例如：`spam, ham = 'wanna', 'be'`实际是`(spam, ham) = ('wanna', 'be')`的简便写法。

* 元组赋值语句可用来交换两变量的值，而不需自行创建临时变量。例如：
```
>>> nudge = 1
>>> wink = 2
>>> nudge, wink = wink, nudge
>>> nudge, wink
>>> (2, 1)
```

* 使用分片来灵活赋值
```
>>> str = 'spam'
>>> a, b, c = str[0], str[1], str[2:]
>>> a, b, c = list(string[:2]) + [string[2:]]
```

* 赋值嵌套序列
```
>>> ((a, b), c) = ('SP', 'AM')
>>> a, b, c
>>> ('S', 'P', 'AM')
```

* 赋值一系列整数给一组变量
```
>>> red, green, blue = range(3)
>>> red, blue
(0, 2)
```

#### 多目标赋值语句
多目标赋值语句就是把所有提供的变量名都赋值为右侧的对象，亦即多个变量共享一个对象。

* 对不可变类型，修改某一变量不影响其他变量。
```
>>> a = b = 0
>>> b = b + 1
>>> a, b
(0, 1)
```

* 对可变类型，修改某一变量会影响其他变量。
```
>>> a = b = []
>>> b.append(42)
>>> a, b
>>> ([42], [42])
```

#### 自增赋值语句

* 数字自增，例如：`x += 1`。注意Python没有`x++`或`x--`运算符，因为Python不允许对不可变对象在原处进行修改。

* 字符串自增，例如：`str += 'spam'`。

* 增强赋值语句比合并运算效率更高。因为合并运算必须建立新对象，复制左侧的列表，再复制右侧的列表。与之相比，增强赋值语句是在原处修改，只需在内存块的末尾增加元素。

#### 命名惯例

* 以单一下划线开头的变量名不会被`from module import *`语句导入。
* 前后有下划线的变量名是系统定义的变量名，对解释器有特殊意义。
* 以两下划线开头、但结尾没有两个下划线的变量名是类的本地（“压缩”）变量。
* 类变量名通常与一个大写字母开头，而模块变量名以小写字母开头。

### 表达式

#### 常见Python表达式语句

* `spam(eggs, ham)`               函数调用
* `spam.ham(eggs)`                方法调用
* `spam`                          在交互模式解释器内打印变量
* `spam < ham and ham != eggs`    符号表达式
* `spam < ham < eggs`             范围测试

> 备注：
> 1. Python不允许把赋值语句嵌入到其他表达式中，理由是避免常见的编码错误：当用“==”做相等测试时，不会打成“=”而意外修改变量的值。

#### 表达式语句与原处修改
列表的append，sort或reverse等方法，会对列表做原处的修改，特别注意：这些方法在列表修改后并不会把列表返回，而是返回None对象。如果你赋值这类运算的结果给该变量的变量名，只会丢失该列表。
```
>>> L = [1, 2]
>>> L = L.append(3)  # append returns None, not L
>>> print L          # so we lose our list
None
```

### 打印

#### print语句形式

* `print spam, ham`                  把对象打印至sys.stdout，在元素之间增加一个空格，以及在末尾增加换行字符
* `print spam, ham,`                 一样，但是在文本末尾没有加换行字符
* `print >> myfile, spam, ham`       输出到myfile.write，而不是sys.stdout.write
* `print '%s...%s' % (spam, ham)`    格式化打印

#### print与sys.stdout的关系
`print x`
等价于
```
import sys
sys.stdout.write(str(x) + '\n')
```

我们可以让print语句将字符串打印到其他地方。例如：
```
import sys
sys.stdout = open('log.txt', 'a')  # redirect prints to file
...
print x, y, x                      # shows up in log.txt
```

### 判断语句

### 循环语句
