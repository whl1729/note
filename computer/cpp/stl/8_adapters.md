# 《STL源码剖析》第8章学习笔记

## 第8章 配接器

1. Adapter是一种设计模式，《Design Patterns》一书对adapter设计模式的定义如下：将一个class的接口转换为另一个class的接口，使原本因接口不兼容而不能合作的classes，可以一起运作。

### 8.1 配接器之概观与分类

1. STL所提供的各种配接器中，改变仿函数接口者，我们称为function adapter；改变容器接口者，我们称为container adapter；改变迭代器接口者，我们称为iterator adapter。

> 伍注：就目前我的理解而言，STL中的adapter有点像类似电子领域中的转接头，比如把网口转为USB口，把USB转为mini USB等。

2. STL提供的两个容器queue和stack，实际上是两个container adapter，它们修饰deque的接口而成就出另一种容器风貌。

3. iterator adapter
    - insert iterators：可以将一般迭代器的赋值操作转变为插入操作
        - back_inserter：从尾部插入
        - front_inserter：从头部插入
        - inserter：从任意位置插入
    - reverse iterators：可以将一般迭代器的行进方向逆转，使原本应该前进的operator++变成了后退操作，使原本应该后退的operator--变成了前进操作。适用于“从尾端开始进行”的算法。
    - iostream iterators：可以将迭代器绑定到某个iostream对象中，使得对迭代器的赋值操作转变为io操作
        - istream_iterator
        - ostream_iterator

4. function adapters包括连结（bind）、否定（negate）、组合（compose）以及对一般函数或成员函数的修饰（使其成为一个仿函数）。function adapters的价值在于，通过它们之间的绑定、组合、修饰能力，几乎可以无限制地创造出各种可能的表达式，搭配STL算法一起演出。

5. ***function adapters***

辅助函数  | 实际效果
--------- | --------
bind1st(const op& op, const T& x); | op(x, param);
bind2nd(const op& op, const T& x); | op(param, x);
not1(const Pred& pred); | !pred(param);
not2(const Pred& pred); | !pred(param1, param2);
compose1(const Op1& op1, const Op2& op2); | op1(op2(param));
compose2(const Op1& op1, const Op2& op2, const Op3 &op3); | op1(op2(param), op3(param));
ptr_fun(Result(\*fp)(Arg)); | fp(Arg);
ptr_fun(Result(\*fp)(Arg1, Arg2)); | fp(Arg1, Arg2);
mem_fun(S (T::\*f)()); | (param->\*f)();
mem_fun_ref(S (T::\*f)() const); | (param->\*f)();
mem_fun_ref(S (T::\*f)()); | (param->\*f)();
mem_fun(S (T::\*f)() const); | (param->\*f)();
mem_fun(S (T::\*f)(A)); | (param->\*f)(x);
mem_fun_ref(S (T::\*f)(A) const); | (param->\*f)(x);
mem_fun_ref(S (T::\*f)(A)); | (param->\*f)(x);
mem_fun(S (T::\*f)(A) const); | (param->\*f)(x);

### 8.3 iterator adapters

1. insert iterators的实现原理：每一个insert iterators内部都维护有一个容器（必须由用户指定），insert iterators的operator=操作符会调用底层容器的push_front()或push_back()或insert()操作函数，至于其他的迭代器常用操作比如前进（++）、后退（--）、取值（\*）、成员取用(->)等都被关闭功能。

2. 当迭代器被逆转方向时，虽然其实体位置（真正的地址）不变，但其逻辑位置（迭代器所代表的元素）改变了。
```
template <class Iterator>
reference reverse_iterator<Iterator>::operator*() const
{
    Iterator tmp = current;
    return *--tmp;
}
```

3. stream iterators可以将迭代器绑定到一个stream对象身上。
    - 所谓绑定一个istream object，其实就是在istream iterator内部维护一个istream member，对istream iterator所做的operator++操作，会被导引调用迭代器内部所含的那个istream member的输入操作（operator>>）
    - 所谓绑定一个ostream object，起始就是在ostream iterator内部维护一个ostream member，对ostream iterator所做的operator=操作，会被导引调用迭代器内部所含的那个ostream member的输出操作（operator<<）；而对ostream iterator所做的operator++操作，只会返回自身，不做其他处理。

4. 注意：只要用户定义一个istream iterator并绑定到某个istream object，程序便立刻停在istream_iterator\<\T>::read()函数，等待输入。因此，情在绝对必要的时刻才定义你所需要的istream iterator。

### 8.4 function adapters

1. 容器是以class templates完成，算法以function templates完成，仿函数是一种将operator()重载的class templates，迭代器则是一种将operator++和operator\*等指针常用行为重载的class template，container adapters和iterator adapters都是一种class template。

2. 每一个function adapter内部包含一个member object，其类型与它所要配接的对象（那个对象当然是一个“可配接的仿函数”）相同。当function adapter有了完全属于自己的一份修饰对象在手，它就成了该修饰对象的主人，也就有资格调用该修饰对象（一个仿函数），并在参数和返回值上面动手脚了。

3. 以binder1st为例，理解function adapters的原理
```
  template<typename _Operation>
    class binder1st
    : public unary_function<typename _Operation::second_argument_type,
			    typename _Operation::result_type>
    {
    protected:
      _Operation op;
      typename _Operation::first_argument_type value;

    public:
      binder1st(const _Operation& __x,
		const typename _Operation::first_argument_type& __y)
      : op(__x), value(__y) { }

      typename _Operation::result_type
      operator()(const typename _Operation::second_argument_type& __x) const
      { return op(value, __x); }

      typename _Operation::result_type
      operator()(typename _Operation::second_argument_type& __x) const
      { return op(value, __x); }
    } _GLIBCXX_DEPRECATED;

  template<typename _Operation, typename _Tp>
    inline binder1st<_Operation>
    bind1st(const _Operation& __fn, const _Tp& __x)
    {
      typedef typename _Operation::first_argument_type _Arg1_type;
      return binder1st<_Operation>(__fn, _Arg1_type(__x));
    }
```

4. ptr_fun：这种配接器使我们能够将一般函数当做仿函数使用。一般函数当做仿函数传给STL算法，就语言层面本来就是可以的，就好像原生指针可被当做迭代器传给STL算法一样。但如果你不使用ptr_fun配接器先做一番包装，你所使用的那个一般函数将无配接能力，也就无法和其他配接器接轨。（伍注：不理解，为什么需要经ptr_fun包装？）

5. mem_fun：一定要以配接器mem_fun修饰member function，才能被算法for_each接受。伍注：不理解？为什么要经mem_fun修饰？通过编程验证后，发现直接将member function作为for_each的输入参数时，会有以下报错，大概意思是调用方式有误，member function不能简单地通过operator()来调用。这就是需要mem_fun修饰的原因吧（经过mem_fun修饰后，就可以直接通过operator()来调用了）
```
 error: must use ‘.*’ or ‘->*’ to call pointer-to-member function in ‘__f (...)’, e.g. ‘(... ->* __f) (...)
```
