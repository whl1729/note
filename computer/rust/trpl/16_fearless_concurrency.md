# The Rust Programming Language

## 16 Fearless Concurrency

1. Handling concurrent programming safely and efficiently is another of Rust’s major goals.

2. Concurrent programming, where different parts of a program execute independently, and parallel programming, where different parts of a program execute at the same time, are becoming increasingly important as more computers take advantage of their multiple processors.

3. Initially, the Rust team thought that ensuring memory safety and preventing concurrency problems were two separate challenges to be solved with different methods. Over time, the team discovered that the ownership and type systems are a powerful set of tools to help manage memory safety and concurrency problems!

4. By leveraging ownership and type checking, many concurrency errors are compile-time errors in Rust rather than runtime errors. Therefore, rather than making you spend lots of time trying to reproduce the exact circumstances under which a runtime concurrency bug occurs, incorrect code will refuse to compile and present an error explaining the problem. As a result, you can fix your code while you’re working on it rather than potentially after it has been shipped to production. We’ve nicknamed this aspect of Rust **fearless concurrency**. Fearless concurrency allows you to write code that is free of subtle bugs and is easy to refactor without introducing new bugs.

5. Many languages are dogmatic about the solutions they offer for handling concurrent problems. For example, Erlang has elegant functionality for message-passing concurrency but has only obscure ways to share state between threads.

6. Supporting only a subset of possible solutions is a reasonable strategy for higher-level languages, because a higher-level language promises benefits from giving up some control to gain abstractions. However, lower-level languages are expected to provide the solution with the best performance in any given situation and have fewer abstractions over the hardware. Therefore, Rust offers a variety of tools for modeling problems in whatever way is appropriate for your situation and requirements.

### 16.1 Using Threads to Run Code Simultaneously

1. Because threads can run simultaneously, there’s no inherent guarantee about the order in which parts of your code on different threads will run. This can lead to problems, such as:
    - Race conditions, where threads are accessing data or resources in an inconsistent order
    - Deadlocks, where two threads are waiting for each other to finish using a resource the other thread has, preventing both threads from continuing
    - Bugs that happen only in certain situations and are hard to reproduce and fix reliably

2. Programming languages implement threads in a few different ways. Many operating systems provide an API for creating new threads. This model where a language calls the operating system APIs to create threads is sometimes called 1:1, meaning one operating system thread per one language thread.

3. Many programming languages provide their own special implementation of threads. Programming language-provided threads are known as green threads, and languages that use these green threads will execute them in the context of a different number of operating system threads. For this reason, the green-threaded model is called the M:N model: there are M green threads per N operating system threads, where M and N are not necessarily the same number.

4. Each model has its own advantages and trade-offs, and the trade-off most important to Rust is runtime support. Runtime is a confusing term and can have different meanings in different contexts.

5. In this context, by runtime we mean code that is included by the language in every binary. This code can be large or small depending on the language, but every non-assembly language will have some amount of runtime code. For that reason, colloquially when people say a language has “no runtime,” they often mean “small runtime.” Smaller runtimes have fewer features but have the advantage of resulting in smaller binaries, which make it easier to combine the language with other languages in more contexts. Although many languages are okay with increasing the runtime size in exchange for more features, Rust needs to have nearly no runtime and cannot compromise on being able to call into C to maintain performance.

6. The green-threading M:N model requires a larger language runtime to manage threads. As such, the Rust standard library only provides an implementation of 1:1 threading. Because Rust is such a low-level language, there are crates that implement M:N threading if you would rather trade overhead for aspects such as more control over which threads run when and lower costs of context switching, for example.

7. We can fix the problem of the spawned thread not getting to run, or not getting to run completely, by saving the return value of thread::spawn in a variable. The return type of thread::spawn is JoinHandle. A JoinHandle is an owned value that, when we call the join method on it, will wait for its thread to finish.

8. Calling join on the handle blocks the thread currently running until the thread represented by the handle terminates. Blocking a thread means that thread is prevented from performing work or exiting.

### 16.2 Using Message Passing to Transfer Data Between Threads

1. One increasingly popular approach to ensuring safe concurrency is message passing, where threads or actors communicate by sending each other messages containing data. Here’s the idea in a slogan from the Go language documentation: **“Do not communicate by sharing memory; instead, share memory by communicating.”**

2. One major tool Rust has for accomplishing message-sending concurrency is the channel, a programming concept that Rust’s standard library provides an implementation of.

3. We create a new channel using the mpsc::channel function; mpsc stands for multiple producer, single consumer. In short, the way Rust’s standard library implements channels means a channel can have multiple sending ends that produce values but only one receiving end that consumes those values.

4. The send method returns a Result<T, E> type, so if the receiving end has already been dropped and there’s nowhere to send a value, the send operation will return an error.

5. The try_recv method doesn’t block, but will instead return a Result<T, E> immediately: an Ok value holding a message if one is available and an Err value if there aren’t any messages this time.

### 16.3 Shared-State Concurrency

1. Mutex is an abbreviation for **mutual exclusion**, as in, a mutex allows only one thread to access some data at any given time. To access the data in a mutex, a thread must first signal that it wants access by asking to acquire the mutex’s lock. The lock is a data structure that is part of the mutex that keeps track of who currently has exclusive access to the data. Therefore, the mutex is described as guarding the data it holds via the locking system.

2. As you might suspect, Mutex<T> is a smart pointer. More accurately, the call to lock returns a smart pointer called MutexGuard, wrapped in a LockResult that we handled with the call to unwrap. The MutexGuard smart pointer implements Deref to point at our inner data; the smart pointer also has a Drop implementation that releases the lock automatically when a MutexGuard goes out of scope.

3. Unfortunately, Rc<T> is not safe to share across threads. When Rc<T> manages the reference count, it adds to the count for each call to clone and subtracts from the count when each clone is dropped. But it doesn’t use any concurrency primitives to make sure that changes to the count can’t be interrupted by another thread. This could lead to wrong counts—subtle bugs that could in turn lead to memory leaks or a value being dropped before we’re done with it.

4. Fortunately, Arc<T> is a type like Rc<T> that is safe to use in concurrent situations. The a stands for atomic, meaning it’s an atomically reference counted type.

5. You might then wonder why all primitive types aren’t atomic and why standard library types aren’t implemented to use Arc<T> by default. The reason is that thread safety comes with a performance penalty that you only want to pay when you really need to. If you’re just performing operations on values within a single thread, your code can run faster if it doesn’t have to enforce the guarantees atomics provide.

6. Similarities Between RefCell<T>/Rc<T> and Mutex<T>/Arc<T>
    - Mutex<T> provides interior mutability, as the Cell family does. In the same way we used RefCell<T> to allow us to mutate contents inside an Rc<T>, we use Mutex<T> to mutate contents inside an Arc<T>.
    - Using Rc<T> came with the risk of creating reference cycles, where two Rc<T> values refer to each other, causing memory leaks. Similarly, Mutex<T> comes with the risk of creating deadlocks. These occur when an operation needs to lock two resources and two threads have each acquired one of the locks, causing them to wait for each other forever.

### 16.4 Extensible Concurrency with the Sync and Send Traits

1. Two concurrency concepts are embedded in the language: the std::marker traits Sync and Send.

2. The Send marker trait indicates that ownership of the type implementing Send can be transferred between threads. Almost every Rust type is Send, but there are some exceptions, including Rc<T>.

3. Any type composed entirely of Send types is automatically marked as Send as well.

4. The Sync marker trait indicates that it is safe for the type implementing Sync to be referenced from multiple threads. In other words, any type T is Sync if &T (a reference to T) is Send, meaning the reference can be sent safely to another thread. Similar to Send, primitive types are Sync, and types composed entirely of types that are Sync are also Sync.

5. Building new concurrent types not made up of Send and Sync parts requires careful thought to uphold the safety guarantees. The Rustonomicon has more information about these guarantees and how to uphold them.

