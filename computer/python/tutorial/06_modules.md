# The Python Tutorial

## 06 Modules

1. Python has a way to put definitions in a file and use them in a script or in an interactive instance of the interpreter. Such a file is called a **module**; definitions from a module can be imported into other modules or into the main module (the collection of variables that you have access to in a script executed at the top level and in calculator mode).
    - Question: what does the sentences in the parentheses mean?

2. **A module is a file containing Python definitions and statements.** The file name is the module name with the suffix .py appended. Within a module, the module’s name (as a string) is available as the value of the global variable `__name__`.

### 6.1 More on Modules

1. A module can contain executable statements as well as function definitions. These statements are intended to initialize the module. They are executed only the **first time** the module name is encountered in an import statement. (They are also run if the file is executed as a script.)

2. In fact function definitions are also ‘statements’ that are ‘executed’; the execution of a module-level function definition enters the function name in the module’s global symbol table.

3. Each module has its own private symbol table, which is used as the global symbol table by all functions defined in the module. Thus, the author of a module can use global variables in the module without worrying about accidental clashes with a user’s global variables. On the other hand, if you know what you are doing you can touch a module’s global variables with the same notation used to refer to its functions, `modname.itemname`.
    - Can we access all the symbol in module's private symbol table by using the notation `modname.itemname`?
    - What's the differences between modules's private symbol table and global symbol table?

4. Modules can import other modules. It is customary but not required to place all import statements at the beginning of a module (or script, for that matter). The imported module names are placed in the importing module’s global symbol table.

5. There is a variant of the import statement that imports names from a module directly into the importing module’s symbol table. For example:
```
>>> from fibo import fib, fib2
>>> fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

6. There is even a variant to import all names that a module defines:
```
>>> from fibo import *
>>> fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```
    - This imports all names except those beginning with an underscore (\_). In most cases Python programmers **do not use** this facility since it introduces an unknown set of names into the interpreter, possibly **hiding** some things you have already defined.
    - Note that in general the practice of importing \* from a module or package is **frowned upon**, since it often causes **poorly readable** code. However, it is okay to use it to save typing in **interactive sessions**.

7. For efficiency reasons, each module is only imported once per interpreter session. Therefore, if you change your modules, you must restart the interpreter – or, if it’s just one module you want to test interactively, use `importlib.reload()`, e.g. `import importlib; importlib.reload(modulename)`.

#### 6.1.1 Executing modules as scripts

1. When you run a Python module with `python fibo.py <arguments>`, the code in the module will be executed, just as if you imported it, but with the `__name__` set to `"__main__"`. That means that by adding this code at the end of your module:
```
if __name__ == "__main__":
    import sys
    fib(int(sys.argv[1]))
```
you can make the file usable as a script as well as an importable module, because the code that parses the command line only runs if the module is executed as the “main” file.

#### 6.1.2 The Module Search Path

1. When a module named spam is imported, the interpreter first searches for a built-in module with that name. If not found, it then searches for a file named spam.py in a list of directories given by the variable `sys.path`. sys.path is initialized from these locations:
    - The directory containing the input script (or the current directory when no file is specified).
    - **PYTHONPATH** (a list of directory names, with the same syntax as the shell variable PATH).
    - The installation-dependent default.

2. On file systems which support symlinks, the directory containing the input script is calculated after the symlink is followed. In other words the directory containing the symlink is not added to the module search path. （伍注：比如有个链接`/somedir/somelink`指向`/actualdir/actualpath`，那么`/somedir`不会添加到搜索路径中，而`/actualdir`则会。）

3. After initialization, Python programs can modify sys.path. The directory containing the script being run is placed at the beginning of the search path, ahead of the standard library path. **This means that scripts in that directory will be loaded instead of modules of the same name in the library directory. This is an error unless the replacement is intended.**

#### 6.1.3 "Compiled" Python file

1. To speed up loading modules, Python caches the compiled version of each module in the `__pycache__` directory under the name module.version.pyc, where the version encodes the format of the compiled file; it generally contains the Python version number. For example, in CPython release 3.3 the compiled version of spam.py would be cached as `__pycache__/spam.cpython-33.pyc`. This naming convention allows compiled modules from different releases and different versions of Python to coexist.

2. Python checks the modification date of the source against the compiled version to see if it’s out of date and needs to be recompiled. This is a completely automatic process. Also, the compiled modules are platform-independent, so the same library can be shared among systems with different architectures.

3. Python does not check the cache in two circumstances. First, it always recompiles and does not store the result for the module that’s loaded directly from the command line. Second, it does not check the cache if there is no source module. To support a non-source (compiled only) distribution, the compiled module must be in the source directory, and there must not be a source module.

4. Some tips about Python compiling for experts:
    - You can use the `-O` or `-OO` switches on the Python command to reduce the size of a compiled module. The `-O` switch removes assert statements, the `-OO` switch removes both assert statements and `__doc__` strings. Since some programs may rely on having these available, you should only use this option if you know what you’re doing. “Optimized” modules have an `opt-` tag and are usually smaller. Future releases may change the effects of optimization.
    - A program doesn’t run any faster when it is read from a .pyc file than when it is read from a .py file; the only thing that’s faster about .pyc files is the speed with which they are loaded. (Question: Why?)
    - The module compileall can create .pyc files for all modules in a directory.
    - There is more detail on this process, including a flow chart of the decisions, in [PEP 3147](https://www.python.org/dev/peps/pep-3147/).

### 6.2 Standard Modules

1. Python comes with a library of standard modules, described in a separate document, the **Python Library Reference** (“Library Reference” hereafter). Some modules are built into the interpreter; these provide access to operations that are not part of the core of the language but are nevertheless built in, either for efficiency or to provide access to operating system primitives such as system calls. The set of such modules is a configuration option which also depends on the underlying platform. For example, the winreg module is only provided on Windows systems. One particular module deserves some attention: `sys`, which is built into every Python interpreter. The variables `sys.ps1` and `sys.ps2` define the strings used as primary and secondary prompts:
```
>>> import sys
>>> sys.ps1
'>>> '
>>> sys.ps2
'... '
>>> sys.ps1 = 'C> '
C> print('Yuck!')
Yuck!
C>
```
These two variables are only defined if the interpreter is in interactive mode.

2. The variable sys.path is a list of strings that determines the interpreter’s search path for modules. It is initialized to a default path taken from the environment variable PYTHONPATH, or from a built-in default if PYTHONPATH is not set.

### 6.3 The dir() Function

1. The built-in function dir() is used to find out which names a module defines. It returns a sorted list of strings.

2. Without arguments, dir() lists the names you have defined currently. Note that it lists all types of names: variables, modules, functions, etc.

3. dir() does not list the names of built-in functions and variables. If you want a list of those, they are defined in the standard module builtins:
```
>>> import builtins
>>> dir(builtins)  
```

### 6.4 Packages

1. Packages are a way of structuring Python’s module namespace by using “dotted module names”. For example, the module name A.B designates a submodule named B in a package named A. Just like the use of modules saves the authors of different modules from having to worry about each other’s global variable names, the use of dotted module names **saves the authors of multi-module packages like NumPy or Pillow from having to worry about each other’s module names**. (伍注：A package is a collection of modules.）

2. The `__init__.py` files are required to make Python treat directories containing the file as packages. This prevents directories with a common name, such as string, unintentionally hiding valid modules that occur later on the module search path. In the simplest case, `__init__.py` can just be an empty file, but it can also execute initialization code for the package or set the `__all__` variable, described later. (Notice: The character '-' isn't allowed in the module name.)

3. When using from package import item, the item can be either a submodule (or subpackage) of the package, or some other name defined in the package, like a function, class or variable. The import statement first tests whether the item is defined in the package; if not, it assumes it is a module and attempts to load it. If it fails to find it, an ImportError exception is raised.

4. When using syntax like `import item.subitem.subsubitem`, each item except for the last must be a package; the last item can be a module or a package but can’t be a class or function or variable defined in the previous item.

5. Packages support one more special attribute, `__path__`. This is initialized to be a list containing the name of the directory holding the package’s `__init__.py` before the code in that file is executed. This variable can be modified; doing so affects future searches for modules and subpackages contained in the package.
