# RDD学习笔记

## 参考资料
1. 论文：《Resilient Distributed Datasets: A Fault-Tolerant Abstraction for In-Memory Cluster Computing》

## RDD是什么

1. RDD(Resilient Distributed Datasets)：一种分布式内存抽象，允许在大型集群中执行in-memory计算，容错性高
2. RDD的起因：解决迭代算法和交互式数据挖掘工具的低效问题
3. RDD的特点
    * 数据存储在内存中
    * 通过共享内存实现容错性

## 为什么需要RDD

1. 目前集群计算框架的不足：缺乏充分利用分布式内存的抽象，导致在需要数据复用的场景下很低效。（目前框架实现数据复用的方式都是将数据写到分布式文件系统中）
2. Pregel和HaLoop等框架只能支持特定计算模式的数据复用，不能提供更一般性的复用。
3. RDD能够支持大量应用的高效数据复用；容错性高；支持并行数据结构。
4. RDD既能兼容大部分集群编程模型（比如MapReduce，DryadLINQ，SQL，Pregel和HaLoop等），也能支持新应用（比如迭代数据挖掘）。

## RDD的主要挑战及应对策略
1. RDD的主要挑战是定义能够提供容错性的编程接口。
2. 应对策略：粗粒度的变换（coarse-grained transformations）。日志记录用于构建数据集的变换（血统）。
3. 一个RDD区域的数据丢失后，可以通过其他RDD计算恢复回来，不需要耗时的拷贝。

## RDD抽象
1. RDD的创建：通过对稳定内存或其他RDD中的数据的转换（transformations）
2. RDD的数据转换（transformations）：map, filter, join
3. RDD记录有如何由其他数据集来计算自己的那部分数据的信息
4. 用户可以控制RDD的两个其他特性：
    * 持续性（persistence）
    * 划分（partition）

## RDD编程接口

### RDD使用方法
1. 首先，通过数据变换（比如map或filter）定义若干个RDD
2. 然后，通过actions使用这些RDD。
3. 其次，通过设置persist的flag，可以指示RDD保存到内存或磁盘。
> 备注：使用persist可以将数据保存在内存中，这样可以在不同查询操作中共享数据。

### RDD Operations：
1. RDD Operations包括transformations和actions。
2. transformations是指会定义一个新的RDD、具有推迟计算特点的操作，比如map，filter，groupByKey，union，join，sort，partitionBy等。
3. actions是指返回一个结果给应用或者输出数据到存储系统的操作，比如count（返回元素数目）、collect（返回元素自身）和save（输出数据集到存储系统）。

## Spark编程接口

### Spark使用方法
1. 开发者编写driver程序，用于连接worker集群。
2. driver定义若干个RDD，并对其调用actions。
3. driver也会跟踪记录RDD的血统。
4. worker可以将RDD分区存储在RAM中。
5. 用户通过传递闭包提供参数给RDD operation。

###
