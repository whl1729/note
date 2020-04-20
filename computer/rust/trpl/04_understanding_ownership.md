# The Rust Programming Language

## 4 Understanding Ownership

### 4.1 What is Ownership?

1. The Stack and the Heap
    - All data stored on the stack must have a known, fixed size. Data with an unknown size at compile time or a size that might change must be stored on the heap instead.
    - Pushing to the stack is faster than allocating on the heap because the operating system never has to search for a place to store new data; that location is always at the top of the stack. Comparatively, allocating space on the heap requires more work, because the operating system must first find a big enough space to hold the data and then perform bookkeeping to prepare for the next allocation.
    - Keeping track of what parts of code are using what data on the heap, minimizing the amount of duplicate data on the heap, and cleaning up unused data on the heap so you don’t run out of space are all problems that ownership addresses.

2. Ownership Rules
    - Each value in Rust has a variable that’s called its owner.
    - There can only be one owner at a time.
    - When the owner goes out of scope, the value will be dropped.

3. When a variable goes out of scope, Rust calls a special function for us. This function is called `drop`, and it’s where the author of String can put the code to return the memory. Rust calls drop automatically at the closing curly bracket.

> [Solved] Q: Can we define our drop function? What if we do that?
> A: Yes, we can. If we do that, Rust will call ourself drop fuction instead of default drop fuction when the variables go out of scope.

4. In C++, this pattern of deallocating resources at the end of an item’s lifetime is sometimes called Resource Acquisition Is Initialization (RAII). The drop function in Rust will be familiar to you if you’ve used RAII patterns.

5. RAII can be summarized as follows:
    - encapsulate each resource into a class, where
        - the constructor acquires the resource and establishes all class invariants or throws an exception if that cannot be done,
        - the destructor releases the resource and never throws exceptions;
    - always use the resource via an instance of a RAII-class that either
        - has automatic storage duration or temporary lifetime itself, or
        - has lifetime that is bounded by the lifetime of an automatic or temporary object

6.  Rust will never automatically create “deep” copies of your data. Therefore, any automatic copying can be assumed to be inexpensive in terms of runtime performance.
```
let s1 = String::from("hello");
let s2 = s1;

println!("{}, world!", s1);  // error[E0382]: use of moved value: `s1`
```

7.  If a type has the Copy trait, an older variable is still usable after assignment. Rust won’t let us annotate a type with the Copy trait if the type, or any of its parts, has implemented the Drop trait. If the type needs something special to happen when the value goes out of scope and we add the Copy annotation to that type, we’ll get a compile-time error. **Generalizing, any type implementing Drop can't be Copy, because it's managing some resource besides its own bytes.**（伍注：一个类型实现了drop，说明它管理着一些其他资源，如果允许它也实现Copy，就可能导致shallow copy，并进而导致double free内存。比如String就是一个很好的例子。）
    - [Solved] Q: So what should we do if the type needs something special to happen when it goes out of scope?
    - A: We can implement either Copy or Drop trait for a type, so we must not implement the Copy trait if we want to call drop.
    - [Solved] Q: What is trait? And How to define the Copy trait?
    - A: trait is a common interface for a class of types. There are two ways to implement Copy on your type: use `#[derive(Copy, Clone)]` or implement Copy and Clone manually. See [Trait Copy](https://doc.rust-lang.org/std/marker/trait.Copy.html) for more details.

8. Some of the types that are `Copy`:
    - All the integer types, such as u32.
    - The Boolean type, bool, with values true and false.
    - All the floating point types, such as f64.
    - The character type, char.
    - Tuples, if they only contain types that are also Copy.

9. `Clone` and `Copy` for Duplicating Values
    - The Clone trait allows you to explicitly create a deep copy of a value, and the duplication process might involve running arbitrary code and copying heap data.
    - The Copy trait allows you to duplicate a value by only copying bits stored on the stack; no arbitrary code is necessary.
    - The Copy trait doesn’t define any methods to prevent programmers from overloading those methods and violating the assumption that no arbitrary code is being run. That way, all programmers can assume that copying a value will be very fast.
    - You can only apply the Copy trait to types that also implement Clone, because a type that implements Copy has a trivial implementation of Clone that performs the same task as Copy. （对某个类型实现Copy trait时，也必须实现Clone trait，因为Clone的默认实现方法需要用到Copy）

10. The `move` semantics（一个变量退出其作用域后，如果它不再合法（控制权已被转移），Rust不会调用drop来释放资源）
    - The ownership of a variable follows the same pattern every time: assigning a value to another variable moves it. When a variable that includes data on the heap goes out of scope, the value will be cleaned up by drop **unless the data has been moved to be owned by another variable**.
    - Because Rust also **invalidates** the first variable, instead of being called a shallow copy, it’s known as a move. In this example, we would say that s1 was moved into s2.
    - Instead of trying to copy the allocated memory, Rust considers s1 to no longer be valid and, therefore, Rust doesn’t need to free anything when s1 goes out of scope.

### 4.2 References and Borrowing

1. We’re not allowed to modify something we have a reference to, unless we use mutable references.

2. Mutable references have one big restriction: you can have only one mutable reference to a particular piece of data in a particular scope. The benefit of having this restriction is that Rust can prevent data races at compile time.

3. A data race is similar to a race condition and happens when these three behaviors occur:
    - Two or more pointers access the same data at the same time.
    - At least one of the pointers is being used to write to the data.
    - There’s no mechanism being used to synchronize access to the data.

4. We also cannot have a mutable reference while we have an immutable one.

5. A reference’s scope starts from where it is introduced and continues through the last time that reference is used.

6. The Rules of References
    - At any given time, you can have either one mutable reference or any number of immutable references.
    - References must always be valid.

### 4.3 The Slice Type

1. Question: Can we get substring in a non-reference way?
```
let s = String::from("hello world");
let hello = &s[..5]; // error[E0277]: the size for values of type `str` cannot be known at compilation time
```
