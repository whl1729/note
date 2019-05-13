# 《The C++ Programming Language》第41章学习笔记

## 41 Concurrency

### 41.2 Memory Model

1. To understand the problems involved, keep one simple fact in mind: operations on an object in memory are never directly performed on the object in memory. Instead, the object is loaded into a processor register, modified there, and then written back. Worse still, an object is typically first loaded from the main memory into a cache memory and from there to a register.

2. Memory Location（伍注：同时更新位域里的不同字段不是线程安全的）
    - The C++ memory model guarantees that two threads of execution can update and access separate memory locations without interfering with each other.
    - The language defines memory location as the unit of memory for which sensible behavior is guaranteed to exclude individual bit-fields.
    - A memory location is either an object of arithmetic type, a pointer, or a maximal sequence of adjacent bit-fields all having nonzero width. 

3. To gain performance, compilers, optimizers, and hardware reorder instructions.

4. Data races: Two threads have a data race if both can access a memory location simultaneously and at least one of their accesses is a write.

5. ***There are many ways of avoiding data races***:
    - Use only a single thread. That eliminates the benefits of concurrency (unless you use processes or co-routines).
    - Put a lock on every data item that might conceivably be subject to a data race. That can eliminate the benefits of concurrency almost as effectively as single threading because we easily get into a situation where all but one thread waits. Worse still, heavy use of locks increases the chances of deadlock, where a thread waits for another forever, and other locking problems.
    - Try to look carefully at the code and avoid data races by selectively adding locks. This may be the currently most popular approach, but it is error-prone.
    - Have a program detect all data races and either report them for the programmer to fix or automatically insert locks. Programs that can do that for programs of commercial size and complexity are not common. Programs that can do that and also guarantee the absence of deadlocks are still research projects.
    - Design the code so that threads communicate only through simple put-and-get-style interfaces that do not require two threads to directly manipulate a single memory location.
    - Use a higher-level library or tool that makes data sharing and/or concurrency implicit or sufficiently stylized to make sharing manageable. Examples include parallel implementations of algorithms in a library, directive-based tools (e.g., OpenMP), and transactional memory (often abbreviated to TM).

### 41.3 Atomics

1. Atomic Operations: the programmer relies on primitive operations (***directly supported by hardware***) to avoid data races for small objects (typically a single word or a double word). Primitive operations that do not suffer data races, often called atomic operations, can then be used in the implementation of higher-level concurrency mechanisms, such as locks, threads, and lockfree data structures.

2. A synchronization operation on one or more memory locations is a consume operation, an acquire operation, a release operation, or both an acquire and release operation.
    - For an acquire operation, other processors will see its effect before any subsequent operation’s effect.
    - For a release operation, other processors will see every preceding operation’s effect before the effect of the operation itself.
    - A consume operation is a weaker form of an acquire operation. For a consume operation, other processors will see its effect before any subsequent operation’s effect, except that effects that do not depend on the consume operation’s value may happen before the consume operation.

3. The standard memory orders are:（伍注：没看懂？）
```
enum memory_order {
    memory_order_relaxed,
    memory_order_consume,
    memory_order_acquire,
    memory_order_release,
    memory_order_acq_rel,
    memory_order_seq_cst
};
```

4. ***RAII（Resource Acquisition Is Initialization）***是由c++之父Bjarne Stroustrup提出的，中文翻译为资源获取即初始化，他说：使用局部对象来管理资源的技术称为资源获取即初始化；这里的资源主要是指操作系统中有限的东西如内存、网络套接字等等，局部对象是指存储在栈的对象，它的生命周期是由操作系统来管理的，无需人工介入。
