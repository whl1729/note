# The Python Tutorial

## 4 More Control Flow Tools

### 4.2 for Statements

1. Rather than always iterating over an arithmetic progression of numbers (like in Pascal), or giving the user the ability to define both the iteration step and halting condition (as C), Python’s for statement **iterates over the items of any sequence (a list or a string)**, in the order that they appear in the sequence.

2. Code that modifies a collection while iterating over that same collection can be tricky to get right. Instead, it is usually more straight-forward to **loop over a copy of the collection or to create a new collection**.
    - Question: why?
```
# Strategy:  Iterate over a copy
for user, status in users.copy().items():
    if status == 'inactive':
        del users[user]

# Strategy:  Create a new collection
active_users = {}
for user, status in users.items():
    if status == 'active':
        active_users[user] = status
```

### 4.3 The range() Function

1. If you do need to iterate over a sequence of numbers, the built-in function `range()` comes in handy. To iterate over the indices of a sequence, you can combine `range()` and `len()` or use the `enumerate()` function.

2. We say such an object is **iterable**, that is, suitable as a target for functions and constructs that expect something from which they can obtain successive items until the supply is exhausted.

3. Get a list from a range:
```
>>> list(range(4))
[0, 1, 2, 3]
```

### 4.4 break and continue Statements, and else Clauses on Loops

1. Loop statements may have an else clause; it is executed when the loop terminates through exhaustion of the iterable (with for) or when the condition becomes false (with while), but not when the loop is terminated by a break statement.

2. When used with a loop, the `else` clause has more in common with the `else` clause of a `try` statement than it does with that of if statements: a `try` statement’s `else` clause runs when no exception occurs, and a loop’s `else` clause runs when no break occurs.

### 4.5 pass Statements

1. The `pass` statement does nothing. It can be used when a statement is required syntactically but the program requires no action.
    - This is commonly used for creating minimal classes.
    - Another place pass can be used is as a place-holder for a function or conditional body when you are working on new code, allowing you to keep thinking at a **more abstract** level.

### 4.6 Defining Functions

1. The first statement of the function body can optionally be a string literal; this string literal is the function’s **documentation string**, or **docstring**. There are tools which use docstrings to automatically produce online or printed documentation, or to let the user interactively browse through code; it’s good practice to include docstrings in code that you write, so make a habit of it.

2. The execution of a function introduces a new symbol table used for the local variables of the function. More precisely, all variable assignments in a function store the value in the local symbol table; whereas variable references first look in the local symbol table, then in the local symbol tables of enclosing functions, then in the global symbol table, and finally in the table of built-in names. Thus, **global variables and variables of enclosing functions cannot be directly assigned a value within a function** (unless, for global variables, named in a global statement, or, for variables of enclosing functions, named in a nonlocal statement), although they may be referenced.

3. The actual parameters (arguments) to a function call are introduced in the local symbol table of the called function when it is called; thus, arguments are passed using **call by value** (where the value is always an **object reference**, not the value of the object). When a function calls another function, a new local symbol table is created for that call.

4. Actually, **call by object reference** would be a better description, since if a mutable object is passed, the caller will see any changes the callee makes to it (items inserted into a list).

5. A function definition introduces the function name in the current **symbol table**. The value of the function name has a type that is recognized by the interpreter as a user-defined function. This value can be assigned to another name which can then also be used as a function. This serves as a general renaming mechanism.

6. Even functions without a return statement do return a value, albeit a rather boring one. This value is called **None** (it’s a built-in name). Writing the value None is normally suppressed by the interpreter if it would be the only value written.

### 4.7 More on Defining Functions

1. The default values are evaluated at the point of function definition in the defining scope.

2. Important warning: **The default value is evaluated only once. This makes a difference when the default is a mutable object such as a list, dictionary, or instances of most classes.**

3. Functions can also be called using **keyword arguments** of the form `kwarg=value`.

4. When a final formal parameter of the form `**name` is present, it receives a dictionary containing all **keyword arguments** except for those corresponding to a formal parameter. This may be combined with a formal parameter of the form `*name` which receives a tuple containing the **positional arguments** beyond the formal parameter list. (`*name` must occur before `**name`.)

5. A function definition may look like this(see the following), where / and * are optional. If used, these symbols indicate the kind of parameter by how the arguments may be passed to the function: **positional-only**, **positional-or-keyword**, and **keyword-only**. Keyword parameters are also referred to as named parameters.
```
def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2):
      -----------    ----------     ----------
        |             |                  |
        |        Positional or keyword   |
        |                                - Keyword only
         -- Positional only
```

6. Determine which parameters to use in the function definition: `def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2)`
    - Use positional-only if you want the name of the parameters to not be available to the user. This is useful when parameter names have no real meaning, if you want to enforce the order of the arguments when the function is called or if you need to take some positional parameters and arbitrary keywords.
    - Use keyword-only when names have meaning and the function definition is more understandable by being explicit with names or you want to prevent users relying on the position of the argument being passed.
    - For an API, use positional-only to prevent breaking API changes if the parameter’s name is modified in the future.

7. The least frequently used option is to specify that a function can be called with an arbitrary number of arguments. These arguments will be wrapped up in a tuple. Before the variable number of arguments, zero or more normal arguments may occur.
```
def write_multiple_items(file, separator, *args):
    file.write(separator.join(args))
```

8. Unpacking Argument Lists
    - Write the function call with the `*-operator to` unpack the arguments out of a list or tuple.
    - Dictionaries can deliver keyword arguments with the `**-operator`.

9. Small anonymous functions can be created with the `lambda` keyword. Lambda functions can be used wherever function objects are required. They are syntactically restricted to a single expression. Semantically, they are just syntactic sugar for a normal function definition. Like nested function definitions, lambda functions can reference variables from the containing scope.

10. **Function annotations** are completely optional metadata information about the types used by user-defined functions. Annotations are stored in the `__annotations__` attribute of the function as a dictionary and have no effect on any other part of the function.

### 4.8 Intermezzo: Coding Style

1. For Python, [PEP 8](https://www.python.org/dev/peps/pep-0008/) has emerged as the style guide that most projects adhere to; it promotes a very readable and eye-pleasing coding style. Every Python developer should read it at some point; here are the most important points extracted for you:
    - Use 4-space indentation, and no tabs.
    - Wrap lines so that they don’t exceed **79** characters.
    - Use blank lines to separate functions and classes, and larger blocks of code inside functions.
    - When possible, put comments on a line of their own.
    - Use docstrings.
    - Use spaces around operators and after commas, but not directly inside bracketing constructs.
    - Name your classes and functions consistently; the convention is to use UpperCamelCase for classes and lowercase_with_underscores for functions and methods. Always use self as the name for the first method argument.
    - Don’t use fancy encodings if your code is meant to be used in international environments. Python’s default, UTF-8, or even plain ASCII work best in any case.
    - Likewise, don’t use non-ASCII characters in identifiers if there is only the slightest chance people speaking a different language will read or maintain the code.
