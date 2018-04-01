# shell使用笔记

## grep

### 匹配多个字符串
grep默认不支持”或“运算符（”|“），需要加上-E选项或使用egrep才能支持”或“运算符。
```
grep -E 'warning|error'
egrep 'warning|error'
```
