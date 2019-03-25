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

3. Member functions cannot use the Constructor Initializer list to set members.
```
// error: only constructors take member initializers
HasPtr& operator=(const HasPtr &rhp): ps(new string(*rhp.ps)), i(rhp.i) {}
```

4. Initialize static member of a class: The class declaration should be in the header file (Or in the source file if not shared). But the initialization should be in source file.

5. If we want users of the class to be able to call a friend function, then we must also declare the function separately from the friend declaration.

## 疑问

1. static class members的实现原理？

2. C/C++使用scanf或cin时，有时不等待用户输入，具体原因是什么？怎么解决？

3. 异常处理try-catch机制的实现原理？
