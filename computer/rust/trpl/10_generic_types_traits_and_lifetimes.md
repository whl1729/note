# The Rust Programming Language

## 10 Generic Types, Traits, and Lifetimes

### 10.1 Generic Data Types

1. Rust’s type-naming convention is CamelCase.

2. [Solved] Q: How to understand the `&` in `for &item in list.iter()` ?
    - A: This is used for pattern matching. `list.iter()` return `&i32`, so we can match the i32 value and store it in item.
```
fn largest_i32(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}
```

3. In the following example, we have to declare T just after impl so we can use it to specify that we’re implementing methods on the type Point<T>. By declaring T as a generic type after impl, Rust can identify that the type in the angle brackets in Point is a generic type rather than a concrete type.
```
impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}
```

### 10.2 Traits: Defining Shared Behavior

1. A trait tells the Rust compiler about functionality a particular type has and can share with other types. We can use traits to define shared behavior in an abstract way. We can use trait bounds to specify that a generic can be any type that has certain behavior.

2. Traits are similar to a feature often called interfaces in other languages, although with some differences.

3. A type’s behavior consists of the methods we can call on that type. Different types share the same behavior if we can call the same methods on all of those types. Trait definitions are a way to group method signatures together to define a set of behaviors necessary to accomplish some purpose.

4. One restriction to note with trait implementations is that we can implement a trait on a type only if either the trait or the type is local to our crate. This restriction is part of a property of programs called coherence, and more specifically the orphan rule, so named because the parent type is not present. This rule ensures that other people’s code can’t break your code and vice versa. Without the rule, two crates could implement the same trait for the same type, and Rust wouldn’t know which implementation to use.

5. Traits as Parameter
    - `impl Trait` syntax: The impl Trait syntax works for straightforward cases but is actually syntax sugar for a longer form, which is called a **trait bound**.
    ```
    pub fn notify(item: impl Summary) {
        println!("Breaking news! {}", item.summarize());
    }
    ```
    -  `trait bound` syntax
    ```
    pub fn notify<T: Summary>(item: T) {
        println!("Breaking news! {}", item.summarize());
    }
    ```

6. The ability to return a type that is only specified by the trait it implements is especially useful in the context of closures and iterators. Closures and iterators create types that only the compiler knows or types that are very long to specify. The `impl Trait` syntax lets you concisely specify that a function returns some type that implements the Iterator trait without needing to write out a very long type.
    - [Solved] Q: Not understand?
    - A: See [impl Trait](https://doc.rust-lang.org/stable/rust-by-example/trait/impl_trait.html) for more details.（伍注：`impl Trait`语法可以方便我们简洁地声明某种类型，这个要结合实际例子才容易理解。）

7. You can only use impl Trait if you’re returning a single type.

8. [self and Self](https://stackoverflow.com/questions/32304595/whats-the-difference-between-self-and-self)
    - Self is the type of the current object. It may appear either in a trait or an impl, but appears most often in trait where it is a stand-in for whatever type will end up implementing the trait
    - `self` when used as first method argument, is a shorthand for `self: Self`. There are also `&self`, which is equivalent to `self: &Self`, and `&mut self`, which is equivalent to `self: &mut Self`.
    - self is the name used in a trait or an impl for the first argument of a method. Using another name is possible, however there is a notable difference:
        - if using self, the function introduced is a method
        - if using any other name, the function introduced is an associated function

9. By using a trait bound with an impl block that uses generic type parameters, we can implement methods **conditionally** for types that implement the specified traits.

10. Implementations of a trait on any type that satisfies the trait bounds are called **blanket implementations** and are extensively used in the Rust standard library.

11. In dynamically typed languages, we would get an error at runtime if we called a method on a type which didn’t implement the type which defines the method. But Rust moves these errors to compile time so we’re forced to fix the problems before our code is even able to run. Additionally, we don’t have to write code that checks for behavior at runtime because we’ve already checked at compile time. Doing so improves performance without having to give up the flexibility of generics.

### 10.3 Validating References with Lifetimes

1. lifetime
    - Every reference in Rust has a lifetime, which is the scope for which that reference is valid.
    - Most of the time, lifetimes are implicit and inferred, just like most of the time, types are inferred.
    - We must annotate types when multiple types are possible. In a similar way, we must annotate lifetimes when the lifetimes of references could be related in a few different ways. Rust requires us to annotate the relationships using generic lifetime parameters to ensure the actual references used at runtime will definitely be valid.

2. The main aim of lifetimes is to **prevent dangling references**, which cause a program to reference data other than the data it’s intended to reference.

3. The Rust compiler has a borrow checker that compares scopes to determine whether all borrows are valid. (Question: How does the checker compare scopes?)

4. Question: Why should we add lifetime specifier in Listing 10-22 `fn longest(x: &str, y: &str) -> &str`?
```
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

5. Lifetime syntax is about connecting the lifetimes of various parameters and return values of functions. Once they’re connected, Rust has enough information to allow memory-safe operations and disallow operations that would create dangling pointers or otherwise violate memory safety.

6. It’s possible that more deterministic patterns will emerge and be added to the compiler. In the future, even fewer lifetime annotations might be required.

7. The patterns programmed into Rust’s analysis of references are called the lifetime elision rules. These aren’t rules for programmers to follow; they’re a set of particular cases that the compiler will consider, and if your code fits these cases, you don’t need to write the lifetimes explicitly.

8. Lifetimes on function or method parameters are called input lifetimes, and lifetimes on return values are called output lifetimes.

9. The compiler uses three rules to figure out what lifetimes references have when there aren’t explicit annotations. The first rule applies to input lifetimes, and the second and third rules apply to output lifetimes. If the compiler gets to the end of the three rules and there are still references for which it can’t figure out lifetimes, the compiler will stop with an error. These rules apply to fn definitions as well as impl blocks.

10. Three Rules
    - The first rule is that each parameter that is a reference gets its own lifetime parameter.
    - The second rule is if there is exactly one input lifetime parameter, that lifetime is assigned to all output lifetime parameters.
    - The third rule is if there are multiple input lifetime parameters, but one of them is &self or &mut self because this is a method, the lifetime of self is assigned to all output lifetime parameters.

11. Where we declare and use the lifetime parameters depends on whether they’re related to the struct fields or the method parameters and return values.

12. One special lifetime is 'static, which means that this reference can live for the entire duration of the program. All string literals have the 'static lifetime.

13. Most of the time, the problem results from attempting to create a dangling reference or a mismatch of the available lifetimes.
