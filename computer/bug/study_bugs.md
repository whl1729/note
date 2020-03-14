# 学习中的Bug

## 3 使用equal_range查找确认存在的元素却返回不存在

- Bug发现时间：2019年4月4日
- Bug发现过程：在做《C++ Primer》Exercise 17.4时发现
- Bug出现原因：equal_range函数要求输入的序列是有序的，而我输入的vector中的元素并非有序的，导致equal_range使用二分法搜索时出现异常。意识到这个问题后，我第一次修改后的版本仍然有bug，原因是我使用的string中大小写混合，没意识到任意的小写字母比任意的大写字母的取值都要大，导致仍然没排序。
- 教训：使用API前一定要清楚API的约束条件。注意大小写混合时的字符串大小顺序。

## 2 打印空格变成打印换行符

- Bug发现时间：2019年4月2日
- Bug发现过程：在做《C++ Primer》 Exercise 16.15时发现
- Bug出现原因：在初始化字符串contents时，如果长度没达到要求则在后面填上空格，我调用`string(int num, char ch)`来添加10个空格，但我误写成`string(' ', 10)`，结果变成添加了32个换行符！因为' '被转换成int是32，而10转换成char恰好是换行符！
- 教训：记住API的用法。

## 1 编写《C++ Primer》第12章的Text-Query Program时没理清需求，导致实现与需求不符

- Bug发现时间：2019年3月22日
- Bug发现过程：自己编程完毕，对照课本时发现出错。
- Bug出现原因：编码前没理清需求，没考虑到计算单词出现次数时，同一行可能出现多次。后来考虑到这种情况后，通过在同一行调用find搜索单词来优化，又发现还有一个Bug：如果某个单词以目标为前缀或后缀，也会被我统计进去，而这是错误的。
- 教训：编码前理清需求，可以列举出来逐个分析；设计时要仔细考虑是否与需求符合。