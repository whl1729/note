# 《The C++ Programming Language》第42章学习笔记

## 42 Threads and Tasks

### 42.2 Threads

1. All threads work in the same address space. If you want hardware protection against data races, use some notion of a process.

2. ***Operations of thread***
```
id  // The type of a thread identifier
native_handle_type  // The type of a system's thread handle
thread t{};
thread t{t2};
thread t{f, args};
t.~thread();  // if t.joinable(), then terminate()
t = move(t2);
t.swap(t2);
t.joinable(); // Is there a thread of execution associated with t?( t.get_id() != id{} ?)
t.join();  // Join t with the current thread; that is, block the current thread until t completes.
t.detach(); // Ensure that no system thread is represented by t
x = t.get_id();
x = t.native_handle();
n = hardware_concurrency();  // x is the number of hardware processing units (0 means "don't know")
swap(t, t2);
```

3. To prevent a system thread from accidentally outliving its thread, the thread destructor calls terminate() to terminate the program if the thread is joinable() (that is, if get_id()!=id{}). For example:
```
void heartbeat()
{
    while(true) {
        output(steady_clock::now());
        this_thread::sleep_for(second{1}); // §42.2.6
    }
}

void run()
{
    thread t {heartbeat};
} // terminate because heartbeat() is still running at the end of t’s scope
```

4. Note that thread provides a move assignment and a move constructor. This allows threads to migrate out of the scope in which they were constructed and often provides an alternative to detach(). We can migrate threads to a "main module" of a program, access them through unique_ptrs or shared_ptrs, or place them in a container (e.g., vector\<thread\>) to avoid losing track of them.

### 42.3 Avoiding Data Races

1. If we must share data, use some form of locking:
    - Mutexes
    - Condition variables

2. Mutex classes
    - mutex: A nonrecursive mutex; a thread will block if it tries to acquire a mutex that has already been acquired
    - recursive_mutex: A mutex that can be repeatedly acquired by a single thread
    - timed_mutex: A nonrecursive mutex with operations to try to acquire the mutex for (only) a specified time
    - recursive_timed_mutex: A recursive timed mutex
    - lock_guard\<M\>: A guard for a mutex M
    - unique_lock\<M\>: A lock for a mutex M

3. ***Operations of mutex***
```
mutex m{};
m.~mutex();
m.lock();  // Acquire m; block until ownership is acquired
m.try_lock();  // Try to acquire m; did acquisition succeed?
m.unlock(); // Release m
native_handle_type
nh = m.native_handle();
```

4. By itself, a mutex doesn’t do anything. Instead, we use a mutex to represent something else. We use ownership of a mutex to represent the right to manipulate a resource, such as an object, some data, or an I/O device.

5. To minimize contention and the chances of a thread becoming blocked, we try to minimize the time a lock is held by locking only where it is essential to do so. A section of code protected by a lock is called a critical section. To keep code fast and free of problems related to locking, we minimize the size of critical sections.

6. The try_lock() operation is used when we have some other work we might usefully do if some other thread is using a resource.

7. ***Operations of timed_mutex***
```
timed_mutex m{};
m.~timed_mutex();
m.lock();
m.try_lock();
m.try_lock_for(d);  // Try to acquire m for a maximum duration of d; did the acquisition succeed?
m.try_lock_until(tp); // Try to acquire m until time_point tp at the latest; did the acquisition succeed?
m.unlock();
native_handle_type
nh = m.native_handle();
```

8. The standard library provides two RAII classes, lock_guard and unique_lock, to handle the problems of not releasing a lock. The lock_guard’s destructor does the necessary unlock() on its argument. 

9. ***Operations of lock_guard***
```
lock_guard<mutex> lck{m}; // lck acquires m; explicit
lock_guard<mutex> lck{m, adopt_lock)t};  // lck holds m; assume that the current thread has already acquired m; noexcept
lck.~lock_guard();
```
10. ***Operations of unique_lock***
```
unique_lock lck{};
unique_lock lck{m};
unique_lock lck{m, defer_lock_t};
unique_lock lck{m, try_to_lock_t};
unique_lock lck{m, adopt_lock_t};
unique_lock lck{m, tp}; // lck holds m and call m.try_lock_until(tp);
unique_lock lck{m, d}; // lck holds m and call m.try_lock_for(d);
unique_lock lck{lck2};
lck.~unique_lock();
lck2 = move(lck);
lck.lock();
lck.try_lock();
lck.try_lock_for(d);
lck.try_lock_until(tp);
lck.unlock();
lck.swap(lck2);
pm = lck.release();
lck.owns_lock();
bool b{lck};
pm = lck.mutex();
swap(lck, lck2);
```

11. Condition variables are used to manage communication among threads. A thread can wait (block) on a condition_variable until some event, such as reaching a specific time or another thread completing, occurs.

12. ***Operations of Condition Variables***
```
condition_variable cv{};
cv.˜condition_variable();
cv.notify_one();  // Unblock one waiting thread (if any); noexcept
cv.notify_all();  // Unblock all waiting threads; noexcept
cv.wait(lck);  // lck must be owned by the calling thread; ***atomically calls lck.unlock() and blocks***; unblocks if notified or ‘‘spuriously’’; when unblocked calls lck.lock();
cv.wait(lck, pred); // lck must be owned by the calling thread; while (!pred()) wait(lock);
x=cv.wait_until(lck, tp);  // lck must be owned by the calling thread; atomically calls lck.unlock() and blocks; unblocks if notified or timed out at tp; when unblocked calls lck.lock(); x is timeout if it timed out; otherwise x=no_timeout
b=cv.wait_until(lck,tp,pred);  //  while (!pred()) if (wait_until(lck,tp)==cv_status::timeout);
b=pred();
x=cv.wait_for(lck,d);  //  x=cv.wait_until(lck,steady_clock::now()+d)
b=cv.wait_for(lck,d,pred);  //  b=cv.wait_until(lck,steady_clock::now()+d,move(pred))
native_handle_type
nh=cv.native_handle(); // nh is the system handle for cv
```

### 42.4 Task-Based Concurrency

1. Task Support
```
packaged_task<F>  // Package a callable object of type F to be run as a task
promise<T>    // A type of object to which to put one result of type T
future<T>     // A type of object from which to move one result of type T
shared_future<T>  // A future from which to read a result of type T several times
x=async(policy,f,args);   // Launch f(args) to be executed according to policy
x=async(f,args);    // Launch with the default policy: x=async(launch::async|launch::deferred,f,args)
```
