# The Rust Programming Language

## Chapter 01: Getting Started

1. The installation of Rust also includes a copy of the documentation locally, so you can read it offline. Run `rustup doc` to open the local documentation in your browser.

2. If you want to stick to a standard style across Rust projects, `rustfmt` will format your code in a particular style.

3. using a ! means that you’re calling a macro instead of a normal function.

4. Cargo expects your source files to live inside the src directory. The top-level project directory is just for README files, license information, configuration files, and anything else not related to your code. Using Cargo helps you organize your projects.

5. `cargo check` quickly checks your code to make sure it compiles but doesn’t produce an executable

6. Basic usages of cargo:
  - We can build a project using cargo build.
  - We can build and run a project in one step using cargo run.
  - We can build a project without producing a binary to check for errors using cargo check.
  - Instead of saving the result of the build in the same directory as our code, Cargo stores it in the target/debug directory.
