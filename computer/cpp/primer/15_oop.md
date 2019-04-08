# 《C++ Primer》第15章读书笔记

## Object-Oriented Programming

1. Object-oriented programming is based on three fundamental concepts: data abstraction, inheritance and dynamic binding.

2. Inheritance and dynamic binding affect how we write our programs in two ways: 
    - They make it easier to define new classes that are similar, but not identical, to other classes
    - They make it easier for us to write programs that can ignore the details of how those similar types differ.

### OOP: An Overview

1. Inheritance 
    - Classes related by inheritance form a hierarchy. Typically there is a base class at the root of the hierarchy, from which the other classes inherit, directly or indirectly. These inheriting classes are known as derived classes. 
    - The base class defines those members that are common to the types in the hierarchy. Each derived class defines those members that are specific to the derived class itself.

2. The base class defines as virtual those functions it expects its derived classes to define for themselves.

3. A derived class must specify the class(es) from which it intends to inherit. It does so in a class derivation list, which is a colon followed by a comma-separated list of base classes each of which may have an optional access specifier.

4. virtual and override
    - A derived class may include the virtual keyword on these functions but is not required to do so. 
    - The new standard lets a derived class explicitly note that it intends a member function to override a virtual that it inherits. It does so by specifying override after its parameter list.
    - ***You cannot put a virt-specifier (override and final) outside of a class definition.*** You only put that specifier on the function declaration within the class definition. The same is true for, e.g., explicit, static, virtual

5. Through dynamic binding, we can use the same code to process objects of either type Quote or Bulk_quote interchangeably. 

6. Because the decision as to which version to run depends on the type of the argument, that decision can’t be made until run time. Therefore, dynamic binding is sometimes known as run-time binding.

### Defining Base and Derived Classes

1. Base classes ordinarily should define a virtual destructor. Virtual destructors are needed even if they do no work.

2. When we call a virtual function through a pointer or reference, the call will be dynamically bound. 

3. Declare function as virtual
    - Any nonstatic member function, other than a constructor, may be virtual. 
    - The virtual keyword appears only on the declaration inside the class and may not be used on a function definition that appears outside the class body. 
    - A function that is declared as virtual in the base class is implicitly virtual in the derived classes as well. 

4. Access Control and Inheritance
    - Like any other code that uses the base class, a derived class may access the public members of its base class but may not access the private members. 
    - Sometimes a base class has members that it wants to let its derived classes use while still prohibiting access to those same members by other users. We specify such members after a protected access specifier.

5. The access specifier determines whether users of a derived class are allowed to know that the derived class inherits from its base class.

6. When the derivation is public, the public members of the base class become part of the interface of the derived class as well. In addition, we can bind an object of a publicly derived type to a pointer or reference to the base type. 

7. Virtual Functions in the Derived Class
    - Derived classes frequently, but not always, override the virtual functions that they inherit. If a derived class does not override a virtual from its base, then, like any other member, the derived class inherits the version defined in its base class. 
    - The new standard lets a derived class explicitly note that it intends a member function to override a virtual that it inherits. It does so by specifying override after the parameter list, or after the const or reference qualifier(s) if the member is a const or reference function.

8. Derived-to-Base Conversion
    - Because a derived object contains subparts corresponding to its base class(es), we can use an object of a derived type as if it were an object of its base type(s). In particular, we can bind a base-class reference or pointer to the base-class part of a derived object.
    - we can use an object of derived type or a reference to a derived type when a reference to the base type is required. Similarly, we can use a pointer to a derived type where a pointer to the base type is required.

9. Each class controls how its members are initialized. A derived class must use a base-class constructor to initialize its base-class part.

10. The base class is initialized first, and then the members of the derived class are initialized in the order in which they are declared in the class.

11. The scope of a derived class is nested inside the scope of its base class. As a result, there is no distinction between how a member of the derived class uses members defined in its own class and how it uses members defined in its base.

12. Inheritance and static Members
    - If a base class defines a static member, there is only one such member defined for the entire hierarchy. Regardless of the number of classes derived from a base class, there exists a single instance of each static member.
    - static members obey normal access control. If the member is private in the base class, then derived classes have no access to it.

13. A derived class is declared like any other class. The declaration contains the class name but does not include its derivation list: The purpose of a declaration is to make known that a name exists and what kind of entity it denotes, for example, a class, function, or variable.

14. A class must be defined, not just declared, before we can use it as a base class. The reason for this restriction should be easy to see: Each derived class contains, and may use, the members it inherits from its base class. To use those members, the derived class must know what they are.

15. A base class can itself be a derived class.  A direct base class is named in the derivation list. An indirect base is one that a derived class inherits through its direct base class.

16. We can prevent a class from being used as a base by following the class name with final.

17. Static Type and Dynamic Type
    - The static type of an expression is always known at compile time—it is the type with which a variable is declared or that an expression yields. 
    - The dynamic type is the type of the object in memory that the variable or expression represents. The dynamic type may not be known until run time.
    - The dynamic type of a pointer or reference to a base class may differ from its static type.
    - The dynamic type of an expression that is neither a reference nor a pointer is always the same as that expression’s static type.
    - In a word, dynamic binding happens only when a virtual function is called through a pointer or a reference.

18. There Is No Implicit Conversion from Base to Derived, and No Conversion between Objects
    - Because a base object might or might not be part of a derived object, there is no automatic conversion from the base class to its derived class(s)
    - In those cases when we know that the conversion from base to derived is safe, we can use a static_cast to override the compiler.
    - When we initialize or assign an object of a base type from an object of a derived type, only the base-class part of the derived object is copied, moved, or assigned. The derived part of the object is ignored.

### Virtual Functions

1. Because we don’t know which version of a function is called until run time, virtual functions must always be defined.

2. Virtual Functions in a Derived Class     
    - A derived-class function that overrides an inherited virtual function must have exactly the same parameter type(s) as the base-class function that it overrides.
    - With one exception, the return type of a virtual in the derived class also must match the return type of the function from the base class. The exception applies to virtuals that return a reference (or pointer) to types that are themselves related by inheritance. 

3. Why we specify override
    - It is legal for a derived class to define a function with the same name as a virtual in its base class but with a different parameter list. The compiler considers such a function to be independent from the base-class function. 
    -  we can specify override on a virtual function in a derived class. Doing so makes our intention clear and (more importantly) enlists the compiler in finding such problems for us. 
    - The compiler will reject a program if a function marked override does not override an existing virtual function

4. Any attempt to override a function that has been defined as final will be flagged as an error.

5. final and override specifiers appear after the parameter list (including any const or reference qualifiers) and after a trailing return.

6. Virtual Functions and Default Argument
    - If a call uses a default argument, the value that is used is the one defined in the base class. 
    - Best Practices: Virtual functions that have default arguments should use the same argument values in the base and derived classes.

7. Circumventing the Virtual Mechanism
    - Sometimes we want to force the call to use a particular version of that virtual. We can use the scope operator to do so.
    - Warning: If a derived virtual function that intended to call its base-class version omits the scope operator, the call will be resolved at run time as a call to the derived version itself, resulting in an infinite recursion.

### Abstract Base Classes

1. Pure Virtual Functions
    - A pure virtual function does not have to be defined. 
    - We specify that a virtual function is a pure virtual by writing = 0 in place of a function body (i.e., just before the semicolon that ends the declaration).
    - The = 0 may appear only on the declaration of a virtual function in the class body
    - We can provide a definition for a pure virtual. However, the function body must be defined outside the class. 

2. Abstract Base Classes: A class containing (or inheriting without overridding) a pure virtual function is an abstract base class. An abstract base class defines an interface for subsequent classes to override. We cannot (directly) create objects of a type that is an abstract base class.

### Access Control and Inheritance

1. Members and friends of a derived class can access the protected members only in base-class objects that are embedded inside a derived type object; they have no special access to ordinary objects of the base type.

2. Access to a member that a class inherits is controlled by a combination of the access specifier for that member in the base class, and the access specifier in the derivation list of the derived class.
    - public X type = type
    - private X type = private
    - protected X protected = protected

3. The derivation access specifier has no effect on whether members (and friends) of a derived class may access the members of its own direct base class. Access to the members of a base class is controlled by the access specifiers in the base class itself.

4. The purpose of the derivation access specifier is to control the access that users of the derived class—including other classes derived from the derived class—have to the members inherited from Base.

5. ***Whether the derived-to-base conversion is accessible depends on which code is trying to use the conversion and may depend on the access specifier used in the derived class’ derivation.*** Assuming D inherits from B: 
    - User code may use the derived-to-base conversion only if D inherits publicly from B. 
    - Member functions and friends of D can use the conversion to B regardless of how D inherits from B. The derived-to-base conversion to a direct base class is always accessible to members and friends of a derived class. 
    - Member functions and friends of classes derived from D may use the derived-to-base conversion if D inherits from B using either public or protected. Such code may not use the conversion if D inherits privately from B.

6. Friendship and Inheritance
    - Just as friendship is not transitive, friendship is also not inherited. Friends of the base have no special access to members of its derived classes, and friends of a derived class have no special access to the base class
    - When a class makes another class a friend, it is only that class to which friendship is granted. The base classes of, and classes derived from, the friend have no special access to the befriending class

7. Sometimes we need to change the access level of a name that a derived class inherits. We can do so by providing a using declaration. A derived class may provide a using declaration only for names it is permitted to access.

8. Default Inheritance Protection Levels
    - By default, a derived class defined with the class keyword has private inheritance; a derived class defined with struct has public inheritance
    - The only differences between class and struct are the default access specifier for members and the default derivation access specifier. 
    - A privately derived class should specify private explicitly rather than rely on the default. Being explicit makes it clear that private inheritance is intended and not an oversight.

### Class Scope under Inheritance

1. Under inheritance, the scope of a derived class is nested inside the scope of its base classes. If a name is unresolved within the scope of the derived class, the enclosing base-class scopes are searched for a definition of that name.

2. The static type of an object, reference, or pointer determines which members of that object are visible. Even when the static and dynamic types might differ (as can happen when a reference or pointer to a base class is used), the static type determines what members can be used.

3. A derived-class member with the same name as a member of the base class hides direct use of the base-class member. We can use a hidden base-class member by using the scope operator.

4. Name Lookup and Inheritance: Given the call p->mem() (or obj.mem()), the following four steps happen:
    - First determine the static type of p (or obj). Because we’re calling a member, that type must be a class type.
    - Look for mem in the class that corresponds to the static type of p (or obj). If mem is not found, look in the direct base class and continue up the chain of classes until mem is found or the last class is searched. If mem is not found in the class or its enclosing base classes, then the call will not compile.
    - Once mem is found, do normal type checking to see if this call is legal given the definition that was found.
    - Assuming the call is legal, the compiler generates code, which varies depending on whether the call is virtual or not: 
        - If mem is virtual and the call is made through a reference or pointer, then the compiler generates code to determine at run time which version to run based on the dynamic type of the object. 
        - Otherwise, if the function is nonvirtual, or if the call is on an object (not a reference or pointer), the compiler generates a normal function call.

5. As in any other scope, if a member in a derived class (i.e., in an inner scope) has the same name as a baseclass member (i.e., a name defined in an outer scope), then the derived member hides the base-class member within the scope of the derived class. The base member is hidden even if the functions have different parameter lists.

6. If the base and derived members took arguments that differed from one another, there would be no way to call the derived version through a reference or pointer to the base class.

7. The dynamic type doesn’t matter when we call a nonvirtual function. The version that is called depends only on the static type of the pointer.

8. A using declaration for a base-class member function adds all the overloaded instances of that function to the scope of the derived class. Having brought all the names into its scope, the derived class needs to define only those functions that truly depend on its type. It can use the inherited definitions for the others.

### Constructors and Copy Control

1. The primary direct impact that inheritance has on copy control for a base class is that a base class generally should define a virtual destructor. The destructor needs to be virtual to allow objects in the inheritance hierarchy to be dynamically allocated.

2. Executing delete on a pointer to base that points to a derived object has undefined behavior if the base’s destructor is not virtual.

3. If a base class has an empty destructor in order to make it virtual, then the fact that the class has a destructor does not indicate that the assignment operator or copy constructor is also needed.

4. If a class defines a destructor—even if it uses = default to use the synthesized version—the compiler will not synthesize a move operation for that class.

5. The way in which a base class is defined can cause a derived-class member to be defined as deleted: 
    - If the default constructor, copy constructor, copy-assignment operator, or destructor in the base class is deleted or inaccessible, then the corresponding member in the derived class is defined as deleted.
    - If the base class has an inaccessible or deleted destructor, then the synthesized default and copy constructors in the derived classes are defined as deleted.
    - As usual, the compiler will not synthesize a deleted move operation. If we use = default to request a move operation, it will be a deleted function in the derived if the corresponding operation in the base is deleted or inaccessible, because the base class part cannot be moved. The move constructor will also be deleted if the base class destructor is deleted or inaccessible.

6. Because lack of a move operation in a base class suppresses synthesized move for its derived classes, base classes ordinarily should define the move operations if it is sensible to do so. 

7. The destructor is responsible only for destroying the resources allocated by the derived class. Recall that the members of an object are implicitly destroyed. Similarly, the base-class part of a derived object is destroyed automatically.

8. When a derived class defines a copy or move operation, that operation is responsible for copying or moving the entire object, including base-class members.

9. By default, the base-class default constructor initializes the base-class part of a derived object. If we want copy (or move) the base-class part, we must explicitly use the copy (or move) constructor for the base class in the derived’s constructor initializer list.

10. Like the copy and move constructors, a derived-class assignment operator, must assign its base part explicitly.

11. Objects are destroyed in the opposite order from which they are constructed: The derived destructor is run first, and then the base-class destructors are invoked, back up through the inheritance hierarchy.

12. If a constructor or destructor calls a virtual, the version that is run is the one corresponding to the type of the constructor or destructor itself.

13. Inherited Constructors
    - A derived class inherits its base-class constructors by providing a using declaration that names its (direct) base class.
    - A using declaration causes the compiler to generate code. The compiler generates a derived constructor corresponding to each constructor in the base. 

14. Characteristics of an Inherited Constructor
    - Unlike using declarations for ordinary members, a constructor using declaration does not change the access level of the inherited constructor(s).
    - A using declaration can’t specify explicit or constexpr.
    - If a base-class constructor has default arguments, those arguments are not inherited. Instead, the derived class gets multiple inherited constructors in which each parameter with a default argument is successively omitted. 
    - A derived class can inherit some constructors and define its own versions of other constructors. If the derived class defines a constructor with the same parameters as a constructor in the base, then that constructor is not inherited. 
    - A class cannot inherit the default, copy, and move constructors. If the derived class does not directly define these constructors, the compiler synthesizes them as usual.

### Containers and Inheritance

1. When we need a container that holds objects related by inheritance, we typically define the container to hold pointers to the base class. 

2. One of the ironies of object-oriented programming in C++ is that we cannot use objects directly to support it. Instead, we must use pointers and references. Because pointers impose complexity on our programs, we often define auxiliary classes to help manage that complexity. 

### Text Queries Revisited

1. Inheritance versus Composition
    - When we define a class as publicly inherited from another, the derived class should reflect an “Is A” relationship to the base class. In well-designed class hierarchies, objects of a publicly derived class can be used wherever an object of the base class is expected.
    - Another common relationship among types is a “Has A” relationship. Types related by a “Has A” relationship imply membership.

### Questions

1. 编译器如何解决run-time binding带来的问题：由于在编译时不能确定调用哪个函数，那么编译器如何编译这段代码？先进行标记，等到链接时再解析？

2. 将Derived类对象与base类指针绑定时，编译器如何找到Derived类对象中的base part？

### TODO

1. Exercise 15.41 ~ 15.42
