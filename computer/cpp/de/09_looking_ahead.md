# 《The Design and Evolution of C++》书籍分析笔记

## Chapter 9 Looking Ahead

### Q1：这一章的内容是什么？

> 备注：用一句话或最多几句话来回答。

简单回顾C++的发展，并展望未来。

### Q2：这一章的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Retrospective 回顾以往
- Only a bridge? C++ 可以解决哪些问题
  - 作为桥梁，从传统的程序设计过渡到依赖于数据抽象和面向对象的程序设计
  - C++可以发挥优势的领域
    - 低级系统编程
    - 高级系统编程
    - 嵌入式
    - 数值/科学计算
    - 通用应用程序
- What will make C++ much effective? 如何使C++更有效
  - 提高语言、关键库和接口的稳定性
  - 学习新的设计技术和编程技术
  - 解决系统方面的问题
  - 改善C++开发环境

### Q3：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

### Q4：这一章的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

### Q5：这一章的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

#### 9.2 Retrospective

- The first-order decisions
  - Use of static type checking and Simula-like class
  - Clean separation between language and environment
  - C source compatibility ("as close as possible")
  - C link and layout compatibility ("genuine local variables")
  - No reliance on garbage collection

- C++ is really three languages in one:
  - A C-like language (supporting low-level programming)
  - An Ada-like language (supporting abstract data type techniques)
  - A Simula-like language (supporting object-oriented programming)
  - What it takes to integrate those features into a coherent whole

- **Worst Mistake**: Release 1.0 and my first edition should have been delayed until a larger library have been included.
  - The library should include some fundamental classes such as singly and doubly linked lists, an associative array class, a range-checked array class, and a simple string class.

#### 9.3 Only a bridge?

- Where C++ has fundamental strengths
  - Low-level systems programming
  - Higher-level systems programming
  - Embedded code
  - Numeric/scientific computing
  - General application programming

- The most a general-purpose language can hope for is to be **"everybody's second choice"**.

#### 9.4 What will make C++ much more effective?

- C++'s main strength isn't being great at a single thing, but being good at a great variety of things.

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

