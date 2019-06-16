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
每个源文件以包的声
明语句开始， 说明该源文件是属于哪个包。 包声明语句之后是import语句导入依赖的其它包，
然后是包一级的类型、 变量、 常量、 函数的声明语句， 包一级的各种类型的声明语句的顺序
无关紧要（ 译注： 函数内部的名字则必须先声明之后才能使用） 。
