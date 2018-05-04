# 《Apace Spark: A Unified Engine for Big Data Processing》学习笔记

## 前言

1. 数据增长 --> 多节点计算（分布式计算）
2. 早期集群编程模型的局限性：功能单一
3. Spark编程模型：RDD（Resilient Distributed Datasets）。该模型支持SQL、streaming、机器学习和图像处理等功能。
4. Spark的好处：
    * 开发应用更容易，因为具有统一的API
    * 合并处理任务更高效
    * 能够支持更多新应用
5. Spark vs MapReduce,Dremel,Pregel 正如 手机 vs 照相机、电话、GPS
6. Spark具有一个集成标准库
7. 处理函数的可组合性对并行数据处理很重要
8. 本文结构：
    * Spark 编程模型及其通用性
    * 使用Spark来构建处理任务
    * 总结Spark的应用及未来的工作

## 编程模型

1. RDD：同一集群划分出来的、可以被并行处理的对象的容错集合。
2. RDD的创建：通过应用变换（transformations），包括map, filter, groupBy。
3. RDD API支持的语言：Scala, Java, Python, R
4. RDD的懒惰特性：推迟计算、合并计算、避免数据移动等，从而使得计算更高效
5. RDD的数据分享：persist操作，速度提升百倍
6. RDD的容错性：lineage，追踪变换的图表。
7. RDD与存储系统的集成：HDFS、Apache Hive等

## 高级库

1. SQL和DataFrame
    * SQL：使用相同的数据布局（压缩的圆柱状内存）
    * DataFrame：基本数据变换，包括过滤、计算新列、聚合
2. Spark Streaming
    * 离散流（discretized streams）
    * 将输入数据分批处理（batches）
3. GraphX：提供图像计算接口
4. MLlib：机器学习库，包含超过50个分布式模型训练算法的实现
5. Combining processing tasks：Spark的库函数都在RDD上运行，因此容易合并在一起

## 应用

1. 批处理（Batch processing）
    * Extract-Transform-Load：数据格式转换
    * 机器学习模型的线下训练
2. 交换式查询
    * 关系式查询（relational queries）
    * 在shell或虚拟笔记本环境下调用Spark API接口，来查询高级问题或设计模型
    * 特定领域的交互式应用
3. 流处理：实时分析和实时决策
    * 网络安全监控
    * 规范分析（prescriptive analytics）
    * 日志挖掘
4. 科学应用
    * 大规模垃圾邮件检测
    * 图像处理
    * 染色体数据处理
    * 大脑图像数据分析

## 通用性（Generality）

1. 从表现力的视角来看（Expressiveness perspective）
RDD可以效仿所有分布式计算，并且能在多数情形下表现高效
    * 数据分享更快：避免复制
    * 延迟更短

2. 从系统的视角来看
允许应用控制网络和内存I/O，优化资源利用
    * 允许应用控制数据的放置、划分和场地出租
    * CPU时间简短：所有节点均可允许相同算法和库
    * 缺点：由于提供容错性而导致的额外开销

## 未来的工作

1. DataFrame和更具描述性的API
2. 性能优化
3. 支持R语言
4. 研究库
