# C++ 使用笔记

## IO

1. The operator>> eats whitespace (space, tab, newline). Use yourstream.get() to read each character. or use `cin >> std::noskipws >> ch`.

2. getline
```
cin.getline() or getline(cin) ?

```
## 头文件

1. 常用函数/变量与对应的头文件

## 类

1. Making Window_mgr's Member Function (clear) a Friend of Screen：详见《C++ Primer》第281页。注意声明与定义顺序，否则会编译失败。
    - 先定义Window_mgr类，在类里面只声明但不定义clear函数。因为clear函数里面需要使用Screen类，而此时Screen类未声明，暂时不可见。
    - 定义Screen类，并声明clear为其friend。
    - 定义clear函数。注意：clear函数使用了Screen，编译器的Lookup过程如下：首先查找clear函数，没找到Screen的声明；然后回到Window_mgr中查找clear函数，还是没找到；最后在同一文件内clear函数前面找到了Screen的声明及定义。

2. If the member was declared as a const member function, then the definition must also specify const after the parameter list. 
