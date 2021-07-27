# The Python Tutorial

## 9 Classes

1. Compared with other programming languages, Python’s class mechanism adds classes with a **minimum** of new syntax and semantics. It is a mixture of the class mechanisms found in C++ and Modula-3.

2. Python classes provide all the standard features of Object Oriented Programming:
  - the class inheritance mechanism allows **multiple base classes**, （伍注：多重继承）
  - a derived class can override any methods of its base class or classes,
  - and a method can call the method of a base class with the same name.
  - Objects can contain arbitrary amounts and kinds of data.
  - As is true for modules, classes partake of the dynamic nature of Python: they are created at runtime, and can be **modified further after creation**. （伍注：动态修改）

3. Unlike C++ and Modula-3, built-in types can be used as base classes for extension by the user. （伍注：允许继承内建类型，这在C++中是禁止的）

4. Also, like in C++, most built-in **operators** with special syntax (arithmetic operators, subscripting etc.) can be redefined for class instances. （伍注：支持运算符重载）

### 9.1. A Word About Names and Objects

1. Objects have individuality, and multiple names (in multiple scopes) can be bound to the same object. This is known as **aliasing** in other languages. （伍注：aliasing 可以类比为指针或引用。）

2. Aliases vs Pointers
  - Aliasing has a possibly surprising effect on the semantics of Python code involving **mutable objects** such as lists, dictionaries, and most other types.
  - This is usually used to the benefit of the program, since aliases behave like **pointers** in some respects.
  - For example, passing an object is cheap since only a pointer is passed by the implementation;
  - And if a function modifies an object passed as an argument, the caller will see the change — this eliminates the need for two different argument passing mechanisms as in Pascal.

### 9.2 Python Scopes and Namespaces

> Question: It's a bit difficult to understand Python Scope described in 9.2.

1. Class definitions play some neat tricks with namespaces, and you need to know how **scopes and namespaces** work to fully understand what’s going on. （伍注：要理解Python class，需要先理解Python scope 和 Python namespace）

2. **A namespace is a mapping from names to objects.** （伍注：「命名空间」是从名字到对象的映射。）
  - Most namespaces are currently implemented as Python dictionaries, but that’s normally not noticeable in any way (except for performance), and it may change in the future.

3. The important thing to know about namespaces is that **there is absolutely no relation between names in different namespaces**.
  - for instance, two different modules may both define a function maximize without confusion — users of the modules must prefix it with the module name.

4. Writable Module
  - Module attributes are writable: you can write `modname.the_answer = 42`.
  - Writable attributes may also be **deleted** with the del statement. For example, `del modname.the_answer` will remove the attribute the_answer from the object named by modname.

5. Namespaces are created at **different moments** and have **different lifetimes**.
  - The namespace containing the built-in names is created when the Python interpreter starts up, and is never deleted.
  - The global namespace for a module is created when the module definition is read in; normally, module namespaces also last until the interpreter quits.
  - The statements executed by the top-level invocation of the interpreter, either read from a script file or interactively, are considered part of a module called __main__, so they have their own global namespace. (The built-in names actually also live in a module; this is called builtins.)
    - A top-level statement mean anything that starts at indentation level 0.
    - "__main__" is the name of the scope in which top-level code executes.
    - A module’s `__name__` is set equal to "__main__" when read from standard input, a script, or from an interactive prompt.

6. A scope is a textual region of a Python program where a namespace is directly accessible.
  - "Directly accessible" here means that an unqualified reference to a name attempts to find the name in the namespace.
  - If you have a nested package named `foo.bar.baz` with a class `Spam`, the method ham on that class will have a fully qualified name of `foo.bar.baz.Spam.ham`. `ham` is the unqualified name.

> 伍注：「作用域」与「命名空间」的区别与联系是什么？思考一下。
> 1. 从定义上看，「命名空间」是映射，「作用域」是文本区域。
> 2. 每个「作用域」里都有对应的能够直接访问的「命名空间」。通俗点说，「作用域」是一块地盘，「命名空间」是这块地盘能够看到的东西。

7. At any time during execution, there are at least three nested scopes whose namespaces are directly accessible:
  - the innermost scope, which is searched first, contains the local names
  - the scopes of any enclosing functions, which are searched starting with the nearest enclosing scope, contains non-local, but also non-global names
  - the next-to-last scope contains the current module’s global names
  - the outermost scope (searched last) is the namespace containing built-in names

> 伍注：继续理解「作用域」与「命名空间」的关系。
> 1. 这里提到Python的作用域一般有四层，由内到外看分别是：函数内作用域、外层函数作用域、模块内全局作用域、内置作用域。
> 2. 从内到外看，作用域所能直接访问的「命名空间」依次缩小。不妨以金字塔来打比方，并且假设只能向下看。那么金字塔最底层是内置作用域，最高层是函数内作用域。站在最高层，可以看到自顶向下的所有层。

8. `global` and `nonlocal`
  - If a name is declared global, then all references and assignments go directly to the middle scope containing the module’s global names.
  - To rebind variables found outside of the innermost scope, the nonlocal statement can be used; if not declared nonlocal, those variables are read-only (an attempt to write to such a variable will simply create a new local variable in the innermost scope, leaving the identically named outer variable unchanged).
  - The global statement can be used to indicate that particular variables live in the global scope and should be rebound there.
  - The nonlocal statement indicates that particular variables live in an enclosing scope and should be rebound there.

9. It is important to realize that scopes are determined textually.
  - The global scope of a function defined in a module is that module’s namespace, no matter from where or by what alias the function is called.
  - On the other hand, the actual search for names is done dynamically, at run time.
  - However, the language definition is evolving towards static name resolution, at "compile" time, so don't rely on dynamic name resolution! (In fact, local variables are already determined statically.) (Question: not understand?)

10. **If no global or nonlocal statement is in effect, assignments to names always go into the innermost scope.**
  - Assignments do not copy data — they just bind names to objects.
  - The same is true for deletions: the statement del x removes the binding of x from the namespace referenced by the local scope.
  - In fact, all operations that introduce new names use the local scope: in particular, import statements and function definitions bind the module or function name in the local scope.

11. `__dict__`
  - Module objects have a secret read-only attribute called `__dict__` which returns the dictionary used to implement the module’s namespace
  - The name `__dict__` is an attribute but not a global name.
  - Obviously, using this violates the abstraction of namespace implementation, and should be restricted to things like post-mortem debuggers.

### 9.3 A First Look at Classes

1. Class definitions, like function definitions (def statements) must be executed before they have any effect.
  - You could conceivably place a class definition in a branch of an if statement, or inside a function.

> 伍注：如果你在函数内或if分支里创建了某个类的对象，并且该函数没被调用或该if分支没被执行，则不会产生任何效果。

2. Class Object
  - When a class definition is left normally (via the end), a class object is created.
  - This is basically a wrapper around the contents of the namespace created by the class definition.
  - The original local scope (the one in effect just before the class definition was entered) is reinstated, and the class object is bound here to the class name given in the class definition header.

> Question: What is a class object? Is a class object created after the class definition finished?

3. Class objects support two kinds of operations: **attribute references and instantiation.**
  - Attribute references use the standard syntax used for all attribute references in Python: obj.name.
  - Class instantiation uses function notation.

> 伍注：Python的attribute是不是相当于C++的data member？好像不对，应该是member，包括data member和function member。

4. `__init__`
  - The instantiation operation ("calling" a class object) creates an empty object.
  - Many classes like to create objects with instances customized to a specific initial state. Therefore a class may define a special method named `__init__()`.
  - When a class defines an `__init__()` method, class instantiation automatically invokes `__init__()` for the newly-created class instance.

5. Attribute Reference
  - The only operations understood by instance objects are **attribute references**.
  - There are two kinds of valid attribute names: **data attributes and methods**.

6. Data attribute
  - Data attributes correspond to "instance variables" in Smalltalk, and to **"data members"** in C++. （伍注：Python data attribute类似于C++ data member）
  - Data attributes need not be declared; like local variables, they spring into existence when they are first assigned to.

7. Method
  - A method is a function that "belongs to" an object.
  - In Python, the term method is not unique to class instances: other object types can have methods as well.
  - For example, list objects have methods called append, insert, remove, sort, and so on.

8. Method Object vs Function Object
  - Valid method names of an instance object depend on its class. By definition, all attributes of a class that are function objects define corresponding methods of its instances. So in our example, x.f is a valid method reference, since MyClass.f is a function, but x.i is not, since MyClass.i is not. But x.f is not the same thing as MyClass.f — it is a method object, not a function object.
  - Question: How to understand "x.f is a method object, not a function object."?

9. The special thing about methods is that the instance object is passed as the first argument of the function. In our example, the call `x.f()` is exactly equivalent to `MyClass.f(x)`. In general, calling a method with a list of n arguments is equivalent to calling the corresponding function with an argument list that is created by inserting the method’s instance object before the first argument.

10. When a non-data attribute of an instance is referenced, the instance’s class is searched. If the name denotes a valid class attribute that is a function object, a **method object** is created by packing (pointers to) the instance object and the function object just found together in an abstract object: this is the method object. When the method object is called with an argument list, a new argument list is constructed from the instance object and the argument list, and the function object is called with this new argument list.

11. Instance variables are for data unique to each instance and class variables are for attributes and methods shared by all instances of the class.

12. **Shared data can have possibly surprising effects with involving mutable objects such as lists and dictionaries.** Correct design of the class should use an instance variable instead.

### 9.4 Random Remarks

1. If the same attribute name occurs in both an instance and in a class, then attribute lookup prioritizes the instance.

2. Data attributes may be referenced by methods as well as by ordinary users ("clients") of an object. In other words, classes are not usable to implement pure abstract data types. In fact, **nothing in Python makes it possible to enforce data hiding — it is all based upon convention.** (On the other hand, the Python implementation, written in C, can completely hide implementation details and control access to an object if necessary; this can be used by extensions to Python written in C.)

3. Clients should use data attributes with care — clients may mess up invariants maintained by the methods by stamping on their data attributes. Note that clients may add data attributes of their own to an instance object without affecting the validity of the methods, as long as name conflicts are avoided — again, a naming convention can save a lot of headaches here.（伍注：这样带来的一个问题是：当你访问class的一个数据属性时，如果你不慎拼写错误，python也不会报错。）

4. There is **no shorthand** for referencing data attributes (or other methods!) from within methods. I find that this actually increases the readability of methods: there is no chance of confusing local variables and instance variables when glancing through a method.

5. Often, the first argument of a method is called self. This is nothing more than a **convention**: the name self has absolutely no special meaning to Python. Note, however, that by not following the convention your code may be less readable to other Python programmers, and it is also conceivable that a class browser program might be written that relies upon such a convention.

6. Methods may call other methods by using method attributes of the self argument.

7. Each value is an object, and therefore has a class (also called its type). It is stored as object.`__class__`.

### 9.5 Inheritance

1. If a requested attribute is not found in the class, the search proceeds to look in the base class. This rule is applied recursively if the base class itself is derived from some other class.

2. Derived classes may override methods of their base classes. Because methods have no special privileges when calling other methods of the same object, **a method of a base class that calls another method defined in the same base class may end up calling a method of a derived class that overrides it.** (For C++ programmers: **all methods in Python are effectively virtual.**)

3. An overriding method in a derived class may in fact want to extend rather than simply replace the base class method of the same name. There is a simple way to call the base class method directly: just call BaseClassName.methodname(self, arguments). This is occasionally useful to clients as well. (Note that this only works if the base class is accessible as BaseClassName in the global scope.)

4. Python has two built-in functions that work with inheritance:
  - Use `isinstance()` to check an instance’s type: `isinstance(obj, int)` will be True only if `obj.__class__` is int or some class derived from int.
  - Use `issubclass()` to check class inheritance: `issubclass(bool, int)` is True since bool is a subclass of int. However, `issubclass(float, int)` is False since float is not a subclass of int.

#### 9.5.1 Multiple Inheritance

1. For most purposes, in the simplest cases, you can think of the search for attributes inherited from a parent class as **depth-first, left-to-right**, not searching twice in the same class where there is an overlap in the hierarchy. Thus, if an attribute is not found in DerivedClassName, it is searched for in Base1, then (recursively) in the base classes of Base1, and if it was not found there, it was searched for in Base2, and so on.

2. In fact, it is slightly more complex than that; the method resolution order changes dynamically to support cooperative calls to `super()`. This approach is known in some other multiple-inheritance languages as **call-next-method** and is more powerful than the super call found in single-inheritance languages.

3. **Dynamic ordering** is necessary because all cases of multiple inheritance exhibit one or more **diamond relationships** (where at least one of the parent classes can be accessed through multiple paths from the bottommost class). For example, all classes inherit from object, so any case of multiple inheritance provides more than one path to reach object. To keep the base classes from being accessed more than once, the dynamic algorithm linearizes the search order in a way that preserves the left-to-right ordering specified in each class, that calls each parent only once, and that is monotonic (meaning that a class can be subclassed without affecting the precedence order of its parents).

### 9.6 Private Variables

1. "Private" instance variables that cannot be accessed except from inside an object don’t exist in Python. However, there is a convention that is followed by most Python code: **a name prefixed with an underscore should be treated as a non-public part of the API** (whether it is a function, a method or a data member). It should be considered an implementation detail and subject to change without notice.

2. Since there is a valid use-case for class-private members (namely to avoid name clashes of names with names defined by subclasses), there is limited support for such a mechanism, called **name mangling**. Any identifier of the form `__spam` (at least two leading underscores, at most one trailing underscore) is textually replaced with `_classname__spam`, where `classname` is the current class name with leading underscore(s) stripped. This mangling is done without regard to the syntactic position of the identifier, as long as it occurs within the definition of a class.

3. **Name mangling** is helpful for letting subclasses override methods without breaking intraclass method calls.

4. Notice that code passed to `exec()` or `eval()` does not consider the classname of the invoking class to be the current class; this is similar to the effect of the global statement, the effect of which is likewise restricted to code that is byte-compiled together. The same restriction applies to `getattr()`, `setattr()` and `delattr()`, as well as when referencing `__dict__` directly. (Question: not understand?)

### 9.7 Odds and Ends

1. A piece of Python code that expects a particular abstract data type can often be passed a class that emulates the methods of that data type instead. For instance, if you have a function that formats some data from a file object, you can define a class with methods `read()` and `readline()` that get the data from a string buffer instead, and pass it as an argument.

2. Instance method objects have attributes, too: m.`__self__` is the instance object with the method `m()`, and `m.__func__` is the function object corresponding to the method.

### 9.8 Iterators

1. The use of iterators pervades and unifies Python. Behind the scenes, the for statement calls `iter()` on the container object. The function returns an iterator object that defines the method `__next__()` which accesses elements in the container one at a time. When there are no more elements, `__next__()` raises a StopIteration exception which tells the for loop to terminate.

2. It is easy to add iterator behavior to your classes. Define an `__iter__()` method which returns an object with a `__next__()` method. If the class defines `__next__()`, then `__iter__()` can just return self.

### 9.9 Generators

1. Generators are a simple and powerful tool for creating iterators. They are written like regular functions but use the yield statement whenever they want to return data. Each time `next()` is called on it, the generator resumes where it left off (it remembers all the data values and which statement was last executed).

2. What makes generators so compact is that the `__iter__()` and `__next__()` methods are created automatically.

3. Another key feature is that the local variables and execution state are automatically saved between calls. This made the function easier to write and much more clear than an approach using instance variables like `self.index` and `self.data`.

4. In addition to automatic method creation and saving program state, when generators terminate, they automatically raise StopIteration. In combination, these features make it easy to create iterators with no more effort than writing a regular function.

### 9.10 Generator Expressions

1. Some simple generators can be coded succinctly as expressions using a syntax similar to list comprehensions but with parentheses instead of square brackets. These expressions are designed for situations where the generator is used right away by an enclosing function. Generator expressions are more compact but less versatile than full generator definitions and tend to be more memory friendly than equivalent list comprehensions.
