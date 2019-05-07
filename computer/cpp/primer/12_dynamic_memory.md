# 《C++ Primer》第12章学习笔记

## 12 Dynamic Memory

1. Dynamically allocated objects have a lifetime that is independent of where they are created; they exist until they are explicitly freed.

2. To make using dynamic objects safer, the library defines two smart pointer types (shared_ptr and unique_ptr) that manage dynamically allocated objects. Smart pointers ensure that the objects to which they point are automatically freed when it is appropriate to do so.

3. Kinds of memory
    - Static memory is used for local static objects, for class static data members and for variables defined outside any function. Stack memory is used for nonstatic objects defined inside functions. 
    - Objects allocated in static or stack memory are automatically created and destroyed by the compiler.
    - In addition to static or stack memory, every program also has a pool of memory that it can use. This memory is referred to as the free store or heap. Programs use the heap for objects that they dynamically allocate—that is, for objects that the program allocates at run time.

### 12.1 Dynamic Memory and Smart Pointers

1. Dynamic memory is problematic because it is surprisingly hard to ensure that we free memory at the right time. Either we forget to free the memory—in which case we have a memory leak—or we free the memory when there are still pointers referring to that memory—in which case we have a pointer that refers to memory that is no longer valid.

2. ***Two smart pointer types (Defined in memory header)***
    - shared_ptr, which allows multiple pointers to refer to the same object
    - unique_ptr, which “owns” the object to which it points
    - weak_ptr, which is a weak reference to an object managed by a shared_ptr

3. A default initialized smart pointer holds a null pointer.

4. make_shared allocates and initializes an object in dynamic memory and returns a shared_ptr that points to that object.

5. Copying and Assigning shared_ptrs
    - We can think of a shared_ptr as if it has an associated counter, usually referred to as a reference count. 
    - Whenever we copy a shared_ptr, the count is incremented. For example, the counter associated with a shared_ptr is incremented when we use it to initialize another shared_ptr, when we use it as the right-hand operand of an assignment, or when we pass it to or return it from a function by value. 
    - The counter is decremented when we assign a new value to the shared_ptr and when the shared_ptr itself is destroyed, such as when a local shared_ptr goes out of scope. 
    - Once a shared_ptr’s counter goes to zero, the shared_ptr automatically frees the object that it manages.

6. ***Operations Common to shared_ptr and unique_ptr***
```
shared_ptr<T> sp;
unique_ptr<T> up;
p
*p
p->member
p.get()  // Returns the pointer in p
swap(p, q)
p.swap(q)
```

7. ***Operations Specific to shared_ptr***
```
make_shared<T>(args)  // Returns a shared_ptr pointing to a dynamically allocated object of type T.
shared_ptr<T> p(q)  // p is a copy of the shared_ptr q
p = q  // Decrements p's reference count and increments q's count; deletes p's existing memory if p's count goes to 0.
p.unique()  // Return true if p.use_count() is one, false otherwise.
p.use_count()  // Return the number of objects shareing with p
```

8. Because memory is not freed until the last shared_ptr goes away, it can be important to be sure that shared_ptrs don’t stay around after they are no longer needed. If you put shared_ptrs in a container, and you subsequently need to use some, but not all, of the elements, remember to erase the elements you no longer need.

9. Programs tend to use dynamic memory for one of three purposes:
    - They don’t know how many objects they’ll need
    - They don’t know the precise type of the objects they need
    - They want to share data between several objects

10. One common reason to use dynamic memory is to allow multiple objects to share the same state.（伍注：具体而言，只分配一份内存，然后在多个object中均定义一个指针指向这份内存，就能实现信息共享。）

11. Classes that do manage their own memory—unlike those that use smart pointers—cannot rely on the default definitions for the members that copy, assign, and destroy class objects. As a result, programs that use smart pointers are likely to be easier to write and debug.

12. By default, ***dynamically allocated objects are default initialized***, which means that objects of built-in or compound type have undefined value; objects of class type are initialized by their default constructor.

13. ***We can value initialize a dynamically allocated object by following the type name with a pair of empty parentheses.***
```
string *ps1 = new string; // default initialized to the empty string
string *ps = new string(); // value initialized to the empty string
int *pi1 = new int; // default initialized; *pi1 is undefined
int *pi2 = new int(); // value initialized to 0; *pi2 is 0
```

14. value-initialized vs default-initialized built-in type
    - A value-initialized object of built-in type has a well-defined value but a default-initialized object does not.
    - members of built-in type in classes that rely on the synthesized default constructor will also be uninitialized if those members are not initialized in the class body.

15. Advice: For the same reasons as we usually initialize variables, it is also a good idea to initialize dynamically allocated objects.

16. When we provide an initializer inside parentheses, we can use auto to deduce the type of the object we want to allocate from that initializer. However, because the compiler uses the initializer’s type to deduce the type to allocate, we can use auto only with a single initializer inside parentheses:
```
auto p1 = new auto(obj); // p points to an object of the type of obj
// that object is initialized from obj
auto p2 = new auto{a,b,c}; // error: must use parentheses for the initializer
```

17. Like any other const, a dynamically allocated const object must be initialized. A const dynamic object of a class type that defines a default constructor may be initialized implicitly. Objects of other types must be explicitly initialized.

18. ***By default, if new is unable to allocate the requested storage, it throws an exception of type bad_alloc. We can prevent new from throwing an exception by using a nothrow new. Both bad_alloc and nothrow are defined in the new header.***
```
int *p1 = new int; // if allocation fails, new throws std::bad_alloc
int *p2 = new (nothrow) int; // if allocation fails, new returns a null pointer
```

19. A delete expression performs two actions: It destroys the object to which its given pointer points, and it frees the corresponding memory.

20. The pointer we pass to delete must either point to dynamically allocated memory or be a null pointer. Deleting a pointer to memory that was not allocated by new, or deleting the same pointer value more than once, is undefined.

21. Caution: Managing Dynamic Memory Is Error-Prone. There are three common problems with using new and delete to manage dynamic memory. You can avoid all of these problems by using smart pointers exclusively.
    - Forgetting to delete memory, which is known as a “memory leak”. Testing for memory leaks is difficult because they usually cannot be detected until the application is run for a long enough time to actually exhaust memory. 
    - Using an object after it has been deleted. This error can sometimes be detected by making the pointer null after the delete. （伍注：shared_ptr不存在这个问题，因为只要还有指针指向某个object，那个object绝不会被delete。）
    - Deleting the same memory twice. This error can happen when two pointers address the same dynamically allocated object. If delete is applied to one of the pointers, then the object’s memory is returned to the free store. If we subsequently delete the second pointer, then the free store may be corrupted.

22. After the delete, the pointer becomes what is referred to as a dangling pointer. If we need to keep the pointer around, we can assign nullptr to the pointer after we use delete. Doing so makes it clear that the pointer points to no object.

23. A fundamental problem with dynamic memory is that there can be several pointers that point to the same memory. Resetting the pointer we use to delete that memory lets us check that particular pointer but has no effect on any of the other pointers that still point at the (freed) memory.

24. ***Other Ways to Define and Change shared_ptrs***
```
shared_ptr<T> p(q)
shared_ptr<T> p(u)  // p assumes ownership from the unique_ptr u, makes u null
shared_ptr<T> p(q, d)  // p will use the callable object d in place of delete to free q
shared_ptr<T> p(p2, d)  // p is a copy of the shared_ptr p2 except that p uses the callable object d in place of delete
p.reset()   // If p is the only shared_ptr pointing at its object, reset frees p's existing object.
p.reset(q)  // If the optional built-in pointer q is passed, makes p points to q, otherwise makes p null.
p.reset(q,d)
```

25. The smart pointer constructors that take pointers are explicit. Hence, ***we cannot implicitly convert a built-in pointer to a smart pointer; we must use the direct form of initialization to initialize a smart pointer.***
```
shared_ptr<int> p1 = new int(1024); // error: must use direct initialization
shared_ptr<int> p2(new int(1024)); // ok: uses direct initialization
```

26. By default, a pointer used to initialize a smart pointer must point to dynamic memory because, by default, smart pointers use delete to free the associated object. We can bind smart pointers to pointers to other kinds of resources. However, to do so, we must supply our own operation to use in place of delete.

27. ***Don’t Mix Ordinary Pointers and Smart Pointers, and Don’t Use get to Initialize or Assign Another Smart Pointer.***
    - Warning: It is dangerous to use a built-in pointer to access an object owned by a smart pointer, because we may not know when that object is destroyed.（伍注：当我们用一个普通指针指向一个原本被smart pointer指向的object后，我们就可以通过这个普通指针delete对应的object，然而smart pointer无法感知到object已被delete。）
    - Warning: Use get only to pass access to the pointer to code that you know will not delete the pointer. In particular, never use get to initialize or assign to another smart pointer.（伍注：这样做会导致smart pointers的refcount计算错误，即旧smart pointer的refcount不会加1，新smart pointer的refcount为1）

28. ***The reset member is often used together with unique to control changes to the object shared among several shared_ptrs.***
```
if (!p.unique())
    p.reset(new string(*p)); // we aren't alone; allocate a new copy
*p += newVal; // now that we know we're the only pointer, okay to change this object
```

29. Programs that use exception handling to continue processing after an exception occurs need to ensure that resources are properly freed if an exception occurs. One easy way to make sure resources are freed is to use smart pointers.

30. Smart Pointers and Dumb Classes
    - Classes that are designed to be used by both C and C++ generally require the user to specifically free any resources that are used.
    - Classes that allocate resources—and that do not define destructors to free those resources—can be subject to the same kind of errors that arise when we use dynamic memory. It is easy to forget to release the resource. 
    - If an exception happens between when the resource is allocated and when it is freed, the program will leak that resource.

31. ***To use smart pointers correctly, we must adhere to a set of conventions***:
    - Don’t use the same built-in pointer value to initialize (or reset) more than one smart pointer.
    - Don’t delete the pointer returned from get().
    - Don’t use get() to initialize or reset another smart pointer.
    - If you use a pointer returned by get(), remember that the pointer will become invalid when the last corresponding smart pointer goes away.
    - If you use a smart pointer to manage a resource other than memory allocated by new, remember to pass a deleter

32. Unlike shared_ptr, only one unique_ptr at a time can point to a given object. The object to which a unique_ptr points is destroyed when the unique_ptr is destroyed.

33. ***unique_ptr Operations***（伍注：可以将unique_ptr视为特殊的shared_ptr，特殊之处在于refcount不能大于1）
```
unique_ptr<T> u1;  // u1 will use delete to free its pointer
unique_ptr<T, D> u2;  // u2 will use a callable object of type D to free its pointer
unique_ptr<T, D> u(d);  // Null unique_ptr that point to objects of type T that use d.
u = nullptr;  // Delete the object to which u points, makes u null
u.release();  // Returns the pointer u had held and makes u null
u.reset();  // Delete the object to which u points;
u.reset(q); // If the built-in pointer is supplied, makes u point to that object.
u.reset(nullptr); // Otherwise makes u nullptr.
```

34. If we do not use another smart pointer to hold the pointer returned from release, our program takes over responsibility for freeing that resource.

35. We can copy or assign a unique_ptr that is about to be destroyed. The most common example is when we return a unique_ptr from a function. Alternatively, we can also return a copy of a local object.

36. A ***weak_ptr*** points to an object that is managed by a shared_ptr. Binding a weak_ptr to a shared_ptr does not change the reference count of that shared_ptr. Once the last shared_ptr pointing to the object goes away, the object itself will be deleted. That object will be deleted even if there are weak_ptrs pointing to it.（伍注：为什么需要发明weak_ptr？）

37. ***weak_ptr operations***
```
weak_ptr<T> w
weak_ptr<T> w(sp)
w = p          // p can be a shared_ptr or a weak_ptr.
w.reset()      // Makes w null.
w.use_count()  // The number of shared_ptrs that share ownership with w
w.expired()    // Return true if w.use_count() is zero, false otherwise
w.lock()       // If expired is true, returns a null shared_ptr; otherwise returns a shared_ptr to the object to which w points.
```

38. Because the object might no longer exist, we cannot use a weak_ptr to access its object directly. To access that object, we must call lock. The lock function checks whether the object to which the weak_ptr points still exists. If so, lock returns a shared_ptr to the shared object. 

### 12.2 Dynamic Arrays

1. The language and library provide two ways to allocate an array of objects at once: new expression or allocator. Using an allocator generally provides better performance and more flexible memory management.
```
int *pia = new int[get_size()];
```

2. Advice: Most applications should use a library container rather than dynamically allocated arrays. Using a container is easier, less likely to contain memory management bugs, and is likely to give better performance.

3. Allocating an Array Yields a Pointer to the Element Type Rather than a Array Type. Therefore, ***we cannot call begin or end or a range for on a dynamic array.***

4. If there are fewer initializers than elements, the remaining elements are value initialized. ***If there are more initializers than the given size, then the new expression fails and no storage is allocated. In this case, new throws an exception of type bad_array_new_length.*** Like bad_alloc, this type is defined in the new header.

5. When we use new to allocate an array of size zero, new returns a valid, nonzero pointer. This pointer acts as the off-the-end pointer for a zero-element array. We can use this pointer in ways that we use an off-the-end iterator. 

6. Freeing Dynamic Arrays
    - `delete [] pa; // pa must point to a dynamically allocated array or be null` destroys the elements in the array to which pa points and frees the corresponding memory. 
    - ***Elements in an array are destroyed in reverse order.*** That is, the last element is destroyed first, then the second to last, and so on. 
    - When we delete a pointer to an array, the empty bracket pair is essential: It indicates to the compiler that the pointer addresses the first element of an array of objects. ***If we omit the brackets when we delete a pointer to an array (or provide them when we delete a pointer to an object), the behavior is undefined.***

7. unique_ptrs to Arrays: Member access operators (dot and arrow) are not supported for unique_ptrs to arrays. Other unique_ptr operations unchanged.
```
unique_ptr<T[]> u;
unique_ptr<T[]> u(p);  // p must be convertible to T*
u[i];   // u must point to an array.
```

8. ***shared_ptr and Dynamic Arrays***
    - shared_ptrs provide no direct support for managing a dynamic array. If we want to use a shared_ptr to manage a dynamic array, we must provide our own deleter. 
    - There is no subscript operator for shared_ptrs, and the smart pointer types do not support pointer arithmetic. As a result, to access the elements in the array, we must use get to obtain a built-in pointer, which we can then use in normal ways.

9. limits of new/delete
    - An aspect of new that limits its flexibility is that new combines allocating memory with constructing object(s) in that memory. Similarly, delete combines destruction with deallocation. 
    - Decoupling construction from allocation means that we can allocate memory in large chunks and pay the overhead of constructing the objects only when we actually need to create them.
    - Classes that do not have default constructors cannot be dynamically allocated as an array.

10. The library allocator class, which is defined in the memory header, lets us separate allocation from construction. It provides type-aware allocation of raw, unconstructed, memory. 

11. ***Standard allocator Class and Customized Algorithms***
```
allocator<T> a
a.allocate(n)
a.deallocate(p, n)  // The user must run destroy on any objects that were constructed in this memory before calling deallocate
a.construct(p, args)  // args are passed to a constructor for type T
a.destroy(p)  // Runs the destructor on the object pointed to by the T* pointer p
```

12. ***allocator Algorithms***: The following functions construct elements in the destination, rather than assigning to them. They are defined in the memory header.
```
uninitialized_copy(b, e, b2)  // return a pointer positioned one element pass the last constructed element
uninitialized_copy_n(b, n, b2)
uninitialized_fill(b, e, t)
uninitialized_fill_n(b, n, t)
```

### 12.3 Using the Library: A Text-Query Program

1. A good way to start the design of a program is to list the program’s operations. Knowing what operations we need can help us see what data structures we’ll need.

2. When we design a class, it can be helpful to write programs using the class before actually implementing the members. That way, we can see whether the class has the operations we need. 
