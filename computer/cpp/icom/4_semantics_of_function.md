# 《Inside the C++ Object Model》第4章读书笔记

## 4 The Semantics of Function

1.  C++ supports three flavors of member functions: static, nonstatic, and virtual. Each is invoked differently.

### Varieties of Member Invocation

1. One C++ design criterion is that a nonstatic member function at a minimum must be as efficient as its analogous nonmember function.

2. In practice the member function is transformed internally to be equivalent to the nonmember instance. Following are the ***steps in the transformation of a member function***:
    - Rewrite the signature to insert an additional argument to the member function that provides access to the invoking class object. This is called the implicit this pointer. If the member function is const, this pointer should also be declared as pointing to a const object.
    - Rewrite each direct access of a nonstatic data member of the class to access the member through the this pointer
    - Rewrite the member function into an external function, mangling its name so that it's lexically unique within the program.

3. ***Name Mangling***
    - In general, member names are made unique by concatenating the name of the member with that of the class. 
    - Function names are made unique by internally encoding the signature types and concatenating those to the name (use of the extern "C" declaration suppresses mangling of nonmember functions). 
    - By encoding the argument list with the function name, the compiler achieves a limited form of type checking across separately compiled modules.
    - In current compilation systems, "demangling" tools intercept and convert these names; the user remains blissfully unaware of the actual internal names. 

4. If normalize() were a virtual member function, the call `ptr->normalize();`would be internally transformed into `(*ptr->vptr[1])(ptr);`
    - vptr represents the internally generated virtual table pointer inserted within each object whose class declares or inherits one or more virtual functions. (In practice, its name is mangled. There may be multiple vptrs within a complex class derivation.)
    - 1 is the index into the virtual table slot associated with normalize().
    - ptr in its second occurrence represents the this pointer.

5. ***The explicit invocation of a virtual function using the class scope operator is resolved in the same way as a nonstatic member function.***

6. The class object is necessary only when one or more nonstatic data members are directly accessed within the member function. The class object provides the this pointer value for the call. If no member is directly accessed, there is, in effect, no need of the this pointer. There then is no need to invoke the member function with a class object. 

7. ***The primary characteristic of a static member function is that it is without a this pointer.*** The following secondary characteristics all derive from that primary one:
    - It cannot directly access the nonstatic members of its class.
    - It cannot be declared const, volatile, or virtual.
    - It does not need to be invoked through an object of its class, although for convenience, it may.

8. A static member function is also lifted out of the class declaration and given a suitably mangled name. 

### Virtual Member Functions

1. The general virtual function implementation model: the class-specific ***virtual table*** that contains the addresses of the set of active virtual functions for the class and the ***vptr*** that addresses that table inserted within each class object.

2. The virtual table is generated on a per-class basis. Each table holds the addresses of all the virtual function instances "active" for objects of the table's associated class. These active functions consist of the following: 
    - An instance defined within the class, thus overriding a possible base class instance. 伍注：如果派生类override了基类的某些虚函数，那么派生类的虚函数表保存的是派生类override后的函数地址，不再是基类的函数地址。
    - An instance inherited from the base class, should the derived class choose not to override it.
    - A pure_virtual_called() library instance that serves as both a placeholder for a pure virtual function and a runtime exception should the instance somehow be invoked.（纯虚类的virtual table中为每个纯虚函数也预留了位置。）

3. Each virtual function is assigned a ***fixed index*** in the virtual table. This index remains associated with the particular virtual function throughout the inheritance hierarchy.（伍注：正因为每个虚函数的index是固定的，我们才能不区分派生类还是基类，直接通过vptr + index找到对应虚函数的地址）

4. What happens when a class is subsequently derived from a base class? There are three possibilities:
    - It can inherit the instance of the virtual function declared within the base class. Literally, the address of that instance is copied into the associated slot in the derived class's virtual table.
    - It can override the instance with one of its own. In this case, the address of its instance is placed within the associated slot.
    - It can introduce a new virtual function not present in the base class. In this case, the virtual table is grown by a slot and the address of the function is placed within that slot.

5. So if we have the expression `ptr->z();` how do we know enough at compile time to set up the virtual function call? 
    - In general, we don't know the exact type of the object ptr addresses at each invocation of z(). We do know, however, that through ptr we can access the virtual table associated with the object's class. 
    - Although we again, in general, don't know which instance of z() to invoke, we know that each instance's address is contained in slot 4.

#### Virtual Functions under Multiple Inheritance

1. The complexity of virtual function support under multiple inheritance revolves around the second and subsequent base classes and the need to adjust the this pointer at runtime. 伍注：当一个类继承了多个虚基类时，这些基类按声明顺序依次存放在该类的内存空间中，其中只有第一个基类的地址位于该类的开头，用this指针可以直接访问到第一个基类，而后面的基类就需要通过this指针加上偏移来访问。

2. When we assign a Base2 pointer the address of a Derived class object allocated on the heap, ***The address of the new Derived object must be adjusted to address its Base2 subobject.*** The code to accomplish this is generated at compile time:
```
Base2 *pbase2 = new Derived;

// transformation to support second base class
Derived *temp = new Derived;
Base2 *pbase2 = temp ? temp + sizeof( Base1 ) : 0;
```

3. When we wants to call `delete pbase2;` to delete the object addressed by pbase2, ***the pointer must be readjusted in order to again address the beginning of the Derived class object*** (presuming it still addresses the Derived class object). This offset addition, however, cannot directly be set up at compile time because the actual object that pbase2 addresses generally can be determined only at runtime.

4. The general rule is that the this pointer adjustment of a derived class virtual function invocation through a pointer (or reference) of a second or subsequent base class must be accomplished at runtime. That is, the size of the necessary offset and the code to add it to the this pointer must be tucked away somewhere by the compiler.（伍注：编译器必须插入一些代码，使得通过非首个base class的指针来访问Derived class时，能够确认offset的大小以及把offset加到this指针上面，从而调整this指针指向Derived class的起始处。）

5. The more efficient solution is the use of a ***thunk***. The thunk is a small assembly stub that adjusts the this pointer with the appropriate offset and then jumps to the virtual function. 

6. Under multiple inheritance, a derived class contains n – 1 additional virtual tables, where n represents the number of its immediate base classes (thus single inheritance introduces zero additional tables).

7. To better accommodate the performance of the runtime linker, the Sun compiler concatenates the multiple virtual tables into one. The pointers to the secondary virtual tables are generated by adding an offset to the name of the primary table. Under this strategy, each class has only one named virtual table.

8. My recommendation is not to declare nonstatic data members within a virtual base class. Doing that goes a long way in taming the complexity.

### Function Efficiency

1. Inline expansion not only saves the overhead associated with a function call but also provides additional opportunities for program optimization.

### Pointer-to-Member Functions

1. The value returned from taking the address of a nonstatic data member is the byte value of the member's position in the class layout (plus 1). One can think of it as an incomplete value. It needs to be bound to the address of a class object before an actual instance of the member can be accessed.（伍注：指向成员函数的指针必须被绑定于某个class object的地址上，才能够被存取。）

2. The value returned from taking the address of a nonstatic member function, if it is nonvirtual, is the actual address in memory where the text of the function is located. This value, however, is equally incomplete. It, too, needs to be bound to the address of a class object before an actual invocation of the member function is possible. The object's address serves as the this pointer argument required by all nonstatic member functions.（伍注：同上）

3. When we taking the address of a virtual member function, that address is unknown at compile time. What is known is the function's associated index into the virtual table. That is, taking the address of a virtual member function yields its index into its class's associated virtual table.

### Inline Functions

1. The inline keyword (or the definition of a member function (or friend) within a class declaration) is only a request. For the request to be honored, the compiler must believe it can "reasonably" expand the function in an arbitrary expression.

2. When I say the compiler believes it can "***reasonably***" expand an inline function, I mean that at some level the execution cost of the function is by some measure less than the overhead of the function call and return mechanism.

3. In general, ***there are two phases to the handling of an inline function***:
    - The analysis of the function definition to determine the "intrinsic inline-ability" of the function (intrinsic in this context means unique to an implementation). If the function is judged non-inlineable, due either to its complexity or its construction, it is turned into a static function and a definition is generated within the module being compiled.
    - The actual inline expansion of the function at a point of call. This involves argument evaluation and management of temporaries. It is at this point of expansion that an implementation determines whether an individual call is non-inlineable.

4. During an inline expansion, each formal argument is replaced with its corresponding actual argument. 
    - If the actual argument exhibits a side effect, it cannot simply be plugged into each occurrence of the formal argument — that would result in multiple evaluations of the actual argument. In general, handling actual arguments that have side effects requires the introduction of a ***temporary object***. 
    - If the actual argument is a constant expression, we'd like it to be evaluated prior to its substitution; subsequent constant folding may also be performed.
    - If it is neither a constant expression nor an expression with side effects, a straight substitution of each actual argument with the associated formal argument is carried out. 

5. In general, each local variable within the inline function must be introduced into the enclosing block of the call as a uniquely named variable. If the inline function is expanded multiple times within one expression, each expansion is likely to require its own set of the local variables. If the inline function is expanded multiple times in discrete statements, however, a single set of the local variables can probably be reused across the multiple expansions.

6. Arguments with side effects, multiple calls within a single expression, and multiple local variables within the inline itself can all create temporaries that the compiler may or may not be able to remove. 

7. The expansion of inlines within inlines can cause a seemingly trivial inline to not be expanded due to its "concatenated complexity." This may occur in constructors for complex class hierarchies or in a chain of seemingly innocent inline calls within an object hierarchy, each of which executes a small set of operations and then dispatches a request to another object. 
