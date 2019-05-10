# 《Inside the C++ Object Model》第3章学习笔记

## 3 The Semantics of Data

1. ***An empty class, such as `class X {};` in practice is never empty.*** Rather it has an associated size of 1 byte — a char member inserted by the compiler. This allows two objects of the class to be allocated unique addresses in memory.

2. ***The size of a class*** on any machine is the interplay of three factors:
    - Language support overhead. There is an associated overhead incurred in the language support of virtual base classes.
    - Compiler optimization of recognized special cases. There is the 1 byte size of the virtual base class subobject present within the derived class. Traditionally, this is placed at the end of the "fixed" (that is, invariant) portion of the derived class. Some compilers now provide special support for an empty virtual base class.（伍注：有些编译器会在继承类的尾端插入1字节表示虚基类，有些则不会）
    - Alignment constraints.

3. ***The C++ standard does not mandate details such as the ordering of either base class subobjects or of data members across access levels. Neither does it mandate the implementation of either virtual functions or virtual base classes; rather, it declares them to be implementation dependent.***

### The Binding of a Data Member

1. The analysis of the member function's body is delayed until the entire class declaration is seen. 

2. Names within the argument list are still resolved in place at the point they are first encountered. Nonintuitive bindings between extern and nested type names, therefore, can still occur. This aspect of the language still requires the general defensive programming style of always placing nested type declarations at the beginning of the class.（伍注：如果要在类内部声明某些类型，把这些声明放在类定义的起始处）

### Data Member Layout

1. The Standard requires within an access section only that the members be set down such that "later members have higher addresses within a class object". That is, the members are not required to be set down contiguously. What might intervene between the declared members? Alignment constraints on the type of a succeeding member may require padding. 

2. Additionally, the compiler may synthesize one or more additional internal data members in support of the Object Model. The ***vptr***, for example, is one such synthesized data member that all current implementations insert within each object of a class containing one or more virtual functions. 

3. The Standard allows the compiler the freedom to insert these internally generated members anywhere, even between those explicitly declared by the programmer. The Standard also allows the compiler the freedom to order the data members within multiple access sections within a class in whatever order it sees fit.

4. ***In practice, multiple access sections are concatenated together into one contiguous block in the order of declaration. No overhead is incurred by the access section specifier or the number of access levels.***

### Access of a Data Member

1. Each member's access permission and class association is maintained without incurring any space or runtime overhead either in the individual class objects or in the static data member itself.(疑问：如何实现？类对象与static成员之间如何建立联系？猜测：编译器内部维持一个“符号表”，类的static成员经过name mangling后的名字及其地址会记录在这个表中，当需要访问该static成员时，查表即可)

2. ***A single instance of each class static data member is stored within the data segment of the program.*** Each reference to the static member is internally translated to be a direct reference of that single extern instance.
```
// origin.chunkSize == 250;
Point3d::chunkSize == 250;
// pt->chunkSize == 250;
Point3d::chunkSize == 250;
```

3. ***Taking the address of a static data member yields an ordinary pointer of its data type, not a pointer to class member, since the static member is not contained within a class object.***

4. The two important aspects of any name mangling scheme are that
    - the algorithm yields unique names, and
    - those unique names can be easily recast back to the original name in case the compilation system (or environment tool) needs to communicate with the user.

5. Nonstatic data members are stored directly within each class object and cannot be accessed except through an explicit or implicit class object. An implicit class object is present whenever the programmer directly accesses a nonstatic data member within a member function.

6. Access of a nonstatic data member requires the addition of the beginning address of the class object with the offset location of the data member.

7. The address of `&origin._y;` is equivalent to the addition of `&origin + ( &Point3d::_y - 1 );` Notice the peculiar "***subtract by one***" expression applied to the pointer-to-data-member offset value. Offset values yielded by the pointer-to-data-member syntax are always bumped up by one. Doing this permits the compilation system to distinguish between a pointer to data member that is addressing the first member of a class and a pointer to data member that is addressing no member. 

8. The offset of each nonstatic data member is known at compile time, even if the member belongs to a base class subobject derived through a single or multiple inheritance chain. Access of a nonstatic data member, therefore, is equivalent in performance to that of a C struct member or the member of a nonderived class.

9. ***Virtual inheritance introduces an additional level of indirection in the access of its members through a base class subobject.*** Thus `Point3d *pt3d; pt3d->_x = 0.0;`
    - performs equivalently if \_x is a member of a struct, class, single inheritance hierarchy, or multiple inheritance hierarchy, 
    - but it performs somewhat slower if it is a member of a virtual base class. In this case, we cannot say with any certainty which class type pt addresses (and therefore we cannot know at compile time the actual offset location of the member), so the resolution of the access must be delayed until runtime through an additional indirection.（伍注：通过指针访问虚基类的成员的操作必须延迟至执行期，因为在编译期间我们不知道这个member真正的offset位置。）

### Inheritance and the Data Member

1. The actual ordering of the derived and base class parts is left unspecified by the Standard. In theory, a compiler is free to place either the base or the derived part first in the derived class object. ***In practice, the base class members always appear first, except in the case of a virtual base class.***

2. Inheritance without Polymorphism
    - A naive design might double the number of function calls to perform the same operations. 
    - A possible bloating of the space necessary to represent the abstraction as a class hierarchy. The issue is the language guarantee of the integrity of the base class subobject within the derived class.

3. It makes sense to introduce a virtual interface into our design only if we intend to manipulate two- and three-dimensional points polymorphically, that is, to write code such as
```
void foo( Point2d &p1, Point2d &p2 ) {
    // ...
    p1 += p2;
    // ...
}
```
where p1 and p2 may be either two- or three-dimensional points. This flexibility is at the heart of OO programming. 

4. Support for this flexibility, however, does introduce a number of ***space and access-time overheads*** for our Point2d class:
    - Introduction of a virtual table associated with Point2d to hold the address of each virtual function it declares. The size of this table in general is the number of virtual functions declared plus an additional one or two slots to support runtime type identification.
    - Introduction of the vptr within each class object. The vptr provides the runtime link for an object to efficiently find its associated virtual table.
    - Augmentation of the constructor to initialize the object's vptr to the virtual table of the class. Depending on the aggressiveness of the compiler's optimization, this may mean resetting the vptr within the derived and each base class constructor. 
    - Augmentation of the destructor to reset the vptr to the associated virtual table of the class. (It is likely to have been set to address the virtual table of the derived class within the destructor of the derived class. Remember, the order of destructor calls is in reverse: derived class and then base class.) An aggressive optimizing compiler can suppress a great many of these assignments.

5. ***Where best to locate the vptr within the class object***（疑问：最新标准是怎样实现的？）
    - In the original cfront implementation, it was placed at the end of the class object. This preserves the object layout of the base class C struct, thus permitting its use within C code. But this may be less efficient, since not only must the offset to the start of the class be made available at runtime, but also the offset to the location of the vptr of that class must be made available.
    - Placing the vptr at the start of the class is more efficient in supporting some virtual function invocations through pointers to class members under multiple inheritance. The trade-off is a loss in C language interoperability. 

6. ***Multiple Inheritance***（伍注：多重继承如果不涉及虚基类，其内存布局还是很简单的，直接把其继承的基类按照继承列表的顺序依次堆起来即可）
    - The complexity of multiple inheritance lies in the "unnatural" relationship of the derived class with its second and subsequent base class subobjects.
    - The assignment of the address of a multiply derived object to a pointer of its leftmost (that is, first) base class is the same as that for single inheritance, since both point to the same beginning address. The cost is simply the assignment of that address. 
    - The assignment of the address of a second or subsequent base class, however, requires that that address be modified by the addition (or subtraction in the case of a downcast) of the size of the intervening base class subobject(s).

7. ***The general implementation solution for Virtual Inheritance***
    - A class containing one or more virtual base class subobjects, such as istream, is divided into two regions: an invariant region and a shared region. 
    - Data within the invariant region remains at a fixed offset from the start of the object regardless of subsequent derivations. So members within the invariant region can be accessed directly. 
    - The shared region represents the virtual base class subobjects. The location of data within the shared region fluctuates with each derivation. So members within the shared region need to be accessed indirectly. What has varied among implementations is the method of indirect access. 

8. Virtual Inheritance with Pointer Strategy（伍注：仅用于讨论，C++并没采用此策略）
    - Strategy: A pointer to each virtual base class is inserted within each derived class object. Access of the inherited virtual base class members is achieved indirectly through the associated pointer. 
    - Weakness 1: An object of the class carries an additional pointer for each virtual base class. Ideally, we want a constant overhead for the class object that is independent of the number of virtual base classes within its inheritance hierarchy.
    - Weakness 2: As the virtual inheritance chain lengthens, the level of indirection increases to that depth. This means that three levels of virtual derivation requires indirection through three virtual base class pointers. Ideally, we want a constant access time regardless of the depth of the virtual derivation.

9. ***Vritual Inheritance with Virtual Table Offset Strategy***（C++采用此策略）
    - Introduced the virtual base class table and place the offset of the virtual base class within the virtual function table. 
    - The virtual function table is indexed by both positive and negative indices. The positive indices, as previously, index into the set of virtual functions; the negative indices retrieve the virtual base class offsets. 

10. ***In general, the most efficient use of a virtual base class is that of an abstract virtual base class with no associated data members.***（出于效率的考虑，虚基类一般不定义数据成员）

11. A possible pitfall in factoring a class into a two-level or deeper hierarchy is a possible bloating of the space necessary to represent the abstraction as a class hierarchy. The issue is the language guarantee of the integrity of the base class subobject within the derived class.（伍注：把原本一个class分解成多层继承的方式，可能会因为每一层的字节对齐而导致空间膨胀。）

### Object Member Efficiency

1. Without the optimizer turned on, it is extremely difficult to guess at the performance characteristics of a program, since the code is potentially hostage to the "quirk(s) of code generation…unique to a particular compiler." Before one begins source level "optimizations" to speed up a program, one should always do actual performance measurements rather than relying on speculation and common sense.

2. The programmer concerned with efficiency must actually measure the performance of his or her program and not leave the measurement of the program to speculation and assumption. It is also worth noting that optimizers don't always work. I've more than once had compilations fail with an optimizer turned on that compiled fine "normally."

### Pointer to Data Members

1. Pointers to data members are a somewhat arcane but useful feature of the language, particularly if you need to probe at the underlying member layout of a class. One example of such a probing might be to determine if the vptr is placed at the beginning or end of the class. A second use might be to determine the ordering of access sections within the class. 

2. The value returned from taking the member's address is always bumped up by 1. The problem is distinguishing between a pointer to no data member and a pointer to the first data member.
