# 《The Design and Evolution of C++》书籍分析笔记

## Chapter 4 C++ Language Design Rules

### Q1：这一章的内容是什么？

> 备注：用一句话或最多几句话来回答。

介绍C++语言的设计规则。

### Q2：这一章的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Rules and Principles
- General Rules
- Design Support Rules
- Language-Technical Rules
- Low-Level Programming Support Rules
- A Final Word

### Q3：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

### Q4：这一章的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

### Q5：这一章的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

#### 4.1 Rules and Principles

- Overall view
  - To be genuinely useful and pleasant to work with, a programming language must be designed according to an **overall view** that guides the design of its individual language features.
  - For C++, this overall view takes the form of a set of **rules and constraints**.

- Fundamental Aims of C++
  - C++ makes programming more enjoyable for serious programmers.
  - C++ is a general-purpose programming language that
    - is a better C
    - supports data abstraction
    - supports object-oriented programming

- 4 parts of Rules
  - Overall ideals for the whole language
  - C++'s role in supporting design
  - Technicalities related to the form of the language
  - C++'s role as a language for low-level systems programming

#### 4.2 General Rules

- The most general and most important C++ rules are almost **sociological** in their focus on the community C++ serves.

- General rules
  - C++'s evolution must be driven by real problems
  - Don't get involved in a sterile quest for perfection
  - C++ must be useful now
  - Every feature must have a reasonably obvious implementation
  - Always provide a transition path
  - C++ is a language, not a complete system
  - Provide comprehensive support for each supported style
  - Don't try to force People

- The right motivation for a change to C++ is for several independent programmers to demonstrate how the language is insufficiently expressive for their projects.

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

#### Q10.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

### Q11：这一章和我有什么关系？

> 备注：这一章的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这一章的理论应用到实践中？

