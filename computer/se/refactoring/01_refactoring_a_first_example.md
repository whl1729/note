# 《Refactoring: Improving the Design of Existing Code》书籍分析笔记

## Chapter 1 Refactoring: A First Example

### Q1：这一章的内容是什么？

> 备注：用一句话或最多几句话来回答。

通过一个案例介绍重构的流程及作用。

> I’ll talk about how refactoring works and will give you a sense of the refactoring process.

### Q2：这一章的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- The Starting Point: 提供初始版本的代码
- Comments on the Starting Program: 重构的动机（为何需要重构）
- The First Step in Refactoring: 重构的第一步——写测试用例
- Decomposing the statement Function
  - Removing the play Variable
  - Extracting Volume Credits
  - Removing the format Variable
  - Removing Total Volume Credits
- Status: Lots of Nested Functions
- Splitting the Phases of Calculation and Formatting 将计算与渲染分离
- Status: Separated into Two Files (and Phases) 分为多个文件
- Reorganizing the Calculations by Type 使用多态来代替条件语句
  - Creating a Performance Calculator
  - Moving Functions into Calculator
  - Making the Performance Calculator Polymorphic
- Status: Creating the Data with the Polymorphic Calculator
- Final Thoughts

### Q3：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

### Q4：这一章的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

### Q5：这一章的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

#### Comments on the Starting Program

- A poorly designed system is hard to **change**
  - because it is difficult to figure out what to change and how these changes will interact with the existing code to get the behavior I want. 
  - And if it is hard to figure out what to change, there is a good chance that I will make mistakes and introduce bugs.

- The importance of **structure**
  - If I’m faced with modifying a program with hundreds of lines of code, I’d rather it be structured into a set of functions and other program elements that allow me to understand more easily what the program is doing.
  - If the program lacks structure, it’s usually easier for me to add structure to the program first, and then make the change I need.

- When you have to **add a feature** to a program but the code is **not structured** in a convenient way, 
  - first refactor the program to make it easy to add the feature,
  - then add the feature.

- It's these changes that drive the need to perform refactoring.

> 伍注：需求变更是重构的驱动力。

#### The First Step in Refactoring

- Before you start refactoring, make sure you have a solid suite of **tests**. These tests must be **self­checking**.

> 伍注：重要原则——重构前必须要先写好测试用例。

#### Decomposing the statement Function

- This understanding is in my head, I need to persist it by moving it from my head back into the code itself.

> 伍注：这是一个很好的原则——对费解的代码进行重构，使其变得易懂。

- It's an important habit to **test** after every refactoring.

> 伍注：这是一个好习惯——每次重构后都必须测试。因此，重构前我们必须先写好测试用例。

- Refactoring changes the programs in **small steps**, so if you make a mistake, it is easy to find where the bug is.

> 伍注：重构时小步修改。

- It's my coding standard to always call the return value from a function **"result"**.

> 伍注：将返回值变量命名为result。好主意！

- Any fool can write code that a computer can understand. Good programmers write code that humans can understand.

> 伍注：注重可读性！

- It's hard to get names right the first time, so I use the best name I can think of for the moment, and don't hesitate to rename it later.

> 伍注：命名很重要，但不必苛求一次命对。

- My overall advice on performance with refactoring is:
  - Most of the time you should ignore it.
  - If your refactoring introduces performance slow-downs, finish refactoring first and do performance tuning afterwards.

> 伍注：重构时先不考虑性能损失。

- When the best name for the extracted function is the same to the existed variable:
  - First give the new function a random name when you extract it
  - Then inline the variable and rename the function to something more sensible

#### Status: Separated into Two Files (and Phases)

- Clarity is the soul of evolvable software.

> 伍注：清晰是可拓展软件的灵魂。

- When programming, follow the camping rule: **Always leave the code base healthier than when you found it.**

> 伍注：每次离开时让代码比之前更健康。

#### Reorganizing the Calculations by Type

- Replace Conditional with **Polymorphism**

> 伍注：使用多态代替条件语句。

#### Final Thoughts

- The Early stagets of refactoring
  - Read the code
  - Gain some insight
  - Use refactoring to **move that insight from your head back into the code**

> 伍注：这是一个很好的原则：重构费解之处，释放大脑压力。

- The true test of good code is **how easy it is to change it**.

> 伍注：好代码容易修改。

- Code should be obvious:
  - When someone needs to make a change, they should be able to find the code to be changed **easily** and to make the change **quickly without introducing any errors**.

> 伍注：好代码不仅容易修改，修改时还难以犯错。

- The key to effective refactoring is 
  - recognizing that you go faster when you **take tiny steps**, the code is never broken,
  - and you can compose those small steps into substantial changes.

> 伍注：小步重构，揍得更快！

### Q6：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

#### 作者对于示例代码的重构过程

- 拆分statement函数
  - 将计算数量（thisAmount）的代码提取为新函数amountFor: Extract Function
  - 将返回值thisAmount重命名为result
  - 将输入参数perf重命名为aPerformance
  - 通过查询函数将临时变量play删除: Replace Temp with Query、Inline Variable、Change Function Declaration
  - 通过查询函数将临时变量thisAmount删除: Inline Variable
  - 将计算积分（volumeAmount）的代码提取为新函数volumeCreditsFor: Extract Function
  - 通过查询函数将临时变量format删除: Replace Temp with Query
  - 将函数format重命名为usd: Change Function Declaration
  - 通过查询函数将临时变量totalAmount和volumeCredits删除：Split Loop、Slide Statements、Replace Temp with Query、Extract Function、Inline Variable
- 分离计算和渲染过程
- 使用多态代替条件语句

#### 作者提出的重构原则

- 重构前必须写好测试用例
- 重构时小步修改
- 每次重构都必须测试
- 重构时先不考虑性能损失
- 每次离开前的代码比之前更健康
- 使用多态代替条件语句

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

