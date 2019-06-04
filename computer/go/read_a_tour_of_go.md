# 《A Tour of Go》读书笔记

## 疑问

1. interface的实现原理？
2. method的实现原理？
3. fmt.Println如何支持打印各种类型的变量的？
4. Image待完成？
5. Equivalent Binary Trees为什么在main中执行go walk时没有输出？
6. Web Crawler待完成？
7. Inside a function, the := short assignment statement can be used in place of a var declaration with implicit type. Outside a function, every statement begins with a keyword (var, func, and so on) and so the := construct is not available. 为什么要这么设计？声明规则因声明位置而不同。

## 声明

1. Inside a function, the := short assignment statement can be used in place of a var declaration with implicit type. 伍注：`:=`只适用于声明默认类型的变量，所以`n := 1000,000,000,000`在32位系统下编译会报错，因为n被默认为int32变量，右边的数字会溢出。

## I/O

1. `%T` 打印变量的类型

2. Println 不会解析格式化字符串，会把格式化字符串当做普通字符串输出。

## Methods

1. while methods with value receivers take either a value or a pointer as the receiver when they are called.

