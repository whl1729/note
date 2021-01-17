# 如何减少代码中的bug

## 如何最大程度的减少程序中的bug？

### vczh

1. 《Why Programs Fail》

### 刘项

1. **完整的测试**，包括（以下各点有交叉和重复）：
    - 单元测试
    - 集成测试
    - 测试自动化
    - 持续集成

## 作为程序员，你有哪些最大限度降低bug率的办法？

### Belleve

1. 写证明。把行为约束打在 type 里，所谓 Type driven 是也。

> 评论中有人提到[Software Foundations](https://softwarefoundations.cis.upenn.edu/)，有空研究一下。

### 张明云

1. 最笨、最实用的方法是**不断地验证**。

2. 就跟一篇好文章是改出来的一样，一款优秀的程序也是不断迭代、完善优化出来的，并不能一气呵成做得完美，即使你做了完善的程序设计、Code Review、Unit Test，并不能保证你的程序靠谱、bug少，最重要的还是要验证，如果想让bug少，就在提交测试前自己多验证，包括自动化测试、手动跑用例等等。

3. 今天的软件开发，确定开发前要调研验证；开发过程中要持续迭代、小步快跑一个feature一个feature地验证；发布时要先灰度再全量。其实都是在不断地验证，只有这样，程序才会足够稳定、bug少。

4. 没经过商业项目考验的代码一文不值。

### 叛逆者

1. Code review + unit test + system test

### Kenneth

1. 大道至简，用最平实的心态来做日常coding，不耍花哨，不玩技巧，多写注释，注意排版。

### jamesr

1. 不加班，保持清醒状态写代码。咖啡不会让你注意力更集中，只会让你自以为清醒。
2. 写代码前写文档，设计好类型和接口。
3. 写文档前了解环境，设计适应不了环境等代码写了一半才发现就被动了。临时补丁往往引入新bug。
4. 严格控制需求，一口吃不成胖子。
5. **有类型系统的语言一定要少用原始类型，多用自定义类型，这样编译器才能帮上忙。**
6. **类型系统太弱的语言手动进行类型注释，多做assert。**
7. **有条件多用函数式编程。**
8. 有条件多用状态机模型。
9. 画出核心状态转换图再写状态机代码。
10. 有用时一定要抽象，没有用时一定不要抽象。
11. **减少测试代价，能自动测试的一定写代码来测试。**
12. 不要过早优化，有O(log n)方法的一定先用O(n)的实现，只要接口保持随时可以无缝替换即可。
13. 不要做太多假设，尽可能写通用代码，再reduce到特定情况。

### 程墨Morgan

1. 写单元测试
2. 写枯燥的代码
3. **不熬夜写代码**
4. **使用函数式编程**
5. **使用数据流简单的框架**
6. 写代码前沟通清楚需求
7. 对产品经理复杂的需求说No

### 李运华

1. 1个原则：2/8原则。20%的代码完成80%的功能，80%的代码用来处理20%概率出现的异常和分支。

2. 2个技巧：防御性编程、代码写三遍
    - **每行代码都考虑分支或者错误情况**（注意考虑并不代表一定要写，没有就不用写，只是要培养自己的这种意识，如果没有这样的意识，那就会导致该写的也都遗漏了）
    - 第一遍代码完成基本功能，第二遍代码完善异常和分支处理，第三遍代码优化（包括编程规范、性能、逻辑等）

3. 熟悉编程语言、单元测试、熟悉业务
    - **特别注意编程语言的坑**，例如PHP的==和===
    - 单元测试不用多说，能够以最小的代价发现隐藏很深的问题
    - 代码写的再好，如果业务理解错了都是白搭

## 如何使自己编写的程序更靠谱(Robust)？

### 司徒正美

1. 必须要写测试，包括单元测试（mocha+chai）,UI测试（selenium, nightwath）与持续集成测试（通过GITHUB的hook与IC平台结合）。

2. 持续优化（这必须位于拥有庞大的测试套装的基础）。一个庞大的东西写着写着，必然需要模块化。模块化是基于某些抽象的概念之上。许多相同的操作，经过多次修改，就需要聚合到一块，它们就可以形成一个模块。而模块可以由一个核心的类及若干什么私有方法与数据构成。

3. 数据结构优于算法。框架与业务不单是由于某些任务进行划分。好的代码必须是可以递归。递归可以让我们的代码大大减少。为了形成这种递归结构，我们需要设计一些数据结构。因此基础很重要。（伍注：不理解？）

4. 为了保证效率，需要引入缓存机制。越大的东西，必须有所损耗。缓存是一个很好的解决方案。

5. 处处布置各种异常捕捉代码，凡是可能出错的地方都会有机会出错。因此要构筑错误栈，及合置错误栈输入，方便日后的调试。

6. 先完成后完美，每完成一个阶段必须提交到版本管理系统。给自己留一条后路。

### 张明云

1. 想让自己写的程序靠谱，最笨、最实用的方法是：**不断地验证**。这里的验证包括：
    - 程序设计评审（对需求和程序设计的验证）
    - Code Review（对代码质量和程序设计的验证）
    - 自动化测试（比如Android的Monkey和集成测试，对程序稳定性的验证）
    - 单元测试
    - 开发自测（对基本功能的验证）
    - 持续集成（对项目健康状态的验证）
    - SQA（专业测试人员，主要是黑盒测试，保证程序的质量）
    - 持续地迭代（每个版本只交付有限的功能，不断经过用户验证改善)

#### Kidneyball

1. 使用代码静态检查工具。Java上findbug, JS上JsLint。保证无警告。

2. 在1的基础上，学习单元测试的基础理论。然后无脑保证单元测试行覆盖率95%以上，分支覆盖率85%以上。你会发现如果代码太不靠谱，编写和维护单元测试会把你烦死。

> 伍注：使用代码静态检查工具。

## 程序出现bug是必然出现的情况还是程序猿水平有限导致的？

### 灵剑

1. 软件工程的主要目标一直都是**控制复杂度**。程序员水平的一个重要表征就是可以控制住每一段代码的复杂度，保证代码可读性和非耦合性，从而保证即便在精神不够集中的情况下也不会产生太多的bug。也有一些程序员在精神高度集中的情况下可以将很复杂的逻辑一遍写对，这是一种很有益的技巧，但在可能的情况下，我还是更推崇将问题拆分降低复杂度的方法。

## What are good ways to avoid bugs while programming?

### Tim Boudreau

1. One provable way to have fewer bugs: **Have less code**. Code that does not exist cannot have bugs.

2. Ways to have less code:
    - When you're solving a problem, notice if there is a generic version of the problem you could solve - if so, write that and **reuse it as a library** wherever you have the specific problem (and have lots of tests for that library)
    - If there is a library that does what you need, use it. And spend the time to find out if one exists.
    - Avoid boilerplate unless you know you need it. Yeah, iterating that array might be a microsecond faster if you stored the bound in a local variable, but unless you know that that code is called a lot and will be a performance hotspot, don't do it.

3. When writing anything, ask yourself "does this need to exist?". Look for ways to leverage the technologies you're using to write less code.（伍注：C1主机服务软件存在一些重复代码，如APP/screen消息发送功能。）

4. For reducing the probability of bugs, look for techniques that eliminate entire classes of bug. Wherever possible, use **language features** that let the compiler prove a particular kind of bug can't exist, so you don't have to pray it isn't in your code. For example, if your language has an idiom for immutability like Java's final keyword (as applied to variables), use it wherever you possibly can - then there is exactly one place you need to test if the value is valid, and it is simply impossible (without really dirty JVM tricks or hardware failures) for it to become invalid unexpectedly. If your language has an idiom for iterating a collection or array, use that in place of explicit bounds.

### Arjun Ramachandran

1. The very first step in avoiding bugs is knowing your feature/requirements thoroughly . Make sure you have **no assumptions** about your module , the existing dependent modules and the other modules to be developed.（伍注：凡是对需求有任何不确定的地方，必须先沟通清楚。）

2. **Have a test plan in place** . I can't stress enough the need for a test plan as early as you have a dev design.（伍注：先写测试文档。）

3. **Have decent estimates** . Always have a buffer and assume the worst. Most of software bugs are always due to poor estimates and dishing out code under time crunch.Allocate time for code refactoring.（伍注：合理安排开发时间。）

## 参考资料

### Websites

1. [如何最大程度的减少程序中的bug？](https://www.zhihu.com/question/26541982)
2. [作为程序员，你有哪些最大限度降低bug率的办法？](https://www.zhihu.com/question/61146782)
3. [如何使自己编写的程序更靠谱(Robust)？](https://www.zhihu.com/question/59318151)
4. [Software Foundations](https://softwarefoundations.cis.upenn.edu/)
5. [Continuation](https://en.wikipedia.org/wiki/Continuation)
6. [Simple Made Easy](https://www.infoq.com/presentations/Simple-Made-Easy/)

### Books

1. 《重构》
2. 《代码简洁之道》
3. 《个体软件过程》

