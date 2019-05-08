# C++ STL源码剖析

## gcc相关知识

1. GCC typically has the standard C++ headers installed in /usr/include/c++/\<version\>/. You can run gcc -v to find out which version you have installed.

2. `g++ -dM -E -x c++ -std=c++11 /dev/null`查看g++定义的宏。

3. [What is \_GLIBCXX\_VISIBILITY?](https://stackoverflow.com/questions/29270208/what-is-glibcxx-visibility): It's a preprocessor macro. And is defined as:
```
#if _GLIBCXX_HAVE_ATTRIBUTE_VISIBILITY
#define _GLIBCXX_VISIBILITY(V) __attribute__ ((__visibility__ (#V)))
#else
#define _GLIBCXX_VISIBILITY(V) 
#endif
```

> 备注：在我的ubuntu 18.04环境中，\_GLIBCXX_HAVE_ATTRIBUTE_VISIBILITY定义在/usr/include/x86_64-linux-gnu/c++/7/bits/c++config.h文件中。

4. The \_\_visibility\_\_ attribute is used for defining the visibility of the symbols in a DSO file. Using "hidden" instead of "default" can be used to hide symbols from things outside the DSO. For example:
```
// foo() would be useable from outside the DSO .
__attribute__ ((__visibility__("default"))) void foo();
// bar() is basically private and can only be used inside the DSO.
__attribute__ ((__visibility__("hidden"))) void bar();
```

5. 为便于论述，约定以下环境变量。其中$(include)是我的Ubuntu 18环境下的C++头文件的根目录，$(gnu_include)是我的Ubuntu 18环境下的g++编译器关于C++的其他一些头文件的根目录。
```
include=/usr/include/c++/7/
gnu_include=/usr/include/x86_64-linux-gnu/c++/7/
```

## allocator

1. allocator继承\_\_allocator_base<\_Tp>，在$(gnu_include)/bits/c++allocator.h文件中可以找到\_\_allocator_base<\_Tp>的定义：
```
  template<typename _Tp>
    using __allocator_base = __gnu_cxx::new_allocator<_Tp>;
```

2. \_\_gnu_cxx::new_allocator<\_Tp>定义在$(include)/ext/new_allocator.h文件中。

3. new_allocator::allocate的主要操作
```
	return static_cast<_Tp*>(::operator new(__n * sizeof(_Tp)));
```

4. new_allocator::deallocate的主要操作
```
	::operator delete(__p);
```

5. new函数及operator new的实现定义在哪里？
    - 答：我猜测是已经编译进二进制文件中了。在/usr/lib/gcc/x86_64-linux-gnu/7目录下发现有libstdc++.a和libstdc++.so文件，执行`nm libstdc++.a | grep new`命令发现其中含有一些带有new字眼的函数。

## iterator

1. vector iterator的定义在$(include)/bits/stl_vector.h文件中
```
    typedef __gnu_cxx::__normal_iterator<pointer, vector> iterator;
    typedef __gnu_cxx::__normal_iterator<const_pointer, vector> const_iterator;
    typedef std::reverse_iterator<const_iterator>	const_reverse_iterator;
    typedef std::reverse_iterator<iterator>		reverse_iterator;
```

2. iterator的定义
```
  template<typename _Category, typename _Tp, typename _Distance = ptrdiff_t,
           typename _Pointer = _Tp*, typename _Reference = _Tp&>
    struct iterator
    {
      typedef _Category  iterator_category;
      typedef _Tp        value_type;
      typedef _Distance  difference_type;
      typedef _Pointer   pointer;
      typedef _Reference reference;
    };
```

3. iterator_traits的定义
```
  template<typename _Iterator>
    struct iterator_traits
    {
      typedef typename _Iterator::iterator_category iterator_category;
      typedef typename _Iterator::value_type        value_type;
      typedef typename _Iterator::difference_type   difference_type;
      typedef typename _Iterator::pointer           pointer;
      typedef typename _Iterator::reference         reference;
    };
```

4. 疑问：不明白为什么要定义iterator_traits来这么封装一层？直接用原来的iterator来获取对应的value_type等不是更简便吗？
    - 一个可能的解释是：STL必须接受原生指针作为一种迭代器，这时就不能通过\_Iterator::value_type的方式来得到value_type，因此需要封装一层，来屏蔽原生指针与一般意义下的迭代器在获取value_type等类型时的差异。

5. \_\_normal_iterator, reverse_iterator, insert_iterator, back_insert_iterator, back_insert_iterator等均定义在$(include)/bits/stl_iterator.h中。

6. iterator_category: STL提供的算法的操作对象是迭代器，设计算法时，如果可能，我们尽量针对上图的某种迭代器提供一个明确定义，并针对更强化的某种迭代器提供另一种定义，这样才能在不同情况下提供最大效率。重载函数机制可以达成这个目标。因此我们为迭代器定义了一个iterator_category类型成员，用以区分5种迭代器类型。
```
  struct input_iterator_tag { };

  //  Marking output iterators.
  struct output_iterator_tag { };

  // Forward iterators support a superset of input iterator operations.
  struct forward_iterator_tag : public input_iterator_tag { };

  // Bidirectional iterators support a superset of forward iterator operations.
  struct bidirectional_iterator_tag : public forward_iterator_tag { };

  // Random-access iterators support a superset of bidirectional iterator operations.
  struct random_access_iterator_tag : public bidirectional_iterator_tag { };
```
