# 《Google C++ Style Guide》文档分析笔记


## Q1: 这个文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

实用类/计算机科学。

## Q2：这个文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

介绍Google公司制定的C++编程规范，以控制C++程序的复杂度。

## Q3：这个文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Background
  - The goal of this guide is to **manage this complexity** by describing in detail the **dos and don'ts** of writing C++ code.
- Goals of the Style Guide
  - Optimize for the reader, not the writer
  - Avoid surprising or dangerous constructs
  - Avoid constructs that our average C++ programmer would find tricky or hard to maintain
- C++ Version

- Header Files
  - Self-contained Headers
  - The #define Guard
  - Include What You Use
  - Avoid using forward declarations
  - Define functions inline only when they are small
  - Names and Order of Includes
- Scoping
  - Place code in a namespace
  - Internal Linkage
  - Nonmember, Static Member, and Global Functions (to_study)
  - Place a function's variables in the narrowest scope possible, and initialize variables in the declaration.
  - Static and Global Variables (to_study)
  - thread_local Variables (to_study)
- Classes
  - Doing Work in Constructors
  - Do not define implicit conversions.
  - Copyable and Movable Types
  - Structs vs Classes
  - Structs vs. Pairs and Tuples
  - Overator Overloading
  - Access Control
  - Declaration Order
- Functions
  - Inputs and Outputs
  - Write Short Functions
  - Function Overloading
  - Default Arguments
  - Trailing Return Type Syntax
- Google-Specific Magic
  - Ownership and Smart Pointers
  - cpplint
- Other C++ Features (to_study)
  - Rvalue References
  - Friends
  - Exceptions
  - noexcept
  - RTTI (to_study)
  - Casting (to_study)
  - Streams (to_study)
  - Preincrement and Predecrement
  - Use of const
  - Use of constexpr (to_study)
  - Integer Types
  - 64-bit Protability (to_study)
  - Preprocessor Macros
  - 0 and nullptr/NULL
  - sizeof
  - std::hash (to_study)
- Inclusive Language
- Naming
  - General Naming Rules
  - File Names
  - Type Names
  - Variable Names
  - Constant Names
  - Functions Names
  - Namespace Names
  - Enumerator Names
  - Macro Names
  - Exceptions to Naming Rules
- Comments
  - Comment Style
  - File Comments
  - Class Comments
  - Function Comments
  - Variable Comments
  - Implementation Comments
  - Function Argument Comments
  - Don'ts
  - Punctuation, Spelling and Grammar
  - TODO Comments
- Formatting
  - Line Length
  - Non-ASCII Characters
  - Spaces vs. Tabs
  - Function Declarations and Definitions
  - Lambda Expressions
  - Floating-point Literals
  - Function Calls
  - Braced Initializer List Format
  - Conditionals
  - Loops and Switch Statements
  - Pointer and Reference Expressions
  - Boolean Expressions
  - Return Values
  - Variable and Array Initialization
  - Preprocessor Directives
  - Class Format
  - Constructor Initializer Lists
  - Namespace Formatting
  - Horizontal Whitespace
  - Vertical Whitespace
- Exceptions to the Rules
  - Existing Non-conformant Code
  - Windows Code
- Parting Words

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

## Q5：这个文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- Static Member
- Static and Global Variable
- thread_local Variables
- implicit conversion
- Copyable and Movable Types
- Inheritance vs Composition
- interface inheritance 
- implementation inheritance
- Trailing Return Type Syntax
- RTTI(Run-Time Type Information)
- Rvalue References
- absl/string
- constexpr
- specializations
-

## Q6：这个文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

### Header Files

> In general, every .cc file should have an associated .h file. There are some common exceptions, such as unit tests and small .cc files containing just a main() function.

> Header files should be **self-contained** (compile on their own) and end in .h. Non-header files that are meant for inclusion should end in .inc and be used sparingly.

> All header files should have #define guards to prevent multiple inclusion. The format of the symbol name should be `<PROJECT>_<PATH>_<FILE>_H_`.

> If a source or header file refers to a symbol defined elsewhere, the file should **directly** include a header file which properly intends to provide a declaration or definition of that symbol. It should not include header files for any other reason.

> Do not rely on transitive inclusions.

> Avoid using forward declarations where possible. (Wu: Avoid using extern declaration.)

> Define functions inline only when they are small, say, 10 lines or fewer.

> Include headers in the following order: Related header, C system headers, C++ standard library headers, other libraries' headers, your project's headers.

> Separate each non-empty group with one blank line.

### Scoping

> Namespaces should have unique names based on the project name, and possibly its path. Do not use using-directives (e.g., using namespace foo). Do not use inline namespaces.

> When definitions in a .cc file do not need to be referenced outside that file, give them internal linkage by placing them in an unnamed namespace or declaring them static. Do not use either of these constructs in .h files.

> Prefer placing nonmember functions in a namespace; use completely global functions rarely. Do not use a class simply to group static members. Static methods of a class should generally be closely related to instances of the class or the class's static data.

> Variables needed for if, while and for statements should normally be declared within those statements, so that such variables are confined to those scopes.

### Classes

> Avoid virtual method calls in constructors, and avoid initialization that can fail if you can't signal an error.

> Do not define implicit conversions. Use the explicit keyword for conversion operators and single-argument constructors.

> A class's public API must make clear whether the class is copyable, move-only, or neither copyable nor movable. Support copying and/or moving if these operations are clear and meaningful for your type.

> Use a struct only for passive objects that carry data; everything else is a class.

> Prefer to use a struct instead of a pair or a tuple whenever the elements can have meaningful names.

> Composition is often more appropriate than inheritance. When using inheritance, make it public.

> Overload operators judiciously. Do not use user-defined literals.

> Make classes' data members private, unless they are constants.

> Group similar declarations together, placing public parts earlier.

> Within each section, prefer grouping similar kinds of declarations together, and prefer the following order: types (including typedef, using, and nested structs and classes), constants, factory functions, constructors and assignment operators, destructor, all other methods, data members.

### Functions

> Prefer using return values over output parameters: they improve readability, and often provide the same or better performance.

> Prefer to return by value or, failing that, return by reference. Avoid returning a pointer unless it can be null.

> Avoid defining functions that require a const reference parameter to outlive the call.

> When ordering function parameters, put all input-only parameters before any output parameters. In particular, do not add new parameters to the end of the function just because they are new; place new input-only parameters before the output parameters.

> Use overloaded functions (including constructors) only if a reader looking at a call site can get a good idea of what is happening without having to first figure out exactly which overload is being called.

> If you can document all entries in the overload set with a single comment in the header, that is a good sign that it is a well-designed overload set.

> Default arguments are allowed on non-virtual functions when the default is guaranteed to always have the same value.

> In some other cases, default arguments can improve the readability of their function declarations enough to overcome the downsides above, so they are allowed. When in doubt, use overloads.

> Use trailing return types only where using the ordinary syntax (leading return types) is impractical or much less readable.

### Google-Specific Magic

> Prefer to have single, fixed owners for dynamically allocated objects. Prefer to transfer ownership with smart pointers.

> Use cpplint.py to detect style errors.

### Other C++ Features

> Use rvalue references only in certain special cases listed below.

> We allow use of friend classes and functions, within reason.

> We do not use C++ exceptions.

> Specify noexcept when it is useful and correct.

> Avoid using run-time type information (RTTI).

> Use C++-style casts like `static_cast<float>(double_value)`, or brace initialization for conversion of arithmetic types like `int64 y = int64{1} << 42`. Do not use cast formats like `(int)x` unless the cast is to void. You may use cast formats like `T(x)` only when `T` is a class type.

> Use streams only when they are the best tool for the job. This is typically the case when the I/O is ad-hoc, local, human-readable, and targeted at other developers rather than end-users. Be consistent with the code around you, and with the codebase as a whole; if there's an established tool for your problem, use that tool instead. In particular, logging libraries are usually a better choice than std::cerr or std::clog for diagnostic output, and the libraries in absl/strings or the equivalent are usually a better choice than std::stringstream.

> Use the prefix form (++i) of the increment and decrement operators unless you need postfix semantics.

> In APIs, use const whenever it makes sense. constexpr is a better choice for some uses of const.

> Use constexpr to define true constants or to ensure constant initialization.

> Of the built-in C++ integer types, the only one used is int. If a program needs a variable of a different size, use a precise-width integer type from <stdint.h>, such as int16_t. If your variable represents a value that could ever be greater than or equal to 2^31 (2GiB), use a 64-bit type such as int64_t. Keep in mind that even if your value won't ever be too large for an int, it may be used in intermediate calculations which may require a larger type. When in doubt, choose a larger type.

> Avoid defining macros, especially in headers; prefer inline functions, enums, and const variables. Name macros with a project-specific prefix. Do not use macros to define pieces of a C++ API.

> Use nullptr for pointers, and '\0' for chars (and not the 0 literal).

> Prefer sizeof(varname) to sizeof(type).

> Do not define specializations of std::hash.

### Naming

> Use names that describe the purpose or intent of the object.

> Minimize the use of abbreviations that would likely be unknown to someone outside your project (especially acronyms and initialisms). Do not abbreviate by deleting letters within a word. As a rule of thumb, an abbreviation is probably OK if it's listed in Wikipedia.

> Filenames should be all lowercase and can include underscores (\_) or dashes (-). Follow the convention that your project uses. If there is no consistent local pattern to follow, prefer "\_".

> C++ files should end in .cc and header files should end in .h. Files that rely on being textually included at specific points should end in .inc

> Do not use filenames that already exist in /usr/include.h.

> In general, make your filenames very specific.

> Type names start with a capital letter and have a capital letter for each new word, with no underscores.

> The names of variables (including function parameters) and data members are all lowercase, with underscores between words. Data members of classes (**but not structs**) additionally have **trailing underscores**.

> Variables declared constexpr or const, and whose value is fixed for the duration of the program, are named with a leading "k" followed by mixed case. Underscores can be used as separators in the rare cases where capitalization cannot be used for separation.

> Regular functions have mixed case; accessors and mutators (get and set functions) may be named like variables. Ordinarily, functions should start with a capital letter and have a capital letter for each new word.

> Namespace names are all lower-case, with words separated by underscores. Top-level namespace names are based on the project name . Avoid collisions between nested namespaces and well-known top-level namespaces.

> Enumerators (for both scoped and unscoped enums) should be named like constants, not like macros.

### Comments

> `//` is much more common.

> Start each file with license boilerplate.

> File comments describe the contents of a file. If a file declares, implements, or tests exactly one abstraction that is documented by a comment at the point of declaration, file comments are not required. All other files must have file comments.

> New files should usually not contain copyright notice or author line.

> If a .h declares multiple abstractions, the file-level comment should broadly describe the contents of the file, and how the abstractions are related. A 1 or 2 sentence file-level comment may be sufficient. The detailed documentation about individual abstractions belongs with those abstractions, not at the file level.

> Do not duplicate comments in both the .h and the .cc. Duplicated comments diverge.

> Every non-obvious class or struct declaration should have an accompanying comment that describes what it is for and how it should be used.

> The class comment should provide the reader with enough information to know how and when to use the class, as well as any additional considerations necessary to correctly use the class. Document the synchronization assumptions the class makes, if any. If an instance of the class can be accessed by multiple threads, take extra care to document the rules and invariants surrounding multithreaded use.

> Declaration comments describe use of the function (when it is non-obvious); comments at the definition of a function describe operation. (Wu: Declaration comments describe what it does, definition comments describe how it does.)

> Function comments should be written with an implied subject of This function and should start with the verb phrase; for example, "Opens the file", rather than "Open the file". In general, these comments do not describe how the function performs its task. Instead, that should be left to comments in the function definition.

> Types of things to mention in comments at the function declaration:
  - What the inputs and outputs are. If function argument names are provided in `backticks`, then code-indexing tools may be able to present the documentation better.
  - For class member functions: whether the object remembers reference arguments beyond the duration of the method call, and whether it will free them or not.
  - If the function allocates memory that the caller must free.
  - Whether any of the arguments can be a null pointer.
  - If there are any performance implications of how a function is used.
  - If the function is re-entrant. What are its synchronization assumptions?

> If there is anything tricky about how a function does its job, the function definition should have an explanatory comment.

> Note you should not just repeat the comments given with the function declaration, in the .h file or wherever. It's okay to recapitulate briefly what the function does, but the focus of the comments should be on how it does it.

> In particular, add comments to describe the existence and meaning of sentinel values, such as nullptr or -1, when they are not obvious.

> All global variables should have a comment describing what they are, what they are used for, and (if unclear) why it needs to be global.

> In your implementation you should have comments in tricky, non-obvious, interesting, or important parts of your code.

> Also, lines that are non-obvious should get a comment at the end of the line. These end-of-line comments should be separated from the code by 2 spaces.

> When the meaning of a function argument is nonobvious, consider one of the following remedies:
  - If the argument is a literal constant, and the same constant is used in multiple function calls in a way that tacitly assumes they're the same, you should use a named constant to make that constraint explicit, and to guarantee that it holds.
  - Consider changing the function signature to replace a bool argument with an enum argument. This will make the argument values self-describing.
  - For functions that have several configuration options, consider defining a single class or struct to hold all the options , and pass an instance of that.
  - Replace large or complex nested expressions with named variables.
  - As a last resort, use comments to clarify argument meanings at the call site.

> Do not state the obvious. In particular, don't literally describe what code does, unless the behavior is nonobvious to a reader who understands C++ well. Instead, provide higher level comments that describe why the code does what it does, or make the code self describing.

> Pay attention to punctuation, spelling, and grammar.

> Use TODO comments for code that is temporary, a short-term solution, or good-enough but not perfect.

> TODOs should include the string TODO in all caps, followed by the name, e-mail address, bug ID, or other identifier of the person or issue with the best context about the problem referenced by the TODO.

### Formatting

> Each line of text in your code should be at most 80 characters long.

> Non-ASCII characters should be rare, and must use UTF-8 formatting.

> Use only spaces, and indent 2 spaces at a time.

> Return type on the same line as function name, parameters on the same line if they fit. Wrap parameter lists which do not fit on a single line as you would wrap arguments in a function call.

> Floating-point literals should always have a radix point, with digits on both sides, even if they use exponential notation. Readability is improved if all floating-point literals take this familiar form, as this helps ensure that they are not mistaken for integer literals, and that the E/e of the exponential notation is not mistaken for a hexadecimal digit. It is fine to initialize a floating-point variable with an integer literal (assuming the variable type can exactly represent that integer), but note that a number in exponential notation is never an integer literal.

> Either write the call all on a single line, wrap the arguments at the parenthesis, or start the arguments on a new line indented by four spaces and continue at that 4 space indent. In the absence of other considerations, use the minimum number of lines, including placing multiple arguments on each line where appropriate.

> Format a braced initializer list exactly like you would format a function call in its place.

> Be careful when using a braced initialization list {...} on a type with an std::initializer_list constructor. A nonempty braced-init-list prefers the std::initializer_list constructor whenever possible. Note that empty braces {} are special, and will call a default constructor if available. To force the non-std::initializer_list constructor, use parentheses instead of braces.

> The hash mark that starts a preprocessor directive should always be at the beginning of the line.

> Sections in public, protected and private order, each indented one space.

> Constructor initializer lists can be all on one line or with subsequent lines indented four spaces.

> The contents of namespaces are not indented.

> Use of horizontal whitespace depends on location. Never put trailing whitespace at the end of a line.

> Minimize use of vertical whitespace.

### Exceptions to the Rules

> If you find yourself modifying code that was written to specifications other than those presented by this guide, you may have to diverge from these rules in order to stay consistent with the local conventions in that code. If you are in doubt about how to do this, ask the original author or the person currently responsible for the code. Remember that consistency includes local consistency, too.

### Parting Words

> Use common sense and BE CONSISTENT.

> Local style is also important.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

## Q10：这个文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这个文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

## Q11：如何拓展这个文档？

### Q11.1：为什么是这样的？为什么发展成这样？为什么需要它？

> 备注：深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。简单地说就是问为什么：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

### Q11.2：有哪些相似的知识点？它们之间的联系是什么？

> 备注：水平拓展，指类比相似的知识点。知识点的载体可以是书籍、网站、视频等。相似点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

### Q11.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

## Q12：这个文档和我有什么关系？

> 备注：这个文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这个文档的理论应用到实践中？


## 参考资料

1. [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)

2. [googletest](https://github.com/google/googletest)

3. [cpplint](https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py)
