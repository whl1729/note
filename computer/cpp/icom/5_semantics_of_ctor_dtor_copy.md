# 《Inside the C++ Object Model》第5章学习笔记

## 5 Semantics of Construction, Destruction and Copy

1. In general, the data members of a class should be initialized and assigned to only within the constructor and other member functions of that class. To do otherwise breaks encapsulation, thereby making maintenance and modification of the class more difficult.

2. The pure virtual destructor must be defined by the class designer. Why? Every derived class destructor is internally augmented to statically invoke each of its virtual base and immediate base class destructors. The absence of a definition of any of the base class destructors in general results in a link-time error.

3. A better design alternative is to not declare a virtual destructor as pure.

4. In general, it is still a bad design choice to declare all functions virtual and to depend on the compiler to optimize away unnecessary virtual invocations.

### Object Construction without Inheritance

#### Plain Ol's Data

1. Here is a first declaration of Point, written as it might be in C. The Standard speaks of this Point declaration as Plain Ol' Data.
```
typedef struct
{
    float x, y, z;
} Point;
```

2. What happens when this declaration is compiled under C++? Conceptually, a trivial default constructor, trivial destructor, trivial copy constructor, and trivial copy assignment operator are internally declared for Point. In practice, all that happens is that the compiler has analyzed the declaration and tagged it to be Plain Ol' Data.

3. In C, Point global` is treated as a tentative definition because it is without explicit initialization. A tentative definition can occur multiple times within the program. Those multiple instances are collapsed by the link editor, and a single instance is placed within BSS.

4. In C++, tentative definitions are not supported because of the implicit application of class constructors. `Point global`, therefore, is treated within C++ as a full definition (precluding a second or subsequent definition). One difference between C and C++, then, is the relative unimportance of the BSS data segment in C++. All global objects within C++ are treated as initialized.

#### Abstract Data Type

1. Here is the second declaration of Point provides full encapsulation of private data behind a public interface but does
not provide any virtual function interface:
```
class Point {
public:
    Point(float x = 0.0, float y = 0.0, float z = 0.0) :
        _x( x ), _y( y ), _z( z ) {}
    // no copy constructor, copy operator
    // or destructor defined ...
    // ...
private:
    float _x, _y, _z;
};
```

2. Conceptually, our Point class has an associated default copy constructor, copy operator, and destructor. These, however, are trivial and are not in practice actually generated by the compiler.

3. In the special case of initializing a class to all constant values, an explicit initialization list is slightly more efficient than the equivalent inline expansion of a constructor. Consider the following code segment, local1's initialization is slightly more efficient than that of local2's. This is because the values within the initialization list can be placed within local1's memory during placement of the function's activation record upon the program stack.
```
void mumble()
{
    Point1 local1 = { 1.0, 1.0, 1.0 };
    Point2 local2;
    // equivalent to an inline expansion
    // the explicit initialization is slightly faster
    local2._x = 1.0;
    local2._y = 1.0;
    local2._z = 1.0;
}
```

#### Preparing for Inheritance

1. Our third declaration of Point prepares for inheritance and the dynamic resolution of certain operations.
```
class Point {
public:
    Point( float x = 0.0, float y = 0.0 ):
        _x( x ), _y( y ) {}
    // no destructor, copy constructor, or
    // copy operator defined ...
    virtual float z();
    // ...
protected:
    float _x, _y;
};
```

2. In addition to the vptr added within each class object, the introduction of the virtual function causes the following compiler-driven augmentations to our Point class:
    - The constructor we've defined has code added to it to initialize the virtual table pointer. This code has to be added after the invocation of any base class constructors but before execution of any usersupplied code.
    - Both a copy constructor and a copy operator need to be synthesized, as their operations are now nontrivial. (The implicit de-structor remains trivial and so is not synthesized.) 

### Object Construction under Inheritance

1. Constructors can contain a great deal of hidden program code because the compiler augments every constructor to a greater or lesser extent depending on the complexity of T's class hierarchy. The general sequence of compiler augmentations is as follows: 
    - The data members initialized in the member initialization list have to be entered within the body of the constructor in the order of member declaration. 
    - If a member class object is not present in the member initialization list but has an associated default constructor, that default constructor must be invoked.
    - Prior to that, if there is a virtual table pointer (or pointers) contained within the class object, it (they) must be initialized with the address of the appropriate virtual table(s).
    - Prior to that, all immediate base class constructors must be invoked in the order of base class declaration (the order within the member initialization list is not relevant).
        - If the base class is listed within the member initialization list, the explicit arguments, if any, must be passed.
        - If the base class is not listed within the member initialization list, the default constructor (or default memberwise copy constructor) must be invoked, if present.
        - If the base class is a second or subsequent base class, the this pointer must be adjusted.
    - Prior to that, all virtual base class constructors must be invoked in a left-to-right, depth-first search of the inheritance hierarchy defined by the derived class.
        - If the class is listed within the member initialization list, the explicit arguments, if any, must be passed. Otherwise, if there is a default constructor associated with the class, it must be invoked.
        - In addition, the offset of each virtual base class subobject within the class must somehow be made accessible at runtime.
        - These constructors, however, may be invoked if, and only if, the class object represents the "most-derived class." Some mechanism supporting this must be put into place. 

2. Failure to check for an assignment to self in a user-supplied copy operator is a common pitfall of the beginner programmer.

3. The traditional strategy for supporting this sort of "now you initialize the virtual base class, now you don't" is to introduce an additional argument in the constructor(s) indicating whether the virtual base class constructor (s) should be invoked. The body of the constructor conditionally tests this argument and either does or does not invoke the associated virtual base class constructors.

4. The general algorithm of constructor execution is as follows:
    - Within the derived class constructor, all virtual base class and then immediate base class constructors are invoked.
    - That done, the object's vptr(s) are initialized to address the associated virtual table(s).
    - The member initialization list, if present, is expanded within the body of the constructor. This must be done after the vptr is set in case a virtual member function is called.
    - The explicit user-supplied code is executed.

### Object Copy Semantics

1. I recommend not permitting the copy operation of a virtual base class whenever possible. An even stronger recommendation: Do not declare data within any class that serves as a virtual base class.

### Semantics of Destruction

1. To determine if a class needs a program level destructor (or constructor, for that matter), consider the case where the lifetime of a class object terminates (or begins). What, if anything, needs to be done to guarantee that object's integrity? This is preferably what you need to program (or else the user of your class has to). This is what should go into the destructor (or constructor).

2. A user-defined destructor is augmented in much the same way as are the constructors, except in reverse order:
    - If the object contains a vptr, it is reset to the virtual table associated with the class.
    - The body of the destructor is then executed; that is, the vptr is reset prior to evaluating the usersupplied code.
    - If the class has member class objects with destructors, these are invoked in the reverse order of their declaration.
    - If there are any immediate nonvirtual base classes with destructors, these are invoked in the reverse order of their declaration.
    - If there are any virtual base classes with destructors and this class represents the most-derived class, these are invoked in the reverse order of their original construction.