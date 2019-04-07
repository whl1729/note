# 《C++ Primer》第18章学习笔记

## 18 Tools for Large Programs

### Exception Handing

1. The type of the thrown expression, together with the current call chain, determines which handler will deal with the exception. The selected handler is the one nearest in the call chain that matches the type of the thrown object. The type and contents of that object allow the throwing part of the program to inform the handling part about what went wrong.

2. The fact that control passes from one location to another has two important implications:
    - Functions along the call chain may be prematurely exited.
    - When a handler is entered, objects created along the call chain will have been destroyed.

3. Because the statements following a throw are not executed, a throw is like a return: It is usually part of a conditional statement or is the last (or only) statement in a function.

4. Stack Unwinding
    - 根据调用栈和try block的嵌套顺序，由里而外地搜索各函数的各个try block，当找到第一个合适的try block后停止。
    - When the catch completes, execution continues at the point immediately after the last catch clause associated with that try block.
    - If no matching catch is found, the program is exited by calling the library terminate function.

5. Objects Are Automatically Destroyed during Stack Unwinding
    - When a block is exited during stack unwinding, the compiler guarantees that objects created in that block are properly destroyed. 
    - If a local object is of class type, the destructor for that object is called automatically. 
    - The objects will be properly destroyed even if an exception occurs in a constructor or during initialization of the elements of an array or a library container type.
    - Warning: The memory dynamically allocated using new will not be freed automatically!

6. Warning: During stack unwinding, destructors are run on local objects of class type. Because destructors are run automatically, they should not throw. If, during stack unwinding, a destructor throws an exception that it does not also catch, the program will be terminated.

7. It is almost certainly an error to throw a pointer to a local object. It is an error for the same reasons that it is an error to return a pointer to a local object from a function. If the pointer points to an object in a block that is exited before the catch, then that local object will have been destroyed before the catch.

8. When we throw an expression, the static, compile-time type of that expression determines the type of the exception object. If a throw expression dereferences a pointer to a base-class type, and that pointer points to a derived-type object, then the thrown object is sliced down; only the base-class part is thrown.

9. 异常声明中的参数遵循普通的参数传递规则：值传递、引用传递、derived-to-base.

10. Ordinarily, a catch that takes an exception of a type related by inheritance ought to define its parameter as a reference.

11. Finding a Matching Handler
    - The selected catch is the first one that matches the exception at all. 
    - As a consequence, in a list of catch clauses, the most specialized catch must appear first. 
    - Programs that use exceptions from an inheritance hierarchy must order their catch clauses so that handlers for a derived type occur before a catch for its base type. 

12. The types of the exception and the catch declaration must match exactly with only a few possible differences:
    - Conversions from nonconst to const are allowed. That is, a throw of a nonconst object can match a catch specified to take a reference to const.
    - Conversions from derived type to base type are allowed.
    - An array is converted to a pointer to the type of the array; a function is converted to the appropriate pointer to function type.

13. Rethrow
    - A catch passes its exception out to another catch by rethrowing the exception. A rethrow is a throw that is not followed by an expression.
    - An empty throw can appear only in a catch or in a function called (directly or indirectly) from a catch. If an empty throw is encountered when a handler is not active, terminate is called.

14. The Catch-All Handler
    - To catch all exceptions, we use catch-all handlers, which have the form catch(...). A catch-all clause matches any type of exception. 
    - A catch(...) is often used in combination with a rethrow expression. The catch does whatever local work can be done and then rethrows the exception. 
    - If a catch(...) is used in combination with other catch clauses, it must be last. Any catch that follows a catch-all can never be matched.

15. The only way for a constructor to handle an exception from a constructor initializer is to write the constructor as a function try block.
```
template <typename T>
Blob<T>::Blob(std::initializer_list<T> il) try :
              data(std::make_shared<std::vector<T>>(il)) {
        /* empty body */
} catch(const std::bad_alloc &e) { handle_out_of_memory(e); }
```

16. Providing a noexcept specification
    - The noexcept specifier must appear on all of the declarations and the corresponding definition of a function or on none of them. 
    - The specifier precedes a trailing return. 
    - It may not appear in a typedef or type alias. 
    - In a member function the noexcept specifier follows any const or reference qualifiers, and it precedes final, override, or = 0 on a virtual function.
    - The compiler in general cannot, and does not, verify exception specifications at compile time.
    - noexcept should be used in two cases: if we are confident that the function won’t throw, and/or if we don’t know what we’d do to handle the error anyway.

17. A function that is designated by throw() promises not to throw any exceptions:
```
void recoup(int) noexcept; // recoup doesn't throw
void recoup(int) throw(); // equivalent declaration
```

18. The noexcept specifier takes an optional argument that must be convertible to bool: If the argument is true, then the function won’t throw; if the argument is false, then the function might throw:
```
void recoup(int) noexcept(true); // recoup won't throw
void alloc(int) noexcept(false); // alloc can throw
```
19. noexcept has two meanings: It is an exception specifier when it follows a function’s parameter list, and it is an operator that is often used as the bool argument to a noexcept exception specifier.

20. More generally, `noexcept(e)` is true if all the functions called by e have nonthrowing specifications and e itself does not contain a throw. Otherwise, noexcept(e) returns false.

21. Exception Specifications and Pointers, Virtuals, and Copy Control
    - If we declare a pointer that has a nonthrowing exception specification, we can use that pointer only to point to similarly qualified functions. A pointer that specifies (explicitly or implicitly) that it might throw can point to any function, even if that function includes a promise not to throw. 
    - If a virtual function includes a promise not to throw, the inherited virtuals must also promise not to throw. On the other hand, if the base allows exceptions, it is okay for the derived functions to be more restrictive and promise not to throw.
    - When the compiler synthesizes the copy-control members, it generates an exception specification for the synthesized member. If all the corresponding operation for all the members and base classes promise not to throw, then the synthesized member is noexcept. If any function invoked by the synthesized member can throw, then the synthesized member is noexcept(false).

22. exception
    |__ bad_alloc
    |__ bad_cast
    |__ logic_error
    |       |__ domain_error
    |       |__ invalid_argument
    |       |__ out_of_range
    |       |__ length_error
    |
    |__ runtime_error
            |__ overflow_error
            |__ underflow_error
            |__ range_error

23. The exception, bad_cast, and bad_alloc classes also define a default constructor. The runtime_error and logic_error classes do not have a default constructor but do have constructors that take a C-style character string or a library string argument. Those arguments are intended to give additional information about the error.

### Namespaces

1. Libraries that put names into the global namespace are said to cause namespace pollution.

2. Any declaration that can appear at global scope can be put into a namespace: classes, variables (with their initializations), functions (with their definitions), templates, and other namespaces.

3. Note:
    - A namespace scope does not end with a semicolon.
    - We do not put a #include inside the namespace.

4. Namespaces Can Be Discontiguous
    - A namespace can be defined in several parts. Writing a namespace definition either defines a new namespace named nsp or adds to an existing one. If the name nsp does not refer to a previously defined namespace, then a new namespace with that name is created. Otherwise, this definition opens an existing namespace and adds declarations to that already existing namespace. 
    - Namespaces that define multiple, unrelated types should use separate files to represent each type (or each collection of related types) that the namespace defines.

5. Template specializations must be defined in the same namespace that contains the original template.

6. The Global Namespace
    - Names defined at global scope (i.e., names declared outside any class, function, or namespace) are defined inside the global namespace. The global namespace is implicitly declared and exists in every program. 
    - The notation ::member_name refers to a member of the global namespace. 

7. Nested namespace names follow the normal rules: 
    - Names declared in an inner namespace hide declarations of the same name in an outer namespace. 
    - Names defined inside a nested namespace are local to that inner namespace. 
    - Code in the outer parts of the enclosing namespace may refer to a name in a nested namespace only through its qualified name.

8. Inline Namespace
    - Names in an inline namespace can be used as if they were direct members of the enclosing namespace.
    - Inline namespaces are often used when code changes from one release of an application to the next. 

9. Unnamed Namespaces
    - An unnamed namespace is the keyword namespace followed immediately by a block of declarations delimited by curly braces. 
    - Unlike other namespaces, an unnamed namespace is local to a particular file and never spans multiple files.
    - If an unnamed namespace is defined at the outermost scope in the file, then names in the unnamed namespace must differ from names defined at global scope.
    - [Why are unnamed namespaces used and what are their benefits?](https://stackoverflow.com/questions/357404/why-are-unnamed-namespaces-used-and-what-are-their-benefits): This is the same as the C way of having a static global variable or static function but it can be used for class definitions as well.

10. Namespace Aliases: `namespace primer = cplusplus_primer;`

11. using Declarations
    - A using declaration introduces only one namespace member at a time.
    - A using declaration can appear in global, local, namespace, or class scope. In class scope, such declarations may only refer to a base class member.

12. using Directives
    - A using directive begins with the keyword using, followed by the keyword namespace, followed by a namespace name. 
    - A using directive injectes all the names from a namespace
    - Warning: Providing a using directive for namespaces, such as std, that our application does not control reintroduces all the name collision problems inherent in using multiple libraries.

13. Ordinarily, headers should define only the names that are part of its interface, not names used in its own implementation. As a result, header files should not contain using directives or using declarations except inside functions or namespaces.

14. Caution: Avoid using Directives
    - Rather than relying on a using directive, it is better to use a using declaration for each namespace name used in the program. Doing so reduces the number of names injected into the namespace. Ambiguity errors caused by using declarations are detected at the point of declaration, not use, and so are easier to find and fix.
    - One place where using directives are useful is in the implementation files of the namespace itself.

15. Classes, Namespaces, and Scope
    - Only names that have been declared before the point of use that are in blocks that are still open are considered.
    - When a name is used by a member function, look for that name in the member first, then within the class (including base classes), then look in the enclosing scopes, one or more of which might be a namespace.
    - The order in which scopes are examined to find a name can be inferred from the qualified name of a function. The qualified name indicates, in reverse order, the scopes that are searched.

16. Argument-Dependent Lookup and Parameters of Class Type
    - Q: Why can we write "std::cin >> s" without an std:: qualifier ?
    - A: When we pass an object of a class type to a function, the compiler searches the namespace in which the argument’s class is defined in addition to the normal scope lookup. 

17. Name collisions with move (and forward) are more likely than collisions with other library functions. So we suggest always using the fully qualified versions of these names: `std::move` and `srd::forward` 

18. Argument-Dependent Lookup and Overloading: Each namespace that defines a class used as an argument (and those that define its base classes) is searched for candidate functions. Any functions in those namespaces that have the same name as the called function are added to the candidate set. These functions are added even though they otherwise are not visible at the point of the call.

19. Overloading and using Declarations
    - A using declaration declares a name, not a specific function: When we write a using declaration for a function, all the versions of that function are brought into the current scope.
    - The using declaration defines additional overloaded instances of the given name. The effect is to increase the set of candidate functions.

20. Overloading and using Directives: Differently from how using declarations work, it is not an error if a using directive introduces a function that has the same parameters as an existing function. As with other conflicts generated by using directives, there is no problem unless we try to call the function without specifying whether we want the one from the namespace or from the current scope.

### Multiple and Virtual Inheritance

1. The order in which base classes are constructed depends on the order in which they appear in the class derivation list. The order in which they appear in the constructor initializer list is irrelevant. 

2. A derived class can inherit its constructors from one or more of its base classes. It is an error to inherit the same constructor (i.e., one with the same parameter list) from more than one base class.

3. Destructors are always invoked in the reverse order from which the constructors are run.

4. Classes with multiple bases that define their own copy/move constructors and assignment operators must copy, move, or assign the whole object. The base parts of a multiply derived class are automatically copied, moved, or assigned only if the derived class uses the synthesized versions of these members. 

5. Conversions and Multiple Base Classes
    - A pointer or reference to any of an object’s (accessible) base classes can be used to point or refer to a derived object. 
    - A Base class generally define a virtual destructor. The destructor is run when we delete a pointer to a dynamically allocated object. If that pointer points to a type in an inheritance hierarchy, it is possible that the static type of the pointer might differ from the dynamic type of the object being destroyed.
    - The compiler makes no attempt to distinguish between base classes in terms of a derived-class conversion. Converting to each base class is equally good.
    - As with single inheritance, the static type of the object, pointer, or reference determines which members we can use. 这意味着：假设我们用基类Base的指针pb指向派生类Derived，那么通过pb能够调用Derived类对Base类的虚函数进行override后的函数，但不能调用Derived类新定义的函数。

6. Class Scope under Multiple Inheritance
    - Under multiple inheritance, the same lookup happens simultaneously among all the direct base classes. If a name is found through more than one base class, then use of that name is ambiguous.
    - It is perfectly legal for a class to inherit multiple members with the same name. However, if we want to use that name, we must specify which version we want to use.
    - 即使函数参数列表不同、即使访问权限不同、即使出现在非直接基类，通过派生类调用多个基类均定义的函数会存在二义性问题。
    - The best way to avoid potential ambiguities is to define a version of the function in the derived class that resolves the ambiguity. 

7. Although the derivation list of a class may not include the same base class more than once, a class can inherit from the same base class more than once. It might inherit the same base indirectly from two of its own direct base classes, or it might inherit a particular class directly and indirectly through another of its base classes.

8. **Virtual inheritance** lets a class specify that it is willing to share its base class. The shared base-class subobject is called a virtual base class. Regardless of how often the same virtual base appears in an inheritance hierarchy, the derived object contains only one, shared subobject for that virtual base class.

9. Virtual derivation affects the classes that subsequently derive from a class with a virtual base; it doesn’t affect the derived class itself.

10. We specify that a base class is virtual by including the keyword virtual in the derivation list. The order of the keywords public and virtual is not significant.

11. If a member from the virtual base is overridden along only one derivation path, then that overridden member can still be accessed directly. If the member is overridden by more than one base, then the derived class generally must define its own version as well.

12. In a virtual derivation, the virtual base is initialized by the most derived constructor.

13. Virtual base classes are always constructed prior to nonvirtual base classes regardless of where they appear in the inheritance hierarchy.  Once the virtual base subparts of the object are constructed, the direct base subparts are constructed in the order in which they appear in the derivation list.

14. Constructor and Destructor Order for Virtual Inheritance
    - A class can have more than one virtual base class. In that case, the virtual subobjects are constructed in left-to-right order as they appear in the derivation list. 
    - The same order is used in the synthesized copy and move constructors, and members are assigned in this order in the synthesized assignment operators.
    - As usual, an object is destroyed in reverse order from which it was constructed.
