# 《Go程序设计语言》第2章学习笔记

## 2 程序结构

### 2.1 命名

1. Go keywords
```
break default func interface select
case defer go map struct
chan else goto package switch
const fallthrough if range type
continue for import return var
```

2. Go predeclared names
    - Constants: `true false iota nil`
    - Types: `int int8 int16 int32 int64 uint uint8 uint16 uint32 uint64 uintptr float32 float64 complex128 complex64 bool byte rune string error`
    - Functions: `make len cap new append copy close delete complex real imag panic recover`

3. Name scopes
    - 如果一个名字是在函数内部定义，那么它的就只在函数内部有效。
    - 如果是在函数外部定义，那么将在当前包的所有文件中都可以访问。
    - 名字的开头字母的大小写决定了名字在包外的可见性。如果一个名字是大写字母开头的，那么它将是导出的，也就是说可以被外部的包访问，例如fmt包的Printf函数就是导出的，可以在fmt包外部访问。包本身的名字一般总是用小写字母。

### 2.2 声明

1. Go语言主要有四种类型的声明语句：var、const、type和func，分别对应变量、常量、类型和函数实体对象的声明。

2. 每个源文件以包的声明语句开始，说明该源文件是属于哪个包。包声明语句之后是import语句导入依赖的其它包，然后是包一级的类型、变量、常量、函数的声明语句，包一级的各种类型的声明语句的顺序无关紧要（译注：函数内部的名字则必须先声明之后才能使用）。

### 2.3 变量

1. 如果初始化表达式被省略，那么将用零值初始化该变量。数值类型变量对应的零值是0，布尔类型变量对应的零值是false，字符串类型对应的零值是空字符串，接口或引用类型（包括slice、map、chan和函数）变量对应的零值是nil。数组或结构体等聚合类型对应的零值是每个元素或字段都是对应该类型的零值。

2. 在一个声明语句中可以同时声明多个类型不同的变量。比如：`var b, f, s = true, 2.3, "four"`

3. 简短变量声明左边的变量可能并不是全部都是刚刚声明的。如果有一些已经在相同的词法域声明过了，那么简短变量声明语句对这些已经声明过的变量就只有赋值行为了。简短变量声明语句中必须至少要声明一个新的变量。

4. 在Go语言中， 返回函数中局部变量的地址也是安全的。

> Go performs pointer escape analysis. If the pointer escapes the local stack, which it does in this case, the object is allocated on the heap. If it doesn't escape the local function, the compiler is free to allocate it on the stack.

5. flag包使用命令行参数来设置对应变量的值。在程序运行时，先调用flag.Parse函数更新对应变量的值（之前是默认值），然后调用flag.Args()函数获取命令行参数。

6. Go语言的自动圾收集器是如何知道一个变量是何时可以被回收的呢？基本的实现思路是，从每个包级的变量和每个当前运行函数的每一个局部变量开始，通过指针或引用的访问路径遍历，是否可以找到该变量。如果不存在这样的访问路径，那么说明该变量是不可达的，也就是说它是否存在并不会影响程序后续的计算结果。

7. 虽然你不需要显式地分配和释放内存，但是要编写高效的程序你依然需要了解变量的生命周期。例如，如果将指向短生命周期对象的指针保存到具有长生命周期的对象中，特别是保存到全局变量时，会阻止对短生命周期对象的垃圾回收（从而可能影响程序的性能） 。

### 2.4 赋值

1. 元组赋值允许同时更新多个变量的值。在赋值之前，赋值语句右边的所有表达式将会先进行求值， 然后再统一更新左边对应变量的值。 

### 2.5 类型

1. 类型声明语句`type name underlying-type`一般出现在包一级，因此如果新创建的类型名字的首字符大写，则在外部包也可以使用。

2. 对于每一个类型T，都有一个对应的类型转换操作T(x)，用于将x转为T类型。如果T是指针类型，可能会需要用小括弧包装T，比如(*int)(0)。只有当两个类型的底层基础类型相同时，才允许这种转型操作，或者是两者都是指向相同底层结构的指针类型，这些转换只改变类型而不会影响值本身。

3. 许多类型都会定义一个String方法，因为当使用fmt包的打印方法时，将会优先使用该类型对应的String方法返回的结果打印。

### 2.6 包和文件

1. 一个目录下只能有一个包。

2. import package时，如果相应的package不在默认路径下，需要在import语句中指定该package具体的路径。
