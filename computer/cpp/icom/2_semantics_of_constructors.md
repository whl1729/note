# 《Inside the C++ Object Model》第2章学习笔记

## 2 The Semantics of Constructors

1. ***The keyword explicit was introduced into the language in order to give the programmer a method by which to suppress application of a single argument constructor as a conversion operator.***

### My Conclusion: What if a class doesn't define a constructor?

第2章花了不少篇幅讨论当一个类没定义构造函数时编译器会做什么事情，下面简单总结一下。

1. 当一个类（不妨称为C）没定义默认构造函数时
    - 其built-in类型以及指针、数组类型的成员不会被初始化
    - 其member class（不妨称为M）如果定义有默认构造函数，则调用M的默认构造函数；如果没有默认构造函数，则M的初始化流程与C类似
    - 如果这个类有虚函数，或者继承自虚基类，则需要初始化虚函数表和vptr

2. 如果一个类没定义默认构造函数，编译器也没有为其synthesized一个默认构造函数，那怎么创建类对象？猜想：编译器为该类对象分配好内存就收工。

3. 如果一个类没定义默认构造函数，编译器也没有为其synthesized一个默认构造函数，那么在创建这个类的时候确实没生成任何构造函数吗？也就是说某些类可以不需要构造函数也能构建？

### Default Constructor Construction

1. When is a default constructor synthesized? Only when the implementation needs it. Moreover, ***the synthesized constructor performs only those activities required by the implementation, it would not zero out the built-in data members.***
    - Note: There are distinctions between the needs of the program and the needs of the implementation（编译器）. A program's need for a default constructor is the responsibility of the programmer.
    - 伍注：在创建类对象时，要区分编译器和程序员的责任。编译器负责支持对象模型，保证类的继承、多态等能够正常运行，比如需要初始化虚函数表等，而类对象的built-in成员是否初始化为0，则是程序员需要考虑的问题，这是程序员的责任。

2. trivial vs nontrivial
    - If there is no user-declared constructor for class X, a default constructor is implicitly declared. 
    - A constructor is trivial if it is an implicitly declared default constructor.
    - A nontrivial default constructor is one that is needed by the implementation and, if necessary, is synthesized by the compiler. 
    - The synthesized constructor fulfills only an implementation need. It does this by invoking member object or base class default constructors or initializing the virtual function or virtual base class mechanism for each object.
    - 疑问：如何理解synthesized？无论constructor是否trivial，都是由编译器生成的。那么trivial constructor和nontrivial constructor的生成过程有何区别？我大胆猜想一下：前者只是为类对象分配内存然后啥也不干了，后者除了为类对象分配内存，还需要调用member class的构造函数、初始化虚函数表、为每个类对象分配一个虚函数指针等。

3. ***Four conditions under which the default constructor is nontrivial***
    - Member Class Object with Default Constructor. 伍注：既然member class定义了默认构造函数，说明该member不能简单创建，需进行一些操作，因此编译器调用其默认构造函数。
    - Base Class with Default Constructor. 伍注：与上同理。
    - Class with a Virtual Function. 伍注：需要初始化虚函数表和为每个类对象分配一个虚函数指针，因此编译器需要synthesized一个默认构造函数。
    - Class with a Virtual Base Class. 伍注：与上同理。

4. If a class without any constructors contains a member object of a class with a default constructor, the implicit default constructor of the class is nontrivial and the compiler needs to synthesize a default constructor for the containing class. (Note: a class won't automatically zero out its data members of built-in type.)（伍注：对应条目3的第1种情况）

5. If a class without any constructors is derived from a base class containing a default constructor, the default constructor for the derived class is considered nontrivial and so needs to be synthesized.（伍注：对应条目3的第2种情况）

6. There are two additional cases in which a synthesized default constructor is needed:（伍注：对应条目3的第3种情况）
    - The class either declares (or inherits) a virtual function
    - The class is derived from an inheritance chain in which one or more base classes are virtual

7. Given the separate compilation model of C++, how does the compiler prevent synthesizing multiple default constructors? In practice, this is solved by ***having the synthesized default constructor, copy constructor, destructor, and/or assignment copy operator defined as inline. If the function is too complex to be inlined by the implementation, an explicit non-inline static instance is synthesized.***

8. What happens if there are multiple class member objects requiring constructor initialization? ***The language requires that the constructors be invoked in the order of member declaration within the class. This is accomplished by the compiler. It inserts code within each constructor, invoking the associated default constructors for each member in the order of member declaration. This code is inserted just prior to the explicitly supplied user code.***

9. 如果一个派生类Bar和其继承的基类Foo均无默认构造函数，但基类Foo定义了其他构造函数，那么通过`Bar bar;`创建Bar对象时会失败，提示如下。
```
error: use of deleted function ‘Bar::Bar()’
     Bar bar;
         ^~~
06_base_default_ctor.cpp:15:7: note: ‘Bar::Bar()’ is implicitly deleted because the default definition would be ill-formed:
```

10. The following two class "***augmentations***" occur during compilation:
    - A virtual function table (referred to as the class vtbl in the original cfront implementation) is generated and populated with the addresses of the active virtual functions for that class.
    - Within each class object, an additional pointer member (the vptr) is synthesized to hold the address of the associated class vtbl.

11. For each constructor the class defines, the compiler inserts code that permits runtime access of each virtual base class. In classes that do not declare any constructors, the compiler needs to synthesize a default constructor.（简言之，一个类如果拥有虚函数或者虚基类，就需要合成默认构造函数，来完成虚函数表和虚函数指针的初始化）

12. ***Within the synthesized default constructor, only the base class subobjects and member class objects are initialized. All other nonstatic data members, such as integers, pointers to integers, arrays of integers, and so on, are not initialized. These initializations are needs of the program, not of the implementation（编译器）.***

### Copy Constructor Construction

1. ***Default Memberwise Initialization***
    - What if the class does not provide an explicit copy constructor? Each class object initialized with another object of its class is initialized by default memberwise initialization. 
    - Default memberwise initialization copies the value of each built-in or derived data member (such as a pointer or an array) from the one class object to another. 
    - A member class object, however, is not copied; rather, memberwise initialization is recursively applied. 

2. In practice, a good compiler can generate bitwise copies for most class objects since they have bitwise copy semantics.

3. Default constructors and copy constructors are generated (by the compiler) where needed. Needed in this instance means when the class does not exhibit bitwise copy semantics.

4. Four instances When bitwise copy semantics aren't exhibited by a class（注：和默认构造函数的四种情况相对应）
    - When the class contains a member object of a class for which a copy constructor exists (either explicitly declared by the class designer, as in the case of the previous String class, or synthesized by the compiler, as in the case of class Word)（伍注：既然类的成员定义了复制构造函数，说明该成员不能简单使用bitwise copy，一种常见场景是该成员含有指向动态分配内存的指针，此时不能简单复制指针。）
    - When the class is derived from a base class for which a copy constructor exists (again, either explicitly declared or synthesized)（伍注：同上）
    - When the class declares one or more virtual functions（伍注：当编译器导入一个vptr到class之中时，该class就不再展现bitwise semantics了。在不同继承层次比如基类与派生类之间进行复制时，不能直接复制vptr）
    - When the class is derived from an inheritance chain in which one or more base classes are virtual（伍注：在不同继承层次之间进行复制时，需要插入一些代码以设定virtual base class pointer/offset）

5. The copying of an object's vptr value **ceases** to be safe when an object of a base class is initialized with an object of a class derived from it.

### Program Transformation Semantis

1. Explicit Initialization
```
void foo_bar() {
    X x1(x0);
    X x2 = x0;
    X x3 = x(x0);
    // ...
}

// Possible program transformation
// Pseudo C++ Code
void foo_bar() {
    X x1;
    X x2;
    X x3;
    // compiler inserted invocations of copy constructor for X
    x1.X::X(x0);
    x2.X::X(x0);
    x3.X::X(x0);
    // ...
}
```

2. Argument Initialization
```
void foo(X x0);
X xx;
// ...
foo(xx);

// Possible program transformation
// The declaration of foo() with the formal argument from an object changed to a reference of class X
void foo(X& x0);
// compiler generated temporary
X __temp0;
// compiler invocation of copy constructor
__temp0.X::X(xx);
// rewrite function call to take temporary
foo(__temp0);
```

3. Return Value Initialization
```
X bar()
{
    X xx;
    // process xx ...
    return xx;
}

X xx = bar();

// Possible program transformation
void bar(X& __result)
{
    X xx;
    // compiler generated invocation of default constructor
    xx.X::X();
    // process xx ... 
    // compiler generated invocation of copy constructor
    __result.X::X(xx);
    return;
}

X xx;
bar(xx);
```

4. NRV(Named Return Value) optimization
```
X bar()
{
    X xx;
    // ... process xx
    return xx;
}

// Using NRV optimization
void bar(X &__result)
{
    // default constructor invocation
    __result.X::X();
    // ... process in __result directly
    return;
}
```

5. Use of both memcpy() and memset() works only if the classes do not contain any compiler generated internal members. If the Point3d class declares one or more virtual functions or contains a virtual base class, use of either of these functions will result in overwriting the values the compiler set for these members. 
```
class Shape {
public:
    // oops: this will overwrite internal vptr!
    Shape() { memset( this, 0, sizeof( Shape ));
    virtual ~Shape();
    // ...
};

// Expansion of constructor
Shape::Shape()
{
    // vptr must be set before user code executes
    __vptr__Shape = __vtbl__Shape;
    // oops: memset zeros out value of vptr
    memset( this, 0, sizeof( Shape ));
};
```

### Member Initialization List

1. When you write a constructor, you have the option of initializing class members either through the ***member initialization list*** or within the body of the constructor. Except in four cases, which one you choose is not significant.
    - You must use the member initialization list in the following cases in order for your program to compile:
        - When initializing a reference member
        - When initializing a const member
        - When invoking a base or member class constructor with a set of arguments
    - In the fourth case, the program compiles and executes correctly. But it does so inefficiently. 

2. The compiler iterates over the initialization list, inserting the initializations in the proper order within the constructor prior to any explicit user code.（伍注：在进入构造函数的函数体执行explicit user code之前，编译器已经根据initialization list构造好data member，对不出现在initialization list的成员使用默认构造函数来构造。）

3. I recommend always placing the initialization of one member with another (if you really feel it is necessary) within the body of the constructor. In that way you can ensure there is no ambiguity about which members are initialized at the point of its invocation.
