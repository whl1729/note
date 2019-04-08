# 《Inside the C++ Object Model》第1章学习笔记

## 1 Object Lessons

1. In C, a data abstraction and the operations that perform on it are declared separately—that is, there is no language-supported relationship between data and functions. We speak of this method of programming as procedural, driven by a set of algorithms divided into task-oriented functions operating on shared, external data. 

2. Layout Costs for the class Point3d
    - The three coordinate data members are directly contained within each class object, as they are in the C struct. 
    - The member functions, although included in the class declaration, are not reflected in the object layout; one copy only of each non-inline member function is generated. 
    - Each inline function has either zero or one definition of itself generated within each module in which it is used. 
    - The Point3d class has no space or runtime penalty in supporting encapsulation.

3. The primary layout and access-time overheads within C++ are associated with the virtuals, that is, 
    - the virtual function mechanism in its support of an efficient run-time binding, and 
    - a virtual base class in its support of a single, shared instance of a base class occurring multiple times within an inheritance hierarchy.

4. There is also additional overhead under multiple inheritance in the conversion between a derived class and its second or subsequent base class. In general, however, there is no inherent reason a program in C++ need be any larger or slower than its equivalent C program.

### The C++ Object Model

1. In C++, there are 
    - two flavors of class data members: static and nonstatic
    - and three flavors of class member functions: static, nonstatic, and virtual. 

2. The C++ Object Model
    - Nonstatic data members are allocated directly within each class object. 
    - Static data members are stored outside the individual class object. 
    - Static and nonstatic function members are also hoisted outside the class object. 
    - Virtual functions are supported in two steps:
        - A table of pointers to virtual functions is generated for each class (this is called the virtual table).
        - A single pointer to the associated virtual table is inserted within each class object (traditionally, this has been called the vptr). The setting, resetting, and not setting of the vptr is handled automatically through code generated within each class constructor, destructor, and copy assignment operator. The type_info object associated with each class in support of runtime type identification (RTTI) is also addressed within the virtual table, usually within the table's first slot.

3. A base table model
    - A base class table is generated for which each slot contains the address of an associated base class. Each class object contains a bptr initialized to address its base class table. 
    - The primary drawback to this strategy is both the space and access-time overhead of the indirection. 
    - One benefit is a uniform representation of inheritance within each class object. Each class object would contain a base table pointer at some fixed location regardless of the size or number of its base classes. 
    - A second benefit would be the ability to grow, shrink, or otherwise modify the base class table without changing the size of the class objects themselves.

### A Keyword Distinction

1. A meta-language rule is required, dictating that when the language cannot distinguish between a declaration and an expression, it is to be interpreted as a declaration.

2. A C program's trick is sometimes a C++ program's trap. One example of this is the use of a one-element array at the end of a struct to allow individual struct objects to address variable-sized arrays.

3. The data members within a single access section are guaranteed within C++ to be laid out in the order of their declaration. The layout of data contained in multiple access sections, however, is left undefined. 

### An Object Distinction

1. The C++ programming model directly supports three programming paradigms:
    - The procedural model as programmed in C, and, of course, supported within C++.
    - The abstract data type (ADT) model in which users of the abstraction are provided with a set of operations (the public interface), while the implementation remains hidden.
    - The object-oriented (OO) model in which a collection of related types are encapsulated through an abstract base class providing a common interface.

2. Although you can manipulate a base class object of an inheritance hierarchy either directly or indirectly, only the indirect manipulation of the object through a pointer or reference supports the polymorphism necessary for OO programming. 

3. The C++ language supports polymorphism in the following ways:
    - Through a set of implicit conversions, such as the conversion of a derived class pointer to a pointer of its public base type
    - Through the virtual function mechanism
    - Through the dynamic_cast and typeid operators

4. The primary use of polymorphism is to effect type encapsulation through a shared interface usually defined within an abstract base class from which specific subtypes are derived.

5. By our writing code such as `library_material->check_out();` user code is shielded from the variety and volatility of lending materials supported by a particular library. This not only allows for the addition, revision, or removal of types without requiring changes to user programs. It also frees the provider of a new Library_materials subtype from having to recode behavior or actions common to all types in the hierarchy itself. 

6. The memory requirements to represent a class object in general are the following:
    - The accumulated size of its nonstatic data members
    - Plus any padding (between members or on the aggregate boundary itself) due to alignment constraints (or simple efficiency)
    - Plus any internally generated overhead to support the virtuals.

7. Internally, a reference is generally implemented as a pointer and the object syntax transformed into the indirection required of a pointer.

8. The type of a pointer instructs the compiler as to how to interpret the memory found at a particular address and also just how much memory that interpretation should span.

9. A cast in general is a kind of compiler directive. In most cases, it does not alter the actual address a pointer contains. Rather, it alters only the interpretation of the size and composition of the memory being addressed.

10. The compiler intercedes in the initialization and assignment of one class object with another. The compiler must ensure that if an object contains one or more vptrs, those vptr values are not initialized or changed by the source object.

11. Why direct object manipulation is not supported under OOP?
    - A pointer and a reference support polymorphism because they do not involve any type-dependent commitment of resources. Rather, all that is altered is the interpretation of the size and composition of the memory they address.
    - Any attempt to alter the actual size of the object za, however, violates the contracted resource requirements of its definition. Assign the entire Bear object to za and the object overflows its allocated memory. As a result, the executable is, literally, corrupted, although the corruption may not manifest itself as a core dump.

12. Summary of Polymorphism
    - Polymorphism is a powerful design mechanism that allows for the encapsulation of related types behind an abstract public interface. 
    - The cost is an additional level of indirection, both in terms of memory acquisition and type resolution. 
    - C++ supports polymorphism through class pointers and references. 
    - This style of programming is called object-oriented. 

13. C++ also supports a concrete ADT style of programming now called object-based (OB) - nonpolymorphic data types, such as a String class. 
    - An OB design can be faster and more compact than an equivalent OO design. Faster because all function invocations are resolved at compile time and object construction need not set up the virtual mechanism, 
    - and more compact because each class object need not carry the additional overhead traditionally associated with the support of the virtual mechanism. 
    - However, an OB design also is less flexible.
