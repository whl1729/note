# JavaScript Modules

## 04 Storing the information you need — Variables

1. In JavaScript, all code instructions should end with a semi-colon (;) — your code may work correctly for single lines, but probably won't when you are writing multiple lines of code together. Try to get into the habit of including it.

2. `let` vs `var`
    - `let` allows you to declare variables that are limited to the scope of a block statement, or expression on which it is used, while `var` defines a variable globally, or locally to an entire function regardless of block scope.
    - The other difference between `var` and `let` is that the latter is initialized to a value only when a parser evaluates it

3. Because variable declarations (and declarations in general) are processed before any code is executed, declaring a variable anywhere in the code is equivalent to declaring it at the top. This also means that a variable can appear to be used before it's declared. This behavior is called **"hoisting"**, as it appears that the variable declaration is moved to the top of the function or global code.

4. Because of `var hoisting`, it is recommended to always declare variables at the top of their scope (the top of global code and the top of function code) so it's clear which variables are function scoped (local) and which are resolved on the scope chain.

5. It's important to point out that the hoisting will affect the variable declaration, but not its value's initialization. The value will be indeed assigned when the assignment statement is reached.
