# 《STL源码剖析》第3章读书笔记

## 第3章 迭代器概念与traits编程技法

1. 《Design Patterns》一书提供有23个设计模式，其中iterator模式定义如下：提供一种方法，使之能够依序访问某个聚合物（容器）所含的各个元素，而又无需暴露该聚合物的内部表述方式。

### 3.1 迭代器设计思维——STL关键所在

1. STL的中心思想在于：将数据容器和算法分开，彼此独立设计，最后再以一帖胶着剂将它们撮合在一起。这个胶着剂就是迭代器。

### 3.2 迭代器是一种smart pointer

1. 迭代器是一种行为类似指针的对象，而指针的各种行为中最常见也最重要的是解引用（dereference）和成员访问（member access），因此迭代器最重要的编程工作是对operator\*和operator->进行重载。

### 3.4 Traits编程技法——STL源代码门钥

1. 通过class template partial specialization的作用，不论是原生指针或class-type iterators，都可以让外界方便地取其相应类型：***value_type, difference_type, pointer, reference, iterator_category***。以上五种类型是最常用到的迭代器类型，如果你希望你所开发的容器能与STL水乳交融，一定要为你的容器的迭代器定义这五种相应类型。
```
template <class I>
struct iterator_traits
{
    typedef typename I::iterator_category iterator_category;
    typedef typename I::value_type value_type;
    typedef typename I::difference_type difference_type;
    typedef typename I::pointer pointer;
    typedef typename I::reference reference;
};
```

2. iterator_traits必须针对传入类型为pointer及pointer-to-const的情况设计特化版本。

3. 根据“迭代器所指对象之内容是否允许改变”的角度观之，迭代器分为两种：不允许改变“所指对象之内容”者，称为constant iterators，例如const int \*pic；允许改变“所指对象之内容”者，称为mutable iterators，例如int \*pi。当我们对一个mutable iterators进行解引用时，获得的是一个左值（lvalue），因为只有左值才允许赋值操作，右值不允许。

4. 根据移动特性与支持的操作，***迭代器被分为五类***：
    - Input Iterator：只读（read only），所指对象不允许外界改变。
    - Output Iterator：只写（write only）
    - Forward Iterator：运行“写入型”算法（例如replace()）在此种迭代器所形成的区间上进行读写操作
    - Bidirectional Iterator：可双向移动。某些算法需要逆向访问某个迭代器区间（例如逆向拷贝某范围内的元素），这时可以使用Bidirectional Iterators
    - Random Access Iterator：前四种迭代器都只支持一部分指针算术能力（前三种支持operator++，第四种再加上operator--），第五种则涵盖所有指针算术能力，包括p+n, p-n, p[n], p1 - p2, p1 < p2.

5. 迭代器的分类与从属关系如下所示。直线与箭头代表的并非C++的继承关系，而是所谓concept（概念）与refinement（强化）的关系。
```
Input ---
        |--> Forward --> Bidirectional --> Random Access
Output --
```

6. 设计算法时，如果可能，我们尽量针对上图的某种迭代器提供一个明确定义，并针对更强化的某种迭代器提供另一种定义，这样才能在不同情况下提供最大效率。

7. 当需要支持多种类型的相同功能时，如果设计成函数表，则在执行时期才决定使用哪一个版本，会影响程序效率。最好能够在编译器就选择正确的版本。重载函数机制可以达成这个目标。

8. 下面定义五个classes，代表五种迭代器类型：
```
struct input_iterator_tag {};
struct output_iterator_tag {};
struct forward_iterator_tag : public input_iterator_tag {};
struct bidirectional_iterator_tag : public forward_iterator_tag {};
struct random_access_iterator_tag : public bidirectional_iterator_tag {};
```

9. 任何一个迭代器，其类型永远应该落在“该迭代器所隶属之各种类型中，最强化的那个”，例如int \*的类型应该归属为random_access_iterator_tag.

10. STL算法的一个命名规则：以算法所能接受之最低阶迭代器类型，来为其迭代器类型参数命名。

11. 设计适当的相应类型，是迭代器的责任。设计适当的迭代器，则是容器的责任。唯容器本身，才知道该设计出怎样的迭代器来遍历自己，并执行迭代器该有的各种行为（前进、后退、取值、取用成员...）。至于算法，完全可以独立于容器和迭代器之外自行发展，只要设计时以迭代器为对外接口即可。

12. traits编程技法大量运用于STL实现中。它利用“内嵌类型”的编程技巧与编译器的template参数推导功能，增强C++未能提供的关于类型认证方面的能力，弥补C++不为强类型语言的遗憾。注：“内嵌类型”是指在类模板内利用模板类型来声明其他类型，如下所示
```
template <class T>
struct Iter
{
    typedef T value_type;  // 内嵌类型声明
    // ...
};
```

13. 为避免写代码时挂一漏万，自行开发的迭代器最好继承std::iterator，这样也可保证符合STL所需的规范。

14. STL把traits技法进一步扩大到迭代器以外的世界，于是有了所谓的\_\_type_traits。iterator_traits负责萃取迭代器的特性，\_\_type_traits则负责萃取类型（type）的特性。此处我们所关注的类型特性是指：这个类型是否具备non-trivial default ctor？是否具备non-trivial copy ctor？是否具备non-trivial assignment operator？释放具备non-trivial dtor？如果答案是否定的，我们在对这个类型进行构造、析构、拷贝、赋值等操作时，就可以采用最有效率的措施（比如根本不调用那些trivial的ctor或dtor），而采用内存直接处理操作如malloc()、memcpy()等，获得最高效率。这对于大规模而操作频繁的容器，有着显著的效率提升。

15. \_\_type_traits内定义了一些typedef，其值不是\_\_true_type就是\_\_false_type。注意：SGI定义出最保守的值（即\_\_false_type），然后再针对每一个标量类型（scalar types）设计适当的\_\_type_traits特化版本。
```
template <class type>
struct __type_traits
{
    typedef __true_type this_dummy_member_must_be_first;
    typedef __false_type has_trivial_default_constructor;
    typedef __false_type has_trivial_copy_constructor;
    typedef __false_type has_trivial_assignment_operator;
    typedef __false_type has_trivial_destructor;
    typedef __false_type is_POB_type;
};
```

16. 一个class何时该有自己的non-trivial default ctor, non-trivial copy ctor, non-trivial assignment operator, non-trivial destructor呢？一个简单的判断准则是：如果class内含指针成员，并且对它进行内存动态配置，那么这个class就需要实现自己的non-tirvial-xxx。
