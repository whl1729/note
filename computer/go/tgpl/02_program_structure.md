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
