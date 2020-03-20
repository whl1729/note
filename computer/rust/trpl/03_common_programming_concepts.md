# The Rust Programming Language

## Chapter 03: Common Proramming Concepts

### 3.1 Variables and Mutability

1. By default variables are immutable. You can make them mutable by adding mut in front of the variable name.

2. Differences Between Variables and Constants
    - You aren’t allowed to use mut with constants.
    - Constants can be declared in any scope, including the global scope.
    - Constants may be set only to a constant expression, not the result of a function call or any other value that could only be computed at runtime.

3. constants
    - You declare constants using the const keyword instead of the let keyword, and the type of the value must be annotated.
    - Rust’s naming convention for constants is to use all uppercase with underscores between words, and underscores can be inserted in numeric literals to improve readability.

4. shadowing
    - You can declare a new variable with the same name as a previous variable, and the new variable shadows the previous variable.
    - The other difference between mut and shadowing is that because we’re effectively creating a new variable when we use the let keyword again, we can change the type of the value but reuse the same name.

### 3.2 Data Types

1. Rust is a statically typed language, which means that it must know the types of all variables at compile time.

2. A scalar type represents a single value. Rust has four primary scalar types: integers, floating-point numbers, Booleans, and characters.

3. The isize and usize types depend on the kind of computer your program is running on: 64 bits if you’re on a 64-bit architecture and 32 bits if you’re on a 32-bit architecture.

4. Integer types default to i32: this type is generally the fastest, even on 64-bit systems.

5. Integer Overflow
    - When you’re compiling in debug mode, Rust includes checks for integer overflow that cause your program to panic at runtime if this behavior occurs.
    - When you’re compiling in release mode with the --release flag, Rust does not include checks for integer overflow that cause panics. Instead, if overflow occurs, Rust performs two’s complement wrapping.

6. The default floating-point type is f64 because on modern CPUs it’s roughly the same speed as f32 but is capable of more precision.

7. Compound types can group multiple values into one type. Rust has two primitive compound types: tuples and arrays.

8. Array
    - Arrays in Rust have a fixed length.
    - In Rust, the values going into an array are written as a comma-separated list inside square brackets.
    - A vector is a similar collection type provided by the standard library that is allowed to grow or shrink in size.
    - If you’re unsure whether to use an array or a vector, you should probably use a vector.
    - if you want to create an array that contains the same value for each element, you can specify the initial value, followed by a semicolon, and then the length of the array in square brackets.

### 3.3 Functions

1. Rust code uses snake case as the conventional style for function and variable names. In snake case, all letters are lowercase and underscores separate words.

2. Rust doesn’t care where you define your functions, only that they’re defined somewhere.
