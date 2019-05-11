# 《Modern C++ Design》第6章学习笔记

## 6 Implementing Singletons

### The Basic C++ Idiom Supporting Singletons

1. Sample Code
```
// Header file Singleton.h
class Singleton
{
public:
    static Singleton& Instance()
    {
        if (!pInstance_)
            pInstance_ = new Singleton;
        return *pInstance_;
    }
private:
    Singleton();  // Prevent clients from creating a new Singleton
    Singleton(const Singleton&); // Prevent clients from creating a copy of the Singleton
    Singleton& operator=(const Singleton&); // Prevent clients from creating a copy of the Singleton
    ~Singleton(); // Prevent clients that hold a pointer to the Singleton object from deleting it accidentally
    static Singleton* pInstance_; // The one and only instance
}

// Implementation file Singleton.cpp
Singleton* Singleton::pInstance_ = 0;
```

2. 实现要点
    - 将默认构造函数设为private，从而阻止用户创建Singleton实体。
    - 将复制构造函数与复制赋值函数设为private，并且只声明不定义或者定义为`= delete`，从而禁止任何复制Singleton实体的操作。
    - 将Singleton实体设为private，并且定义为指针，然后在对外接口Instance()中才创建Singleton实体。这样只有在需要创建实体时才进行创建，能够提高效率。这种“按需创建”的单例称为“懒汉式单例”。
    - 将Instance的返回值设为reference而不是pointer，以及将析构函数设置为private，可以阻止用户通过指向Singleton实体的指针来delete该实体。

3. 缺点
    - 缺少释放资源的操作，可能会导致资源泄漏。比如Singleton的构造函数中可能会申请各种资源，包括网络连接、互斥锁、打开文件等。（伍注：可以通过在析构函数中释放资源来解决吗？）
    - 线程不安全，在多线程环境下可能会创建多个实例（使用“双锁检查”来解决）

4. 疑问：会不会出现Instance调用发生在pInstance\_初始化之前的情况？也就是说，执行Instance时，pInstance\_尚未初始化，其值不一定为nullptr，所以if语句可能会检查失败，从而不会执行创建Singleton实体的语句，而事实上Singleton实体并未被创建！
    - 答：查了C++ N4800标准文档，不会出现这种情况。因为pInstance\_的初始化属于static initialization，发生在任何dynamically initialization之前，也发生在进入main函数之前。而任何对Instance()的调用，要么发生在dynamically initialization，要么发生在main函数执行之后。所以两者的先后顺序是明确的。

### Destroying the Singleton

1. The only correct way to avoid resource leaks is to delete the Singleton object during the application's shutdown. The issue is that we have to choose the moment carefully so that no one tries to access the singleton after its destruction.

2. The simplest solution for destroying the singleton is to rely on language mechanisms. For example, the following code shows a different approach published by Scott Meyers, which is called Meyers singleton.
```
// Header file Singleton.h
class Singleton
{
public:
    static Singleton& Instance()
    {
        static Singleton obj;
        return obj;
    }
private:
    Singleton();  // Prevent clients from creating a new Singleton
    Singleton(const Singleton&); // Prevent clients from creating a copy of the Singleton
    Singleton& operator=(const Singleton&); // Prevent clients from creating a copy of the Singleton
    ~Singleton(); // Prevent clients that hold a pointer to the Singleton object from deleting it accidentally
}
```

3. 评价
    - 优点：The Meyers singleton provides the simplest means of destroying the singleton during an application's exit sequence. It works fine in most cases. （伍注：Meyers singleton在C++11之前不是线程安全的，但在C++11以后是线程安全的，而且可以自动销毁对象。）
    - 缺点：If an application uses multiple interacting singletons, we cannot provide an automated way to control their lifetime. A reasonable singleton should at least perform dead-reference detection.（伍注：Meyers singleton依赖系统自动销毁对象，这对一些具有多个互相依赖的Singleton的应用是不够的，可能导致Dead Reference Problem，即使用已经被销毁的对象引用）

> ISO/IEC N4800 "6.8.3.4 Termination": 
> Destructors for initialized objects (that is, objects whose lifetime has begun) with static storage duration, and functions registered with std::atexit, are called as part of a call to std::exit.（伍注：程序结束前会调用static变量的析构函数来销毁对象）

> ISO/IEC N4800 "8.7 Declaration statement": 
> Dynamic initialization of a block-scope variable with static storage duration or thread storage duration is performed the first time control passes through its declaration; such a variable is considered initialized upon the completion of its initialization. If the initialization exits by throwing an exception, the initialization is not complete, so it will be tried again the next time control enters the declaration. If control enters the declaration concurrently while the variable is being initialized, the concurrent execution shall wait for completion of the initialization. （伍注：static变量的初始化是线程安全的。）


4. The atexit function, provided by the standard C library, allows you to register functions to be automatically called during a program's exit, in a last in, first out (LIFO) order. The signature of atexit is
```
// Takes a pointer to function
// Returns 0 if successful, or a nonzero value if an error occurs
int atexit(void (*pFun)());
```

5. How does atexit work? Each call to atexit pushes its parameter on a private stack maintained by the C runtime library. During the application's exit sequence, the runtime support calls the functions registered with atexit.

### Addressing the Dead Reference Problem: The Phoenix Singleton

1. A reasonable singleton should at least perform dead-reference detection. We can achieve this by tracking destruction with a static Boolean member variable destroyed\_. Initially, destroyed\_ is false. Singleton's destructor sets destroyed\_ to true.

2. Sample Code
```
class Singleton
{
public:
    Singleton& Instance()
    {
        if (!pInstance_)
            if (destroyed_)
                OnDeadReference();
            else
                Create();
        return pInstance_;
    }
private:
    static void Create()
    {
        static Singleton theInstance;
        pInstance_ = true;
    }
    static void OnDeadReference()
    {
        Create();
        new (pInstance_) Singleton;
        atexit(KillPhoenixSingleton);
        destroyed_ = false;
    }
    void KillPhoenixSingleton();
    Singleton pInstance_;
    bool destroyed_;
};

void Singleton::KillPhoenixSingleton()
{
    pInstance_->~Singleton();
}
```

### Implementing Singletons with Longevity

1. SetLongevity maintains a hidden priority queue, separate from the inaccessible atexit stack. In turn, SetLongevity calls atexit, always passing it the same pointer to a function. This function pops one element off the stack and deletes it. It's that simple.

### The Double-Checked Locking Pattern

1. Sample Code
```
Singleton& Singleton::Instance()
{
    if (!pInstance_)
    {
        Lock guard(mutex_);
        if (!pInstance_)
        {
            pInstance_ = new Singleton;
        }
        return *pInstance;
    }
}
```

2. Very experienced multithreaded programmers know that even the Double-Checked Locking pattern, although correct on paper, is not always correct in practice. In certain symmetric multiprocessor environments (the ones featuring the so-called relaxed memory model), the writes are committed to the main memory in bursts, rather than one by one. The bursts occur in increasing order of addresses, not in chronological order. Due to this rearranging of writes, the memory as seen by one processor at a time might look as if the operations are not performed in the correct order by another processor. Concretely, the assignment to pInstance\_ performed by a processor might occur before the Singleton object has been fully initialized! Thus, sadly, the Double-Checked Locking pattern is known to be defective for such systems.（没看懂？）

3. In conclusion, you should check your compiler documentation before implementing the Double-Checked Locking pattern. (This makes it the Triple-Checked Locking pattern.) Usually the platform offers alternative, nonportable concurrency-solving primitives, such as memory barriers, which ensure ordered access to memory. At least, put a volatile qualifier next to pInstance\_. A reasonable compiler should generate correct, nonspeculative code around volatile objects.

## 参考资料

1. [C++ 单例模式](https://zhuanlan.zhihu.com/p/37469260)
