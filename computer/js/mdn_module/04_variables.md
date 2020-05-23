# JavaScript Modules

## 04 Storing the information you need — Variables

### Declaring a variable

1. In JavaScript, all code instructions should **end with a semi-colon (;)** — your code may work correctly for single lines, but probably won't when you are writing multiple lines of code together. Try to get into the habit of including it.

2. `not defined` vs `not exist`: Don't confuse a variable that exists but has no defined value with a variable that doesn't exist at all — they are very different things. In the box analogy you saw above, not existing would mean there's no box (variable) for a value to go in. No value defined would mean that there IS a box, but it has no value inside it.（伍注：前者是已声明但未定义，后者是未声明）

### The difference between var and let

1. `var hoisting`
    - Because variable declarations (and declarations in general) are processed before any code is executed, declaring a variable anywhere in the code is equivalent to declaring it at the top. This also means that a variable can appear to be used before it's declared. This behavior is called **"hoisting"**, as it appears that the variable declaration is moved to the top of the function or global code.
    - Because of **var hoisting**, it is recommended to always declare variables at the top of their scope (the top of global code and the top of function code) so it's clear which variables are function scoped (local) and which are resolved on the scope chain.
    - It's important to point out that the hoisting will affect the variable declaration, but not its value's initialization. The value will be indeed assigned when the assignment statement is reached.

2. `let` vs `var`
    - `let` allows you to declare variables that are limited to the scope of a block statement, or expression on which it is used, while `var` defines a variable globally, or locally to an entire function regardless of block scope.
    - The other difference between `var` and `let` is that the latter is initialized to a value only when a parser evaluates it.
    - Hoisting only works with var, but no longer works with let.
    - When you use var, you can declare the same variable as many times as you like, but with let you can't. (Question: Why?)

3. For these reasons and more, we recommend that you **use let as much as possible** in your code, rather than var. There is no reason to use var, unless you need to support old versions of Internet Explorer with your code (it doesn't support let until version 11; the modern Windows Edge browser supports let just fine).

### Updating a variable

1. Once a variable has been initialized with a value, you can change (or update) that value by simply giving it a different value.（Question: js 允许给同一个变量名赋予不同类型的值，那么 js 是怎么分配内存的呢？每次重新赋值后都要重新分配内存吗？）

### An aside on variable naming rules

1. Generally, you should stick to just using Latin characters (0-9, a-z, A-Z) and the underscore character.

2. A safe convention to stick to is so-called **"lower camel case"**, where you stick together multiple words, using lower case for the whole first word and then capitalize subsequent words.

### Dynamic typing

1. JavaScript is a "dynamically typed language", which means that, unlike some other languages, you don't need to specify what data type a variable will contain (numbers, strings, arrays, etc).
