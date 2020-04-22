# The Rust Programming Language

## 6 Enums and Pattern Matching

### 6.1 Defining an Enum

1. The Option type is used in many places because it encodes the very common scenario in which a value could be something or it could be nothing. Expressing this concept in terms of the type system means the compiler can check whether you’ve handled all the cases you should be handling; this functionality can prevent bugs that are extremely common in other programming languages.
    - [Solved] Q: How can the Option type prevent bugs?
    - A: See 4. （伍注：个人粗略理解是：Option类型强迫你考虑null value的情况，从而避免null value带来的bug）

2. Option<T> and T (where T can be any type) are different types, the compiler won’t let us use an Option<T> value as if it were definitely a valid value.

3. You have to convert an Option<T> to a T before you can perform T operations with it. Generally, this helps catch one of the most common issues with null: assuming that something isn’t null when it actually is.

4. In order to have a value that can possibly be null, you must explicitly opt in by making the type of that value Option<T>. Then, when you use that value, you are required to explicitly handle the case when the value is null. Everywhere that a value has a type that isn’t an Option<T>, you can safely assume that the value isn’t null.
