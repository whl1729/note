# 《Resilient Distributed Datasets》笔记

## 摘要

1. RDD：分布式内存抽象，允许在大型集群中执行in-memory计算，容错性高
2. RDD的起因：迭代算法和交互式数据挖掘工具的低效
3. RDD的特点
    * 数据存储在内存中
    * 通过共享内存实现容错性

## 一、介绍

1. 目前集群计算框架的不足：缺乏利用分布式内存的抽象，导致Data reuse场景下很低效。
2. RDD的主要挑战：定义能够提供容错性的编程接口。实现方法：粗粒度的变换（coarse-grained transformations）。
3. RDD的优势：能够适应不同计算需求。
4. 本文结构
    * RDD概述
    * Spark概述
    * RDD的内部表示
    * RDD的实现
    * RDD的实验结果
    * RDD对现存的集群编程模型的融合

## 二、RDD概述

1. RDD抽象
    * RDD的创建：通过对稳定内存或其他RDD中的数据的转换（transformations）
    * RDD的数据转换（transformations）：map, filter, join
    * RDD记录有如何由其他数据集来计算自己的那部分数据的信息
    * 用户可以控制RDD的两个其他特性：
        * 持续性（persistence）
        * 划分（partition）

2. RDD编程接口
    * actions
        * 返回结果给应用
        * 输出数据到内存系统
    * persist：指示需要重新使用的RDD
    
