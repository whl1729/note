# 《C++ Primer》第4章学习笔记

## 4 Expressions

### 4.1 Fundamentals

1. ***Understanding expressions with multiple operators requires understanding the precedence and associativity of the operators and may depend on the order of evaluation of the operands.***

2. When we use an overloaded operator, the meaning of the operator—including the type of its operand(s) and the result—depend on how the operator is defined. However, the number of operands and the precedence and the associativity of the operator cannot be changed.

3. Every expression in C++ is either an rvalue or an lvalue. These names are inherited from C and originally had a simple mnemonic purpose: ***lvalues could stand on the left-hand side of an assignment whereas rvalues could not.***

4. In C++, an lvalue expression yields an object or a function. However, some lvalues, such as const objects, may not be the lefthand operand of an assignment. Moreover, some expressions yield objects but return them as rvalues, not lvalues. Roughly speaking, ***when we use an object as an rvalue, we use the object’s value (its contents). When we use an object as an lvalue, we use the object’s identity (its location in memory).***

5. The arithmetic operators are left associative, which means operators at the same precdence group left to right.

6. Parentheses Override Precedence and Associativity.

7. ***Precedence specifies how the operands are grouped. It says nothing about the order in which the operands are evaluated. Order of operand evaluation is independent of precedence and associativity. In most cases, the order is largely unspecified. For operators that do not specify evaluation order, it is an error for an expression to refer to and change the same object.***

8. There are four operators that do guarantee the order in which operands are evaluated. 
    - The logical AND and OR operators always evaluate their left operand before the right. Moreover, the right operand is evaluated if and only if the left operand does not determine the result. This strategy is known as short-circuit evaluation.
    - `cond ? expr1 : expr2`: the conditional operator guarantees that only one of expr1 or expr2 is evaluated.
    - The comma operator takes two operands, which it evaluates from left to right. The left-hand expression is evaluated and its result is discarded. The result of a comma expression is the value of its right-hand expression.

9. Advice: Managing Compound Expressions. When you write compound expressions, two rules of thumb can be helpful:
    - When in doubt, parenthesize expressions to force the grouping that the logic of your program requires.
    - If you change the value of an operand, don’t use that operand elsewhere in the same expresion.

### 4.2 Arithmetic Operators

1. ***The unary arithmetic operators(正号、负号) have higher precedence than the multiplication and division operators, which in turn have higher precedence than the binary addition and subtraction operators.***

2. By implication, if m%n is nonzero, it has the same sign as m. Moreover, except for the obscure case where -m overflows, ***(-m)/n and m/(-n) are always equal to -(m/n)***, m%(-n) is equal to m%n, and (-m)%n is equal to -(m%n). More concretely:
```
21/5=4  21%5=1
21/-5=-4  21%-5=1
-21/5=-4  -21%5=-1
-21/-5=4  -21%-5=-1
```

### 4.3 Logical and Relational Operators

1. Warning: It is usually a bad idea to use the boolean literals `true` and `false` as operands in a comparison. These literals should be used only to compare to an object of type bool.

### 4.4 Assignment Operators

1. The left-hand operand of an assignment operator must be a modifiable lvalue. 

2. ***The result of an assignment is its left-hand operand, which is an lvalue. The type of the result is the type of the left-hand operand.***

3. ***Assignment Is Right Associative.***

4. ***Because assignment has lower precedence than the relational operators, parentheses are usually needed around assignments in conditions.***

### 4.5 Increment and Decrement Operators

1. Advice: Use Postfix Operators only When Necessary. By habitually using the prefix versions, we do not have to worry about whether the performance difference matters. Moreover—and perhaps more importantly—we can express the intent of our programs more directly.

2. Increment and Decrement Operators
    - The prefix operators increments (or decrements) its operand and yields the changed object as its result. The postfix operators increment (or decrement) the operand but yield a copy of the original, unchanged value as its result.
    - `*pbeg++` The precedence of postfix increment is higher than that of the dereference operator, so \*pbeg++ is equivalent to \*(pbeg++). The subexpression pbeg++ increments pbeg and yields a copy of the previous value of pbeg as its result. 

18. Warning: Nested conditionals quickly become unreadable. It’s a good idea to nest no more than two or three.

### 4.7 The Conditional Operator

1. ***The conditional operator has fairly low precedence. When we embed a conditional expression in a larger expression, we usually must parenthesize the conditional subexpression.***
```
cout << ((grade < 60) ? "fail" : "pass"); // prints pass or fail
cout << (grade < 60) ? "fail" : "pass"; // prints 1 or 0!
cout << grade < 60 ? "fail" : "pass"; // error: compares cout to 60
```

2. Warning: Because there are no guarantees for how the sign bit is handled, we strongly recommend using unsigned types with the bitwise operators.

### 4.8 The Bitwise Operators

1. `~`: bitwise NOT

2. ***The left-shift operator (the << operator) inserts 0-valued bits on the right. The behavior of the right-shift operator (the >> operator) depends on the type of the left-hand operand: If that operand is unsigned, then the operator inserts 0-valued bits on the left; if it is a signed type, the result is implementation defined—either copies of the sign bit or 0-valued bits are inserted on the left.***

### 4.9 The sizeof Operator

1. The sizeof operator returns the size, in bytes, of an expression or a type name. The operator is right associative. sizeof a dereferenced pointer returns the size of an object of the type to which the pointer points; the pointer need not be valid.

### 4.10 Comma Operator

1. The comma operator takes two operands, which it evaluates from left to right. Like the logical AND and logical OR and the conditional operator, the comma operator guarantees the order in which its operands are evaluated.

2. The left-hand expression is evaluated and its result is discarded. The result of a comma expression is the value of its right-hand expression. The result is an lvalue if the right-hand operand is an lvalue.

### 4.11. Type Conversions

1. ***The compiler automatically converts operands in the following circumstances***:
    - In most expressions, values of integral types smaller than int are first promoted to an appropriate larger integral type.
    - In conditions, nonbool expressions are converted to bool.
    - In initializations, the initializer is converted to the type of the variable; in assignments, the right-hand operand is converted to the type of the left-hand.
    - In arithmetic and relational expressions with operands of mixed types, the types are converted to a common type.
    - Conversions also happen during function calls.

2. The rules define a hierarchy of type conversions in which ***operands to an operator are converted to the widest type***.

3. ***Integral Promotions***
    - The integral promotions convert the small integral types to a larger integral type. The types bool, char, signed char, unsigned char, short, and unsigned short are promoted to int if all possible values of that type fit in an int. Otherwise, the value is promoted to unsigned int. As we’ve seen many times, a bool that is false promotes to 0 and true to 1.
    - The larger char types (wchar_t, char16_t, and char32_t) are promoted to the smallest type of int, unsigned int, long, unsigned long, long long, or unsigned long long in which all possible values of that character type fit.

4. ***signed and unsigned***
    - When the signedness differs and the type of the unsigned operand is the same as or larger than that of the signed operand, the signed operand is converted to unsigned
    - when the signed operand has a larger type than the unsigned operand. In this case, the result is machine dependent. If all values in the unsigned type fit in the larger type, then the unsigned operand is converted to the signed type. If the values don’t fit, then the signed operand is converted to the unsigned type. For example, if the operands are long and unsigned int, and int and long have the same size, the long will be converted to unsigned int. If the long type has more bits, then the unsigned int will be converted to long.（伍注：反正conversion的原则是小转大）

5. ***Array to Pointer Conversions***
    -In most expressions, when we use an array, the array is automatically converted to a pointer to the first element in that array. 
    - This conversion is not performed when an array is used with decltype or as the operand of the address-of (&), sizeof, or typeid operators. The conversion is also omitted when we initialize a reference to an array. 

6. There are several other pointer conversions: 
    - A constant integral value of 0 and the literal nullptr can be converted to any pointer type; 
    - A pointer to any nonconst type can be converted to void\*; 
    - A pointer to any type can be converted to a const void\*. 

7. ***Named Casts***
    - A named cast has the form: `cast-name<type>(expression);` where type is the target type of the conversion, and expression is the value to be cast. If type is a reference, then the result is an lvalue. The cast-name may be one of static_cast, dynamic_cast, const_cast, and reinterpret_cast.
    - static_cast: Any well-defined type conversion, other than those involving low-level const, can be requested using a static_cast. A static_cast is often useful when a larger arithmetic type is assigned to a smaller type. A static_cast is also useful to perform a conversion that the compiler will not generate automatically.（伍注：常用场景是整型变量大转小）
    - dynamic_cast: safely converts a pointer or reference to a base type into a pointer or reference to a derived type.
    - const_cast: A const_cast changes only a low-level const in its operand. Only a const_cast may be used to change the constness of an expression. Trying to change whether an expression is const with any of the other forms of named cast is a compile-time error.
    - reinterpret_cast: A reinterpret_cast generally performs a low-level reinterpretation of the bit pattern of its operands.（伍注：应用场景是不同类型的指针之间的转换）
