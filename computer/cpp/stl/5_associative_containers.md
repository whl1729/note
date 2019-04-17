# 《STL源码剖析》第5章读书笔记

## 第5章 关联式容器

1. 标准的STL关联式容器分为set（集合）和map（映射表）两大类，以及这两大类的衍生体multiset和multimap。这些容器的底层机制均以RB-tree完成。RB-tree也是一个独立容器，但不开放给外界使用。

2. SGI STL还提供了一个不在标准规格之列的关联式容器：hash table，以及以此hash table为底层机制而完成的hash_set、hash_map、hash_multiset、hash_multimap。伍注：set和map既可以使用RB-tree实现，也可以使用hash table实现，标准STL采用的是前者。

###  5.1 树的导览

1. 如何记忆AVL树的四种“平衡破坏条件的调整方案？
    - 左左、右右：这两种情况很容易记，因为是单旋转，把首先失衡的节点上提即可。
    - 左右、右左：需要双旋转。第一次旋转后，“左右”转化为“左左”，“右左”转化为“右右”，第二次旋转按照第一点的方法去做即可。

### 5.2 RB-tree

1. RB-tree是一个满足以下4条规则的二叉搜索树
    - 每个节点不是红色就是黑色
    - 根节点是黑色
    - 如果节点是红色，其子节点必须为黑色
    - 任一节点至NULL（树尾端）的任何路径，所含之黑节点数必须相同

2. 根据新节点的插入位置及外围节点（父兄节点S和曾祖父节点GG）的颜色，分四种情况讨论：
    - 情况1：S为黑且X为外侧插入。先对P、G做一次单旋转，并更改P、G颜色即可。
    - 情况2：S为黑且X为内侧插入。先对P、X做一次单旋转，并更改G、X颜色，再将结果对G做一次单旋转。
    - 情况3：S为红、X为外侧插入。先对P和G做一次单旋转，并更改X的颜色，如果GG为黑，则结束，否则持续往上做，直到不再有父子连续为红的情况。
    - 情况4：S为红、X为内侧插入。先对P、X做一次单旋转，即可转化为情况3.

3. 为了避免情况3或4“父子节点皆为红色”的情况持续向RB-tree的上层结果发展，形成处理时效上的瓶颈，我们可以采取一个由上而下的方案：假设新增节点为A，那么沿着根节点到A的路径，只要看到有某节点的两个子节点皆为红色，就把X改为红色，并把两个子节点改为黑色；如果X的父节点亦为红色，则像情况1一样做一次单旋转并改变颜色，或是像情况2做一次双旋转并改变颜色。

> 由上而下相比由下而上有什么好处？是不是说插入时本来就需要由上而下找插入位置，这时顺便做调整以避免情况3或4出现？

4. 由于RB-tree的各种操作中常需要上溯其父节点，所以在数据结构汇总安排了一个parent指针。

5. 树状结构的各种操作，最需注意的就是边界情况的发生，也就是走到根节点时要有特殊的处理。为了简化处理，SGI STL特别地为根节点再设计了一个父节点，名为header。因此，在插入新节点时，要维护header的正确性，使其父节点指向根节点，左子节点指向最小节点，右子节点指向最大节点。

6. 红黑树的本质是什么？为什么它的性能比较好？

### 5.3 set

1. set的迭代器被定义为constant iterator，我们无法通过set的迭代器来改变set的元素值。因为set元素值就是其键值，关系到set元素的排列规则。如果任意改变set元素值，会严重破坏set组织。

2. STL 特别提供了一组set/multiset相关算法，包括交集set_intersection、联集set_union、差集set_difference、对称差集set_symmetric_difference等。（伍注：了解其原理）

### 5.4 map

1. 我们不可以通过map的迭代器来修改元素的键值，因为map元素的键值关系到map元素的排列规则，任意改变map元素键值将会严重破坏map组织。但我们可以通过map的迭代器来修改元素的实值，因为map元素的实值并不影响map元素的排列规则。

2. [Why std::map is red black tree and not hash table ?](https://stackoverflow.com/questions/22665902/why-stdmap-is-red-black-tree-and-not-hash-table):  map is explicitly called out as an ordered container. It keeps the elements sorted and allows you to iterate in sorted order in linear time. A hashtable couldn't fulfill those requirements. In C++11 they added std::unordered_map which is a hashtable implementation.

### 5.7 hashtable

1. 负载系数指元素个数除以表格大小。开放地址法（包括线性探测、二次探测、双散列等）的负载系数永远在0~1之间，链地址法的负载系数可能大于1.

2. 使用线性探测来解决collision时，必须采用lazy deletion，也就是只标记删除记号，实际删除操作则待表格重新整理时再进行。这是因为hash table中的每一个元素不仅表述它自己，也关系到其他元素的排列。
