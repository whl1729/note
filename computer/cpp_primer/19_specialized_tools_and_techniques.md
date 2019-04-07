# 《C++ Primer》第19章学习笔记

## 19 Specialized Tools and Techniques

### Controlling Memory Allocation

1. Three steps happen when we use new
    - First, The expression calls a library function named operator new (or operator new[]). This function allocates raw, untyped memory large enough to hold an object (or an array of objects) of the specified type.
    - Next, the compiler runs the appropriate constructor to construct the object(s) from the specified initializers.
    - Finally, a pointer to the newly allocated and constructed object is returned.

2. Two steps happen when we use delete
    - First, the appropriate destructor is run on the object to which sp points or on the elements in the array to which arr points.
    - Next, the compiler frees the memory by calling a library function named operator delete or operator delete[].

3. Warning: When we define the global operator new and operator delete functions, we take over responsibility for all dynamic memory allocation. These functions must be correct: They form a vital part of all processing in the program.

4. Applications can define operator new and operator delete functions in the global scope and/or as member functions. When the compiler sees a new or delete expression, it looks for the corresponding operator function to call in an inside-out order. That is: 
    - the compiler first looks in the scope of the class, including any base classes. If the class has a member operator new or operator delete, that function is used by the new or delete expression. 
    - Otherwise, the compiler looks for a matching function in the global scope. If the compiler finds a user-defined version, it uses that function to execute the new or delete expression. Otherwise, the standard library version is used. 

5. We can use the scope operator to force a new or delete expression to bypass a class-specific function and use the one from the global scope. 

6. Like destructors, an operator delete must not throw an exception.

7. When defined as members of a class, these operator functions are implicitly static. The member new and delete functions must be static because they are used either before the object is constructed (operator new) or after it has been destroyed (operator delete). There are, therefore, no member data for these functions to manipulate.

8. An operator new or operator new[] function must have a return type of void\* and its first parameter must have type size_t. That parameter may not have a default argument. The operator new function is used when we allocate an object; operator new[] is called when we allocate an array. 

9. We may not define a function with the following form `void *operator new(size_t, void*);` This specific form is reserved for use by the library and may not be redefined.

10. An operator delete or operator delete[] function must have a void return type and a first parameter of type void\*.

11. new Expression versus operator new Function
    - A new expression always executes by calling an operator new function to obtain memory and then constructing an object in that memory. A delete expression always executes by destroying an object and then calling an operator delete function to free the memory used by the object. 
    - By providing our own definitions of the operator new and operator delete functions, we can change how memory is allocated. However, we cannot change this basic meaning of the new and delete operators.

12. Placement new Expressions
    - Like allocator, operator new and operator delete functions allocate and deallocate memory but do not construct or destroy objects.
    - Differently from an allocator, there is no construct function we can call to construct objects in memory allocated by operator new. Instead, we use the placement new form of new to construct an object.
    ```
    new (place_address) type
    new (place_address) type (initializers)
    new (place_address) type [size]
    new (place_address) type [size] { braced initializer list }
    ```
    - When passed a single argument that is a pointer, a placement new expression constructs an object but does not allocate memory.

13. Calling a destructor destroys an object but does not free the memory.

### Run-Time Type Identification

1. Run-time type identification (RTTI) is provided through two operators:
    - The typeid operator, which returns the type of a given expression
    - The dynamic_cast operator, which safely converts a pointer or reference to a base type into a pointer or reference to a derived type

2. The RTTI operators are useful when we have a derived operation that we want to perform through a pointer or reference to a base-class object and it is not possible to make that operation a virtual function. 

3. RTTI should be used with caution: The programmer must know to which type the object should be cast and must check that the cast was performed successfully. When possible, it is better to define a virtual function rather than to take over managing the types directly.

4. A dynamic_cast has the following form where type must be a class type and (ordinarily) names a class that has virtual functions.
    - The type of e must be either a class type that is publicly derived from the target type, a public base class of the target type, or the same as the target type. 
    - If e has one of these types, then the cast will succeed. Otherwise, the cast fails. 
    - If a dynamic_cast to a pointer type fails, the result is 0. If a dynamic_cast to a reference type fails, the operator throws an exception of type bad_cast.
```
dynamic_cast<type*>(e)
dynamic_cast<type&>(e)
dynamic_cast<type&&>(e)
```

5. Performing a dynamic_cast in a condition ensures that the cast and test of its result are done in a single expression.

6. A typeid expression has the form typeid(e) where e is any expression or a type name. The result of a typeid operation is a reference to a const object of a library type named type_info, or a type publicly derived from type_info. 

7. how typeid evaluated
    - As usual, top-level const is ignored, and if the expression is a reference, typeid returns the type to which the reference refers. 
    - When applied to an array or function, however, the standard conversion to pointer is not done. That is, if we take typeid(a) and a is an array, the result describes an array type, not a pointer type. 
    - When the operand is not of class type or is a class without virtual functions, then the typeid operator indicates the static type of the operand. 
    - When the operand is an lvalue of a class type that defines at least one virtual function, then the type is evaluated at run time. 
    - The typeid of a pointer (as opposed to the object to which the pointer points) returns the static, compile-time type of the pointer.

8. Whether typeid requires a run-time check determines whether the expression is evaluated. The compiler evaluates the expression only if the type has virtual functions. 
    - If the type has no virtuals, then typeid returns the static type of the expression; the compiler knows the static type without evaluating the expression. 
    - If the dynamic type of the expression might differ from the static type, then the expression must be evaluated (at run time) to determine the resulting type. 
    - The distinction matters when we evaluate typeid(\*p). If p is a pointer to a type that does not have virtual functions, then p does not need to be a valid pointer. Otherwise, \*p is evaluated at run time, in which case p must be a valid pointer. If p is a null pointer, then typeid(\*p) throws a bad_typeid exception.

9. The type_info class
    - There is no type_info default constructor, and the copy and move constructors and the assignment operators are all defined as deleted. Therefore, we cannot define, copy, or assign objects of type type_info. The only way to create a type_info object is through the typeid operator.
    - The value used for a given type depends on the compiler and in particular is not required to match the type names as used in a program. The only guarantee we have about the return from name is that it returns a unique string for each type. 

10. Operations on type_info (Defined in typeinfo header)
```
t1 == t2
t1 != t2
t.name()
t1.before(t2)
```

### Enumerations

1. scoped enumerations vs unscoped enumerations
    - We define a scoped enumeration using the keywords enum class (or, equivalently, enum struct), followed by the enumeration name and a comma-separated list of enumerators enclosed in curly braces. A semicolon follows the close curly.
    - We define an unscoped enumeration by omitting the class (or struct) keyword. The enumeration name is optional in an unscoped enum. If the enum is unnamed, we may define objects of that type only as part of the enum definition. 

2. The names of the enumerators in a scoped enumeration follow normal scoping rules and are inaccessible outside the scope of the enumeration. The enumerator names in an unscoped enumeration are placed into the same scope as the enumeration itself.

3. An enumerator value need not be unique. When we omit an initializer, the enumerator has a value 1 greater than the preceding enumerator.

4. An enum object may be initialized or assigned only by one of its enumerators or by another object of the same enum type.

5. Objects or enumerators of an unscoped enumeration type are automatically converted to an integral type. As a result, they can be used where an integral value is required.

6. Specifying the Size of an enum
    - Under the new standard, we may specify that type by following the enum name with a colon and the name of the type we want to use: `enum intValues : unsigned long long {... }`
    - If we do not specify the underlying type, then by default scoped enums have int as the underlying type. 
    - There is no default for unscoped enums; all we know is that the underlying type is large enough to hold the enumerator values. 

7. Forward Declarations for Enumerations
    - Under the new standard, we can forward declare an enum. An enum forward declaration must specify (implicitly or explicitly) the underlying size of the enum.
    - Because there is no default size for an unscoped enum, every declaration must include the size of that enum. We can declare a scoped enum without specifying a size, in which case the size is implicitly defined as int.
    - The size of the enum must be the same across all declarations and the enum definition. Moreover, we cannot declare a name as an unscoped enum in one context and redeclare it as a scoped enum later.

### Pointers to Class Member

1. A pointer to member is a pointer that can point to a nonstatic member of a class. 

2. The type of a pointer to member embodies both the type of a class and the type of a member of that class. We initialize such pointers to point to a specific member of a class without identifying an object to which that member belongs. When we use a pointer to member, we supply the object whose member we wish to use.

3. We must precede the * with `classname::` to indicate that the pointer we are defining can point to a member of classname. Under the new standard, the easiest way to declare a pointer to member is to use auto or decltype.

4. It is essential to understand that when we initialize or assign a pointer to member, that pointer does not yet point to any data. It identifies a specific member but not the object that contains that member. We supply the object when we dereference the pointer to member.

5. If the member function is a const member or a reference member, we must include the const or reference qualifier when we define a pointer to the member function.

6. Unlike ordinary function pointers, there is no automatic conversion between a member function and a pointer to that member, we must explicitly use the address-of operator for it.

7. Because of the relative precedence of the call operator, declarations of pointers to member functions and calls through such pointers must use parentheses: (C::\*p)(parms) and (obj.\*p)(args).

8. Type aliases make code that uses pointers to members much easier to read and write.

9. One common use for function pointers and for pointers to member functions is to store them in a function table.

10. Three Methods to Generate a Callable from a Member Function:
    - Using function template: `function<bool (const string&)> fcn = &string::empty;`
    - Using mem_fn: `find_if(svec.begin(), svec.end(), mem_fn(&string::empty));`
    - Using bind: `auto it = find_if(svec.begin(), svec.end(), bind(&string::empty, _1));`

### Nested Classes

1. A class can be defined within another class. Such a class is a nested class, also referred to as a nested type. Nested classes are most often used to define implementation classes.

2. Until the actual definition of a nested class that is defined outside the class body is seen, that class is an incomplete type.

### union: A Space-Saving Class

1. A union may have multiple data members, but at any point in time, only one of the members may have a value. When a value is assigned to one member of the union, all other members become undefined. The amount of storage allocated for a union is at least as much as is needed to contain its largest data member. 

2. A union cannot have a member that is a reference, but it can have members of most other types, including class types that have constructors or destructors. A union can specify protection labels to make members public, private, or protected. By default, like structs, members of a union are public.

3. A union may define member functions, including constructors and destructors. However, a union may not inherit from another class, nor may a union be used as a base class. As a result, a union may not have virtual functions. 

4. unions offer a convenient way to represent a set of mutually exclusive values of different types.

5. Using a union Type
    - Like the built-in types, by default unions are uninitialized. We can explicitly initialize a union in the same way that we can explicitly initialize aggregate classes by enclosing the initializer in a pair of curly braces.
    - If an initializer is present, it is used to initialize the first member. 
    - When we use a union, we must always know what type of value is currently stored in the union. 

6. Anonymous unions
    - When we define an anonymous union the compiler automatically creates an unnamed object of the newly defined union type.
    - The members of an anonymous union are directly accessible in the scope where the anonymous union is defined.
    - An anonymous union cannot have private or protected members, nor can an anonymous union define member functions.

7. unions with Members of Class Type
    - When we switch the union’s value to and from a member of class type, we must construct or destroy that member, respectively: When we switch the union to a member of class type, we must run a constructor for that member’s type; when we switch from that member, we must run its destructor.
    - For unions that have members of a class type that defines its own default constructor or one or more of the copy-control members, the compiler synthesizes the corresponding member of the union as deleted.

8. Using a Class to Manage union Members
    - Because of the complexities involved in constructing and destroying members of class type, unions with class-type members ordinarily are embedded inside another class. 
    - To keep track of what type of value the union holds, we usually define a separate object known as a discriminant. 
    - Unlike ordinary members of a class type, class members that are part of a union are not automatically destroyed. The destructor has no way to know which type the union holds, so it cannot know which member to destroy.

### Local Classes

1. A class can be defined inside a function body. Such a class is called a local class. A local class defines a type that is visible only in the scope in which it is defined.

2. All members, including functions, of a local class must be completely defined inside the class body. As a result, local classes are much less useful than nested classes.

3. A local class is not permitted to declare static data members, there being no way to define them.

4. The names from the enclosing scope that a local class can access are limited. A local class can access only type names, static variables, and enumerators defined within the enclosing local scopes. A local class may not use the ordinary local variables of the function in which the class is defined.

5. Normal Protection Rules Apply to Local Classes. The enclosing function has no special access privileges to the private members of the local class. 

### Inherently Nonportable Features

#### Bit-fields

1. A bit-field holds a specified number of bits. Bit-fields are normally used when a program needs to pass binary data to another program or to a hardware device. The memory layout of a bit-field is machine dependent.

2. Ordinarily, we use an unsigned type to hold a bit-field, because the behavior of a signed bit-field is implementation defined. 

3. The address-of operator (&) cannot be applied to a bit-field, so there can be no pointers referring to class bit-fields.

4. Bit-fields with more than one bit are usually manipulated using the built-in bitwise operators.

5. Classes that define bit-field members also usually define a set of inline member functions to test and set the value of the bit-field.

#### volatile Qualifier

1. Warning: The precise meaning of volatile is inherently machine dependent and can be understood only by reading the compiler documentation. Programs that use volatile usually must be changed when they are moved to new machines or compilers.

2. An object should be declared volatile when its value might be changed in ways outside the control or detection of the program. The volatile keyword is a directive to the compiler that it should not perform optimizations on such objects.

3. There is no interaction between the const and volatile type qualifiers. A type can be both const and volatile, in which case it has the properties of both.

4. Basically, const means that the value isn’t modifiable by the program. And volatile means that the value is subject to sudden change (possibly from outside the program). In fact, C standard mentions an example of valid declaration which is both const and volatile. The example is “extern const volatile int real_time_clock;” where real_time_clock may be modifiable by hardware, but cannot be assigned to, incremented, or decremented. [C Quiz – 107 | Question 4](https://www.geeksforgeeks.org/c-c-quiz-107-question-4/)

5. In the same way that a class may define const member functions, it can also define member functions as volatile. Only volatile member functions may be called on volatile objects.

5. We have learned the interactions between the const qualifier and pointers. The same interactions exist between the volatile qualifier and pointers. We can declare pointers that are volatile, pointers to volatile objects, and pointers that are volatile that point to volatile objects.

6. As with const, we may assign the address of a volatile object (or copy a pointer to a volatile type) only to a pointer to volatile. We may use a volatile object to initialize a reference only if the reference is volatile.

7. Synthesized Copy Does Not Apply to volatile Objects
    - One important difference between the treatment of const and volatile is that the synthesized copy/move and assignment operators cannot be used to initialize or assign from a volatile object. The synthesized members take parameters that are references to (nonvolatile) const, and we cannot bind a nonvolatile reference to a volatile object. 
    - If a class wants to allow volatile objects to be copied, moved, or assigned, it must define its own versions of the copy or move operation. 

#### Linkage Directives: extern "C"

1. C++ uses linkage directives to indicate the language used for any non-C++ function.

2. A linkage directive can have one of two forms: single or compound. Linkage directives may not appear inside a class or function definition. The same linkage directive must appear on every declaration of a function.

3. We can give the same linkage to several functions at once by enclosing their declarations inside curly braces following the linkage directive.

4. When a #include directive is enclosed in the braces of a compound-linkage directive, all ordinary function declarations in the header file are assumed to be functions written in the language of the linkage directive. 

5. The functions that C++ inherits from the C library are permitted to be defined as C functions but are not required to be C functions—it’s up to each C++ implementation to decide whether to implement the C library functions in C or C++.

6. The language in which a function is written is part of its type. Hence, every declaration of a function defined with a linkage directive must use the same linkage directive. Moreover, pointers to functions written in other languages must be declared with the same linkage directive as the function itself.

7. A pointer to a C function does not have the same type as a pointer to a C++ function. A pointer to a C function cannot be initialized or be assigned to point to a C++ function (and vice versa). As with any other type mismatch, it is an error to try to assign two pointers with different linkage directives.

8. When we use a linkage directive, it applies to the function and any function pointers used as the return type or as a parameter type. 
```
// f1 is a C function; its parameter is a pointer to a C function
extern "C" void f1(void(*)(int));
```

9. To allow the same source file to be compiled under either C or C++, the preprocessor defines \_\_cplusplus (two underscores) when we compile C++. Using this variable, we can conditionally include code when we are compiling C++:
```
#ifdef __cplusplus
// ok: we're compiling C++
extern "C"
#endif
int strcmp(const char*, const char*);
```

10. The C language does not support function overloading, so it should not be a surprise that a C linkage directive can be specified for only one function in a set of overloaded functions.
