# AI工程师职业指南
本文是《<程序员>2017精华本》关于“AI工程师职业指南”的总结。

## 如何成为一名机器学习算法工程师

### 基础开发能力

1. 单元测试
对于算法开发这种流程变动频繁的开发活动而言，做好模块设计和单元测试是不给自己和他人挖坑的重要保证。

2. 逻辑抽象复用
对重复逻辑做好抽象，避免代码中出现大量重复代码或相似代码。

### 概率和统计基础

1. 概率分布
    * 伯努利分布
    * 二项分布
    * 多项分布
    * Beta分布
    * 狄里克莱分布
    * 泊松分布
    * 高斯分布
    * 指数分布

2. 假设检验

3. 参数估计
    * 最大似然估计
    * 最大后验估计
    * EM算法

### 机器学习理论

0. 资源推荐
    * Andrew Ng的《机器学习》公开课
    * 《Learning from Data》（中文版本叫《机器学习基石》）公开课
    * 《An Introduction to Statistical Learning with Application in R》
    * 《Elements Of Statistical Learning》
    * 《Pattern Recognition and Machine Learning》

1. 基础理论
    * VC维
    * 信息论。可参考《Elements of Information Theory》
    * 正则化和bias-variance tradeoff
    * 最优化理论

2. 有监督学习
    * 朴素贝叶斯
    * 线性模型
    * 树形模型
    * 神经网络
    * 以GDBT为代表的boosting组合
    * 以随机森林为代表的bagging组合

3. 无监督学习
    * 聚类
    * 嵌入表示

### 开发语言和开发工具
1. 开发语言
    * Python
    * R
    * Scala

2. 开发工具
    * Python库： Numpy, Scipy, sklearn, pandas, Matplotlib
    * LibSVM, Liblinear, XGBoost
    * Hadoop
    * Spark
    * Spark Streaming
    * Storm
    * Flink
    * Tensorflow

### 机器学习算法工程师领域现状

1. 推荐系统
2. 广告系统
3. 搜索系统
4. 风控系统

## 求职技术突破：深度学习的专业路径

### 数学基础

1. 数学分析

2. 线性代数

3. 概率论

4. 凸优化
推荐书籍：Stephen Boyd的《Convex Optimization》

5. 机器学习
推荐书籍：《The Elements of Statistical Learning》

### 计算机基础

1. 编程语言
在深度学习中，使用最多的两门编程语言是C++和Python。

2. Linux操作系统
深度学习系统通常运行在开源的Linux系统上，目前深度学习社区较为常用的Linux发行版主要是Ubuntu。

3. CUDA编程
深度学习离不开GPU并行计算，而CUDA是一个很重要的工具。CUDA开发套件是Nvidia提供的一套GPU编程套件，实践中使用较多的是CUDA-BLAS库。

4. 其他计算机基础知识
掌握深度学习技术不能只满足于使用Python调用几个主流深度学习框架，从源码入手去理解深度学习算法的底层实现是进阶的必由之路。这时，掌握数据结构与算法（尤其是图算法）知识、分布式计算（理解常用的分布式计算模型）、必要的GPU和服务器的硬件知识，就很有必要了。

