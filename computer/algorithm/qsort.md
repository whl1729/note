# 快速排序

本文大部分基于[QuickSort - Wikipedia](https://en.wikipedia.org/wiki/Quicksort)来展开讨论。

## 实现

1. 快速排序的算法思路可以很简单清晰地用递归表述如下，文字解释也很简单：以数组中某个元素为基准，把小于它的元素挪到它左边，不小于它的元素挪到它右边，再递归处理。不同实现方案的区别在于partition的实现。
```
algorithm quicksort(A, lo, hi) is
    if lo < hi then
        p := partition(A, lo, hi)
        quicksort(A, lo, p)
        quicksort(A, p + 1, hi)
```

2. 维基百科中提供两种partition方案，分别由Lomuto和Hoare提出的。简言之，Lomuto的方案是选择最右边为基准，然后从左往右扫描；Hoare的方案是选择中间为基准，然后同时从两边往中间扫描。

3. 如何分析算法的正确性？关键在于维持循环不变量。比如Lomuto方案的循环不变量是：每次循环结束后，A[lo..i-1]均比pivot小，A[i..j]（如果存在的话）均不小于pivot。那么当循环结束后，A[lo..i-1]均比pivot小，A[i..hi-1]均不小于pivot。显然，这时交换i与hi的位置即可。Hoare的方案是：每次大循环结束后，A[lo..i-1]均不大于pivot，A[j+1..hi]均不小于pivot。当循环结束时，i >= j，则A[lo..j-1]均不大于pivot，A[j+1..hi]均不小于pivot，而且A[j]等于pivot.

## 性能

1. 最坏情况下的时间性能为O(n^2)，最好情况下和平均情况下的时间性能均为O(n\*logn)。

> 疑问：平均情况下的时间性能如何证明？

## 稳定性

1. 稳定性的定义：A sorting algorithm is said to be stable if two objects with equal keys appear in the same order in sorted output as they appear in the input array to be sorted.

2. QuickSort 维基百科中的Lomuto partition scheme是不稳定的，举例：数组arr共4个元素：3 4 3 1 2，第一次发生交换后的次序为1 4 3 3 2，两个3的次序发生改变。

3. QickSort 维基百科中的Hoare partition scheme是不稳定的，举例：数组arr共4个元素：3 2 1 1，pivot为arr[1]=2，第一次发生交换后的次序为1 2 1 3，原来在数组最右边的1被交换到数组最左边，导致两个1的次序发生改变，可见这种方案是不稳定的。

4. The default implementation of QuickSort is not stable. However any sorting algorithm can be made stable by considering indexes as comparison parameter.

## 参考资料
1. [QuickSort - Wiki](https://en.wikipedia.org/wiki/Quicksort)
