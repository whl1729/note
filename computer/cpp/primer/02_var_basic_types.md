# 《C++ Primer》第2章阅读笔记

## 2 Variables and basic types

1.  Some languages, such as Smalltalk and Python, check types at run time. In contrast, C++ is a statically typed language; type checking is done at compile time.

### 2.1 Primitive Built-in Types

1. The character types—wchar_t, char16_t, and char32_t—are used for extended character sets. The wchar_t type is guaranteed to be large enough to hold any character in the machine’s largest extended character set. The types char16_t and char32_t are intended for Unicode characters. (Unicode is a standard for representing characters used in essentially any natural language.)

2. Typically, floats are represented in one word (32 bits), doubles in two words (64 bits), and ***long doubles in either three or four words (96 or 128 bits).***

3. linux中C++头文件路径：/usr/include/c++.

4. Attention: The minimum size of int is 16 bits.

5. Advice: Avoid Undefined and Implementation-Defined Behavior, such as assuming that the size of an int is a fixed and known value. Such programs are said to be nonportable. 

6. signed and unsigned
    - don't mix signed and unsigned types, since signed values are automatically converted to unsigned.
    - if we use both unsigned and int values in an arithmetic expression, the int value ordinarily is converted to unsigned. Converting an int to unsigned executes the same way as if we assigned the int to an unsigned

7. ***The type of an integer and floating-point literal: (first fit)***
    - By default, decimal literals are signed whereas octal and hexadecimal literals can be either signed or unsigned types.
    - By default, floating-point literals have type double. 
    - A decimal literal has the smallest type of int, long, or long long (i.e., the first type in this list) in which the literal’s value fits. Octal and hexadecimal literals have the smallest type of int, unsigned int, long, unsigned long, long long, or unsigned long long in which the literal’s value fits. 
    - Floating-point literals include either a decimal point or an exponent specified using scientific notation. Using scientific notation, the exponent is indicated by either E or e.
    - It is an error to use a literal that is too large to fit in the largest related type. There are no literals of type short. 
    - we can override these defaults by using a suffix.

8. ***Specifying the type of a literal***
    - prefix
        - u: char16_t, Unicode 16 character
        - U: char32_t, Unicode 32 character
        - L: wchar_t, wide character
        - u8: char, utf-8( string literals only)
    - suffix
        - u or U: unsigned
        - l or L: long or long double, depending on whether it's integral
        - ll or LL: long long
        - f or F: float
        - UL: unsigned long or unsigned long long, depending on whether its value fits in unsigned long

9. Advice: ***When you write a long literal, use the uppercase L***; the lowercase letter l is too easily mistaken for the digit 1.

10. hexadecimal and octal digits to represent character
    - We can write a generalized escape sequence, which is \x followed by one or more hexadecimal digits or a \ followed by one, two, or three octal digits. The value represents the numerical value of the character. For example, both "\115" and "\x4d" mean the character 'M'.
    - Note that if a \ is followed by more than three octal digits, only the first three are associated with the \. For example, "\1234" represents two characters: the character represented by the octal value 123 and the character 4. In contrast, \x uses up all the hex digits following it; "\x1234" represents a single, 16-bit character composed from the bits corresponding to these four hexadecimal digits. 

### 2.2 Variables

1. ***Initialization is not assignment.*** Initialization happens when a variable is given a value when it is created. Assignment obliterates an object’s current value and replaces that value with a new one.

2. Four ways to define a int variable and initialize it to 0 is as following. The generalized use of curly braces for initialization is referred to ***list initialization***.
```
int units_sold = 0;
int units_sold = {0};
int units_sold{0};
int units_sold(0);
```

3. ***The compiler will not let us list initialize variables of built-in type if the initializer might lead to the loss of information***:
```
long double ld = 3.1415926536;
int a{ld}, b = {ld}; // error: narrowing conversion required
int c(ld), d = ld; // ok: but value will be truncated
```

4. Default initialization
    - The value of an object of built-in type that is not explicitly initialized depends on ***where it is defined***. Variables defined outside any function body are initialized to zero. With one exception, variables of built-in type defined inside a function are uninitialized. The value of an uninitialized variable of built-in type is undefined. It is an error to copy or otherwise try to access the value of a variable whose value is undefined
    - The exception: Automatic objects corresponding to local variables are initialized if their definition contains an initializer. 
    - Most classes let us define objects without explicit initializers. Such classes supply an appropriate default value for us. For example, the library string class says that if we do not supply an initializer, then the resulting string is the empty string.
    - Uninitialized objects of built-in type defined inside a function body have undefined value. Objects of class type that we do not explicitly initialize have a value that is defined by the class.
    - We recommend initializing every object of built-in type. It is not always necessary, but it is easier and safer to provide an initializer until you can be certain it is safe to omit the initializer.

5. ***declarations vs definitions***
    - A declaration makes a name known to the program. A file that wants to use a name defined elsewhere includes a declaration for that name. A definition creates the associated entity.
    - Any declaration that includes an explicit initializer is a definition. We can provide an initializer on a variable defined as extern, but doing so overrides the extern. An extern that has an initializer is a definition.
    - It is an error to provide an initializer on an extern inside a function.
    - Variables must be defined exactly once but can be declared many times.
```
// world.c
int a = 20;

// hello.c
extern int a = 30;

int main()
{
    std::cout << a << std::endl;  // output: 30
}
```

6. identifiers
    - Identifiers in C++ can be composed of letters, digits, and the underscore character. (Attentions: Identifiers cannot contains '-')
    - C++ imposes no limit on name length. 
    - Identifiers must begin with either a letter or an underscore. 
    - Identifiers are case-sensitive; upper- and lowercase letters are distinct.
    - Identifiers can not begin with an underscore followed immediately by an uppercase letter. 
    - Identifiers defined outside a function may not begin with an underscore.
    
7. Conventions for Variable names
    - An identifier should give some indication of its meaning.
    - Variable names normally are lowercase—index, not Index or INDEX.
    - Like Sales_item, classes we define usually begin with an uppercase letter.
    - Identifiers with multiple words should visually distinguish each word, for example, student_loan or studentLoan, not studentloan.

8. Advice: Define Variables Where You First Use Them
    - Doing so improves readability by making it easy to find the definition of the variable. 
    - More importantly, it is often easier to give the variable a useful initial value when the variable is defined close to where it is first used.

9. Warning: It is almost always a bad idea to define a local variable with the same name as a global variable that the function uses or might use.
```
int reused = 42; // reused has global scope

int main()
{
    // output #1: uses global reused; prints 42
    std::cout << reused << std::endl;

    int reused = 0; // new, local object named reused hides global reused

    // output #2: uses local reused; prints 0 
    std::cout << reused << std::endl;

    // output #3: explicitly requests the global reused; prints 42
    std::cout << ::reused << std::endl;

    return 0;
}
```

### 2.3 Compound Types

1. References
    - A reference is not an object. Instead, a reference is just another name for an already existing object.
    - Once initialized, a reference remains bound to its initial object. There is no way to rebind a reference to refer to a different object. Therefore, references must be initialized.
    - ***We can define multiple references in a single definition. Each identifier that is a reference must be preceded by the & symbol***.
    - The type of a reference and the object to which the reference refers must match exactly, with ***two exceptions***:
        - we can initialize a reference to const from any expression that can be converted to the type of the reference. In particular, we can bind a reference to const to a nonconst object, a literal, or a more general expression.
        - We can bind a pointer or reference to a base-class type to an object of a type derived from that base class.

2. Some Symbols Have Multiple Meanings: In declarations, & and * are used to form compound types. In expressions, these same symbols are used to denote an operator. Because the same symbol is used with very different meanings, it can be helpful to ignore appearances and think of them as if they were different symbols.

3. null pointer
    - nullptr is a literal that has a special type that can be converted to any other pointer type. 
    - initializing a pointer to NULL is equivalent to initializing it to 0. ***Modern C++ programs generally should avoid using NULL and use nullptr instead.***

4. Advice: ***Initialize all Pointers.*** If possible, define a pointer only after the object to which it should point has been defined. If there is no object to bind to a pointer, then initialize the pointer to nullptr or zero. That way, the program can detect that the pointer does not point to an object.

5. ***references vs pointers***
    - A pointer can be re-assigned any number of times while a reference cannot be re-assigned after binding.
    - Pointers can point nowhere (NULL), whereas a reference always refers to an object.
    - You can't take the address of a reference like you can with pointers, because a reference is not an object.
    - There's no "reference arithmetic" (but you can take the address of an object pointed by a reference and do pointer arithmetic on it as in &obj + 5).
    - [differences between a pointer and a reference in C++?](https://stackoverflow.com/questions/57483/what-are-the-differences-between-a-pointer-variable-and-a-reference-variable-in)

6. pointers' equality: Two pointers hold the same address (i.e., are equal) if they are both null, if they address the same object, or if they are both pointers one past the same object. 

7. compound type declarations: 
    - ***Type modifier(\* or &) applies to the variables near to it, it says nothing about any other objects that might be declared in the same statements.***`int* p1, p2; // p1 is a pointer to int; p2 is an int`
    - The easiest way to understand these declarations is to read them ***from right to left***. eg: The symbol closest to the name of the variable r(in this case the & in &r) is the one that has the most immediate effect on the variable’s type. 
    ```
    int *p; // p is a pointer to int
    int *&r = p; // r is a reference to the pointer p
    ```

### 2.4 const Qualifier

1. const
    - ***By Default, const Objects Are Local to a File.*** To share a const object among multiple files, you must define the variable as extern.
    - A reference to const cannot be used to change the object to which the reference is bound. 
    ```
    const int ci = 1024;
    const int &r1 = ci; // ok: both reference and underlying object are const
    r1 = 42; // error: r1 is a reference to const
    int &r2 = ci; // error: non const reference to a const object
    int *p1 = &ci; // error: invalid conversion from const int* to int*
    ```
    - ***We can initialize a reference to const from any expression that can be converted to the type of the reference.*** In particular, we can bind a reference to const to a nonconst object, a literal, or a more general expression
    - A Reference to const May Refer to an Object That Is Not const. ***It is important to realize that a reference to const restricts only what we can do through that reference. Binding a reference to const to an object says nothing about whether the underlying object itself is const***.  
    - we can use a pointer to const to point to a nonconst object, a pointer to const says nothing about whether the object to which the pointer points is const. Defining a pointer as a pointer to const affects only what we can do with the pointer. 

2. ***top-level const***
    - top-level const indicates that an object itself is const. Top-level const can appear in any object type, i.e., one of the built-in arithmetic types, a class type, or a pointer type. Low-level const appears in the base type of compound types such as pointers or references. 
    - When we copy an object, top-level consts are ignored. On the other hand, low-level const is never ignored. When we copy an object, both objects must have the same low-level const qualification or there must be a conversion between the types of the two objects. In general, we can convert a nonconst to const but not the other way round.
    
3. ***constexpr variable***
    - We can ask the compiler to verify that a variable is a constant expression by declaring the variable in a constexpr declaration. Variables declared as constexpr are implicitly const and must be initialized by constant expressions.
    - Generally, it is a good idea to use constexpr for variables that you intend to use as constant expressions.
    - when we define a pointer in a constexpr declaration, the constexpr specifier applies to the pointer, not the type to which the pointer points.

### 2.5 Dealing with Types

1. type alias
    - `typedef double wages`
    - `using SI = Sales_item;`
    - ***pointers, const, and type aliases***: The base type of the following declaration is const pstring. As usual, a const that appears in the base type modifies the given type. The type of pstring is “pointer to char.” So, const pstring is a constant pointer to char—not a pointer to const char.
    ```
    typedef char *pstring;
    const pstring cstr = 0; // cstr is a constant pointer to char, not a pointer to constant char
    const pstring *ps; // ps is a pointer to a constant pointer to char
    ```

2. ***auto***
    - auto tells the compiler to deduce the type from the initializer. By implication, a variable that uses auto as its type specifier must have an initializer.
    - auto ordinarily ignores top-level consts. As usual in initializations, low-level consts, such as when an initializer is a pointer to const, are kept. If we want the deduced type to have a top-level const, we must say so explicitly.
    - When we ask for a reference to an auto-deduced type, top-level consts in the initializer are not ignored. As usual, consts are not top-level when we bind a reference to an initializer.
```
auto &h = 42; // error: we can't bind a plain reference to a literal
// error: type deduced from i is int; type deduced from &ci is const int
auto &n = i, *p2 = &ci;

auto &g = ci; // g is a const int& that is bound to ci
auto &h = 42; // error: we can't bind a plain reference to a literal
const auto &j = 42; // ok: we can bind a const reference to a literal
```

3. ***decltype***
    - Sometimes we want to define a variable with a type that the compiler deduces from an expression but do not want to use that expression to initialize the variable. For such cases, the new standard introduced a second type specifier, decltype, which returns the type of its operand. The compiler analyzes the expression to determine its type but does not evaluate the expression.
    - When the expression to which we apply decltype is a variable, decltype returns the type of that variable, including top-level const and references.
    - It is worth noting that decltype is the only context in which a variable defined as a reference is not treated as a synonym for the object to which it refers.
    - The dereference operator is an example of an expression for which decltype returns a reference. As we’ve seen, when we dereference a pointer, we get the object to which the pointer points. Moreover, we can assign to that object. Thus, the type deduced by decltype(\*p) is int&, not plain int.
    - Assignment is another example of an expression that yields a reference type. The type is a reference to the type of the left-hand operand. That is, if i is an int, then the type of the expression `i = x` is int&.
    - `decltype((variable)) (note, double parentheses)` is always a reference type, but decltype(variable) is a reference type only if variable is a reference.
    ```
    // decltype of a parenthesized variable is always a reference
    decltype((i)) d;  // error: d is int& and must be initialized
    decltype(i) e;    // ok: e is an (uninitialized) int
    ```

### 2.6 Defining Our Own Data Structures

1. Warning: It is a common mistake among new programmers to forget the semicolon at the end of a class definition.

2. ***in-class identifier***
    - Under the new standard, we can supply an in-class initializer for a data member. When we create objects, the in-class initializers will be used to initialize the data members. Members without an initializer are default initialized.
    - In-class initializers are restricted as to the form we can use: They must either be enclosed inside curly braces or follow an = sign. We may not specify an in-class initializer inside parentheses.

3. header
    - Whenever a header is updated, the source files that use that header must be recompiled to get the new or changed declarations.
    - Preprocessor variable names do not respect C++ scoping rules. Preprocessor variables, including names of header guards, must be unique throughout the program. 
    - Headers should have guards, even if they aren’t (yet) included by another header. Header guards are trivial to write, and by habitually defining them you don’t need to decide whether they are needed.
