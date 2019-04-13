# C++ 使用笔记

## 编译问题

1. 如果编译链接多个文件时出现“multiple definition...”的错误，检查是否把报错的函数定义在头文件了，这样如果多个文件都包含了该头文件，则对应的函数定义会被复制多份。

2. 如果只更改了头文件，执行make会提示“make: xxx is up to date”，拒绝重新构建。这时可以clean一把再重新执行make。

3. 如果编译报错说某变量不是你定义的变量类型，检查是否命名空间冲突了。例如，明明定义了hash类模板，却报错“error: ‘hash’ is not a class template”，原因是在文件开头“using namespace std”，导致std命名空间下的hash与自己定义在全局命名空间下的hash冲突。

## IO

1. The operator>> eats whitespace (space, tab, newline). Use yourstream.get() to read each character. or use `cin >> std::noskipws >> ch`.

2. getline
```
getline(cin, str)   // ok
cin.getline(str)  // error
```

3. 由于iostream不能复制，我们定义iostream变量时必须定义成Reference类型。

4. 使用cout打印字符指针，输出的是对应的字符串
```
char word[] = "hello world";
cout << word << endl;  // print "hello world"
```
## Sequential Containers

1. 整数转字符串：使用to_string而非tostring.

2. string
```
s.substr(p, n)  // Return a string containing n characters from s starting at pos
string(int num, char ch) // 不要记错，不是(char, int)
```

3. [Why can't I make a vector of references?](https://stackoverflow.com/questions/922360/why-cant-i-make-a-vector-of-references): The component type of containers like vectors must be assignable. References are not assignable (you can only initialize them once when they are declared, and you cannot make them reference something else later). Other non-assignable types are also not allowed as components of containers, e.g. vector<const int> is not allowed.

## Generic Algorithms

1. foreach + lambda：在类的成员函数中使用for_each及lambda时，如果lambda内部需要使用类的成员，则应该将this放入capture list中，否则会报错：“error: ‘this’ was not captured for this lambda function”。此外，for_each是对input range中的每一个object调用lambda表达式，因此参数列表中的参数类型是object而非object指针。举例：`for_each(elements, first_free, [this](string &s) { alloc.destroy(&s); }); `

2. using placeholders names( Defined in functional header):
```
using std::placeholders::_1;
// or
using namespace std::placeholders;
```

3. equal_range要求序列是有序的。注意API的约束条件。

## Dynamic Memory

1. weak_ptrs
```
weak_ptr<T> w;
w.reset()      // Makes w null.
w.use_count()  // The number of shared_ptrs that share ownership with w
w.expired()    // Return true if w.use_count() is zero, false otherwise
w.lock()       // If expired is true, returns a null shared_ptr; otherwise returns a shared_ptr to the object to which w points.
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

6. 定义class时别忘了大括号后面要加个分号。

## Templates

1. ***In order to refer to a specific instantiation of a template (class or function) we must first declare the template itself.***
```
// forward declarations needed for friend declarations in Blob
template <typename> class BlobPtr;
template <typename> class Blob; // needed for parameters in operator==
template <typename T>
    bool operator==(const Blob<T>&, const Blob<T>&);
template <typename T> class Blob {
    // each instantiation of Blob grants access to the version of
    // BlobPtr and the equality operator instantiated with the same type
    friend class BlobPtr<T>;
    friend bool operator==<T>(const Blob<T>&, const Blob<T>&);
};
```

2. Make the function a frined of a class template that uses nontype parameters. Note: Don't forget the <> after the operator.
```
template <unsigned H, unsigned W> class Screen;
template <unsigned H, unsigned W>
    ostream& operator<<(ostream &os, const Screen<H,W> &sc);

template <unsigned H, unsigned W>
class Screen
{
    friend ostream& operator<< <>(ostream &os, const Screen<H,W> &sc); 
    // member functions
}
```

4. Defining static members in templates: The following code will cause the error: " error: specializing member ‘testClass<int>::\_data’ requires ‘template<>’ syntax", refer to [C++: specializing member requires «template\<\> syntax](https://stackoverflow.com/questions/12525012/c-specializing-member-requires-template-syntax/12525107) for a solution.

5. class template explicit specialization must be preceded by 'template <>'
```
template <class Key> struct hash
{
    // ...
};

// Note: Here 'template <>' must be provided
template <> struct hash<char>
{
    // ...
};
```

## namespace

1. Caution: Avoid using Directives. A using declaration puts the name in the same scope as that of the using declaration itself. It is as if the using declaration declares a local alias for the namespace member.

## Headers

```
assert: cassert
accumulate: numeric
initializer_list: initializer_list
mem_fn: functional
move: utility
pair: utility
runtime_error: stdexcept
shared_ptr: memory
```

## Questions

1. static class members的实现原理？

2. C/C++使用scanf或cin时，有时不等待用户输入，具体原因是什么？怎么解决？

3. 异常处理try-catch机制的实现原理？

4. C++ class的内存布局是怎样的？class的成员函数是怎样存储的？如果成员函数存储在类外面，调用时怎么找到该成员函数？比如一个Derived类继承自Base类，通过Derived对象调用继承自Base的成员函数的过程是怎样的？

5. 类成员指针不支持大小比较操作吗？
```
error: invalid operands of types ‘float Point3d::*’ and ‘float Point3d::*’ to binary ‘operator<’
     return ((mem1 < mem2) ? "member 1 occurs first" : "member 2 occurs first");
             ~~~~~~^~~~~~~
```

6. 假设一个类继承多个虚基类，编译器会为这个类生成多个指针，分别指向每一个虚基类吗？

7. 派生类中含有每一个基类的vptr吗？

8. 即使没创建类对象，类中的静态数据成员也已经在内存中创建，是吗？

9. 没看懂《深度探索C++对象模型》第5.2节“vptr初始化语意学”中关于“constructor执行算法”的介绍：为什么vptr的初始化要在base class constructors调用操作之后？

10. C++的全局对象何时创建与释放？一个C++程序在执行main的第一条指令前要做哪些事情？

11. STL如何做到thread-safe？
