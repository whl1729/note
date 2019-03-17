# 《C++ Primer》第9章学习笔记

## 9 Sequential Containers

### Overview of the Sequential Containers

1. Deciding Which Sequential Container to Use
    - Unless you have a reason to use another container, use a vector. 
    - If your program has lots of small elements and space overhead matters, don’t use list or forward_list. 
    - If the program requires random access to elements, use a vector or a deque
    - If the program needs to insert or delete elements in the middle of the container, use a list or forward_list. 
    - If the program needs to insert or delete elements at the front and the back, but not in the middle, use a deque. 
    - If the program needs to insert elements in the middle of the container only while reading input, and subsequently needs random access to the elements: 
        - First, decide whether you actually need to add elements in the middle of a container. It is often easier to append to a vector and then call the library sort function to reorder the container when you’re done with input. 
        - If you must insert into the middle, consider using a list for the input phase. Once the input is complete, copy the list into a vector.

2. Best Practices: If you’re not sure which container to use, write your code so that it uses only operations common to both vectors and lists: Use iterators, not subscripts, and avoid random access to elements. That way it will be easy to use either a vector or a list as necessary.

### Container Library Overview

1. Although we can store almost any type in a container, some container operations impose requirements of their own on the element type. We can define a container for a type that does not support an operation-specific requirement, but we can use an operation only if the element type meets that operation’s requirements.

2. Iterator Ranges
    - This element range is called a left-inclusive interval. The standard mathematical notation for such a range is `[ begin, end)` indicating that the range begins with begin and ends with, but does not include, end. 
    - end must not precede begin.

3. Standard Container Iterator Operation
```
*iter
iter->mem
++iter
--iter
iter1 == iter2
iter1 != iter2
```

4. Container type alias
    - iterator, const_iterator
    - reverse_iterator, const_reverse_iterator
    - size_type
    - value_type
    - reference, const_reference

5. there are actually two members named begin. One is a const member that returns the container’s const_iterator type. The other is nonconst and returns the container’s iterator type. 

6. Best Practices: When write access is not needed, use cbegin and cend.

7. Initializing a Container
    - When we initialize a container as a copy of another container, the container type and element type of both containers must be identical.
    - When we pass iterators, there is no requirement that the container types be identical. Moreover, the element types in the new and original containers can differ as long as it is possible to convert the elements we’re copying to the element type of the container we are initializing

8. Defining and Initializing Containers
```
C c;
C c1(c2);
C c1 = c2;
C c{a, b, c};
C c = {a, b, c};
C c(b, e);
// Constructors that take a size are valid for sequential containers only
C seq(n);
C seq(n, t);
```

9. When we define an array, in addition to specifying the element type, we
also specify the container size. Also, to use an array type we must specify both the element type and the size:
```
array<int, 42> arr;
array<int, 10>::size_type i; 
```

10. It is worth noting that although we cannot copy or assign objects of built-in array types, there is no such restriction on array:
```
int digs[10] = {0,1,2,3,4,5,6,7,8,9};
int cpy[10] = digs; // error: no copy or assignment for built-in arrays
array<int, 10> digits = {0,1,2,3,4,5,6,7,8,9};
array<int, 10> copy = digits; // ok: so long as array types match
```

11. assignment and swap
```
c1 = c2;  // c1 and c2 must be the same type
c = {a, b, c..};  // Not valid for array
swap(c1, c2);
c1.swap(c2);
// assign operations not valid for associative containers or array
seq.assign(b, e);  // The iterators b and e must not refer to elements in seq.
seq.assign(il);  // Replace the elements in seq with those in the initializer list il.
seq.assign(n, t);
```

12. Because the size of the right-hand operand might differ from the size of the left-hand operand, the array type does not support assign and it does not allow assignment from a braced list of values.

13. The sequential containers (except array) also define a member named assign that lets us assign from a different but compatible type, or assign from a subsequence of a container. 

14. Warning: Because the existing elements are replaced, the iterators passed to assign must not refer to the container on which assign is called.

15. Note: Excepting array, swap does not copy, delete, or insert any elements and is guaranteed to run in constant time. In fact, the elements themselves are not swapped; internal data structures are swapped.

16. Unlike how swap behaves for the other containers, swapping two arrays does exchange the elements. As a result, swapping two arrays requires time proportional to the number of elements in the array.

17. In the new library, the containers offer both a member and nonmember version of swap. The nonmember swap is of most importance in generic programs. As a matter of habit, it is best to use the nonmember version of swap.

18. Every container type supports the equality operators (== and !=); all the containers except the unordered associative containers also support the relational operators (>, >=, <, <=). The right- and left-hand operands must be the same kind of container and must hold elements of the same type.  Comparing two containers performs a pairwise comparison of the elements. These operators work similarly to the string relationals 

19. Note: We can use a relational operator to compare two containers only if the appropriate comparison operator is defined for the element type.

### Sequential Container Operations

1. Operations that Add elements to a Sequential Container
    - These operations change the size of the container, they are not supported by array.
    - forward_list has special versions of insert and emplace.
    - push_back and emplace_back not valid for forward_list.
    - push_front and emplace_front not valid for vector or string.
```
c.push_back(t);
c.emplace_back(args);
c.push_front(t);
c.emplace_front(args);
c.insert(p, t);
c.emplace(p, args);
c.insert(p, n, t);
c.insert(p, b, e);
c.insert(p, il);
```

2. When we use these operations, we must remember that the containers use different strategies for allocating elements and that these strategies affect performance. Adding elements anywhere but at the end of a vector or string, or anywhere but the beginning or end of a deque, requires elements to be moved. Moreover, adding elements to a vector or a string may cause the entire object to be reallocated. Reallocating an object requires allocating new memory and moving elements from the old space to the new.

3. When we use an object to initialize a container, or insert an object into a container, a copy of that object’s value is placed in the container, not the object itself. 

4. Because the iterator might refer to a nonexistent element off the end of the container, and because it is useful to have a way to insert elements at the beginning of a container, element(s) are inserted before the position denoted by the iterator.

5. Warning: It is legal to insert anywhere in a vector, deque, or string. However, doing so can be an expensive operation.

6. When we call an emplace member, we pass arguments to a constructor for the element type. The emplace members use those arguments to construct an element directly in space managed by the container.

7. Accessing Elements
    - at and subscript operator valid only for string, vector, deque, and array.
    - back not valid for forward_list.
```
c.back()   // Undefined if c is empty. 
c.front()  // Undefined if c is empty. 
c[n]       // Undefined if n >= c.size()
c.at[n]    // If the index is out of range, throws an out_of_range exception
```

8. Warning: Calling front or back on an empty container, like using a subscript that is out of range, is a serious programming error.

9. Subscripting and Safe Random Access
    - It is up to the program to ensure that the index is valid; the subscript operator does not check whether the index is in range.
    - If we want to ensure that our index is valid, we can use the at member instead. The at member acts like the subscript operator, but if the index is invalid, at throws an out_of_range exception.

10. erase Operations on Sequential Containers
    - Warning: The members that remove elements do not check their argument(s). The programmer must ensure that element(s) exist before removing them.
    - These operations return void. If you need the value you are about to pop, you must store that value before doing the pop.
    - pop_back not valid for forward_list.
    - pop_front not valid for vector and string.
    - Removing elements anywhere but the beginning or end of deque invalidates all iterators, references and pointers. Iterators, references and pointers to elements after the erasure point in a vector or string are invalidated.
```
c.pop_back();
c.pop_front();
c.erase(p);
c.erase(b, e);
c.clear();
```

11. 判断整数的奇偶性直接使用位运算：`num & 0x1`

12. Specialized forward_list Operations
    - In a singly linked list there is no easy way to get to an element’s predecessor. For this reason, the operations to add or remove elements in a forward_list operate by changing the element after the given element.
```
lst.before_begin();
lst.cbefore_begin();
lst.insert_after(p, t);
lst.insert_after(p, n, t);
lst.insert_after(p, b, e);
emplace_after(p, args);
lst.erase_after(p);
lst.erase_after(b, e);
```

13. If resize shrinks the container, then iterators, references, and pointers to the deleted elements are invalidated; resize on a vector, string, or deque potentially invalidates all iterators, pointers and references.
```
c.resize(n);
c.resize(n, t);
```

14. Warning: It is a serious run-time error to use an iterator, pointer, or reference that has been invalidated.

15. Advice: Because code that adds or removes elements to a container can invalidate iterators, you need to ensure that the iterator is repositioned, as appropriate, after each operation that changes the container.

16. Tip: Don’t cache the iterator returned from end() in loops that insert or delete elements in a deque, string, or vector.
    - When we add or remove elements in a vector or string, or add elements or
remove any but the first element in a deque, the iterator returned by end is always invalidated. 
    - Thus, loops that add or remove elements should always call end rather than use a stored copy. 
    - Partly for this reason, C++ standard libraries are usually implemented so that calling end() is a very fast operation.

### How a vector Grows

1. Container Size Management
```
c.shrink_to_fit();  // Request to reduce capacity() to equal size()
c.capacity();
c.reserve(n);  // Allocate space for at least n elements
```

2.  shrink_to_fit indicates that we no longer need any excess capacity. However, the implementation is free to ignore this request. There is no guarantee that a call to shrink_to_fit will return memory.

3. A vector may be reallocated only when the user performs an insert operation when the size equals capacity or by a call to resize or reserve with a value that exceeds the current capacity. How much memory is allocated beyond the specified amount is up to the implementation.

### Additional string Operations

1. Other ways to construct strings
```
string s(cp, n);  // s is c copy of the first n characters in the array to which cp points
string s(s2, pos2);  // s is a copy of the characters in the string s2 starting at the index pos2
string s(s2, pos2, len2);
```

2. substr
    - `s.substr(pos, n)` return a string containing n charactres from s starting at pos.
    - throws an out_of_range if the position exceeds the size of the string.
    - if the position plus the count is greater than the size, the count is adjusted to copy only up to the end of the string.

3. Operations to Modify strings
```
s.insert(pos, args);
s.erase(pos, len);
s.assign(args);
s.append(args);
s.replace(range, args);
```

4. string Search Operations
```
s.find(args);
s.rfind(args);
s.find_first_of(args);
s.find_last_of(args);
s.find_first_not_of(args);
s.find_last_not_of(args);
```

5. Warning: The string search functions return string::size_type, which is an unsigned type. As a result, it is a bad idea to use an int, or other signed type, to hold the return from these functions 

6. Possible Arguments to s.compare
```
s2
pos1, n1, s2
pos1, n1, s2, pos2, n2
cp
pos1, n1, cp
pos1, n1, cp, n2
```

7. Conversions between strings and Numbers
    - b indicates the numeric base to use for the conversion, b defaults to 10.
    - p is a pointer to a size_t in which to put the index of the first nonnumeric character in s; p defaults to 0.
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

8. If the string can’t be converted to a number, These functions throw an invalid_argument exception. If the conversion generates a value that can’t be represented, they throw out_of_range.

### Container Adaptors

1. The library defines three sequential container adaptors: stack, queue, and priority_queue.  There are container, iterator, and function adaptors. Essentially, an adaptor is a mechanism for making one thing act like another. A container adaptor takes an existing container type and makes it act like a different type. 

2. Operations and Types Common to the Container Adaptors
```
size_type
value_type
container_type
A a;
A a(c);
relational operators
a.empty();
a.size();
swap(a, b);
a.swap(b);
```

3. By default both stack and queue are implemented in terms of deque, and a priority_queue is implemented on a vector. We can override the default container type by naming a sequential container as a second type argument when we create the adaptor:
```
// empty stack implemented on top of vector
stack<string, vector<string>> str_stk;
// str_stk2 is implemented on top of vector and initially holds a copy of svec
stack<string, vector<string>> str_stk2(svec);
```

4. Other Stack Operations
```
s.pop();  // Removes, but does not return, the top element from the stack
s.push(item);
s.emplace(args);
s.top();  // Returns, but does not remove, the top element on the stack
```

5. Other queue, priority_queue Operations
```
q.pop();
q.front();
q.back();  // Valid only for queue
q.top();   // Valid only for priority_queue
q.push(item);
q.emplace(args);
```
