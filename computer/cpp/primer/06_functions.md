# 《C++ Primer》第6章学习笔记

## 6 Functions

### 6.1 Function Basics

1. Although we know which argument initializes which parameter, we have no guarantees about the order in which arguments are evaluated. The compiler is free to evaluate the arguments in whatever order it prefers.

2. In C++, names have scope, and objects have lifetimes. It is important to understand both of these concepts.
    - The scope of a name is the part of the program’s text in which that name is visible.
    - The lifetime of an object is the time during the program’s execution that the object exists.

3. parameters vs arguments
    - Parameters: Local variable declared inside the function parameter list. they are initialized by the arguments provided in the each function call.
    - Arguments: Values supplied in a function call that are used to initialize the function's parameters.

4. Automatic objects: The objects that correspond to ordinary local variables are created when the function’s control path passes through the variable’s definition. They are destroyed when control passes through the end of the block in which the variable is defined. Objects that exist only while a block is executing are known as automatic objects. 

5. Local static objects: It can be useful to have a local variable whose lifetime continues across calls to the function. We obtain such objects by defining a local variable as static. Each local static object is initialized before the first time execution passes through the object’s definition. Local statics are not destroyed when a function ends; they are destroyed when the program terminates.

### 6.2 Argument Passing

1. If the parameter is a reference, then the parameter is bound to its argument. Otherwise, the argument’s value is copied.

2. Advice: Programmers accustomed to programming in C often use pointer parameters to access objects outside a function. In C++, programmers generally use reference parameters instead.

3. It can be inefficient to copy objects of large class types or large containers. Moreover, some class types (including the IO types) cannot be copied. Functions must use reference parameters to operate on objects of a type that cannot be copied.

4. Advice: Reference parameters that are not changed inside a function should be references to const.

5. Using Reference Parameters to Return Additional Information.

6. The fact that ***top-level consts are ignored on a parameter*** has one possibly surprising implication: In C++, we can define several different functions that have the same name. However, we can do so only if their parameter lists are sufficiently different. Because top-level consts are ignored, we can pass exactly the same types to either version of fcn. The second version of fcn is an error. Despite appearances, its parameter list doesn’t differ from the list in the first version of fcn.
```
void fcn(const int i) { /* fcn can read but not write to i */ }
void fcn(int i) { /* . . . */ } // error: redefines fcn(int)
```

7. ***Use Reference to const When Possible.*** It is a somewhat common mistake to define parameters that a function does not change as (plain) references. Doing so gives the function’s caller the misleading impression that the function might change its argument’s value. Moreover, using a reference instead of a reference to const unduly limits the type of arguments that can be used with the function. As we’ve just seen, we cannot pass a const object, or a literal, or an object that requires conversion to a plain reference parameter.

8. Even though we cannot pass an array by value, we can write a parameter that looks like an array:
```
// despite appearances, these three declarations of print are equivalent
// each function has a single parameter of type const int*
void print(const int*);
void print(const int[]); // shows the intent that the function takes an array
void print(const int[10]); // dimension for documentation purposes (at best)
// The following declaration is different from them
void print(const int (&arr)[10]); // arr is a reference to an array of ten ints 
```

9. When you use the arguments in argv, remember that the optional arguments begin in argv[1]; argv[0] contains the program’s name, not user input.

10. Functions with varying parameters:
    - If all the arguments have the same type, we can pass a library type named ***initializer_list***. 
    - If the argument types vary, we can write a special kind of function, known as a ***variadic template***.
    - C++ also has a special parameter type, ***ellipsis***, that can be used to pass a varying number of arguments. It is worth noting that this facility ordinarily should be used only in programs that need to interface to C functions.

11. initializer_list:
    - Defined in the ***initializer_list*** header.
    - Unlike vector, ***the elements in an initializer_list are always const values***; there is no way to change the value of an element in an initializer_list.
    - When we pass a sequence of values to an initializer_list parameter, we must enclose the sequence in curly braces.
    - A function with an initializer_list parameter can have other parameters as well. 
    ```
    // Operations on initializer_lists
    initializer_list<T> lst;
    initializer_list<T> lst{a,b,c...};
    lst2(lst);  // Copying or assigning an initializer_list does not copy the elements in the list. After the copy, the original and the copy share the elements.
    lst2 = lst;
    lst.size()
    lst.begin()
    lst.end()
    ```

12. Ellipsis parameters
    - Warning: Ellipsis parameters should be used only for types that are common to both C and C++. In particular, objects of most class types are not copied properly when passed to an ellipsis parameter.
    - An ellipsis parameter may appear only as the last element in a parameter list and may take either of two forms:
    ```
    void foo(parm_list, ...);
    void foo(...);
    ```

### 6.3 Return Types and the return Statement

1. Warning: Failing to provide a return after a loop that contains a return is an error. However, many compilers will not detect such errors.

2. Never Return a Reference or Pointer to a Local Object.

3. The call operator has the same precedence as the dot and arrow operators. Like those operators, the call operator is left associative. As a result, if a function returns a pointer, reference or object of class type, we can use the result of a call to call a member of the resulting object.

4. Calls to functions that return references are lvalues; other return types yield rvalues. A call to a function that returns a reference can be used in the same ways as any other lvalue. In particular, we can assign to the result of a function that returns a reference to nonconst

5. Under the new standard, functions can return a braced list of values. As in any other return, the list is used to initialize the temporary that represents the function’s return. If the list is empty, that temporary is value initialized. Otherwise, the value of the return depends on the function’s return type.

6. There is one exception to the rule that a function with a return type other than void must return a value: The main function is allowed to terminate without a return. If control reaches the end of main and there is no return, then the compiler implicitly inserts a return of 0.

7. Define a function that returns a pointer to an array:
    - `Type (*function(parameter_list))[dimension]`, for example: `int (*func(int i))[10];`
    - use a type alias: `typedef int arrT[10]` or `using arrT = int[10];`
    - use a trailing return type: `auto func(int i) -> int(*)[10];`
    - use decltype

8. trailing return type: Trailing returns can be defined for any function, but are most useful for functions with complicated return types, such as pointers (or references) to arrays. A trailing return type follows the parameter list and is preceded by ->. To signal that the return follows the parameter list, we use auto where the return type ordinarily appears.

### 6.4 Overloaded Functions

1. Functions that have the same name but different parameter lists and that appear in the same scope are overloaded. Function overloading eliminates the need to invent—and remember—names that exist only to help the compiler figure out which function to call.

2. The main function may not be overloaded.

3. It is an error for two functions to differ only in terms of their return types. If the parameter lists of two functions match but the return types differ, then the second declaration is an error.

4. A parameter that has a top-level const is indistinguishable from one without a top-level const. On the other hand, we can overload based on whether the parameter is a reference (or pointer) to the const or nonconst version of a given type; such consts are low-level.

5. Although overloading lets us avoid having to invent (and remember) names for common operations, we should only overload operations that actually do similar things. There are some cases where providing different function names adds information that makes the program easier to understand.

6. For any given call to an overloaded function, there are three possible outcomes:
    - best match
    - no match
    - ambiguous call

7. ***Overloading has no special properties with respect to scope: As usual, if we declare a name in an inner scope, that name hides uses of that name declared in an outer scope. Names do not overload across scopes.***
```
string read();
void print(const string &);
void print(double); // overloads the print function
void fooBar(int ival)
{
    bool read = false; // new scope: hides the outer declaration of read
    string s = read(); // error: read is a bool variable, not a function
    // bad practice: usually it's a bad idea to declare functions at local scope
    void print(int); // new scope: hides previous instances of print
    print("Value: "); // error: print(const string &) is hidden
    print(ival); // ok: print(int) is visible
    print(3.14); // ok: calls print(int); print(double) is hidden
}
```

8. In C++, name lookup happens before type checking.

### 6.5 Features for Specialized Uses

1. A default argument is specified as an initializer for a parameter in the parameter list. We may define defaults for one or more parameters. However, if a parameter has a default argument, all the parameters that follow it must also have default arguments.

2. ***Arguments in the call are resolved by position. The default arguments are used for the trailing (right-most) arguments of a call. Part of the work of designing a function with default arguments is ordering the parameters so that those least likely to use a default value appear first and those most likely to use a default appear last.***

3. Each parameter can have its default specified only once in a given scope. Thus, any subsequent declaration can add a default only for a parameter that has not previously had a default specified.

4. Advice: Default arguments ordinarily should be specified with the function declaration in an appropriate header. (Note: ***Default arguments shouldn't be specified in the function definition, or it would cause compiling error.***)

5. Names used as default arguments are resolved in the scope of the function declaration. The value that those names represent is evaluated at the time of the call.

6. Note: ***The inline specification is only a request to the compiler. The compiler may choose to ignore this request.***

7. constexpr function
    - A constexpr function is a function that can be used in a constant expression. A constexpr function is defined like any other function but must meet certain restrictions: The return type and the type of each parameter in a must be a literal type, and the function body must contain exactly one return statement.
    - A constexpr function is not required to return a constant expression.
    - Advice: Put inline and constexpr Functions in Header Files.

8. `assert(expr);` evaluates expr and if the expression is false (i.e., zero), then assert writes a message and terminates the program. If the expression is true (i.e., is nonzero), then assert does nothing. The assert macro is defined in the cassert header. 

9. ***NDEBUG***
    - The behavior of assert depends on the status of a preprocessor variable named NDEBUG. If NDEBUG is defined, assert does nothing. By default, NDEBUG is not defined, so, by default, assert performs a run-time check.
    - We can “turn off” debugging by providing a #define to define NDEBUG. Alternatively, most compilers provide a command-line option that lets us define preprocessor variables: `$ CC -D NDEBUG main.C # use /D with the Microsoft compiler` has the same effect as writing #define NDEBUG at the beginning of main.C.
    - In addition to using assert, we can write our own conditional debugging code using NDEBUG. If NDEBUG is not defined, the code between the #ifndef and the #endif is executed. If NDEBUG is defined, that code is ignored:
    ```
    void print(const int ia[], size_t size)
    {
        #ifndef NDEBUG
        cerr << __func__ << ": array size is " << size << endl;
        #endif
    }
    ```

10. In addition to \_\_func\_\_, which the C++ compiler defines, the preprocessor
defines four other names that can be useful in debugging:
    - \_\_FILE\_\_ string literal containing the name of the file
    - \_\_LINE\_\_ integer literal containing the current line number
    - \_\_TIME\_\_ string literal containing the time the file was compiled
    - \_\_DATE\_\_ string literal containing the date the file was compiled

### 6.6 Function Matching

1. ***Steps of Function Matching***
    - Find candidate functions: name matches
    - Find viable functions: parameters' number matches
    - type matches: match exactly or there is a conversion from the argument type to the type of the parameter.
    - find the best match. The closer the types of the argument and parameter are to each other, the better the match. Therefore, An exact match is better than a match that requires a conversion.

2. Advice: Casts should not be needed to call an overloaded function. The need for a cast suggests that the parameter sets are designed poorly.

3. In order to determine the best match, the compiler ranks the conversions that could be used to convert each argument to the type of its corresponding parameter. ***Conversions are ranked as follows:***
    - An exact match. An exact match happens when:
        - The argument and parameter types are identical.
        - The argument is converted from an array or function type to the corresponding pointer type.
        - A top-level const is added to or discarded from the argument.
    - Match through a const conversion.
    - Match through a promotion.
    - Match through an arithmetic or pointer conversion.
    - Match through a class-type conversion.

4. ***Matches Requiring Promotion or Arithmetic Conversion***
    - The small integral types always promote to int or to a larger integral type. 
    ```
    void ff(int);
    void ff(short);
    ff('a'); // char promotes to int; calls f(int)
    ```
    - All the arithmetic conversions are treated as equivalent to each other. The conversion from int to unsigned int, for example, does not take precedence over the conversion from int to double.
    ```
    void manip(long);
    void manip(float);
    manip(3.14); // error: ambiguous call
    ```

5. When we call an overloaded function that differs on whether a reference or pointer parameter refers or points to const, the compiler uses the constness of the argument to decide which function to call:
```
Record lookup(Account&); // function that takes a reference to Account
Record lookup(const Account&); // new function that takes a const reference
const Account a;
Account b;
lookup(a); // calls lookup(const Account&)
lookup(b); // calls lookup(Account&)
```

### 6.7 Pointers to Functions

1. Function Pointers:
    - When we use the name of a function as a value, the function is automatically converted to a pointer. For example, we can assign the address of lengthCompare to pf as follows:
    ```
    pf = lengthCompare; // pf now points to the function named lengthCompare
    pf = &lengthCompare; // equivalent assignment: address-of operator is optional
    ```
    - We can use a pointer to a function to call the function to which the pointer points. We can do so directly—there is no need to dereference the pointer:
    ```
    bool b1 = pf("hello", "goodbye"); // calls lengthCompare
    bool b2 = (*pf)("hello", "goodbye"); // equivalent call
    bool b3 = lengthCompare("hello", "goodbye"); // equivalent call
    ```

2. Function Pointer Parameters:
    - When we pass a function as an argument, we can do so directly. It will be automatically converted to a pointer.
    - decltype returns the function type; the automatic conversion to pointer is not done. If we want a pointer we must add the * ourselves.

3. Returning a Pointer to Function:  we must write the return type as a pointer type; the compiler will not automatically treat a function return type as the corresponding pointer type. By far the easiest way to declare a function that returns a pointer to function is by using a type alias:
```
using F = int(int*, int); // F is a function type, not a pointer
using PF = int(*)(int*, int); // PF is a pointer type
PF f1(int); // ok: PF is a pointer to function; f1 returns a pointer to function
F f1(int); // error: F is a function type; f1 can't return a function
F *f1(int); // ok: explicitly specify that the return type is a pointer to function
```
