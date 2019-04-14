# 《STL 源码剖析》第2章读书笔记

## 第2章 空间配置器

### 2.2 具备次配置力（sub-allocation）的SGI空间配置器

1. new操作包括内存配置和对象构造两阶段，delete操作包括对象析构和内存释放两阶段。为了精密分工，STL allocator决定将这两阶段操作区分开来。内存配置操作由alloc::allocate()负责，内存释放操作由alloc::deallocate()负责；对象构造操作由::construct()负责，对象析构操作由::destroy()负责。

2. memory
    |__ stl_construct.h: 定义了全局函数construct()和destroy()
    |__ stl_alloc.h: 定义了一、二级配置器，彼此合作。配置器名为alloc
    |__ stl_uninitialized.h: 定义了一些全局函数，用来填充或复制大块内存数据。

3. `destroy(ForwardIterator first, ForwardIterator last)`利用`iterator_traits<ForwardIterator>::value_type`来判断该类型的析构函数是否trivial（无关痛痒），若是则什么也不做就结束；否则遍历迭代器来析构该类型的对象。

4. 关于对象构造前的空间配置和对象析构后的空间释放，SGI的设计哲学如下
    - 向system heap要求空间
    - 考虑多线程（multi-threads）状态
    - 考虑内存不足时的应变措施
    - 考虑过多“小型区块”可能造成的内存碎片问题

5. SGI二级配置器
    - 第一级配置器直接使用malloc()和free()
    - 第二级配置器视情况采用不同的策略：如果需求区块大于128 bytes，视其为“足够大”，便调用第一级调度器；否则采用复杂的memory pool整理方式，不再求助于第一级配置器。
    - 第二级配置器维护16个自由链表，负责16种小型区块的次配置能力。内存池(memory pool)以malloc()配置而得。如果内存不足，转调用第一级配置器。
    - 第二级配置器每次配置一大块内存，并维护对应的自由链表。下次若再有相同大小的内存需求，就直接从free-lists中分配。如果用户释放小块内存，就由配置器回收到free-lists中。

6. C++ new-handler机制是，你可以要求系统在内存配置无法被满足时，调用一个你所指定的函数。换句话说，一旦::operator new无法完成任务，在丢出std::bad_alloc异常状态之前，会先调用由用户指定的处理例程，该例程即被称为new-handler。new-handler解决内存不足的做法有特定的模式，请参考《Effective C++》2e Item 7.

### 2.3 内存基本处理工具

1. STL定义有5个全局函数，作用于未初始化空间上。这样的功能对于容器的实现很有帮助。
```
construct()
destroy()
uninitialized_copy(InputIterator first, InputIterator last, ForwardIterator result);
uninitialized_fill(ForwardIterator first, ForwardIterator last, const T &x);
uninitialized_fill_n(ForwardIterator first, Size n, const T &x);
```

2. 如果你需要实现一个容器，uninitialized_copy()这样的函数会为你带来很大的帮助，因为容器的全区间构造函数通常以两个步骤完成：
    - 配置内存区块，足以包含范围内的所有元素
    - 使用uninitialized_copy()，在该内存区块上构造元素

3. C++标准规格书要求uninitialized_copy()具有“commit or rollback”语意，意思是要么“构造出所有必要元素”，要么（当有任何一个copy constructor失败时）“不构造任何东西”。

4. POD意指Plain Old Data，也就是标量类型（scalar types）或传统的C struct类型。POD类型必然拥有trivial ctor/dtor/copy/assignment函数。
