# 《STL源码剖析》第6章学习笔记

## 第6章 算法

### 6.1 算法概观

1. 根据是否会改变操作对象的值，可将算法分为两类：
    - 质变算法（mutating algorithms）：会改变操作对象之值。例如：copy，swap，replace，fill，remove，permutation，partition，random shuffling（随机重排），sort等算法。
    - 非质变算法（nonmutating algorithms）：不会改变操作对象之值。例如：find，search，count，for_each，equal，mismatch，max，min等算法。

2. 许多STL算法不只支持一个版本。这一类算法的某个版本采用缺省运算行为，另一个版本提供额外参数，接受外界传入一个仿函数，以便采用其他策略。有些算法干脆将这样的两个版本分为两个不同名称的函数，由用户提供仿函数的版本以\_if结尾，比如find与find_if，replace与replace_if。

3. 质变算法（mutating algorithms）通常提供两个版本：一个是in-place（就地进行）版，就地改变其操作对象；另一个是copy（另地进行）版，将操作对象的内容复制一份副本，然后在副本上进行修改并返回该副本。copy版总是以\_copy结尾，例如replace()与replace_copy()。并不是所有质变算法都有copy版，比如sort()就没有。

### 6.2 算法的泛化过程

1. 只要把操作对象的型别加以抽象化，把操作对象的标示法和区间目标的移动行为抽象化，整个算法也就在一个抽象层面上工作了。整个过程称为算法的泛型化，简称泛化。

### 6.3 数值算法 \<numeric\>

1. 算法accumulate必须提供一个初始值init，这样做的原因之一是当[first, last)为空区间时仍能获得一个明确定义的值。

2. 常用数值算法
    - accumulate(beg, end, init_val)
    - inner_product(beg, end, init_val)
    - partial_sum(beg, end, ostream_iterator): 第n个元素是前n个旧元素的和
    - adjacent_difference(beg, end, ostream_iterator)：第n个元素是第n个旧元素与第n-1个旧元素的差
    - iota(beg, end, n)：在指定区间内填入n, n+1, n+2, ...

### 6.4 基本算法 \<stl_algobase.h\>

1. \<stl_algobase.h\>头文件中的算法
    - equal
    - fill：将[first, last)内的所有元素改填新值
    - fill_n：将[first, last)内的前n个元素改填新值
    - iter_swap：将两个ForwardIterators所指的对象对调
    - lexicographical_compare：若小于则返回true，否则返回false
    - max
    - min
    - mismatch：返回一对迭代器，分别指向两序列中的不匹配点
    - swap

2. 如果两个序列在[first, last)区间内相等，equal()返回true。如果第二序列的元素比较多，多出来的元素不予考虑。因此，如果我们希望两个序列完全相等，必须先判断其元素个数是否相同，或者使用容器所提供的equality操作符（例如==）。
```
if (vec1.size() == vec2.size() && equal(vec1.begin(), vec1.end(), vec2.begin()))
// is equal to
if (vec1 == vec2)
```

3. 执行copy时，赋值操作是按地址从小到大的顺序进行的。如果输出区间的开头与输入区间重叠，我们不能使用copy（但可以使用copy_backward）；但如果输出区间的结尾与输入区间重叠，就可以使用Copy（而不能使用copy_backward）。

4. 如果输出区间的起点位于输入区间中，copy算法可能会在输入区间的某些元素尚未被复制之前，就覆盖其值，导致错误。但如果copy算法根据其所接收的迭代器的特性决定调用memmove()来执行任务，就不会造成上述错误，因为memmove()会先将整个输入区间的内容复制下来，没有被覆盖的危险。

5. 注意：`copy_backward(beg, end, result)`是从后往前复制的，也就是：先将end-1所指内容复制到result-1, 再将end-2所指内容复制到result-2，依次类推，最后将beg所指内容复制到result-n（其中n=end-beg）。因此，执行前必须保证result-n这个地址合法。

### 6.5 set相关算法

1. 与set相关的四种算法
    - 并集：set_union
    - 交集：set_intersection
    - 差集：set_difference
    - 对称差集：set_symmetric_difference

2. 由于集合s1和集合s2的每个元素都不需唯一，因此如果某个值在s1出现n次，在s2出现m次，那么该值
    - 在set_union的输出区间中会出现max(m,n)次
    - 在set_intersection的输出区间中会出现min(m,n)次
    - 在set_difference的输出空间中会出现max(n-m, 0)次
    - 在set_symmetric_difference的输出空间中会出现|n-m|次

3. set_union是一种稳定（stable）操作，意思是输入区间内的每个元素的相对顺序都不会改变。

### 6.7 其他算法

1. 单纯的数据处理
    - adjacent_find：寻找第一组满足条件的相邻元素，默认条件是“两元素相等”
    - count, count_if
    - find, find_if, find_end, find_first_of
    - for_each：将仿函数f施行于[first, last)区间内的每一个元素身上，f不可以改变元素内容，因为first和last都是InputIterators，不保证接受赋值行为。如果想要一一修改元素内容，应该使用算法transform
    - generate, generate_n：将仿函数gen的运算结果填写在[first, last)区间内的所有元素身上
    - includes：应用于有序区间。判断序列二S2是否“涵盖于”序列一S1，所谓“涵盖”是指“S2的每一个元素都出现于S1中”。注意S1或S2内的元素都可以重复，所以判断是否“涵盖”时还要保证S1的对应元素的出现次数不小于S2的元素出现次数
    - max_element：返回一个迭代器，指向序列中数值最大的元素
    - merge：应用于有序区间。合并两个有序集合，将结果存放于另一段空间。
    - min_element
    - partition：partition会将区间[first, last)中的元素重新排列。所有被一元条件运算pred判定为true的元素，都会被放在区间的前段；被判定为false的元素，都会被放在区间的后端。本算法不保证稳定性，如需保证可用stable_partition
    - remove, remove_copy, remove_if, remove_copy_if：并不真正从容器中删除元素，而是将所有不与value相等或被pred判定为false的元素放在容器前面，残余数据（如果有的话）则放在容器最后面
    - replace, replace_copy, replace_if, replace_copy_if
    - reverse, reverse_copy
    - rotate, rotate_copy：将[first, middle)内的元素和[middle, last)内的元素互换
    - search，search_n：在序列一[first1, last1)区间中，查找序列二[first2, last2)的首次出现位置
    - swap_ranges：将[first1, last1)区间内的元素与“从first2开始，个数相同”的元素互相交换
    - transform：以仿函数f作用于[first, last)中的每一个元素身上，并以其结果产生出一个新序列
    - unique, unique_copy

2. lower_bound：应用于有序区间。这是二分查找的一种版本。如果[first, last)具有与value相等的元素，便返回一个迭代器，指向其中第一个元素。如果没有这样的元素，便返回一个迭代器，指向第一个“不小于value”的元素。（也是在不破坏顺序的情况下，可插入value的第一个位置）

3. upper_bound：应用于有序区间。这是二分查找的一种版本。如果[first, last)具有与value相等的元素，便返回一个迭代器，指向其中第一个元素。如果没有这样的元素，便返回一个迭代器，指向第一个“大于value”的元素。（也是在不破坏顺序的情况下，可插入value的最后一个位置）

4. binary_search：如果[first, last)具有与value相等的元素，则返回true，否则返回false

5. next_permutation, prev_permutation：就地计算下一个/上一个排列组合，如果不存在则返回false，否则返回true。

6. random_shuffle：将[first, last)的元素次序随机重排。也即是说，在N!种可能的元素排列顺序中随机选出一种，此处N为last-first.

7. partial_sort, partial_sort_copy：本算法接受一个middle迭代器，然后重新安排[first, last)，使序列中的middle-first个最小元素以递增顺序排序，置于[first, middle)内，其余last-middle个元素安置于[middle, last)中，不保证有任何特定顺序。本算法内部是通过堆来实现的。

8. STL的sort算法，数据量大时采用Quick Sort，分段递归排序。一旦分段后的数据量小于某个门槛，为避免Quick Sort的递归调用带来过大的额外负担，就改用Insertion Sort。如果递归层次过深，还会改用Heap Sort。一般当分段后的序列长度为5~20时就应该改用Insertion Sort，实际的最佳值因设备而异。

9. STL的Insertion Sort在实现时采用了一些技巧：比如先把当前元素与首元素作比较，若当前元素更小，则把当前元素前面的所有元素整体右移一位（通过copy_backward），把当前元素插到开头；否则再将当前元素逐个与前面的元素做比较来找到插入位置，这时不需判断是否超出边界了，因为首元素相当于哨兵守在最左边了（当前元素在遇到第一个比自己小的元素后就停止搜索）。

10. STL目前已改用IntroSort（极类似median-of-three QuickSort的一种排序算法），可将最坏情况的复杂度推进到O(NlogN)。

11. equal_range：返回一对迭代器i和j，代表与value相等的所有元素所形成的区间。

12. inplace_merge：合并两个有序序列。和merge一样，inplace_merge也是一种stable操作。

13. nth_element：重新排列[first, last)，使排序后，以nth所指的元素作为一个分界点，即[nth, last)内任何一个元素均大于[first, nth)内的元素。

14. 由于Merge Sort需借用额外的内存，而且在内存之间移动（复制）数据也会耗费不少时间，所以Merge Sort的效率比不上Quick Sort。实现简单、概念简单，是Merge Sort的两大有点。
