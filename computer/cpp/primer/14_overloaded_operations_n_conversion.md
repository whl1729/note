# 《C++ Primer》第14章学习笔记

## 14 Overloaded Operations and Conversions

### 14.1 Basic Concepts

1. ***Except for the overloaded function-call operator, operator(), an overloaded operator may not have default arguments.***

2. When an overloaded operator is a member function, this is bound to the left-hand operand. Member operator functions have one less (explicit) parameter than the number of operands.

3. An operator function must either be a member of a class or have at least one parameter of class type. This restriction means that we cannot change the meaning of an operator when applied to operands of built-in type.
```
// error: cannot redefine the built-in operator for ints
int operator+(int, int);
```

4. ***What we cannot overload***
    - We can overload most, but not all, of the operators.Operators That Cannot Be Overloaded: `::  .*  . ?:`
    - We can overload only existing operators and cannot invent new operator symbols.
    - Ordinarily, the comma, address-of, logical AND, and logical OR operators should not be overloaded. The operand-evaluation guarantees of the logical AND, logical OR, and comma operators are not preserved. Moreover, overloaded versions of && or || operators do not preserve short-circuit evaluation properties of the built-in operators. Both operands are always evaluated.

5. Four symbols (+, -, \*, and &) serve as both unary and binary operators. Either or both of these operators can be overloaded. The number of parameters determines which operator is being defined.

6. ***An overloaded operator has the same precedence and associativity as the corresponding built-in operator.***

7. If a class has an arithmetic or bitwise operator, then it is usually a good idea to provide the corresponding compound-assignment operator as well. 

8. ***Choosing Member or Nonmember Implementation***
    - The assignment (=), subscript ([]), call (()), and member access arrow (->) operators must be defined as members.（伍注：为什么？）
    - The compound-assignment operators ordinarily ought to be members. However, unlike assignment, they are not required to be members.
    - Operators that change the state of their object or that are closely tied to their given type—such as increment, decrement, and dereference—usually should be members.
    - Symmetric operators—those that might convert either operand, such as the arithmetic, equality, relational, and bitwise operators—usually should be defined as ordinary nonmember functions.

9. Because ***string defines + as an ordinary nonmember function***, `"hi" + s` is equivalent to `operator+("hi", s)`. As with any function call, either of the arguments can be converted to the type of the parameter. The only requirements are that at least one of the operands has a class type, and that both operands can be converted (unambiguously) to string.
```
string s = "world";
string u = "hi" + s; // would be an error if + were a member of string
```

### 14.2 Input and Output Operators

1. Output Operators Usually Do Minimal Formatting. Generally, output operators should print the contents of the object, with minimal formatting. They should not print a newline.

2. If we want to define the IO operators for our types, we must define them as ***nonmember functions***. Of course, IO operators usually need to read or write the nonpublic data members. As a consequence, IO operators usually must be declared as ***friends***.

3. ***Input operators must deal with the possibility that the input might fail***; output operators generally don’t bother.

4. ***The errors that might happen in an input operator***
    - A read operation might fail because the stream contains data of an incorrect type. 
    - Any of the reads could hit end-of-file or some other error on the input stream.

5. Input operators should decide what, if anything, to do about error recovery.

6. ***Some input operators need to do additional data verification. Usually an input operator should set only the failbit. Setting eofbit would imply that the file was exhausted, and setting badbit would indicate that the stream was corrupted. These errors are best left to the IO library itself to indicate.***

### 14.3 Arithmetic and Relational Operators

1. ***Classes that define both an arithmetic operator and the related compound assignment ordinarily ought to implement the arithmetic operator by using the compound assignment.***

2. Equality Operators
    - Classes for which there is a logical meaning for equality normally should define operator==. Classes that define == make it easier for users to use the class with the library algorithms.
    - Ordinarily, the equality operator should be transitive, meaning that if a == b and b == c are both true, then a == c should also be true.
    - If a class defines operator==, it should also define operator!=. Users will expect that if they can use == then they can also use !=, and vice versa.
    - One of the equality or inequality operators should delegate the work to the other. That is, one of these operators should do the real work to compare objects. The other should call the one that does the real work.

3. If a single logical definition for < exists, classes usually should define the < operator. However, if the class also has ==, define < only if the definitions of < and == yield consistent results.

### 14.4 Assignment Operators

1. Assignment operators can be overloaded. Assignment operators, regardless of parameter type, must be defined as member functions.

2. Assignment operators must, and ordinarily compound-assignment operators should, be defined as members. These operators should return a reference to the left-hand operand.

### 14.5 Subscript Operator

1. The subscript operator must be a member function.

2. If a class has a subscript operator, it usually should define two versions: one that returns a plain reference and the other that is a const member and returns a reference to const.

### 14.6 Increment and Decrement Operators

1. Classes that define increment or decrement operators should define both the prefix and postfix versions. These operators usually should be defined as members.

2. To be consistent with the built-in operators, the prefix operators should return a reference to the incremented or decremented object.

3. ***To distinguish a postfix function from the prefix version, the postfix versions take an extra (unused) parameter of type int.*** When we use a postfix operator, the compiler supplies 0 as the argument for this parameter. Although the postfix function can use this extra parameter, it usually should not. Note: The int parameter is not used, so we do not give it a name.

4. To be consistent with the built-in operators, the postfix operators should return the old (unincremented or undecremented) value. That value is returned as a value, not a reference.

### 14.7 Member Access Operators

1. Operator arrow must be a member. The dereference operator is not required to be a member but usually should be a member as well.

2. `point->mem` executes as follows:
    - If point is a pointer, then the built-in arrow operator is applied, which means this expression is a synonym for (\*point).mem. The pointer is dereferenced and the indicated member is fetched from the resulting object. If the type pointed to by point does not have a member named mem, then the code is in error. 
    - If point is an object of a class that defines operator->, then the result of point.operator->() is used to fetch mem. If that result is a pointer, then step 1 is executed on that pointer. If the result is an object that itself has an overloaded operator->(), then this step is repeated on that object. This process continues until either a pointer to an object with the indicated member is returned or some other value is returned, in which case the code is in error.（伍注：没看懂？）

### 14.8 Function-Call Operator

1. Classes that overload the call operator allow objects of its type to be used as if they were a function. Because such classes can also store state, they can be more flexible than ordinary functions.

2. The function-call operator must be a member function. A class may define multiple versions of the call operator, each of which must differ as to the number or types of their parameters.

3. Objects of classes that define the call operator are referred to as ***function objects***.

4. ***When we write a lambda, the compiler translates that expression into an unnamed object of an unnamed class. The classes generated from a lambda contain an overloaded function-call operator.***

5. By default, the function-call operator in a class generated from a lambda is a const member function. If the lambda is declared as mutable, then the call operator is not const.

6. Classes Representing Lambdas with Captures
    - The compiler is permitted to use the reference directly without storing that reference as a data member in the generated class.
    - Classes generated from lambdas that capture variables by value have data members corresponding to each such variable. These classes also have a constructor to initialize these data members from the value of the captured variables.
    - Classes generated from a lambda expression have a deleted default constructor, deleted assignment operators, and a default destructor. Whether the class has a defaulted or deleted copy/move constructor depends in the usual ways on the types of the captured data members.

7. The standard library defines a set of classes that represent the arithmetic, relational, and logical operators. Each class defines a call operator that applies the named operation. These types are defined in the functional header.

8. ***Using a Library Function Object with the Algorithms***
    - To sort into descending order, we can pass an object of type greater.
    - One important aspect of these library function objects is that the library guarantees that they will work for pointers. 
    - It is also worth noting that the associative containers use less\<key_type\> to order their elements. As a result, we can define a set of pointers or use a pointer as the key in a map without specifying less directly.

9. C++ has several kinds of ***callable objects***: functions and pointers to functions, lambdas, objects created by bind, and classes that overload the function-call operator. Two callable objects with different types may share the same call signature.

10. Operations on function, defined in the functional header
```
function<T> f;
function<T> f(nullptr);
function<T> f(obj);
f(args)  // eg: function<int(int, int)>
// Types defined as members of function<T>
result_type
argument_type
first_argument_type
second_argument_type
```

11. In C++, function tables are easy to implement using a map. Usually the key is a string, and the value is an object of certain function type.

12. We cannot (directly) store the name of an overloaded function in an object of type function. One way to resolve the ambiguity is to store a function pointer instead of the name of the function. Alternatively, we can use a lambda to disambiguate.

### 14.9 Overloading, Conversions, and Operators

1. We can also define conversions from the class type. We define a conversion from a class type by defining a conversion operator. Converting constructors and conversion operators define class-type conversions. Such conversions are also referred to as user-defined conversions.

2. Conversion Operators
    - A conversion function has the general form `operator type() const;`
    - Conversion operators can be defined for any type (other than void) that can be a function return type. Conversions to an array or a function type are not permitted.
    - A conversion function must be a member function, may not specify a return type, and must have an empty parameter list. The function usually should be const.

3. ***explicit Conversion Operators***
    - Because bool is an arithmetic type, a class-type object that is converted to bool can be used in any context where an arithmetic type is expected. To prevent such problems, the new standard introduced explicit conversion operators.
    - If the conversion operator is explicit, we can still do the conversion. However, with one exception, we must do so explicitly through a cast.
    - The exception is that the compiler will apply an explicit conversion to an expression used as a condition. That is, an explicit conversion will be used
implicitly to convert an expression used as
        - The condition of an if, while, or do statement
        - The condition expression in a for statement header
        - An operand to the logical NOT (!), OR (||), or AND (&&) operators
        - The condition expression in a conditional (?:) operator
    - Conversion to bool is usually intended for use in conditions. As a result, operator bool ordinarily should be defined as explicit.

4. There are two ways that multiple conversion paths can occur. 
    - The first happens when two classes provide mutual conversions. 
    - The second way to generate multiple conversion paths is to define multiple conversions from or to types that are themselves related by conversions. The most obvious instance is the built-in arithmetic types. A given class ordinarily ought to define at most one conversion to or from an arithmetic type.

5. Ordinarily, it is a bad idea to define classes with mutual conversions or to define conversions to or from two arithmetic types.

6. When two user-defined conversions are used, the rank of the standard conversion, if any, preceding or following the conversion function is used to select the best match.

7. Caution: Conversions and Operators
    - Don’t define mutually converting classes.
    - Avoid conversions to the built-in arithmetic types. 
    - The easiest rule of all: With the exception of an explicit conversion to bool, avoid defining conversion functions and limit nonexplicit constructors to those that are “obviously right.”

8. Warning: Needing to use a constructor or a cast to convert an argument in a call to an overloaded function frequently is a sign of bad design.

9. The set of candidate functions for an operator used in an expression can contain both nonmember and member functions.

10. Providing both conversion functions to an arithmetic type and overloaded operators for the same class type may lead to ambiguities between the overloaded operators and the built-in operators.
