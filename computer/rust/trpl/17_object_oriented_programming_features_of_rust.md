# The Rust Programming Language

## 17 Object Oriented Programming Features of Rust

### 17.1 Characteristics of Object-Oriented Languages

1. The book Design Patterns defines OOP this way:
> Object-oriented programs are made up of objects. An object packages both data and the procedures that operate on that data. The procedures are typically called methods or operations.

2. OOP languages share certain common characteristics, namely objects, encapsulation, and inheritance.

3. If encapsulation is a required aspect for a language to be considered object oriented, then Rust meets that requirement. The option to use pub or not for different parts of code enables encapsulation of implementation details.

4. The Benifit of Encapsulation (Concluded by myself):
    - Prevent the user modify object's data unexpectedly
    - Change the implementation easily in the future

5. Inheritance is a mechanism whereby an object can inherit from another object’s definition, thus gaining the parent object’s data and behavior without you having to define them again.

6. If a language must have inheritance to be an object-oriented language, then Rust is not one. There is no way to define a struct that inherits the parent struct’s fields and method implementations.

7. You choose inheritance for two main reasons.
    - One is for reuse of code: you can implement particular behavior for one type, and inheritance enables you to reuse that implementation for a different type. You can share Rust code using default trait method implementations instead.
    - The other reason to use inheritance relates to the type system: to enable a child type to be used in the same places as the parent type. This is also called **polymorphism**, which means that you can substitute multiple objects for each other at runtime if they share certain characteristics.

8. Polymorphism
    - To many people, polymorphism is synonymous with inheritance. But it’s actually a more general concept that refers to code that can work with data of multiple types. For inheritance, those types are generally subclasses.
    - Rust instead uses generics to abstract over different possible types and trait bounds to impose constraints on what those types must provide. This is sometimes called bounded parametric polymorphism.

9. Why Rust uses trait objects instead of inheritance
    - Inheritance has recently fallen out of favor as a programming design solution in many programming languages because it’s often at risk of sharing more code than necessary. Subclasses shouldn’t always share all characteristics of their parent class but will do so with inheritance. This can make a program’s design less flexible.
    - It also introduces the possibility of calling methods on subclasses that don’t make sense or that cause errors because the methods don’t apply to the subclass.
    - In addition, some languages will only allow a subclass to inherit from one class, further restricting the flexibility of a program’s design.

### 17.2 Using Trait Objects That Allow for Values of Different Types

1. struct, enum, trait and object
    - In Rust, we refrain from calling structs and enums “objects” to distinguish them from other languages’ objects. In a struct or enum, the data in the struct fields and the behavior in impl blocks are separated, whereas in other languages, the data and behavior combined into one concept is often labeled an object.
    - However, trait objects are more like objects in other languages in the sense that they combine data and behavior. But trait objects differ from traditional objects in that we can’t add data to a trait object. Trait objects aren’t as generally useful as objects in other languages: their specific purpose is to allow abstraction across common behavior.

2. This concept—of being concerned only with the messages a value responds to rather than the value’s concrete type—is similar to the concept of **duck typing** in dynamically typed languages: if it walks like a duck and quacks like a duck, then it must be a duck!

3. The advantage of using trait objects and Rust’s type system to write code similar to code using duck typing is that we never have to check whether a value implements a particular method at runtime or worry about getting errors if a value doesn’t implement a method but we call it anyway. Rust won’t compile our code if the values don’t implement the traits that the trait objects need.

4. static dispatch vs dynamic dispatch:
    - The compiler generates nongeneric implementations of functions and methods for each concrete type that we use in place of a generic type parameter. The code that results from monomorphization is doing **static dispatch**, which is when the compiler knows what method you’re calling at compile time.
    - This is opposed to **dynamic dispatch**, which is when the compiler can’t tell at compile time which method you’re calling. In dynamic dispatch cases, the compiler emits code that at runtime will figure out which method to call.
    - When we use trait objects, Rust must use dynamic dispatch. The compiler doesn’t know all the types that might be used with the code that is using trait objects, so it doesn’t know which method implemented on which type to call. Instead, at runtime, Rust uses the pointers inside the trait object to know which method to call. There is a **runtime cost** when this lookup happens that doesn’t occur with static dispatch. Dynamic dispatch also prevents the compiler from choosing to inline a method’s code, which in turn prevents some optimizations. However, we did get extra flexibility, so it’s a trade-off to consider.

5. You can only make **object-safe** traits into trait objects. A trait is object safe if all the methods defined in the trait have the following properties:
    - The return type isn’t Self.
    - There are no generic type parameters.

> Question: What does object-safe mean?

### 17.3 Implementing an Object-Oriented Design Pattern

1. Even though Rust is capable of implementing object-oriented design patterns, other patterns, such as encoding state into the type system, are also available in Rust. These patterns have different trade-offs. Although you might be very familiar with object-oriented patterns, rethinking the problem to take advantage of Rust’s features can provide benefits, such as preventing some bugs at compile time. Object-oriented patterns won’t always be the best solution in Rust due to certain features, like ownership, that object-oriented languages don’t have.

2. You now know that you can use trait objects to get some object-oriented features in Rust. Dynamic dispatch can give your code some flexibility in exchange for a bit of runtime performance. You can use this flexibility to implement object-oriented patterns that can help your code’s maintainability. Rust also has other features, like ownership, that object-oriented languages don’t have. An object-oriented pattern won’t always be the best way to take advantage of Rust’s strengths, but is an available option.
