# 《Refactoring: Improving the Design of Existing Code》书籍分析笔记

## Chapter 2 Principles in Refactoring

### Q1：这一章的内容是什么？

> 备注：用一句话或最多几句话来回答。

介绍重构的原则。

### Q2：这一章的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Defining refactoring 定义重构
- The two hats 软件开发是在增加功能和重构之间不断切换
- Why should we refactor?
- When should we refactor?
- Problems with refactoring
- Refactoring, architecture, and Yagni
- Refactoring and the wider development process
- Refactoring and performance
- Where did refactoring come from?
- Automated Refactorings

### Q3：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

### Q4：这一章的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

### Q5：这一章的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

#### Defining refactoring

- The noun's definition of Refactoring
  - A change made to the **internal structure** of software to make it **easier to understand and cheaper to modify** without changing its observable behavior.

> 伍注：「重构」，重新调整结构也。目的是使软件容易理解、方便修改。

- The verb's definition of Refactoring
  - To restructure software by applying a series of refactorings without changing its observable behavior.

- If someone says their code was broken for a couple of days while they are refactoring, you can be pretty sure they were not refactoring.

> 伍注：重构时要求小步修改，并不断测试，因此不应该导致功能失常。

#### The two hats

- When I use refactoring to develop software, I divide my time between **two distinct activities**
  - Adding functionality
  - Refactoring

#### Why Should We Refactor

- Why should we refactor
  - Refactoring improves the design of software
  - Refactoring makes software easier to understand
  - Refactoring helps me find bugs
  - Refactoring helps me program faster

- I make a point of trying to put everything I should remember into the code so I don't have to remember it.

> 伍注：这是个好习惯——化解费解的地方，减少大脑负担。

- "I'm not a great programmer; I'm just a good programmer with great habits." -- Kent Beck

> 伍注：我这辈子注定做不了伟大的程序员，这曾经令我沮丧。而这句话则让我看到一点希望：我可以养成优秀的编程习惯从而成为一位优秀的程序员。

- Design Stamina(持久力) Hypothesis
  - By putting our effort into a good internal design, we increase the stamina of the software effort, allowing us to go faster for longer.

- We can improver the design of existing code - so we can form and improve a design over time, even as the needs of the program change.

> 伍注：重构可以改善既有代码的设计。化腐朽为神奇。

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

