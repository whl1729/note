# 《STL源码剖析》第7章读书笔记

## 第7章 仿函数

### 7.1 仿函数概观

1. 仿函数（functors）是早期的命名，C++标准规格定案后采用的新名称是函数对象（function objects）。

2. 既然函数指针可以达到“将整组操作当做算法的参数”，那又何必有所谓的仿函数呢？原因在于函数指针毕竟不能满足STL对抽象性的要求，也不能满足软件积木的要求——函数指针无法和STL其他组件（如配接器adapter）搭配，产生更灵活的变化。

3. 就实现观点而言，仿函数其实就是一个“行为类似函数”的对象，为了能够“行为类似函数”，其类型定义中必须重载function call运算符。

4. ***如果想要使用STL build-in的仿函数，必须包含\<functional\>头文件，而\<functional\>包含\<bits/stl_function.h\>，后者定义了各种仿函数。***

5. 仿函数的主要用途是为了搭配STL算法。

### 7.2 可配接（Adaptable）的关键

1. STL仿函数应该有能力被函数配接器（function adapter）修饰，彼此像积木一样地串接。为了拥有配接能力，每一个仿函数必须定义自己的相应类型，从而可以让配接器获得仿函数的某些信息。相应类型都是一些typedef，所有必要操作在编译器就全部完成，不影响程序执行效率。

2. \<stl_function.h\>定义了两个classes，分别为代表一元仿函数的unary_function和代表二元仿函数的binary_function，其中没有任何data members或members functions，只有一些类型定义。任何仿函数，只要依个人需求选择继承其中一个class，便自动拥有了那些相应型别，也就自动拥有了配接能力。

### 7.3 算术类仿函数

1. STL built-in算术类仿函数
    - plus<T>
    - minus<T>
    - multiplies<T>
    - divides<T>
    - modulus<T>
    - negate<T>

2. 运算op的identity element，是指任何数值A与该元素做op运算，会得到A本身。加法的identity element为0，乘法的identity element为1.

### 7.4 关系运算类仿函数

1. STL built-in关系运算类仿函数
    - equal_to<T>
    - not_equal_to<T>
    - greater<T>
    - greater_equal<T>
    - less<T>
    - less_equal<T>

### 7.5 逻辑运算类仿函数

1. STL built-in逻辑运算类仿函数
    - logical_and<T>
    - logical_or<T>
    - logical_not<T>

### 7.6 证同（identity）、选择（select）、投射（project）

1. identity函数：任何数值通过此函数后，不会有任何改变（返回自身）。应用于\<stl_set.h\>中，用来指定RB-tree所需的KeyOfValue op，那是因为set元素的键值即实值，所以采用identity。

2. select1st函数：接受一个pair，传回其第一元素。应用于\<stl_map.h\>，用来指定RB-tree所需的KeyOfValue op，由于map是以pair元素的第一元素为其键值，所以采用select1st

3. select2nd函数：接受一个pair，传回其第二元素。SGI STL并没运用到该函数。

4. project1st：接受两个参数，传回第一参数，忽略第二参数。

5. project2nd：接受两个参数，传回第二参数，忽略第一参数。

