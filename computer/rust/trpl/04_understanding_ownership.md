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

> Question: Can we define our drop function? What if we do that?

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

7.  If a type has the Copy trait, an older variable is still usable after assignment. Rust won’t let us annotate a type with the Copy trait if the type, or any of its parts, has implemented the Drop trait. If the type needs something special to happen when the value goes out of scope and we add the Copy annotation to that type, we’ll get a compile-time error.

> Question: So what should we do if the type needs something special to happen?

> Question: What is trait? And How to define the Copy trait?

8. Some of the types that are `Copy`:
    - All the integer types, such as u32.
    - The Boolean type, bool, with values true and false.
    - All the floating point types, such as f64.
    - The character type, char.
    - Tuples, if they only contain types that are also Copy.

### 4.2 References and Borrowing

1. We’re not allowed to modify something we have a reference to, unless we use mutable references.

2. Mutable references have one big restriction: you can have only one mutable reference to a particular piece of data in a particular scope. The benefit of having this restriction is that Rust can prevent data races at compile time.

3. A data race is similar to a race condition and happens when these three behaviors occur:
    - Two or more pointers access the same data at the same time.
    - At least one of the pointers is being used to write to the data.
    - There’s no mechanism being used to synchronize access to the data.

4. We also cannot have a mutable reference while we have an immutable one.

5. A reference’s scope starts from where it is introduced and continues through the last time that reference is used.

### 4.3 The Slice Type

1. Question: Can we get substring in a non-reference way?
```
let s = String::from("hello world");
let hello = &s[..5]; // error[E0277]: the size for values of type `str` cannot be known at compilation time
```
