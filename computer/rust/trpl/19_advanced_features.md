# The Rust Programming Language

## 19 Advanced Features

### 19.1 Unsafe Rust

1. Why we need unsafe Rust
    - Unsafe Rust exists because, by nature, static analysis is conservative. When the compiler tries to determine whether or not code upholds the guarantees, it’s better for it to reject some valid programs rather than accept some invalid programs. Although the code might be okay, as far as Rust is able to tell, it’s not! In these cases, you can use unsafe code to tell the compiler, “Trust me, I know what I’m doing.” The downside is that you use it at your own risk: if you use unsafe code incorrectly, problems due to memory unsafety, such as null pointer dereferencing, can occur.
    - Another reason Rust has an unsafe alter ego is that the underlying computer hardware is inherently unsafe. If Rust didn’t let you do unsafe operations, you couldn’t do certain tasks. Rust needs to allow you to do low-level systems programming, such as directly interacting with the operating system or even writing your own operating system. Working with low-level systems programming is one of the goals of the language.

2. You can take four actions in unsafe Rust, called **unsafe superpowers**, that you can’t in safe Rust. Those superpowers include the ability to:
    - Dereference a raw pointer
    - Call an unsafe function or method
    - Access or modify a mutable static variable
    - Implement an unsafe trait
    - Access fields of unions

3. People are fallible, and mistakes will happen, but by requiring these four unsafe operations to be inside blocks annotated with unsafe you’ll know that any errors related to memory safety must be within an unsafe block. Keep unsafe blocks small; you’ll be thankful later when you investigate memory bugs.

4. Unsafe Rust has two new types called raw pointers that are similar to references. As with references, raw pointers can be immutable or mutable and are written as *const T and *mut T, respectively. The asterisk isn’t the dereference operator; it’s part of the type name. In the context of raw pointers, immutable means that the pointer can’t be directly assigned to after being dereferenced.

5. Different from references and smart pointers, raw pointers:
    - Are allowed to ignore the borrowing rules by having both immutable and mutable pointers or multiple mutable pointers to the same location
    - Aren’t guaranteed to point to valid memory
    - Are allowed to be null
    - Don’t implement any automatic cleanup

6. With all of these dangers, why would you ever use raw pointers?
    - One major use case is when interfacing with C code, as you’ll see in the next section, “Calling an Unsafe Function or Method.”
    - Another case is when building up safe abstractions that the borrow checker doesn’t understand.

7. Rust has a keyword, extern, that facilitates the creation and use of a **Foreign Function Interface (FFI)**. An FFI is a way for a programming language to define functions and enable a different (foreign) programming language to call those functions.

8. Functions declared within extern blocks are always unsafe to call from Rust code. The reason is that other languages don’t enforce Rust’s rules and guarantees, and Rust can’t check them, so responsibility falls on the programmer to ensure safety.

9. We can also use extern to create an interface that allows other languages to call Rust functions. Instead of an extern block, we add the extern keyword and specify the ABI to use just before the fn keyword. We also need to add a #[no_mangle] annotation to tell the Rust compiler not to mangle the name of this function. Mangling is when a compiler changes the name we’ve given a function to a different name that contains more information for other parts of the compilation process to consume but is less human readable. Every programming language compiler mangles names slightly differently, so for a Rust function to be nameable by other languages, we must disable the Rust compiler’s name mangling.

10. In Rust, global variables are called static variables.

11. The names of static variables are in SCREAMING_SNAKE_CASE by convention, and we must annotate the variable’s type. Static variables can only store references with the 'static lifetime, which means the Rust compiler can figure out the lifetime; we don’t need to annotate it explicitly. Accessing an immutable static variable is safe.

12. Constants and immutable static variables might seem similar, but a subtle difference is that values in a static variable have a fixed address in memory. Using the value will always access the same data. Constants, on the other hand, are allowed to duplicate their data whenever they’re used.

13. Another difference between constants and static variables is that static variables can be mutable. Accessing and modifying mutable static variables is unsafe.

### 19.2 Advanced Traits

1. Associated Types vs Generics
    - When using generics, we must annotate the types in each implementation.
    - With associated types, we don’t need to annotate types because we can’t implement a trait on a type multiple times.

2. When we use generic type parameters, we can specify a default concrete type for the generic type. This eliminates the need for implementors of the trait to specify a concrete type if the default type works. The syntax for specifying a default type for a generic type is <PlaceholderType=ConcreteType> when declaring the generic type.

3. Rust doesn’t allow you to create your own operators or overload arbitrary operators. But you can overload the operations and corresponding traits listed in std::ops by implementing the traits associated with the operator.

4. Associated functions that are part of traits don’t have a self parameter. When two types in the same scope implement that trait, Rust can’t figure out which type you mean unless you use fully qualified syntax.

5. In general, **fully qualified syntax** is defined as follows:
```
<Type as Trait>::function(receiver_if_method, next_arg, ...);
```

6. We mentioned the **orphan rule** that states we’re allowed to implement a trait on a type as long as either the trait or the type are local to our crate. It’s possible to get around this restriction using the **newtype pattern**, which involves creating a new type in a tuple struct. The tuple struct will have one field and be a thin wrapper around the type we want to implement a trait for. Then the wrapper type is local to our crate, and we can implement the trait on the wrapper. Newtype is a term that originates from the Haskell programming language. There is no runtime performance penalty for using this pattern, and the wrapper type is elided at compile time.

7. Sometimes, you might need one trait to use another trait’s functionality. In this case, you need to rely on the dependent trait also being implemented. The trait you rely on is a **supertrait** of the trait you’re implementing.

### 19.3 Advanced Types

1. Using Newtype Pattern to
    - implement external traits on external types
    - abstract away some implementation details of a type: the new type can expose a public API that is different from the API of the private inner type if we used the new type directly to restrict the available functionality
    - hide internal implementation

2. Along with the newtype pattern, Rust provides the ability to declare a type alias to give an existing type another name. For this we use the type keyword.

3. The main use case for type synonyms is to reduce repetition.

4. Rust has a special type named ! that’s known in type theory lingo as the **empty type** because it has no values. We prefer to call it the **never type** because it stands in the place of the return type when a function will never return.

5. The formal way of describing this behavior is that expressions of type ! can be coerced into any other type.

6. Dynamically Sized Types: sometimes referred to as DSTs or unsized types.

7. Dynamically sized types have an extra bit of metadata that stores the size of the dynamic information. The golden rule of dynamically sized types is that we must always put values of dynamically sized types behind a pointer of some kind.

8. Every trait is a dynamically sized type we can refer to by using the name of the trait. We mentioned that to use traits as trait objects, we must put them behind a pointer, such as &dyn Trait or Box<dyn Trait> (Rc<dyn Trait> would work too).

9. To work with DSTs, Rust has a particular trait called the Sized trait to determine whether or not a type’s size is known at compile time. This trait is automatically implemented for everything whose size is known at compile time. In addition, Rust implicitly adds a bound on Sized to every generic function.

10. A trait bound on `?Sized` is the opposite of a trait bound on `Sized`: we would read this as “T may or may not be Sized.” This syntax is only available for Sized, not any other traits.

### 19.4 Advanced Functions and Closures

1. Functions coerce to the type fn (with a lowercase f), not to be confused with the Fn closure trait. The fn type is called a **function pointer**.

2. Function pointers implement all three of the closure traits (Fn, FnMut, and FnOnce), so you can always pass a function pointer as an argument for a function that expects a closure. It’s best to write functions using a generic type and one of the closure traits so your functions can accept either functions or closures.

3. An example of where you would want to only accept fn and not closures is when interfacing with external code that doesn’t have closures: C functions can accept functions as arguments, but C doesn’t have closures.

4. We have another useful pattern that exploits an implementation detail of tuple structs and tuple-struct enum variants. These types use () as initializer syntax, which looks like a function call. The initializers are actually implemented as functions returning an instance that’s constructed from their arguments. We can use these initializer functions as function pointers that implement the closure traits, which means we can specify the initializer functions as arguments for methods that take closures.

### 19.5 Macros

1. The term macro refers to a family of features in Rust: **declarative macros** with macro_rules! and three kinds of **procedural macros**:
    - Custom #[derive] macros that specify code added with the derive attribute used on structs and enums
    - Attribute-like macros that define custom attributes usable on any item
    - Function-like macros that look like function calls but operate on the tokens specified as their argument

2. Fundamentally, macros are a way of writing code that writes other code, which is known as metaprogramming.

3. The Difference Between Macros and Functions
    - A function signature must declare the number and type of parameters the function has. Macros, on the other hand, can take a variable number of parameters
    - macros are expanded before the compiler interprets the meaning of the code, so a macro can, for example, implement a trait on a given type. A function can’t, because it gets called at runtime and a trait needs to be implemented at compile time. (Question: not understand?)
    - The downside to implementing a macro instead of a function is that macro definitions are more complex than function definitions because you’re writing Rust code that writes Rust code.
    - Another important difference between macros and functions is that you must define macros or bring them into scope before you call them in a file, as opposed to functions you can define anywhere and call anywhere.

4. Macros also compare a value to patterns that are associated with particular code: in this situation, the value is the literal Rust source code passed to the macro; the patterns are compared with the structure of that source code; and the code associated with each pattern, when matched, replaces the code passed to the macro. This all happens during compilation.

5. Procedural macros accept some code as an input, operate on that code, and produce some code as an output rather than matching against patterns and replacing the code with other code as declarative macros do.

6. The convention for structuring crates and macro crates is as follows: for a crate named foo, a custom derive procedural macro crate is called foo_derive.

7. The proc_macro crate comes with Rust, so we didn’t need to add that to the dependencies in Cargo.toml. The proc_macro crate is the compiler’s API that allows us to read and manipulate Rust code from our code.

8. The syn crate parses Rust code from a string into a data structure that we can perform operations on. The quote crate turns syn data structures back into Rust code. These crates make it much simpler to parse any sort of Rust code we might want to handle.

9. Attribute-like macros are similar to custom derive macros, but instead of generating code for the derive attribute, they allow you to create new attributes. They’re also more flexible: derive only works for structs and enums; attributes can be applied to other items as well, such as functions.

10. Function-like macros define macros that look like function calls. Similarly to macro_rules! macros, they’re more flexible than functions; for example, they can take an unknown number of arguments. However, macro_rules! macros can be defined only using the match-like syntax. Function-like macros take a TokenStream parameter and their definition manipulates that TokenStream using Rust code as the other two types of procedural macros do.
