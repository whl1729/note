# 深入理解 Rust

## [The Borrow Checker and Memory Management](https://dev.to/strottos/learn-rust-the-hard-bits-3d26)

1. In Rust everything has to be "owned" by something. Once it's no longer owned by something the memory will be cleared for us at that point. It's as if the compiler went and added the delete statement in C++ for me, (how cool is that, I don't need to remember it). But what does it mean to be "owned" by something.

2. We can pass ownership of immutable variable around to be a mutable variable and that's absolutely fine. Well Rust makes no guarantees you won't purposefully change it to mutable but you've got to try to change it. It's not trying to tell you what to do it's trying to get you to stop changing things you never meant to.
