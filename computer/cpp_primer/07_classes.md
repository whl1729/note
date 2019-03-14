# 《C++ Primer》第7章学习笔记

## Classes

1. The fundamental ideas behind classes are data abstraction and encapsulation. 
    - Data abstraction is a programming (and design) technique that relies on the separation of interface and implementation. 
    - Encapsulation enforces the separation of a class’ interface and implementation. A class that is encapsulated hides its implementation—users of the class can use the interface but have no access to the implementation.
    - A class that uses data abstraction and encapsulation defines an abstract data type. 

### Class declaration and definition

1. Member functions and nonmenber functions
    - Member functions must be declared inside the class. 
    - Member functions may be defined inside the class itself or outside the class body. 
    - Nonmember functions that are part of the interface are declared and defined outside the class.

2. Note: Functions defined in the class are implicitly inline.

3. Member functions access the object on which they were called through an extra, implicit parameter named this. When we call a member function, this is initialized with the address of the object on which the function was invoked.

4. Inside a member function, we can refer directly to the members of the object on which the function was called. 

5. A const following the parameter list indicates that this is a pointer to const. Member functions that use const in this way are const member functions.

6. Note: Objects that are const, and references or pointers to const objects, may call only const member functions.

7. The compiler processes classes in two steps— the member declarations are compiled first, after which the member function bodies, if any, are processed. Thus, member function bodies may use other members of their class regardless of where in the class those members appear.

8. when we define a member function outside the class body, 
    - the member’s definition must match its declaration. That is, the return type, parameter list, and name must match the declaration in the class body. 
    - If the member was declared as a const member function, then the definition must also specify const after the parameter list. 
    - The name of a member defined outside the class must include the name of the class of which it is a member.

9. Note: Dereference a pointer returns a reference. For example, `return *this` returns a reference to the object on which the function is executing.

10. Ordinarily, nonmember functions that are part of the interface of a class should be declared in the same header as the class itself. That way users need to include only one file to use any part of the interface.

11. Note that print does not print a newline. Ordinarily, functions that do output should do minimal formatting. That way user code can decide whether the newline is needed.

### Constructors

1. basics of constructors
    - Constructors have the same name as the class. 
    - Unlike other functions, constructors have no return type.
    - Unlike other member functions, constructors may not be declared as const. When we create a const object of a class type, the object does not assume its “constness” until after the constructor completes the object’s initialization. Thus, constructors can write to const objects during their construction.

2. Classes control default initialization by defining a special constructor, known as the default constructor. The default constructor is one that takes no arguments. If our class does not explicitly define any constructors, the compiler will implicitly define the default constructor for us, which is known as the synthesized default constructor. 

3. For most classes, this synthesized constructor initializes each data member of the class as follows:
    - If there is an in-class initializer, use it to initialize the member.
    - Otherwise, default-initialize the member.

4. Some Classes Cannot Rely on the Synthesized Default Constructor
    - The compiler generates the default for us only if we do not define any other constructors for the class. If we define any constructors, the class will not have a default constructor unless we define that constructor ourselves. The basis for this rule is that if a class requires control to initialize an object in one case, then the class is likely to require control in all cases.
    - Classes that have members of built-in or compound type should ordinarily either initialize those members inside the class or define their own version of the default constructor. Otherwise, users could create objects with members that have undefined value.
    - Sometimes the compiler is unable to synthesize one. For example, if a class has a member that has a class type, and that class doesn’t have a default constructor, then the compiler can’t initialize that member. 

5. `= default`
    - If we want the default behavior, we can ask the compiler to generate the constructor for us by writing = default after the parameter list. 
    - The = default can appear with the declaration inside the class body or on the definition outside the class body. 
    - If the = default appears inside the class body, the default constructor will be inlined; if it appears on the definition outside the class, the member will not be inlined by default.

6. Constructor Initializer List
    - The constructor initializer is a list of member names, each of which is followed by that member’s initial value in parentheses (or inside curly braces). Multiple member initializations are separated by commas.
    - When a member is omitted from the constructor initializer list, it is implicitly initialized using the same process as is used by the synthesized default constructor.  
    - Even if the constructor initializer list is empty, the members of this object are still initialized before the constructor body is executed.
    - If we do not explicitly initialize a member in the constructor initializer list, that member is default initialized before the constructor body starts executing. 
    - Note: We must use the constructor initializer list to provide values for members that are const, reference, or of a class type that does not have a default constructor.
    - Advice: Use Constructor Initializers. More important than the efficiency issue is the fact that some data members must be initialized. By routinely using constructor initializers, you can avoid being surprised by compile-time errors when you have a class with a member that requires a constructor initializer.

7. Order of Member Initialization: the constructor initializer list specifies only the values used to initialize the members, not the order in which those initializations are performed. Members are initialized in the order in which they appear in the class definition.

8. Advice: It is a good idea to write constructor initializers in the same order as the members are declared. Moreover, when possible, avoid using members to initialize other members.

9. Note: A constructor that supplies default arguments for all its parameters also defines the default constructor.

10. A delegating constructor uses another constructor from its own class to perform its initialization. When a constructor delegates to another constructor, the constructor initializer list and function body of the delegated-to constructor are both executed.

11. The default constructor is used automatically whenever an object is default or value initialized. 
    - Default initialization happens
        - When we define nonstatic variables or arrays at block scope without initializers
        - When a class that itself has members of class type uses the synthesized default constructor
        - When members of class type are not explicitly initialized in a constructor initializer list 
    - Value initialization happens 
        - During array initialization when we provide fewer initializers than the size of the array.
        - When we define a local static object without an initializer.
        - When we explicitly request value initialization by writing an expressions of the form T() where T is the name of a type.

12. Advice: In practice, it is almost always right to provide a default constructor if other constructors are being defined. (It's an error that there is no initializer for the object that do not have a default constructor.)

13. Warning: It is a common mistake among programmers new to C++ to try to declare an object initialized with the default constructor as follows:
```
Sales_data obj(); // oops! declares a function, not an object
Sales_data obj2; // ok: obj2 is an object, not a function
```

14. Implicit Class-Type Conversions
    - A constructor that can be called with a single argument defines an implicit conversion from the constructor’s parameter type to the class type. 
    - The compiler will automatically apply only one class-type conversion.

15. Explicit
    - We can prevent the use of a constructor in a context that requires an implicit conversion by declaring the constructor as explicit.
    - The explicit keyword is meaningful only on constructors that can be called with a single argument. Constructors that require more arguments are not used to perform an implicit conversion, so there is no need to designate such constructors as explicit. 
    - The explicit keyword is used only on the constructor declaration inside the class. It is not repeated on a definition made outside the class body.
    - When a constructor is declared explicit, it can be used only with the direct form of initialization. Moroever, the compiler will not use this constructor in an automatic conversion.
    - Although the compiler will not use an explicit constructor for an implicit conversion, we can use such constructors explicitly to force a conversion: `item.combine(static_cast<Sales_data>(cin));`

16. An aggregate class gives users direct access to its members and has special initialization syntax. A class is an aggregate if
    - All of its data members are public
    - It does not define any constructors
    - It has no in-class initializers
    - It has no base classes or virtual functions

17. Literal Classes: An aggregate class whose data members are all of literal type is a literal class. A nonaggregate class, that meets the following restrictions, is also a literal class:
    - The data members all must have literal type.
    - The class must have at least one constexpr constructor.
    - If a data member has an in-class initializer, the initializer for a member of builtin type must be a constant expression, or if the member has class type, the initializer must use the member’s own constexpr constructor.
    - The class must use default definition for its destructor, which is the member that destroys objects of the class type.

18. The body of a constexpr constructor is typically empty. We define a constexpr constructor by preceding its declaration with the keyword constexpr.

### Copy, Assignment, and Destruction

1. If we do not define these operations(copy, assignment and destruction), the compiler will synthesize them for us. Ordinarily, the versions that the compiler generates for us execute by copying, assigning, or destroying each member of the object.

2. Some Classes Cannot Rely on the Synthesized Versions
    - The synthesized versions are unlikely to work correctly for classes that allocate resources that reside outside the class objects themselves. 
    - Many classes that need dynamic memory can (and generally should) use a vector or a string to manage the necessary storage. Classes that use vectors and strings avoid the complexities involved in allocating and deallocating memory.
    - Moreover, the synthesized versions for copy, assignment, and destruction work correctly for classes that have vector or string members.

### Access Control and Encapsulation

1.  In C++ we use access specifiers to enforce encapsulation: 
    - Members defined after a public specifier are accessible to all parts of the program. The public members define the interface to the class. 
    - Members defined after a private specifier are accessible to the member functions of the class but are not accessible to code that uses the class. The private sections encapsulate (i.e., hide) the implementation.

2. A class may contain zero or more access specifiers, and there are no restrictions on how often an access specifier may appear. Each access specifier specifies the access level of the succeeding members. The specified access level remains in effect until the next access specifier or the end of the class body.

3. struct vs class
    - The only difference between struct and class is the default access level.
    - A class may define members before the first access specifier. Access to such members depends on how the class is defined. If we use the struct keyword, the members defined before the first access specifier are public; if we use class, then the members are private.
    - As a matter of programming style, when we define a class intending for all of its members to be public, we use struct. If we intend to have private members, then we use class.

4. What is Encapsulation and Why is it useful?
    - encapsulation is the separation of implementation from interface. It hides the implementation details of a type. (In C++, encapsulation is enforced by putting the implementation in the private part of a class)
    - Important advantages:
        - User code cannot inadvertently corrupt the state of an encapsulation object.
        - The implementation of an encapsulated class can change over time without requiring changes in user-level code.
    - Benefits of defining data members as private
        - the class author is free to make changes in the data.
        - the data are protected from mistakes that users might introduce.

5. Friend
    - A class can allow another class or function to access its nonpublic members by making that class or function a friend. A class makes a function its friend by including a declaration for that function preceded by the keyword friend.
    - Friend declarations may appear only inside a class definition; they may appear anywhere in the class.
    - Tip: Ordinarily it is a good idea to group friend declarations together at the beginning or end of the class definition.

6. Declarations for Friends
    - If we want users of the class to be able to call a friend function, then we must also declare the function separately from the friend declaration.
    - Some compilers allow calls to a friend function when there is no ordinary declaration for that function. Even if your compiler allows such calls, it is a good idea to provide separate declarations for friends. That way you won’t have to change your code if you use a compiler that enforces this rule.

7. The pros and cons of using friends
    - Pros:
        - the useful functions can refer to class members in the class scope without needing to explicitly prefix them with the class name.
        - you can access all the nonpublic members conveniently.
        - sometimes, more readable to the users of class.
    - Cons:
        - lessens encapsulation and therefore maintainability.
        - code verbosity, declarations inside the class, outside the class.

### Additional Class Features

1. Defining a Type Member
    - A class can define its own local names for types. Type names defined by a class are subject to the same access controls as any other member and may be either public or private.
    - We can use a typedef or a type alias to define a type member.
    - Members that define types must appear before they are used. As a result, type members usually appear at the beginning of the class.

2. Making Members inline
    - Although we are not required to do so, it is legal to specify inline on both the declaration and the definition. However, specifying inline only on the definition outside the class can make the class easier to read.
    - For the same reasons that we define inline functions in headers, inline member functions should be defined in the same header as the corresponding class definition.

3. mutable Data Members
    - It sometimes (but not very often) happens that a class has a data member that we want to be able to modify, even inside a const member function. We indicate such members by including the mutable keyword in their declaration.
    - A mutable data member is never const, even when it is a member of a const object. Accordingly, a const member function may change a mutable member.

4. Note: When we provide an in-class initializer, we must do so following an = sign or inside braces.

5. Functions that return a reference are lvalues, which means that they return the object itself, not a copy of the object. If we concatenate a sequence of these actions into a single expression, these operations will execute on the same object. 
```
// move the cursor to a given position, and set that character
myScreen.move(4,0).set('#');
```

6. Note: A const member function that returns \*this as a reference should have a return type that is a reference to const.

7. Advice: Use Private Utility Functions for Common Code. In practice, well-designed C++ programs tend to have lots of small functions such as do_display that are called to do the “real” work of some other set of functions.

8. Note: Even if two classes have exactly the same member list, they are different types. The members of each class are distinct from the members of any other class (or any other scope).

9. Class Declarations(sometimes referred to as a forward declaration)
    - Just as we can declare a function apart from its definition, we can also declare a class without defining it: `class Screen;`
    -  We can define pointers or references to such types, and we can declare (but not define) functions that use an incomplete type as a parameter or return type.
    - Because a class is not defined until its class body is complete, a class cannot have data members of its own type. However, a class is considered declared (but not yet defined) as soon as its class name has been seen. Therefore, a class can have data members that are pointers or references to its own type:
    ```
    class Link_screen {
        Screen window;
        Link_screen *next;
        Link_screen *prev;
    };
    ```

10. Friendship
    - A class can also make another class its friend or it can declare specific member functions of another (previously defined) class as friends. In addition, a friend function can be defined inside the class body.
    - The member functions of a friend class can access all the members, including the nonpublic members, of the class granting friendship.
    - Friendship is not transitive. 
    - Each class controls which classes or functions are its friends.

11. Making A Member Function a Friend
    - Making a member function a friend requires careful structuring of our programs to accommodate interdependencies among the declarations and definitions.
    - Although overloaded functions share a common name, they are still different functions. Therefore, a class must declare as a friend each function in a set of overloaded functions that it wishes to make a friend.

12. A friend declaration affects access but is not a declaration in an ordinary sense.

### Class scope

1. Scope and Members Defined outside the Class
    - The fact that a class is a scope explains why we must provide the class name as well as the function name when we define a member function outside its class. Outside of the class, the names of the members are hidden.
    - Once the class name is seen, the remainder of the definition—including the parameter list and the function body—is in the scope of the class. As a result, we can refer to other class members without qualification.
    - The return type of a function normally appears before the function’s name. When a member function is defined outside the class body, any name used in the return type is outside the class scope. As a result, the return type must specify the class of which it is a member.

2. Note: Member function definitions are processed after the compiler processes all of the declarations in the class.

3. Names used in declarations, including names used for the return type and types in the parameter list, must be seen before they are used.

4. In a class, if a member uses a name from an outer scope and that name is a type, then the class may not subsequently redefine that name.

5. Tip: Definitions of type names usually should appear at the beginning of a class. That way any member that uses that type will be seen after the type name has already been defined.

6. A name used in the body of a member function is resolved as follows:
    - First, look for a declaration of the name inside the member function. As usual, only declarations in the function body that precede the use of the name are considered. 
    - If the declaration is not found inside the member function, look for a declaration inside the class. All the members of the class are considered. 
    - If a declaration for the name is not found in the class, look for a declaration that is in scope before the member function definition.

7. Note: 
    - Even though the class member is hidden, it is still possible to use that member by qualifying the member’s name with the name of its class or by using the this pointer explicitly.
    - Even though the outer object is hidden, it is still possible to access that object by using the scope operator(::).

### static Class Members

1. Declaring static Members
    - We say a member is associated with the class by adding the keyword static to its declaration. Like any other member, static members can be public or private. The type of a static data member can be const, reference, array, class type, and so forth.
    - The static members of a class exist outside any object. Objects do not contain data associated with static data members.
    - static member functions are not bound to any object; they do not have a this pointer. As a result, static member functions may not be declared as const, and we may not refer to this in the body of a static member. 

2. Using a Class static Member
    - We can access a static member directly through the scope operator.
    - Even though static members are not part of the objects of its class, we can use an object, reference, or pointer of the class type to access a static member.
    - Member functions can use static members directly, without the scope operator.

3. Defining static Members
    - When we define a static member outside the class, we do not repeat the static keyword. The keyword appears only with the declaration inside the class body.
    - We may not initialize a static member inside the class. Instead, we must define and initialize each static data member outside the class body. 
    - Tip: The best way to ensure that the object is defined exactly once is to put the definition of static data members in the same file that contains the definitions of the class noninline member functions.

4. Advice: Even if a const static data member is initialized in the class body, that member ordinarily should be defined outside the class definition.

5. static Members Can Be Used in Ways Ordinary Members Can’t
    - As one example, a static data member can have incomplete type. In particular, a static data member can have the same type as the class type of which it is a member.
    - Another difference between static and ordinary members is that we can use a static member as a default argument.

### 疑问

1. static class members的实现原理？

