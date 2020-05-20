# Python 编程规范

## PEP 8

[PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)

### 命名规范

#### Package Names

Python packages should also have short, all-lowercase names, although the use of underscores is discouraged.（伍注：小写，尽量不带下划线）

#### Module Names

Modules should have short, all-lowercase names. Underscores can be used in the module name if it improves readability.

#### Class Names

Class names should normally use the **CapWords** convention.

#### Function Names

Function names should be lowercase, with words separated by underscores as necessary to improve readability.

#### Variable Names

- Normal Variable Names: Variable names follow the same convention as function names.
- Type Variable Names: Names of type variables should normally use **CapWords** preferring short names: T, AnyStr, Num. It is recommended to add suffixes `_co` or `_contra` to the variables used to declare covariant or contravariant behavior correspondingly. (Question: what is type variable ?)

#### Exception Names

Because exceptions should be classes, the class naming convention applies here. However, you should use the suffix **"Error"** on your exception names (if the exception actually is an error).

#### Function and Method Arguments

- Always use `self` for the first argument to instance methods.
- Always use `cls` for the first argument to class methods.
- If a function argument's name clashes with a reserved keyword, it is generally better to append a single trailing underscore rather than use an abbreviation or spelling corruption. Thus `class_` is better than clss. (Perhaps better is to avoid such clashes by using a synonym.)

#### Method Names and Instance Variables

- Use the function naming rules: lowercase with words separated by underscores as necessary to improve readability.
- Use one leading underscore only for non-public methods and instance variables.
- To avoid name clashes with subclasses, use two leading underscores to invoke Python's name mangling rules.

#### Constants

Constants are usually defined on a module level and written in **all capital letters with underscores** separating words. Examples include MAX_OVERFLOW and TOTAL.

## 文件名

1. 文件名应该使用 lowercase_separated_by_underscores 的风格。
