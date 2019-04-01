# C++ 使用笔记

## 编译问题

1. 如果编译链接多个文件时出现“multiple definition...”的错误，检查是否把报错的函数定义在头文件了，这样如果多个文件都包含了该头文件，则对应的函数定义会被复制多份。

2. 如果只更改了头文件，执行make会提示“make: xxx is up to date”，拒绝重新构建。这时可以clean一把再重新执行make。

## IO

1. The operator>> eats whitespace (space, tab, newline). Use yourstream.get() to read each character. or use `cin >> std::noskipws >> ch`.

2. getline
```
getline(cin, str)   // ok
cin.getline(str)  // error
```

3. 由于iostream不能复制，我们定义iostream变量时必须定义成Reference类型。

## Sequential Containers

1. 整数转字符串：使用to_string而非tostring.

## Generic Algorithms

1. foreach + lambda：在类的成员函数中使用for_each及lambda时，如果lambda内部需要使用类的成员，则应该将this放入capture list中，否则会报错：“error: ‘this’ was not captured for this lambda function”。此外，for_each是对input range中的每一个object调用lambda表达式，因此参数列表中的参数类型是object而非object指针。举例：`for_each(elements, first_free, [this](string &s) { alloc.destroy(&s); }); `

2. using placeholders names: 
```
using std::placeholder::_1;
// or
using namespace std::placeholders;
```

## Classes

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

## Headers
```
move: utility
pair: utility
shared_ptr: memory
```

## Questions

1. static class members的实现原理？

2. C/C++使用scanf或cin时，有时不等待用户输入，具体原因是什么？怎么解决？

3. 异常处理try-catch机制的实现原理？
