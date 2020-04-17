# The Rust Programming Language

## 20 Final Project: Building a Multithreaded Web Server

### 20.1 Building a Single-Threaded Web Server

1. In networking, connecting to a port to listen to is known as “binding to a port.”

### 20.2 Turning Our Single-Threaded Server into a Multithreaded Server

1. A **thread pool** is a group of spawned threads that are waiting and ready to handle a task. When the program receives a new task, it assigns one of the threads in the pool to the task, and that thread will process the task. The remaining threads in the pool are available to handle any other tasks that come in while the first thread is processing. When the first thread is done processing its task, it’s returned to the pool of idle threads, ready to handle a new task. A thread pool allows you to process connections concurrently, increasing the throughput of your server.

2. Thread Pool is just one of many ways to improve the throughput of a web server. Other options you might explore are the **fork/join model** and the **single-threaded async I/O model**.

3. When you’re trying to design code, writing the client interface first can help guide your design. Write the API of the code so it’s structured in the way you want to call it; then implement the functionality within that structure rather than implementing the functionality and then designing the public API.

4. We’ll use **compiler-driven** development here. We’ll write the code that calls the functions we want, and then we’ll look at errors from the compiler to determine what we should change next to get the code to work.

5. Create a new directory, src/bin, and move the binary crate rooted in src/main.rs into src/bin/main.rs. Doing so will make the library crate the primary crate in the hello directory; we can still run the binary in src/bin/main.rs using cargo run.
