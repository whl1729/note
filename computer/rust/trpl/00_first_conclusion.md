# The Rust Programming Language

## 第一次总结（2020年4月18日）

2020年3月8日至2020年4月18日，读完一遍《The Rust Programming Language》，并按照书中样例代码敲了一遍。自知不少地方没掌握好，需要回头复习、消化，故作此笔记。

### 对 Rust 的印象（好的方面）

- 文档资源齐全，制作用心（比如rust book左边还有书签导航）
- 包管理功能很强大、很好用。
- 测试用例、注释文档等都比较好用，比较现代化。

### 对 Rust 的印象（不太愉快的方面）

- 生命周期注释有点麻烦
- 各种指针类型有点复杂
- 控制权有点复杂

### 未掌握的知识点

- smart pointer: Box, Rc, RefCell, Arc
- ownership: reference, lifetime
- trait
- closure: Fn, FnOnce, FnMut
- iterator
- concurrency: Sync, Send
- common collections: vector, string, hash map

### 疑问

- [ ] Q: The Rust compiler has a borrow checker that compares scopes to determine whether all borrows are valid. (Question: How does the checker compare scopes?)
- [x] Q: Can we define our drop function? What if we do that? (See ch04)
- [x] Q: So what should we do if the type needs something special to happen when it goes out scope? (See ch04)
- [x] Q: What is trait? And How to define the Copy trait? (See ch04)
- [x] Q: Can we get substring in a non-reference way?
- [x] Q: How can the Option type prevent bugs?
- [x] Q: I can't understand crate root?
- [x] Q: We don't need the type annotation if Rust can infers it from the data. Question: So the Rust compiler will be more complicated ?
- [x] Q: How to understand the `&` in `for &item in list.iter()` ?
- [x] Q: The impl Trait syntax lets you concisely specify that a function returns some type that implements the Iterator trait without needing to write out a very long type. (not understand?)
- [ ] Q: Why should we add lifetime specifier in `fn longest(x: &str, y: &str) -> &str`?
- [ ] Q: What's the differences between memory leaks and memory unsafe?
- [ ] Q: I can't understand Figure 15-4: Why does `Cons(10, RefCell::new(Rc::clone(&a))` point to a instead of Cons(5, ...)`?
- [ ] Q: What does object-safe mean?
- [ ] Q: macros are expanded before the compiler interprets the meaning of the code, so a macro can, for example, implement a trait on a given type. A function can’t, because it gets called at runtime and a trait needs to be implemented at compile time. (not understand?)
- [ ] Q: Why can't we use 'while let' in Listing 20-21?
