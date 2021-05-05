# 《The Design and Evolution of C++》读书笔记

## 0 Notes to the Reader

注：为简便起见，把前言部分也归为第0章来进行分析。

### Q1：这一章的内容是什么？

> 备注：用一句话或最多几句话来回答。

本章介绍了本书的写作动机、全书组织结构及C++的一些基本信息。

### Q2：这一章的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Preface
  - origin of the book
    - HOPL-2 conference asked for a paper on the history of C++
    - a friend asked for a book on the design of C++
  - content of the book
    - explains how C++ evolved
    - describes the key problems, design aims, language ideas, and constraints
- Introduction
  - C++'s design aim: provide both program organization facilities and efficiency and flexibility
  - the purpose of the book: documents the aims, track their evolution
- How to Read this Book
  - book organization
    - Part 1: in chronologic order
    - Part 2: major language features
  - all nontechnical aspects is on part 1
- C++ Timeline
  - 1979: Work on C with Classes starts
  - 1983: 1st C++ implementation in use, C++ named
  - 1990: Templates and Exceptions accepted
  - 1993: Run-time type identification and Namespaces accepted
- Focus on Use and Users
- Programming Languages
  - refused to compare C++ to other languages
    - effort
    - impartiality
    - up-to-date
  - C++ family chart
  - What is a programming language and what is its main purpose
  - What computer science is and how languages ought to be designed
  - eclectic
  - all successful languages are grown
- References

### Q3：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

- 为什么写作本书
- 本书的内容是如何组织的

### Q4：这一章的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- HOPL: History of Programming Languages. 一个关于编程语言历史的会议。
- Run-time type identification

### Q5：这一章的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

#### Preface

- What really evolved was the C++ users' understanding of their practical problems and of the tools needed to help solve them.

> 伍注：真正在演进的是C++用户对实际问题及所需工具的理解。

#### Introduction

- C++ was designed to provide Simula's facilities for **program organization** together with C's **efficiency and flexibility for systems programming**.

#### Programming Languages

- There is no agreement on what a programming language really is and what its main purpose is supposed to be.

- My view is that a general-purpose programming language must be **all of those** to serve its diverse set of users.
  - A tool for instructing machines
  - A means of communicating between programmer
  - A vehicle for expressing high-level designs
  - A notation for algorithms
  - A means of controlling computerized devices

> 伍注：作者认为，编程语言需要提供控制机器、表达高层设计支持、算法、促进程序员交流等功能。

- I think computer science borrows techniques and approaches from **all of these disciplines**.
  - mathematics
  - engineering
  - architecture
  - art
  - biology
  - sociology
  - philosophy

> 伍注：作者认为，计算机科学需要借鉴其他科学的技术和方法。但我不理解从生物学中可借鉴什么？

- To serve its users, a general-purpose programming language must be **eclectic** and take many practical and sociological factors into account.

> 伍注：通用程序语言必须是折衷主义的，需要考虑许多实践性和社会学的因素。

- In particular, every language is designed to solve a particular set of problems at a particular time according to the understanding of a particular group of people.

- From this initial design, it grows to meet new demands and reflects new understandings of problems and of tools and techinques for solving them. ... It is my firm belief that **all successful languages are grown and not merely designed from first principles**.

> 伍注：成功的编程语言都是与时俱进的。

### Q6：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

### Q7：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

### Q8：我有哪些疑问？

### Q9：这一章说得有道理吗？为什么？

> 备注：0. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这一章、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

### Q10：如何拓展这一章？

#### Q10.1：为什么是这样的？为什么发展成这样？为什么需要它？

> 备注：深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。简单地说就是问为什么：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

#### Q10.2：有哪些相似的知识点？它们之间的联系是什么？

> 备注：水平拓展，指类比相似的知识点。知识点的载体可以是书籍、网站、视频等。相似点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

##### HOPL

HOPL conference 记录有不少编程语言的历史的论文：

- C
- C++
- Erlang
- Haskell
- Lisp
- JavScript
- etc.

#### Q10.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

### Q11：这一章和我有什么关系？

> 备注：这一章的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这一章的理论应用到实践中？

