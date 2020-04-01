# The Rust Programming Language

## 10 Generic Types, Traits, and Lifetimes

### 10.1 Generic Data Types

1. Rust’s type-naming convention is CamelCase.

2. Question: how to understand the `&` in `for &item in list.iter()` ?

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
