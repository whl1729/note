# 《STL源码剖析》第1章读书笔记

## 第1章 STL概论与版本简介

1. STL由Alexander Stepanov创造于1979年前后，并于1994年2月年正式成为ANSI/ISO C++的一部分。

2. STL并非以二进制代码面貌出现，而是以源代码面貌供应。STL存放在相应的各个C++头文件中。伍注：对于我的ubuntu 18.04虚拟机，STL位于/usr/include/c++/7/bits目录下。

3. STL六大组件
    - 容器（container）：各种数据结构，如vector，list，deque，set，map等，用来存放数据。从实现的角度来看，STL容器是一种class template。
    - 算法（algorithm）：各种常用算法，如sort，search，copy，erase等。从实现的角度来看，STL算法是一种function template。
    - 迭代器（iterators）：扮演容器与算法直接的胶合剂，是所谓的“泛型指针”。从实现的角度来看，迭代器是一种将operator\*, operator->, operator++, operator--等指针相关操作予以重载的class template。原生指针也是一种迭代器。
    - 仿函数（functors）：行为类似函数，可作为算法的某种策略。从实现的角度来看，仿函数是一种重载了operator()的class或class template。一般函数指针可视为狭义的仿函数。
    - 配接器（adapters）：一种用来修饰容器或仿函数或迭代器接口的东西。例如，STL提供的queue和stack，虽然看似容器，其实只能算是一种容器配接器，因为它们的底部完全借助deque，所有操作都由底层的deque供应。改变functor接口者，称为function adapter；改变container接口者，称为container adapter；改变iterator接口者，成为iterator adapter。
    - 配置器（allocators）：负责空间配置与管理。从实现的角度来看，配置器是一个实现了动态空间配置、空间管理、空间释放的class template。

4. STL六大组件的交互关系：Container通过Allocator取得数据储存空间，Algorithm通过Iterator存取Container内容，Functor可以协助Algorithm完成不同的策略变化，Adapter可以修饰或套接Functor。

5. class template里面可以定义template members
```
template <class T, class Alloc>
class vector
{
public:
    typedef T value_type;
    typedef value_type* iterator;

    template <class I>
    void insert(iterator pos, I first, I last)
    {
        cout << "insert()" << endl;
    }
};
```

6. template参数可以根据前一个template参数而设定默认值
```
template <class T, class Sequence = deque<T>>
class stack
{
public:
    stack() { cout << "stack" << endl; }
private:
    Sequence c;
};
```

7. 刻意制造临时对象的方法是，在类型名称之后直接加一对小括号，并可指定初值，例如Shape(3, 5) 或 int(8)，其意义相当于调用相应的constructor且不指定对象名称。STL最常将此技巧应用于仿函数与算法的搭配上。

8. 静态常量整数成员可以在class内部直接初始化。

9. 许多STL算法都提供了两个版本，一个用于一般状况（例如排序时以递增方式排列），一个用于特殊状况（例如排序时由使用者指定以何种特殊关系进行排列）。像这种情况，需要用户指定某个条件或某个策略，而条件或策略的背后由一整组操作构成，便需要某种特殊的东西来代表这“一整组操作”。代表“一整组操作”的，当然是函数。

10. 过去C语言时代，欲将函数当做参数传递，唯有通过函数指针才能达成。但是函数指针有缺点，最重要的是它无法持有自己的状态（局部状态，local state），也无法达到组件技术中的可适配性（adaptability），即无法再将某些修饰条件加诸于其上而改变其状态。

11. STL算法的特殊版本所接受的所谓“条件”或“策略”或“一整组操作”，都以仿函数形式呈现。所谓仿函数（functor）就是使用起来像函数一样的东西。如果你针对某个class进行operator()重载，它就成为一个仿函数。
