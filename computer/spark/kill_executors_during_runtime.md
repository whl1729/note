# 《Deallocate Executor During Runtime》

## 疑问
1. 每个没被kill的executor都要保存被kill的executor的执行结果吗？
2. 为什么是在两次shuffle map stage之间kill掉部分executor？可以是3次，4次甚至N次吗？
3. 怎么确定kill掉哪些executor？这个要在task开始前就设置好，还是可以在运行过程中动态设置？
