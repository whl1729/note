# Programming FAQ

## General Questions

### Is there a source code level debugger with breakpoints, single-stepping, etc.?

1. The pdb module is a simple but adequate console-mode debugger for Python.

2. The IDLE interactive development environment, which is part of the standard Python distribution (normally available as Tools/scripts/idle), includes a graphical debugger.

### Is there a tool to help find bugs or perform static analysis?

- PyCheker
- Pylint
- Mypy
- Pyre
- Pytype

### How can I create a stand-alone binary from a Python script?

1. One is to use the freeze tool, which is included in the Python source tree as Tools/freeze. It converts Python byte code to C arrays; a C compiler you can embed all your modules into a new program, which is then linked with the standard Python modules. (Question: not understand?)

## Core Language

### Why am I getting an UnboundLocalError when the variable has a value?

1. When you make an assignment to a variable in a scope, that variable becomes local to that scope and shadows any similarly named variable in the outer scope.

### What are the rules for local and global variables in Python?

1. In Python, variables that are only referenced inside a function are implicitly global. If a variable is assigned a value anywhere within the function’s body, it’s assumed to be a local unless explicitly declared as global.

2. Though a bit surprising at first, a moment’s consideration explains this. On one hand, requiring global for assigned variables provides a bar against **unintended side-effects**. On the other hand, if global was required for all global references, you’d be using global all the time. You’d have to declare as global every reference to a built-in function or to a component of an imported module. This **clutter** would defeat the usefulness of the global declaration for identifying side-effects.

### Why do lambdas defined in a loop with different values all return the same result?

1. This happens because x is not local to the lambdas, but is defined in the outer scope, and it is accessed when the lambda is called — not when it is defined.

### How do I share global variables across modules?

1. The canonical way to share information across modules within a single program is to create a special module (often called config or cfg). Just import the config module in all modules of your application; the module then becomes available as a global name. Because there is only one instance of each module, any changes made to the module object get reflected everywhere.

### What are the “best practices” for using import in a module?

1. It’s good practice if you import modules in the following order:
    - standard library modules – e.g. sys, os, getopt, re
    - third-party library modules (anything installed in Python’s site-packages directory) – e.g. mx.DateTime, ZODB, PIL.Image, etc.
    - locally-developed modules

2. Circular imports are fine where both modules use the `"import <module>"` form of import. They fail when the 2nd module wants to grab a name out of the first (`"from module import name"`) and the import is at the top level. That’s because names in the 1st are not yet available, because the first module is busy importing the 2nd.

3. It may also be necessary to move imports out of the top level of code if some of the modules are platform-specific. In that case, it may not even be possible to import all of the modules at the top of the file. In this case, importing the correct modules in the corresponding platform-specific code is a good option.

4. Only move imports into a local scope, such as inside a function definition, if it’s necessary to solve a problem such as avoiding a circular import or are trying to reduce the initialization time of a module. This technique is especially helpful if many of the imports are unnecessary depending on how the program executes. You may also want to move imports into a function if the modules are only ever used in that function.

### Why are default values shared between objects?

1. Default values are created exactly once, when the function is defined. If that object is changed, like the dictionary in this example, subsequent calls to the function will refer to this changed object.

2. It is good programming practice to not use mutable objects as default values. Instead, use None as the default value and inside the function, check if the parameter is None and create a new list/dictionary/whatever if it is.

3. When you have a function that’s time-consuming to compute, a common technique is to cache the parameters and the resulting value of each call to the function, and return the cached value if the same value is requested again. This is called "memoizing".

### Why did changing list 'y' also change list 'x'?

1. If we have a mutable object (list, dict, set, etc.), we can use some specific operations to mutate it and all the variables that refer to it will see the change.

2. If we have an immutable object (str, int, tuple, etc.), all the variables that refer to it will always see the same value, but operations that transform that value into a new value always return a new object.

### How do you make a higher order function in Python?

1. You have two choices: you can use nested scopes or you can use callable objects.

2. The callable object approach has the disadvantage that it is a bit slower and results in slightly longer code. However, note that a collection of callables can share their signature via inheritance.

### How can I find the methods or attributes of an object?

1. For an instance x of a user-defined class, `dir(x)` returns an alphabetized list of the names containing the instance attributes and methods and attributes defined by its class.
