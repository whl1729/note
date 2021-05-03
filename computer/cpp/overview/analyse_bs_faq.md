# 《Bjarne Stroustrup's FAQ》文档分析笔记

## Q1: 这个文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

理论类。计算机科学/编程语言/C++

## Q2：这个文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

列出关于C++的一些常见问题并解答。

## Q3：这个文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- General
- Learning C++
- Standardization
- Books
- Other languages
- C and C++
- History of C++
- Etc. C++ questions
- Personal

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

回答关于C++的一些常见问题。

## Q5：这个文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- invariant
- parameterization
- ad hoc polymorphism: 特设多态。ad hoc指这类多态并不是类型系统的基本特性，不是像参数多态那样适用于无穷多的类型，而是针对特定问题的解决方案。

## Q6：这个文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

### General

#### What is so great about classes?

- Classes are there to help you organize your code and to reason about your programs. ... Classes significantly helps maintenance.

- Classes make the relationships among data items and functions explicit. ... With classes, more of the high-level structure of your program is reflected in the code, not just in the comments.

- Even data structures can benefit from auxiliary functions, such as constructors.

- **invariant**
  - When designing a class, it is often useful to consider what's true for every object of the class and at all times. Such a property is called an invariant.
  - It is the job of every constructor to establish the class invariant, so that every member function can rely on it.
  - Every member function must leave the invariant valid upon exit.

> 伍注：作者认为类的伟大之处在于：帮助组织代码和分析程序、提高可维护性、增加可读性、为用户提供简洁易用的接口（通过封装）

> 伍注：突然体会到：构造函数/析构函数的作用就是一个辅助函数，在语言层面让用户可以定义数据类型的资源初始化和释放操作。

> 伍注：从作者的举例中可以看到，构造函数中可以做一些可能失败的操作（如申请资源），操作失败后就抛出异常。

#### What is "OOP" and what's so great about it?

- object-oriented programming is a style of programming relying of encapsulation, inheritance, and polymorphism.

- In the context of C++, OOP means programming using class hierarchies and virtual functions to allow manipulation of objects of a variety of types through well-defined interfaces and to allow a program to be extended incrementally through derivation.

- Not every program should be object-oriented.

#### What is "generic programming" and what's so great about it?

- Generic programming is programming based on **parameterization**.（参数化）

- The aim of generic programming is to generalize a useful algorithm or data structure to its most general and useful form.

- Generic programming is in some ways more flexible than object-oriented programming. In particular, it does not depend on hierarchies.

- Generic programming is generally more structured than OOP
  - generic programming is "parametric polymorphism" （参数多态）
  - object-oriented programming is "ad hoc polymorphism" （ad hoc 多态）
  - In the context of C++, generic programming resolves all names at compile time; it does not involve dynamic (run-time) dispatch. This has led generic programming to become dominant in areas where run-time performance is important.

#### Why does C++ allow unsafe code?

- Reasons
  - to access hardware directly (e.g. to treat an integer as a pointer to (address of) a device register)
  - to achieve optimal run-time and space performance (e.g. unchecked access to elements of an array and unchecked access to an object through a pointer)
  - to be compatible with C

- Avoid unsafe code whenever you don't actually need one of those three features:
  - don't use casts
  - keep arrays out of interfaces (hide them in the innards of high-performance functions and classes where they are needed and write the rest of the program using proper strings, vectors, etc.)
  - avoid `void*` (keep them inside low-level functions and data structures if you really need them and present type safe interfaces, usually templates, to your users)
  - avoid unions
  - if you have any doubts about the validity of a pointer, use a smart pointer instead,
  - don't use "naked" news and deletes (use containers, resource handles, etc., instead)
  - don't use ...-style variadic functions ("printf style")
  - Avoid macros excpt for include guards

### Learning C++

#### What is the best book to learn C++ from?

- For freshman: Programming: Principles and Practice using C++
- Classical textbook: The C++ Programming Language (4th edition)
- Quick overview: A Tour of C++ (second edition)
- why C++ is the way it is: The Design and Evolution of C++ (D&E)
- up-to-date follow-up to D&E: Thriving in a Crowded and Changing World: C++ 2006-2020

#### Why are you so keen on portability?

- Successful software is long-lived; life-spans of decades are not uncommon.
- Being tied to a single platform or single vendor, limits the application/program's potential use.

### C and C++

#### Do you really think that C and C++ could be merged into a single language?

- [C and C++: Case Studies in Compatibility](https://www.stroustrup.com/examples_short.pdf)
- [C and C++: A Case for Compatibility](https://www.stroustrup.com/compat_short.pdf)
- [C and C++: Siblings](https://www.stroustrup.com/siblings_short.pdf)
- [Sibling rivalry: C and C++](https://www.stroustrup.com/sibling_rivalry.pdf)

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

### Q9.1 dynamic dispatch 会带来额外的时间开销？体现在哪里？

## Q10：这个文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这个文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

## Q11：如何拓展这个文档？

### Q11.1：为什么是这样的？为什么发展成这样？为什么需要它？

> 备注：深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。简单地说就是问为什么：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

### Q11.2：有哪些相似的知识点？它们之间的联系是什么？

> 备注：水平拓展，指类比相似的知识点。知识点的载体可以是书籍、网站、视频等。相似点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

#### Bjarne Stroustrup 推荐的其他资源

- [Bjarne Stroustrup's C++ Style and Technique FAQ](https://www.stroustrup.com/bs_faq2.html)
- [The C++ Programming Language](https://www.stroustrup.com/C++.html)
- [C++11 - the new ISO C++ standard](https://www.stroustrup.com/C++11FAQ.html)
- [isocpp.org C++ FAQ](https://isocpp.org/faq)
- [A Tour of C++](https://isocpp.org/tour)
- [Why C++ is not just an Object-Oriented Programming Language](https://www.stroustrup.com/oopsla.pdf)
- History
  - [A History of C++: 1979-1991](https://www.stroustrup.com/hopl2.pdf)
  - [Evolving a language in and for the real world: C++ 1991-2006](https://www.stroustrup.com/hopl-almost-final.pdf)
  - [Thriving in a Crowded and Changing World: C++ 2006-2020](https://dl.acm.org/doi/pdf/10.1145/3386320)
- [Learning Standard C++ as a New Language](https://www.stroustrup.com/new_learning.pdf)

#### Bjarne Stroustrup 视频资源

- [Bjarne Stroustrup's 2012 "Going Native" Keynote](https://channel9.msdn.com/Events/GoingNative/GoingNative-2012/Keynote-Bjarne-Stroustrup-Cpp11-Style)

### Q11.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

## Q12：这个文档和我有什么关系？

> 备注：这个文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这个文档的理论应用到实践中？

