# 《C++ Primer》第10章学习笔记

## 10 Generic Algorithm

### Overview

1. Most of the algorithms are defined in the algorithm header. The library also defines a set of generic numeric algorithms that are defined in the numeric header.

2. Algorithms Never Execute Container Operations
    - The generic algorithms do not themselves execute container operations. They operate solely in terms of iterators and iterator operations.
    - Algorithms never change the size of the underlying container.Algorithms may change the values of the elements stored in the container, and they may move elements around within the container. They do not, however, ever add or remove elements directly.
    - The library algorithms operate on iterators, not containers. Therefore, an algorithm cannot (directly) add or remove elements.

3. The algorithms that take an input range always use their first two parameters to denote that range. These parameters are iterators denoting the first and one past the last elements to process.

4. The most basic way to understand the algorithms is to know whether they read elements, write elements, or rearrange the order of the elements.

5. Note: The type of the third argument to accumulate determines which addition operator is used and is the type that accumulate returns.
```
vector<double> dvec{1.1, 2.2, 3.14};
cout << accumulate(dvec.cbegin(), dvec.cend(), 0.0) << endl;  // output 6.44
cout << accumulate(dvec.cbegin(), dvec.cend(), 0) << endl;  // output 6

```

6. Ordinarily it is best to use cbegin() and cend() with algorithms that read, but do not write, the elements. However, if you plan to use the iterator returned by the algorithm to change an element’s value, then you need to pass begin() and end().

7. Iterator Arguments
    - The elements that constitute these sequences can be stored in different kinds of containers.
    - Algorithms that operate on two sequences differ as to how we pass the second sequence. Some algorithms take three iterators, others take four iterators.
    - Warning: Algorithms that take a single iterator denoting a second sequence assume that the second sequence is at least as large at the first. It is up to us to ensure that the algorithm will not attempt to access a nonexistent element in the second sequence. 
    ```
    // roster2 should have at least as many elements as roster1
    equal(roster1.cbegin(), roster1.cend(), roster2.cbegin());
    ```

8. Read-Only Algorithms
    - accumulate
    - count
    - equal
    - find
    - find_if: The third argument to find_if is a predicate. The find_if algorithm calls the given predicate on each element in the input range. It returns the first element for which the predicate returns a nonzero value, or its end iterator if no such element is found.

9. Algorithms That Write Container Elements
    - fill
    - fill_n
    - back_inserter
    - copy: the destination passed to copy be at least as large as the input range.
    - replace
    - replace_copy:  create a new sequence to contain the results.

10. Warning: Algorithms Do Not Check Write Operations. Algorithms that write to a destination iterator assume the destination is large enough to hold the number of elements being written.

11. insert iterator: An insert iterator is an iterator that adds elements to a container. When we assign through an insert iterator, a new element equal to the right-hand value is added to the container.

12. back_inserter takes a reference to a container and returns an insert iterator bound to that container. When we assign through that iterator, the assignment calls push_back to add an element with the given value to the container.

13. Algorithms That Reorder Container Elements
    - sort
    - stable_sort
    - unique: unique reorders the input range so that each word appears once in the front portion of the range and returns an iterator one past the unique range

14. Note: `unique` overwrites adjacent duplicates so that the unique elements appear at the front of the sequence. The iterator returned by unique denotes one past the last unique element. The elements beyond that point still exist, but we don’t know what values they have.

### Customizing Operations

1. A predicate is an expression that can be called and that returns a value that can be used as a condition. The predicates used by library algorithms are either unary predicates (meaning they have a single parameter) or binary predicates (meaning they have two parameters). 

2. callable object
    - An object or expression is callable if we can apply the call operator to it. That is, if e is a callable expression, we can write e(args) where args is a comma-separated list of zero or more arguments.
    - We can pass any kind of callable object to an algorithm. 
    - four kinds: functions, function pointers, classes that overload the function-call operator and lambda expressions.

3. lambda
    - A lambda expression represents a callable unit of code. It can be thought of as an unnamed, inline function. 
    - Unlike a function, lambdas may be defined inside a function. 
    - unlike ordinary functions, a lambda must use a trailing return to specify its return type.
    - Lambdas with function bodies that contain anything other than a single return statement that do not specify a return type return void.
    - A lamba expression has the form
    ```
    [capture list] (parameter list) -> return type { function body
    ```

4. A lambda may not have default arguments. Therefore, a call to a lambda always has as many arguments as the lambda has parameters.

5. Passing Arguments to a Lambda
    - A lambda may use a variable local to its surrounding function only if the lambda captures that variable in its capture list.
    - The capture list is used for local nonstatic variables only; lambdas can use local statics and variables declared outside the function directly.

6. When we define a lambda, the compiler generates a new (unnamed) class type that corresponds to that lambda. 
    - When we pass a lambda to a function, we are defining both a new type and an object of that type: The argument is an unnamed object of this compiler-generated class type. 
    - When we use auto to define a variable initialized by a lambda, we are defining an object of the type generated from that lambda. 
    - By default, the class generated from a lambda contains a data member corresponding to the variables captured by the lambda. 

7. Lambda Capture List
    - When we mix implicit and explicit captures, the first item in the capture list must be an & or =, and the explicitly captured variables must use the alternate form.
```
[]
[names]
[&]
[=]
[&, identifier_list]
[=, reference_list]
```

8. The value of a captured variable is copied when the lambda is created, not when it is called:
```
void fcn1()
{
    size_t v1 = 42; // local variable
    // copies v1 into the callable object named f
    auto f = [v1] { return v1; };
    v1 = 0;
    auto j = f(); // j is 42; f stored a copy of v1 when we created it
}
```

9. If we capture a variable by reference, we must be certain that the referenced object exists at the time the lambda is executed. The variables captured by a lambda are local variables. These variables cease to exist once the function completes. If it is possible for a lambda to be executed after the function finishes, the local variables to which the capture refers no longer exist.

10. Advice: Keep Your Lambda Captures Simple. We can avoid potential problems with captures by minimizing the data we capture. Moreover, if possible, avoid capturing pointers or references.

11. Mutable Lambda
    - By default, a lambda may not change the value of a variable that it copies by value. If we want to be able to change the value of a captured variable, we must follow the parameter list with the keyword mutable. Lambdas that are mutable may not omit the parameter list.
    - Whether a variable captured by reference can be changed (as usual) depends only on whether that reference refers to a const or nonconst type.

12. By default, if a lambda body contains any statements other than a return, that lambda is assumed to return void. Like other functions that return void, lambdas inferred to return void may not return a value.

13. Lambda vs Function
    - Lambda expressions are most useful for simple operations that we do not need to use in more than one or two places. 
    - If we need to do the same operation in many places, or if an operation requires many statements, it is ordinarily better to use a function.
    - sometimes we can't define an unary predicate by using function, so we can use a lambda expression instead.

14. Binding Arguments
    - Defined in the functional header
    - It takes a callable object and generates a new callable that “adapts” the parameter list of the original object.
    - The general form of a call to bind is: `auto newCallable = bind(callable, arg_list);`
    - when we call newCallable, newCallable calls callable, passing the arguments in arg_list.
    - The arguments in arg_list may include names of the form \_n, where n is an integer. These arguments are “placeholders” representing the parameters of newCallable. They stand “in place of” the arguments that will be passed to newCallable. The number n is the position of the parameter in the generated callable: \_1 is the first parameter in newCallable, \_2 is the second, and so forth. 
    - we can use bind to bind or rearrange the parameters in the given callable.

15. Using placeholders name: `using namespace std::placeholders;`

16. Binding Reference Parameters
    - If we want to pass an object to bind without copying it, we must use the library ref function.
    - The ref function returns an object that contains the given reference and that is itself copyable. There is also a cref function that generates a class that holds a reference to const. Like bind, the ref and cref functions are defined in the functional header.

### Revisiting Iterators

1. Several kinds of iterators defined in the iterator header
    - Insert iterators
        - back_inserter
        - front_inserter
        - inserter
    - Stream iterators
        - istream_iterator
        - ostream_iterator
    - Reverse iterators
    - Move iterators

2. Adaptors:  An adaptor is a general concept in the library. There are container, iterator, and function adaptors. Essentially, an adaptor is a mechanism for making one thing act like another.

3. Inserter: An inserter is an iterator adaptor that takes a container and yields an iterator that adds elements to the specified container. When we assign a value through an insert iterator, the iterator calls a container operation to add an element at a specified position in the given container. 

4. Three kinds of inserters
    - back_inserter creates an iterator that uses push_back.
    - front_inserter creates an iterator that uses push_front.
    - inserter creates an iterator that uses insert. This function takes a second argument, which must be an iterator into the given container. Elements are inserted ahead of the element denoted by the given iterator.
    - We can use front_inserter only if the container has push_front. Similarly, we can use back_inserter only if it has push_back.

5. inserter vs front_inserter
    - When we call inserter(c, iter), we get an iterator that, when used successively, inserts elements ahead of the element originally denoted by iter.
    - Even if the position we pass to inserter initially denotes the first element, as soon as we insert an element in front of that element, that element is no longer the one at the beginning of the container
    - When we use front_inserter, elements are always inserted ahead of the then first element in the container.
    ```
    list<int> 1st = {1,2,3,4};
    list<int> lst2, lst3; // empty lists
    // after copy completes, 1st2 contains 4 3 2 1C++ Primer, Fifth Edition
    copy(1st.cbegin(), lst.cend(), front_inserter(lst2));
    // after copy completes, 1st3 contains 1 2 3 4
    copy(1st.cbegin(), lst.cend(), inserter(lst3, lst3.begin()));
    ```

6. istream_iterators
    - An istream_iterator uses >> to read a stream. Therefore, the type that an istream_iterator reads must have an input operator defined.
    - We can default initialize the iterator, which creates an iterator that we can use as the off-the-end value.

7. istream_iterator Operations
```
istream_iterator<T> in(is);
istream_iterator<T> end;
in1 == in2;  // equal if they are both the end value or are bound to the same input stream.
in1 != in2;
*in
in->mem
++in, in++  // Reads the next value from the input stream using the >> operator for the element type.
```

8. istream_iterators Are Permitted to Use Lazy Evaluation: The implementation is permitted to delay reading the stream until we use the iterator. We are guaranteed that before we dereference the iterator for the first time, the stream will have been read.

9. ostream_iterators
    - When we create an ostream_iterator, we may (optionally) provide a second argument that specifies a character string to print following each element. That string must be a C-style character string (i.e., a string literal or a pointer to a null-terminated array). 
    - We must bind an ostream_iterator to a specific stream. There is no empty or off-the-end ostream_iterator.

10. ostream Iterator Operations
```
ostream_iterator<T> out(os);
ostream_iterator<T> out(os, d);  // out writes values of type T followed by d to output stream os.
out = val;
*out, ++out, out++;  // do nothing to out. Each operator returns out.
```

11. Reverse iterator
    - A reverse iterator is an iterator that traverses a container backward, from the last element toward the first.
    - Incrementing (++it) a reverse iterator moves the iterator to the previous element; derementing (--it) moves the iterator to the next element.
    - We obtain a reverse iterator by calling the rbegin, rend, crbegin, and crend members. 
    - sorts in reverse: `sort(vec.rbegin(), vec.rend());`
    - Reverse Iterators Require Decrement Operators. Therefore, it is not possible to create a reverse iterator from a forward_list or a stream iterator.
    - reverse_iterator's base member gives us its corresponding ordinary iterator.
    - use function `distance` to count its position

12. Note: The fact that reverse iterators are intended to represent ranges and that these ranges are asymmetric has an important consequence: When we initialize or assign a reverse iterator from a plain iterator, the resulting iterator does not refer to the same element as the original.

### Structure of Generic Algorithms

1. Iterator Categories
    - Input iterator: Read, but not write; single-pass, increment only
    - Output iterator: Write, but not read; single-pass, increment only
    - Forward iterator: Read and write; multi-pass, increment only
    - Bidirectional iterator: Read and wrtie; multi-pass; increment and decrement
    - Random-access iterator: Read and write; multi-pass, full iterator arithmetic

2. Use the correct category of iterator
    - The standard specifies the minimum category for each iterator parameter of the generic and numeric algorithms.
    - For each parameter, the iterator must be at least as powerful as the stipulated minimum. Passing an iterator of a lesser power is an error.
    - Warning: Many compilers will not complain when we pass the wrong category of iterator to an algorithm.

3. Algorithm Parameter Patterns: Most of the algorithms have one of the following four forms:
```
alg(beg, end, other args);
alg(beg, end, dest, other args);  // dest: inserter, ostream_iterator, etc.
alg(beg, end, beg2, other args);
alg(beg, end, beg2, end2, other args);
```

4. Algorithm Naming Conventions
    - Algorithms that take a predicate to use in place of the < or == operator, and that do not take other arguments, typically are overloaded.
    - Algorithms that take an element value typically have a second named (not overloaded) version that takes a predicate in place of the value. The algorithms that take a predicate have the suffix \_if appended
    - By default, algorithms that rearrange elements write the rearranged elements back into the given input range. These algorithms provide a second version that writes to a specified output destination. As we’ve seen, algorithms that write to a destination append \_copy to their names.
    - Some algorithms provide both \_copy and \_if versions. These versions take a destination iterator and a predicate.

### Container-Specific Algorithms

1. list-specific operations
    - The list types define their own versions of sort, merge, remove, reverse, and unique.
    - The generic version of sort cannot be used with list and forward_list because these types offer bidirectional and forward iterators, respectively.
    - The list-specific versions of these algorithms can achieve much better performance than the corresponding generic versions.
    - Generic algorithms not listed in the table that take appropriate iterators execute equally efficiently on lists and forward_listss as on other containers.
    - Advice: The list member versions should be used in preference to the generic algorithms for lists and forward_lists.

2. Algorithms That are Members of list and forward_list
```
lst.merge(lst2);  // Both lst and lst2 must be sorted. After the merge, lst2 is empty
lst.merge(lst2, comp);
lst.remove(val);
lst.remove_if(pred);
lst.reverse();
lst.sort();
lst.sort(comp);
lst.unique();
lst.unique(pred);
```

3. Arguments to the list and forward_list splice Members
```
lst.splice(args) or flst.splice_after(args)
args:
(p, lst2)
(p, lst2, p2)
(p, lst2, b, e)
```

4. A crucially important difference between the list-specific and the generic versions is that the list versions change the underlying container. For example:
    - The list version of remove removes the indicated elements. 
    - The list version of unique removes the second and subsequent duplicate elements.
    - The list version of merge and splice are destructive on their arguments.
