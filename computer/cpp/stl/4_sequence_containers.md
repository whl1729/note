# 《STL源码剖析》第4章学习笔记

## 第4章 序列式容器

### 4.1 容器的概观与分类

1. 根据“数据在容器中的排列”特性，常用数据结构分为序列式（sequence）和关联式（associative）两种。

2. heap内含一个vector，priority-queue内含一个heap，stack和queue都内含一个deque，set/map/multiset/multimap都内含一个RB-tree。

3. 所谓序列式容器，其中的元素都可序（ordered），但未必有序（sorted）。

### 4.2 vector

1. 对vector的任何操作，一旦引起空间重新配置，指向原vector的所有迭代器就都失效了。这时程序员易犯的一个错误，务需小心。

2. 疑问：vector实现insert时，为什么要分两步来拷贝插入点之后的元素，是因为uninitialized_copy比copy_backward效率更高、所以优先使用前者吗？
```
uninitialized_copy(finish - n, finish, finish);
finish += n;
copy_backward(position, old_finish - n, old_finish);
```

### 4.3 list

1. 由于STL list是一个双向链表，迭代器必须具备前移、后移的能力，所以list提供的是Bidirectional Iterators.

2. list有一个重要性质：插入操作和合并操作都不会造成原有的list迭代器失效。甚至list的元素删除操作，也只有“指向被删除元素”的那个迭代器失效，其他迭代器不受任何影响。

3. STL对于“插入操作”的标准规范：插入完成后，新节点将位于哨兵迭代器所指之节点的前方。

4. list内部提供一个迁移操作：`transfer(iterator pos, iterator first, iterator last)`，作用是将\[first, last)内的所有元素移动到position之前。而list公开提供的是合并操作（splice）：将某连续范围的元素从一个list移动到另一个list的某个定点。

5. 由于STL sort算法只接受RandomAccessIterator，所以list不能使用STL sort算法，必须使用自己的sort()成员函数。list::sort采用的是归并排序：创建64路链表，第i路最多装2^i个元素，最后将所有非空链表合并。参考[std::list::sort 用了什么算法？为什么速度这么快？ - 邱浩的回答 - 知乎](https://www.zhihu.com/question/31478115/answer/74892321)和[What makes the gcc std::list sort implementation so fast?](https://stackoverflow.com/questions/6728580/what-makes-the-gcc-stdlist-sort-implementation-so-fast)

6. STL forward_list是单向链表。

### 4.4 deque

1. deque和vector的最大差异有两点
    - deque允许常数时间内对头结点进行元素的插入或移除操作
    - deque没有所谓容量（capacity）的概念，因为他是动态地以分段连续空间组合而成

> 伍注：为什么deque采用分段连续空间而不是单独一段连续空间呢？我的猜测：因为vector对头结点进行元素插入的复杂度为O(n)，因此deque不直接采用vector的方案，分段连续空间使得在头结点插入时，只需移动其中一段的长度，其他段不受影响。

2. 出于复杂度的考虑，除非必要，我们应尽可能选择使用vector而非deque，对deque进行的排序操作，为了最高效率，可将deque先完整复制到一个vector身上，将vector排序后，再复制回deque。

3. deque采用一块所谓的map作为主控。这里所谓的map是一小块连续空间，其中每个元素都是指针，指向另一段较大的连续线性空间，成为缓冲区。SGI STL允许我们指定缓冲区大小，默认值0表示将使用512 bytes缓冲区。

4. 在初始化map时，令nstart和nfinish指向map所拥有之全部节点的中间位置，这样可使头尾的扩充能力一样大。

### 4.5 stack

1. 由于stack系以底部容器完成其所有工作，而具有这种“修改某物接口，形成另一种风貌”之性质者，称为adapter（配接器），因此，STL stack往往不被归类为container（容器），而被归类为container adapter。

2. stack所有元素的进出都必须符合“先进后出”的条件，只有stack顶端的元素，才有机会被外界取用。stack不提供遍历功能，也不提供迭代器。

3. 除了deque之外，list也是双向开口的数据结构，因此同样可以将list作为底部结构并封闭其头端开口，而形成一个stack。

4. queue同样具有以上三个特点（除了queue是“先进先出”外）。

### 4.7 heap

1. priority的复杂度，最好介于queue和binary search tree之间，才算适得其所。binary heap便是这种条件下的适当候选者。

2. 通过简单的位置规则，array可以轻易实现出complete binary tree，这种以array表述tree的方式，我们称为隐式表述法（implicit representation）。

### 4.8 priority_queue

1. 缺省情况下，priority_queue是以vector作为底部容器。

