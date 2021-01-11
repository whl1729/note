# 如何成为前端开发者

## 知乎问题：Web前端怎样入门

### 匿名用户的回答

[Web 前端怎样入门？ - 知乎](https://www.zhihu.com/question/32314049/answer/100898227)

三个月可以入门，分为三阶段：

#### 第一阶段：HTML + CSS

5天完成以下第1~2点，5天完成第3~4点。

1. 刷一遍MDN上介绍HTML和CSS的部分，有个大致印象。
2. 看《CSS权威指南（第四版）》。
3. 做IFE2015 task1.
4. 阅读代码规范，重写IFE2015 task1.

进阶：

1. 掌握预处理工具Sass或Less。
2. 阅读Bootstrap源码。
3. 阅读《CSS 揭秘》。

#### 第二阶段：JavaScript

广义的JavaScript可以大致分为语言特性（ECMAScript）和Web API（DOM、BOM等）。以下内容用时1个月左右。

1. 阅读《JavaScript 高级程序设计（第3版》。
2. 阅读《JavaScript 语言精髓》。
3. 阅读《ES6 标准入门》。
4. 阅读《You Don't Know JS Yet》。
5. 刷IFE2016阶段二的题目。

进阶：

1. 学习TypeScript。
2. 学习使用包管理工具npm。
3. 尝试使用webpack构建项目，并通过Babel编译ES新特性的代码兼容旧版浏览器。
4. 配置ESLint规范代码格式，养成良好编码习惯。
5. 看一下lodash。
6. 看[Web Fundamentals](https://developers.google.com/web/fundamentals/)。

#### 第三阶段：JavaScript 框架

1. 熟悉掌握至少一种框架，如React，Angular或Vue。
2. 把IFE2016刷通关。

进阶：

1. 学习框架周边生态，如无数种Redux封装，无数种CSS in JS 方案等。
2. 造些轮子。
3. 带着问题阅读源码。
4. Node.js, Backend for Frontend.

### 汪小黑

[Web 前端怎样入门？ - 汪小黑的回答 - 知乎](https://www.zhihu.com/question/32314049/answer/713711753)

分为4个部分：

#### 第一部分：学习Html（2天）

1. 带着以下问题看w3cschool教程：
    - Html是什么
    - Html的基本结构长什么样子
    - 标签是什么
    - 属性是什么

#### 第二部分：学习CSS（5天）

1. 带着以下问题看w3cschool教程：
    - CSS是什么
    - CSS的语法是怎样的结构
    - 怎么对一个标签增加简单的样式
    - CSS盒模型是什么
    - display的值有哪几种，这几种值的区别是什么
    - CSS怎么实现垂直水平居中？你能使用几种方式实现
    - 页面的常见布局有哪几种，分别可以怎么实现
2. 阅读《CSS权威指南》。
3. 学习调试Html+CSS。参考：[前端入门必会的初级调试技巧](https://zhuanlan.zhihu.com/p/145466139)
4. 做一个google首页。

#### 第三部分：学习JavaScript（3周）

1. 带着以下问题看w3cschool教程：
    - js有哪些基本类型，每种基本类型是干啥的
    - 对象是什么，函数是什么，数组是什么
    - 数组、函数、对象的常用方法有哪些
    - DOM是什么，我能用它做什么
    - jquery是什么
2. 阅读《JavaScript 高级程序设计》。
3. 学习调试JavaScript。参考：[前端入门必会的初级调试技巧](https://zhuanlan.zhihu.com/p/145466139)
4. 做2048小游戏。
5. 带着问题学习promise和fetch：
    - promise是什么，它是为了解决什么问题
    - fetch是什么，为了解决什么问题
    - fetch和promise有什么关系
    - fetch和ajax有什么关系
6. 做一个聊天机器人

#### 第四部分：学习框架（1个月）

1. 学习node.js
    - node和npm是什么，它们可以用来做什么
    - npm init命令有什么作用
    - node_modules和package.json有什么作用

2. 学习Vue。带着问题看官方文档的基础部分，vuex和vue-router暂时跳过。慕课上的vue2入门课程也可以看下。
    - 使用vue-cli生成的项目，目录结构是怎样的？其中每个文件夹和每个文件的作用是什么？
    - 什么是双向绑定
    - mvvm框架是什么意思

3. 实现一个todolist。

4. 学习vuex和vue-router.
    - vuex和vue-router分别是什么
    - vuex和vue-router分别能做什么
    - vuex和vue-router的诞生是为了解决什么问题
    - 什么情况下使用vuex，什么情况下使用vue-router

5. 使用vue完成饿了么前后台webapp

6. 使用vue完成QQ音乐

## 参考资料

1. [Web前端怎样入门？](https://www.zhihu.com/question/32314049)