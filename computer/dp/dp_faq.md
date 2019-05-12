# 设计模式 FAQ

## Q2 2019/05/12 如何理解Double-Checked Locking pattern潜在的风险？

1. 问题详述：根据《Modern C++ Design》“6.9 Living in a Multithreaded World”的描述，在new Singleton对象时，可能还没创建成功，就提前返回指针，如何理解这种场景？

2. 解答：在Stack Overflow上面找到了答案：[What are all the common undefined behaviours that a C++ programmer should know about?](https://stackoverflow.com/questions/367633/what-are-all-the-common-undefined-behaviours-that-a-c-programmer-should-know-a/367690#367690)和[C++ and The Perils of Double-Checked Locking: Part I](http://www.drdobbs.com/cpp/c-and-the-perils-of-double-checked-locki/184405726)

## Q1 2019/04/26 深入理解设计模式

1. 问题详述：各种设计模式的意图、解决什么问题、怎样解决、应用实例、优缺点？尤其是搞清楚以下问题：为什么需要这种设计模式？对这种设计模式适用的问题而言，不使用这种设计模式会怎样？
