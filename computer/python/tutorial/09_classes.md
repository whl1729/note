# The Python Tutorial

## 9 Classes

1. Compared with other programming languages, Python’s class mechanism adds classes with a minimum of new syntax and semantics. It is a mixture of the class mechanisms found in C++ and Modula-3.

2. Python classes provide all the standard features of Object Oriented Programming:
    - the class inheritance mechanism allows multiple base classes,
    - a derived class can override any methods of its base class or classes,
    - and a method can call the method of a base class with the same name.
    - Objects can contain arbitrary amounts and kinds of data.
    - As is true for modules, classes partake of the dynamic nature of Python: they are created at runtime, and can be modified further after creation.

3. Unlike C++ and Modula-3, built-in types can be used as base classes for extension by the user.
    - Question: How to use built-in types as base classes for extension?

4. Also, like in C++, most built-in operators with special syntax (arithmetic operators, subscripting etc.) can be redefined for class instances.

### 9.1. A Word About Names and Objects

1. Objects have individuality, and multiple names (in multiple scopes) can be bound to the same object. This is known as **aliasing** in other languages.
    - Question: 不是很理解aliasing的含义？是指：Python中赋值或传参时一般是拷贝地址吗？

2. Aliasing has a possibly surprising effect on the semantics of Python code involving mutable objects such as lists, dictionaries, and most other types. This is usually used to the benefit of the program, since aliases behave like pointers in some respects. For example, passing an object is cheap since only a pointer is passed by the implementation; and if a function modifies an object passed as an argument, the caller will see the change — this eliminates the need for two different argument passing mechanisms as in Pascal.

