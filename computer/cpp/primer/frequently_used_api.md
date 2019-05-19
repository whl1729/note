# C++常用API

## Sequential Container

1. add elements
    - c.push_back(t);
    - c.emplace_back(args);
    - c.push_front(t);
    - c.emplace_front(args);
    - c.insert(p, t);
    - c.emplace(p, args);
    - c.insert(p, n, t);
    - c.insert(p, b, e);
    - c.insert(p, il);

2. access elements
    - c.back()   // Undefined if c is empty. 
    - c.front()  // Undefined if c is empty. 
    - c[n]       // Undefined if n >= c.size()
    - c.at[n]    // If the index is out of range, throws an out_of_range exception

3. erase
    - c.pop_back();
    - c.pop_front();
    - c.erase(p);
    - c.erase(b, e);
    - c.clear();

4. resize
    - c.resize(n);
    - c.resize(n, t);

5. vector
    - c.shrink_to_fit();  // Request to reduce capacity() to equal size()
    - c.capacity();
    - c.reserve(n);  // Allocate space for at least n elements

6. string
    - string s(cp, n);  // s is c copy of the first n characters in the array to which cp points
    - string s(s2, pos2);  // s is a copy of the characters in the string s2 starting at the index pos2
    - string s(s2, pos2, len2);
    - `getline(is, s)` reads the given stream up to and including the first newline and stores what it read—not including the newline—in its string argument. After getline sees a newline, even if it is the first character in the input, it stops reading and returns. If the first character in the input is a newline, then the resulting string is the empty string.
    - `s.empty()` returns true if s is empty, otherwise returns false.
    - `s.size()` returns the number of characters in s.
    - `s.substr(pos, n)` return a string containing n charactres from s starting at pos. pos defaults to 0, n defaults to a value that causes the library to copy all the characters in s starting from pos
    - s.insert(pos, args);
    - s.erase(pos, len);
    - s.assign(args);
    - s.append(args);
    - s.replace(range, args);
    - s.find(args);
    - s.rfind(args);
    - s.find_first_of(args); // args must be (c, pos), (s2, pos), (cp, pos) or (cp, pos, n)
    - s.find_last_of(args);
    - s.find_first_not_of(args);
    - s.find_last_not_of(args);

7. ***Conversions between strings and Numbers***
    - b indicates the numeric base to use for the conversion, b defaults to 10.
    - p is a pointer to a size_t in which to put the index of the first nonnumeric character in s; p defaults to 0.
    - If the string can’t be converted to a number, These functions throw an invalid_argument exception. If the conversion generates a value that can’t be represented, they throw out_of_range.
```
to_string(val);
stoi(s, p, b);
stol(s, p, b);
stoul(s, p, b);
stoll(s, p, b);
stoull(s, p, b);
stof(s, p);
stod(s, p);
stold(s, p);
```

8. ***Other Stack Operations***
```
s.pop();  // Removes, but does not return, the top element from the stack
s.push(item);
s.emplace(args);
s.top();  // Returns, but does not remove, the top element on the stack
```

9. ***Other queue, priority_queue Operations***
```
q.pop();
q.front(); // Returns, but does not remove, the front or back element. Valid only for queue
q.back();  // Valid only for queue
q.top();   // Returns, but does not remove, the highest-priority element. Valid only for priority_queue
q.push(item);
q.emplace(args);
```

10. forward_list
    - lst.before_begin();
    - lst.cbefore_begin();
    - lst.insert_after(p, t);
    - lst.insert_after(p, n, t);
    - lst.insert_after(p, b, e);
    - emplace_after(p, args);
    - lst.erase_after(p);
    - lst.erase_after(b, e);

## Associative Containers

1. Operations on pairs
    - pair<T1, T2> p;
    - pair<T1, T2> p(v1, v2);
    - pair<T1, T2> p = {v1, v2};
    - make_pair(v1, v2);
    - p.first
    - p.second
    - p1 relop p2
    - p1 == p2
    - p1 != p2

2. ***Four ways to add elements to a map***
    - word_count.insert({word, 1});
    - word_count.insert(make_pair(word, 1));
    - word_count.insert(pair<string, size_t>(word, 1));
    - word_count.insert(map<string, size_t>::value_type(word, 1));

3. ***Associative Container insert Operations***
    - c.insert(v)  // For map and set, returns pair<iter, bool>; For multi, returns iter
    - c.emplace(args) 
    - c.insert(b, e)  // returns void
    - c.insert(il)
    - c.insert(p, v)  // returns iter
    - c.emplace(p, args)

4. ***Removing Elements from an Associative Container***
    - c.erase(k)  // Removes every element with key k from c. Returns a count of how many elements were removed.
    - c.erase(p)  // Removes the element denoted by the iterator p from c. p must not be equal to c.end()
    - c.erase(b, e)

5. Operations to Find Elements in an Associative Container
    - c.find(k)
    - c.count(k)
    - c.lower_bound(k)
    - c.upper_bound(k)
    - c.equal_range(k)  // Returns a pair of iterators denoting the elements with key k

6. ***Unordered Container Management Operations***
    - c.bucket_count()
    - c.max_bucket_count()
    - c.bucket_size(n)
    - c.bucket(k)
    - local_iterator
    - const_local_iterator
    - c.begin(n), c.end(n)
    - c.cbegin(n), c.cend(n)
    - c.load_factor()
    - c.max_load_factor()
    - c.rehash(n)
    - c.reserve(n)

## Algorithms

1. \<stl_algobase.h\>头文件中的算法
    - equal
    - fill：将[first, last)内的所有元素改填新值
    - fill_n：将[first, last)内的前n个元素改填新值
    - iter_swap：将两个ForwardIterators所指的对象对调
    - lexicographical_compare：若小于则返回true，否则返回false
    - max
    - min
    - mismatch：返回一对迭代器，分别指向两序列中的不匹配点
    - swap

2. 单纯的数据处理
    - adjacent_find：寻找第一组满足条件的相邻元素，默认条件是“两元素相等”
    - count, count_if
    - find, find_if, find_end, find_first_of
    - for_each：将仿函数f施行于[first, last)区间内的每一个元素身上，f不可以改变元素内容，因为first和last都是InputIterators，不保证接受赋值行为。如果想要一一修改元素内容，应该使用算法transform
    - generate, generate_n：将仿函数gen的运算结果填写在[first, last)区间内的所有元素身上
    - includes：应用于有序区间。判断序列二S2是否“涵盖于”序列一S1，所谓“涵盖”是指“S2的每一个元素都出现于S1中”。注意S1或S2内的元素都可以重复，所以判断是否“涵盖”时还要保证S1的对应元素的出现次数不小于S2的元素出现次数
    - max_element：返回一个迭代器，指向序列中数值最大的元素
    - merge：应用于有序区间。合并两个有序集合，将结果存放于另一段空间。
    - min_element
    - partition：partition会将区间[first, last)中的元素重新排列。所有被一元条件运算pred判定为true的元素，都会被放在区间的前段；被判定为false的元素，都会被放在区间的后端。本算法不保证稳定性，如需保证可用stable_partition
    - remove, remove_copy, remove_if, remove_copy_if：并不真正从容器中删除元素，而是将所有不与value相等或被pred判定为false的元素放在容器前面，残余数据（如果有的话）则放在容器最后面
    - replace, replace_copy, replace_if, replace_copy_if
    - reverse, reverse_copy
    - rotate, rotate_copy：将[first, middle)内的元素和[middle, last)内的元素互换
    - search，search_n：在序列一[first1, last1)区间中，查找序列二[first2, last2)的首次出现位置
    - swap_ranges：将[first1, last1)区间内的元素与“从first2开始，个数相同”的元素互相交换
    - transform：以仿函数f作用于[first, last)中的每一个元素身上，并以其结果产生出一个新序列
    - unique, unique_copy

3. lower_bound：应用于有序区间。这是二分查找的一种版本。如果[first, last)具有与value相等的元素，便返回一个迭代器，指向其中第一个元素。如果没有这样的元素，便返回一个迭代器，指向第一个“不小于value”的元素。（也是在不破坏顺序的情况下，可插入value的第一个位置）

4. upper_bound：应用于有序区间。这是二分查找的一种版本。如果[first, last)具有与value相等的元素，便返回一个迭代器，指向其中第一个元素。如果没有这样的元素，便返回一个迭代器，指向第一个“大于value”的元素。（也是在不破坏顺序的情况下，可插入value的最后一个位置）

5. binary_search：如果[first, last)具有与value相等的元素，则返回true，否则返回false

6. next_permutation, prev_permutation：就地计算下一个/上一个排列组合，如果不存在则返回false，否则返回true。

7. random_shuffle：将[first, last)的元素次序随机重排。也即是说，在N!种可能的元素排列顺序中随机选出一种，此处N为last-first.

8. partial_sort, partial_sort_copy：本算法接受一个middle迭代器，然后重新安排[first, last)，使序列中的middle-first个最小元素以递增顺序排序，置于[first, middle)内，其余last-middle个元素安置于[middle, last)中，不保证有任何特定顺序。本算法内部是通过堆来实现的。

10. equal_range：返回一对迭代器i和j，代表与value相等的所有元素所形成的区间。

11. inplace_merge：合并两个有序序列。和merge一样，inplace_merge也是一种stable操作。

12. nth_element：重新排列[first, last)，使排序后，以nth所指的元素作为一个分界点，即[nth, last)内任何一个元素均大于[first, nth)内的元素。

13. 由于Merge Sort需借用额外的内存，而且在内存之间移动（复制）数据也会耗费不少时间，所以Merge Sort的效率比不上Quick Sort。实现简单、概念简单，是Merge Sort的两大优点。

## exception

1. ***Standard Exception Classes Defined in <stdexcept>***
    ```
    exception         The most general kind of problem
    runtime_error     Problem that can be detected only at run time
    range_error       Run-time error: result generated outside the range of values that are meaningful
    overflow_error
    underflow_error
    logic_error
    domain_error      Logic error: argument doesn't match the domain of a mathematical function
    invalid_argument  Logic error: inappropriate argument.
    length_error      Logic error: attempt to create an object larger than the maximum size for that type
    out_of_range      Logic error: used a value outside the valid range
    ```

