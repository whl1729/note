# JavaScript 学习杂记

## 2020年6月7日 Black Lives Matter

今天想了解下electron，第一次打开electron官网，首页却显示关于George Floyd.的同情和援助："Black Lives Matter", "To be silent is to be complicit".

感觉被程序员的善良暖到。同时也再一次体会到：程序员有能力也应该为改善社会尽一份力。

## 2020年5月28日 js 为什么要设计成单线程的？

## 2020年5月28日 js 为什么不提供 sleep 函数？

使用setInterval可以达到类似效果，但我想知道为啥js不提供sleep函数？

## 2020年5月27日 js 不会帮你检查函数名拼写是否有误

学习 JavaScript MDN 时，有个例子是双击按钮则改变网页背景颜色，我误把函数名`ondblclick`拼写为`ondbclick`，结果双击按钮后无任何反应，浏览器也不会报任何错误。原来，js 是允许你给对象添加新属性的，你以为你拼错了函数名，但 js 说：“不，你没有，你只是增加了一个新属性。”尴尬。。

## 2020年5月24日 谁能记住`substr`和`substring`的区别？

js中的`substr(from, length?)`和`substring(start, end?)`都是取子字符串，但用法却不一样，从函数签名中可以看出来。谁能记住这个区别呢？记忆技巧：先记住参数名字分别是`(from, length)`和`(start, end)`，然后记住对称性：函数名短的参数名长，函数名长的参数名短。

## 2020年5月23日 不懂为什么允许`'74'+3='743'`这种骚操作？

有人会期望这种结果吗？

## 2020年5月23日 不懂为什么要引入`===`这个运算符

直接用`==`不行吗？为啥要区分“只有值相等”和“值和类型均相等”？

## 2020年5月7日 MDN的这个安排很有见地

最近在学习JavaScript，主要是看MDN web docs。刚刚看到教程的第3章，其标题为"What went wrong? Troubleshooting JavaScript"，原来是教我们怎样debug js代码的。我觉得这个安排很有见地，首先把调试程序的方法教给你们，后面遇到各种各样的问题起码心里不慌。貌似 Rust 和 Golang 的 tutorial 要么没提及调试方法，要么将其作为附录。在这一点上，我认为MDN更胜一筹。

