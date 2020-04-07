# The Rust Programming Languge

## 13 Functional Language Features: Iterators and Closures

1. Programming in a functional style often includes using functions as values by passing them in arguments, returning them from other functions, assigning them to variables for later execution, and so forth.

2. Mastering closures and iterators is an important part of writing idiomatic, fast Rust code, so we’ll devote this entire chapter to them.

### 13.1 Closures: Anonymous Functions that Can Capture Their Environment

1. Rust’s closures are anonymous functions you can save in a variable or pass as arguments to other functions. You can create the closure in one place and then call the closure to evaluate it in a different context. Unlike functions, closures can capture values from the scope in which they’re defined.

2. We want to define code in one place in our program, but only execute that code where we actually need the result. This is a use case for closures

3. Closures don’t require you to annotate the types of the parameters or the return value like fn functions do. Type annotations are required on functions because they’re part of an explicit interface exposed to your users. Defining this interface rigidly is important for ensuring that everyone agrees on what types of values a function uses and returns. But closures aren’t used in an exposed interface like this: they’re stored in variables and used without naming them and exposing them to users of our library.

4. Closures are usually short and relevant only within a narrow context rather than in any arbitrary scenario. Within these limited contexts, the compiler is reliably able to infer the types of the parameters and the return type, similar to how it’s able to infer the types of most variables.

5. We can create a struct that will hold the closure and the resulting value of calling the closure. The struct will execute the closure only if we need the resulting value, and it will cache the resulting value so the rest of our code doesn’t have to be responsible for saving and reusing the result. You may know this pattern as memoization or lazy evaluation.

6. To define structs, enums, or function parameters that use closures, we use generics and trait bounds.

7. The Fn traits are provided by the standard library. All closures implement at least one of the traits: Fn, FnMut, or FnOnce.

8. Functions can implement all three of the Fn traits too. If what we want to do doesn’t require capturing a value from the environment, we can use a function rather than a closure where we need something that implements an Fn trait.

9. Closures have an additional capability that functions don’t have: they can capture their environment and access variables from the scope in which they’re defined.

10. When a closure captures a value from its environment, it uses memory to store the values for use in the closure body. This use of memory is overhead that we don’t want to pay in more common cases where we want to execute code that doesn’t capture its environment.

11. Closures can capture values from their environment in three ways, which directly map to the three ways a function can take a parameter: taking ownership, borrowing mutably, and borrowing immutably. These are encoded in the three Fn traits as follows:

12. If you want to force the closure to take ownership of the values it uses in the environment, you can use the move keyword before the parameter list. This technique is mostly useful when passing a closure to a new thread to move the data so it’s owned by the new thread.
    - FnOnce consumes the variables it captures from its enclosing scope, known as the closure’s environment. To consume the captured variables, the closure must take ownership of these variables and move them into the closure when it is defined. The Once part of the name represents the fact that the closure can’t take ownership of the same variables more than once, so it can be called only once.
    - FnMut can change the environment because it mutably borrows values.
    - Fn borrows values from the environment immutably.

13. Most of the time when specifying one of the Fn trait bounds, you can start with Fn and the compiler will tell you if you need FnMut or FnOnce based on what happens in the closure body.

### 13.2 Processing a Series of Items with Iterators

1. The iterator pattern allows you to perform some task on a sequence of items in turn. An iterator is responsible for the logic of iterating over each item and determining when the sequence has finished. When you use iterators, you don’t have to reimplement that logic yourself.

2. In Rust, iterators are lazy, meaning they have no effect until you call methods that consume the iterator to use it up.

3. The `iter` method produces an iterator over **immutable references**. If we want to create an iterator that **takes ownership and returns owned values**, we can call `into_iter` instead of `iter`. Similarly, if we want to iterate over **mutable references**, we can call `iter_mut` instead of iter.

4. Other methods defined on the Iterator trait, known as iterator adaptors, allow you to change iterators into different kinds of iterators. You can chain multiple calls to iterator adaptors to perform complex actions in a readable way. But because all iterators are lazy, you have to call one of the consuming adaptor methods to get results from calls to iterator adaptors.

5. `zip` returns None when either of its input iterators return None.

### 13.3 Improving Our I/O Project

1. The functional programming style prefers to minimize the amount of mutable state to make code clearer.

### 13.4 Comparing Performance: Loops vs. Iterators

1. Iterators, although a high-level abstraction, get compiled down to roughly the same code as if you’d written the lower-level code yourself. Iterators are one of Rust’s zero-cost abstractions, by which we mean using the abstraction imposes no additional runtime overhead.

2. Bjarne Stroustrup defines zero-overhead in “Foundations of C++”:
> In general, C++ implementations obey the zero-overhead principle: What you don’t use, you don’t pay for. And further: What you do use, you couldn’t hand code any better.

3. Unrolling is an optimization that removes the overhead of the loop controlling code and instead generates repetitive code for each iteration of the loop.
