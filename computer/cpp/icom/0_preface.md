# 《Inside the C++ Object Model》第0章读书笔记

## 本立道生（侯捷 译序）

1. 面向对象的语言的编译器为我们（程序员）做了太多的服务：构造函数、析构函数、虚拟函数、继承、多态......有时候它为我们合成一些额外的函数（或运算符），有时候它又扩张我们所写的函数内容，放进更多的操作。有时候它还会为我们的objects添油加醋，放进一些奇妙的东西，使你面对sizeof的结果大惊失色。

## Preface

1. Within Grail, the traditional compiler was factored into separate executables. The parser built up the ALF representation. Each of the other components (type checking, simplification, and code generation) and any tools, such as a browser, operated on (and possibly augmented) a centrally stored ALF representation of the program. 

2. The Simplifier is the part of the compiler between type checking and code generation. It transforms the internal program representation. There are three general flavors of transformations required by any object model component:
    - Implementation-dependent transformations. These are implementation-specific aspects and vary across compilers.
    - Language semantics transformations. These include constructor/destructor synthesis and augmentation, memberwise initialization and memberwise copy support, and the insertion within program code of conversion operators, temporaries, and constructor/destructor calls.
    - Code and object model transformations. These include support for virtual functions, virtual base classes and inheritance in general, operators new and delete, arrays of class objects, local static class instances, and the static initialization of global objects with nonconstant expressions.

3. There are two aspects to the C++ Object Model:
    - The direct support for object-oriented programming provided within the language
    - The underlying mechanisms by which this support is implemented

4. The first aspect of the C++ Object Model is invariant. For example, under C++ the complete set of virtual functions available to a class is fixed at compile time; the programmer cannot add to or replace a member of that set dynamically at runtime. This allows for extremely fast dispatch of a virtual invocation, although at the cost of runtime flexibility.

5. Virtual function calls are generally resolved through an indexing into a table holding the address of the virtual functions. The general pattern of virtual function implementation across all current compilation systems is to use a class-specific virtual table of a fixed size that is constructed prior to program execution.

6. why bother to discuss the C++ Object Model?
    - The primary reason is because my experience has shown that if a programmer understands the underlying implementation model, the programmer can code more efficiently and with greater confidence. Determining when to provide a copy constructor, and when not, is not something one should guess at or have adjudicated by some language guru. It should come from an understanding of the Object Model.
    - A second reason for writing this book is to dispel the various misunderstandings surrounding C++ and its support of object-oriented programming. This book is partially an attempt to lay out the kinds of overhead that are and are not inherent in the various Object facilities such as inheritance, virtual functions, and pointers to class members.

## 导读（译者的话）

1. 本书技术名词及其意义
    - access level：访问级。就是C++的public、private、protected三种等级
    - access section：访问区段。就是class中的public、private、protected三种段落
    - bitwise：对每一个bit施以...
    - memberwise：对每一个member施以...
    - explicit: 显式的（通常意指在程序源代码中所出现的）
    - implicit：隐式的（通常意指并非在程序源代码中出现的）
    - implementation：实现品。本书有时候指C++编译器。大部分时候是指class member function的内容
    - layout：布局。意指object在内存中的数据分布情况
    - mangle：名称切割重组（C++对于函数名称的一种处理方式）
    - object：对象（根据class的声明而完成的一份占有内存的实例）
    - overhead：额外负担（因某种设计而导致的额外成本）
    - override：改写（对virtual function的重新设计）
    - paradigm：范式（一种环境设计和方法论的模型或范例，系统和软件以此模型来开发和运行）
    - resolve：决议。函数调用时链接器所进行的一种操作，将符号与函数实例产生关联。如果你调用func()而链接时找不到func()实例，就会出现"unresolved externals"链接错误
    - semantics：语意
    - slot：表格中的一格（一个元素），条目
    - trivial：没有用的
    - nontrivial：有用的
    - virtual table：虚拟表格（为实现虚拟机制而设计的一种表格，内放virtual functions的地址）
