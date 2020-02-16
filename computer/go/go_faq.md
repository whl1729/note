# Go FAQs

## Q10 调用`os.Stat`报错"invalid argument"

1. 原因：输入参数末尾含有0字符。可以使用`bytes.Trim`去掉byte数组中的0字符

## Q9 编译C1代码时由于import sqlite3而失败，为什么？

1. 问题描述：编译报错："ccache: error: Failed to create directory .ccache/tmp: Permission denied"

2. 临时解决方案：`编译时增加选项 CCACHE_DISABLE=1`

## Q8 2019/7/2 为什么C1-InterfaceServer项目中的TestSetSpeakerVolumn函数中串行执行会失败？

## Q7 2019/7/1 通道只能先写后读吗？能不能反过来？

## Q6 2019/6/20 beego里面的StopRun的工作原理？

1. 问题描述：为什么我在handler中调用StopRun时不会抛出panic异常？StopRun函数内部就是调用panic啊。

2. 解答：
    - 调用StopRun时确实会抛出panic(ErrAbort)异常，这个异常会在recoverPanic中被捕捉，而recoverPanic对该异常实际上不作处理而直接返回。因此调用StopRun的效果就是函数立即返回，其后的

## Q5 2019/6/15 强类型、弱类型和无类型各有什么优缺点？

## Q4 2019/6/14 Go语言如何实现垃圾回收？

## Q3 2019/6/14 Go语言的channel是如何实现的？

1. 问题描述：channel如何实现同步互斥的？

## Q2 2019/6/7 Go语言的函数是怎样实现的？

1. 问题描述：比如Go语言的函数的内存管理是怎样的？

## Q1 2019/6/7 Go语言的标准库是怎样提供的？

1. 问题描述：Go标准库是以二进制文件的形式提供的吗？

