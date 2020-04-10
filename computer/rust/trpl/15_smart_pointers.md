# The Rust Programming Language

## 15 Smart Pointers

1. The most common kind of pointer in Rust is a reference, they don’t have any special capabilities other than referring to data. Also, they don’t have any overhead and are the kind of pointer we use most often.

2. Smart pointers, on the other hand, are data structures that not only act like a pointer but also have additional metadata and capabilities.

3. In Rust, the different smart pointers defined in the standard library provide functionality beyond that provided by references. One example is the reference counting smart pointer type. This pointer enables you to have multiple owners of data by keeping track of the number of owners and, when no owners remain, cleaning up the data.

4. In Rust, an additional difference between references and smart pointers is that references are pointers that only borrow data; in contrast, in many cases, smart pointers own the data they point to.

5. Smart pointers are usually implemented using structs. The characteristic that distinguishes a smart pointer from an ordinary struct is that smart pointers implement the **Deref** and **Drop** traits. The Deref trait allows an instance of the smart pointer struct to behave like a reference so you can write code that works with either references or smart pointers. The Drop trait allows you to customize the code that is run when an instance of the smart pointer goes out of scope.

6. The most common smart pointers in the standard library:
    - `Box<T>` for allocating values on the heap
    - `Rc<T>`, a reference counting type that enables multiple ownership
    - `Ref<T>` and `RefMut<T>`, accessed through `RefCell<T>`, a type that enforces the borrowing rules at runtime instead of compile time

### 15.1 Using Box<T> to Point to Data on the Heap

1. You’ll use `Box<T>` most often in these situations:
    - When you have a type whose size can’t be known at compile time and you want to use a value of that type in a context that requires an exact size
    - When you have a large amount of data and you want to transfer ownership but ensure the data won’t be copied when you do so
    - When you want to own a value and you care only that it’s a type that implements a particular trait rather than being of a specific type

### 15.2 Treating Smart Pointers Like Regular References with the Deref Trait

1. Implementing the Deref trait allows you to customize the behavior of the dereference operator, *. By implementing Deref in such a way that a smart pointer can be treated like a regular reference, you can write code that operates on references and use that code with smart pointers too.

2. Tuple structs have a name, but their fields don't. They are declared with the struct keyword, and then with a name followed by a tuple. There is one case when a tuple struct is very useful, though, and that is when it has only one element. We call this the ‘newtype’ pattern, because it allows you to create a new type that is distinct from its contained value and also expresses its own semantic meaning.
```
struct Inches(i32);
let length = Inches(10);

let Inches(integer_length) = length;
println!("length is {} inches", integer_length);
```

3. The Deref trait, provided by the standard library, requires us to implement one method named deref that borrows self and returns a reference to the inner data.

4. Deref coercion happens automatically when we pass a reference to a particular type’s value as an argument to a function or method that doesn’t match the parameter type in the function or method definition. A sequence of calls to the deref method converts the type we provided into the type the parameter needs.

5. When the Deref trait is defined for the types involved, Rust will analyze the types and use Deref::deref as many times as necessary to get a reference to match the parameter’s type. The number of times that Deref::deref needs to be inserted is resolved at compile time, so there is no runtime penalty for taking advantage of deref coercion!

6. Rust does deref coercion when it finds types and trait implementations in three cases:
    - From &T to &U when T: Deref<Target=U>
    - From &mut T to &mut U when T: DerefMut<Target=U>
    - From &mut T to &U when T: Deref<Target=U>

7. Immutable references will never coerce to mutable references.

### 15.3 Running Code on Cleanup with the Drop Trait

1. You can provide an implementation for the Drop trait on any type, and the code you specify can be used to release resources like files or network connections.

2. Rust doesn’t let you call the Drop trait’s drop method manually; instead you have to call the `std::mem::drop` function provided by the standard library if you want to force a value to be dropped before the end of its scope.

### 15.4 Rc<T>, the Reference Counted Smart Pointer

1. We use the Rc<T> type when we want to allocate some data on the heap for multiple parts of our program to read and we can’t determine at compile time which part will finish using the data last.

2. We could have called a.clone() rather than Rc::clone(&a), but Rust’s convention is to use Rc::clone in this case. The implementation of Rc::clone doesn’t make a deep copy of all the data like most types’ implementations of clone do. The call to Rc::clone only increments the reference count, which doesn’t take much time. Deep copies of data can take a lot of time. By using Rc::clone for reference counting, we can visually distinguish between the deep-copy kinds of clones and the kinds of clones that increase the reference count. When looking for performance problems in the code, we only need to consider the deep-copy clones and can disregard calls to Rc::clone.

3. Rc<T> is only for use in single-threaded scenarios.

4. Via immutable references, Rc<T> allows you to share data between multiple parts of your program for reading only. If Rc<T> allowed you to have multiple mutable references too, you might violate one of the borrowing rules: multiple mutable borrows to the same place can cause data races and inconsistencies.

### 15.5 RefCell<T> and the Interior Mutability Pattern

1. **Interior mutability** is a design pattern in Rust that allows you to mutate data even when there are immutable references to that data; normally, this action is disallowed by the borrowing rules. To mutate data, the pattern uses unsafe code inside a data structure to bend Rust’s usual rules that govern mutation and borrowing. We can use types that use the interior mutability pattern when we can ensure that the borrowing rules will be followed at runtime, even though the compiler can’t guarantee that.

2. Borrowing rules:
    - At any given time, you can have either (but not both of) one mutable reference or any number of immutable references.
    - References must always be valid.

3. The advantages of checking the borrowing rules at compile time are that errors will be caught sooner in the development process, and there is no impact on runtime performance because all the analysis is completed beforehand. For those reasons, checking the borrowing rules at compile time is the best choice in the majority of cases, which is why this is Rust’s default.

4. The advantage of checking the borrowing rules at runtime instead is that certain memory-safe scenarios are then allowed, whereas they are disallowed by the compile-time checks.

5. The RefCell<T> type is useful when you’re sure your code follows the borrowing rules but the compiler is unable to understand and guarantee that.

6. Similar to Rc<T>, RefCell<T> is only for use in single-threaded scenarios and will give you a compile-time error if you try using it in a multithreaded context.

7. Here is a recap of the reasons to choose Box<T>, Rc<T>, or RefCell<T>:
    - Rc<T> enables multiple owners of the same data; Box<T> and RefCell<T> have single owners.
    - Box<T> allows immutable or mutable borrows checked at compile time; Rc<T> allows only immutable borrows checked at compile time; RefCell<T> allows immutable or mutable borrows checked at runtime.
    - Because RefCell<T> allows mutable borrows checked at runtime, you can mutate the value inside the RefCell<T> even when the RefCell<T> is immutable.

8. Catching borrowing errors at runtime rather than compile time means that you would find a mistake in your code later in the development process and possibly not until your code was deployed to production. Also, your code would incur a small runtime performance penalty as a result of keeping track of the borrows at runtime rather than compile time. However, using RefCell<T> makes it possible to write a mock object that can modify itself to keep track of the messages it has seen while you’re using it in a context where only immutable values are allowed. You can use RefCell<T> despite its trade-offs to get more functionality than regular references provide.

### 15.6 Reference Cycles Can Leak Memory

1. Rust’s memory safety guarantees make it difficult, but not impossible, to accidentally create memory that is never cleaned up (known as a memory leak). Preventing memory leaks entirely is not one of Rust’s guarantees in the same way that disallowing data races at compile time is, meaning memory leaks are memory safe in Rust. We can see that Rust allows memory leaks by using Rc<T> and RefCell<T>: it’s possible to create references where items refer to each other in a cycle. This creates memory leaks because the reference count of each item in the cycle will never reach 0, and the values will never be dropped.

> Question: What's the differences between memory leaks and memory unsafe?
