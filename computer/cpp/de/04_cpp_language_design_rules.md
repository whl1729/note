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

> 伍注：如何记忆「一般性规则」呢？首先，它们基本上是社会工程学层面（与人打交道）的规则。
> 前3条体现了「实用主义」：问题驱动、不求完美、当下能用。
> 第4条是针对编译器设计者，第5条和第6条对于从其他语言迁移到C++语言的开发者比较重要，第7条和第8条则是针对所有开发者。
> 可见，这些规则大部分与人相关。

- The right motivation for a change to C++ is for several independent programmers to demonstrate how the language is insufficiently expressive for their projects.

#### 4.3 Design Support Rules

- The design support rules relate primarily to C++'s role in supporting design based on notions of **data abstraction and object-oriented programming**. That is, they are more concerned with the language's role as a support for **thinking and expression of high-level ideas**.

- Design support rules
  - Support sound design notions
  - Provide facilities for program organization
  - Say what you mean
  - All features must be affordable
  - It is more important to allow a useful feature than to prevent every misuse
  - Support composition of software from separately developed parts

> 伍注：如何记忆「设计性规则」呢？
> 第3条、第2条和第6条按照从小到大的顺序讨论了语句、代码块、程序整体的设计原则：语句要有较强的表达能力、代码块具有组织性、程序间具有可组合性。
> 第1条、第4条和第5条则从一致性、成本和作用讨论了引入一个新特性需要考虑的原则：每个特性都要符合整体设计原则、每个特性都必须是能够负担的、允许一个有用的特性比防止各种误用更重要。

#### 4.4 Language-Technical Rules

- The language-technical rules address questions of **how things are expressed in C++** rather than questions of what can be expressed.

- Language-technical rules
  - No implicit violations of the static type system
  - Provide as good support for user-defined types as for built-in types
  - Locality is good
  - Avoid order dependencies
  - If in doubt, pick the variant of a feature that is easiest to teach
  - Syntax matters (often in perverse ways)
  - Preprocessor usage should be eliminated

> 伍注：如何记忆「技术性规则」呢？不妨从一个最简单的C++ Hello world程序来逐行分析。
> 除掉注释外，第一行往往是`#include`语句，这些语言需要被预处理器处理，而第7条规则是讨论预处理器的：应该避免使用预处理器（然而时至今日依然无法做到）。
> 接下来是函数声明，需要提供参数类型和返回值类型，而第1条和第2条规则是讨论类型的：不能隐式违反静态类型系统、为用户定义类型提供与内建类型同样好的支持。
> 接下来是变量，包括局部变量和全局变量，第3条是提倡局部化，第4条则是讨论全局变量声明等带来的顺序依赖问题。
> 最后是各种语法。第6条阐明语法的重要性，第5条也和语法有点沾边，可以理解为使用更容易教的语法。

#### 4.5 Low-Level Programming Support Rules

- Use traditional (dumb) linkers
- No gratuitous incompatibilities with C
- Leave no room for a lower-level language below C++ (except assembler)
- What you don't use, you don't pay for (zero-overhead rule)
- If in doubt, provide means for manual control

> 伍注：如何记忆「低级程序设计规则」呢？
> 首先，低级程序设计当然涉及到链接器、汇编器和C语言，而前3条规则分别讨论这三个东西。
> 第4条和第5条规则，依然可以理解为为了与C语言匹敌而提出的规则：零开销规则、提高手工控制手段，总之性能不可以输给C语言。

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

