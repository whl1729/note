# The Rust Programming Language

## 14 More about Cargo and Crates.io

### 14.1 Customizing Builds with Release Profiles

1. The opt-level setting controls the number of optimizations Rust will apply to your code, with a range of 0 to 3. Applying more optimizations extends compiling time, so if you’re in development and compiling your code often, you’ll want faster compiling even if the resulting code runs slower. That is the reason the default opt-level for dev is 0. When you’re ready to release your code, it’s best to spend more time compiling. You’ll only compile in release mode once, but you’ll run the compiled program many times, so release mode trades longer compile time for code that runs faster. That is why the default opt-level for the release profile is 3.

### 14.2 Publishing a Crate to Crates.io

1. Rust also has a particular kind of comment for documentation, known conveniently as a documentation comment, that will generate HTML documentation. The HTML displays the contents of documentation comments for public API items intended for programmers interested in knowing how to use your crate as opposed to how your crate is implemented.

2. Documentation comments use three slashes, `///`, instead of two and support Markdown notation for formatting the text.

3. `cargo doc --open` will build the HTML for your current crate’s documentation (as well as the documentation for all of your crate’s dependencies) and open the result in a web browser.

4. Here are some sections that crate authors commonly use in their documentation:
    - Examples: demonstrate how to use your library
    - Panics: The scenarios in which the function being documented could panic. Callers of the function who don’t want their programs to panic should make sure they don’t call the function in these situations.
    - Errors: If the function returns a Result, describing the kinds of errors that might occur and what conditions might cause those errors to be returned can be helpful to callers so they can write code to handle the different kinds of errors in different ways.
    - Safety: If the function is unsafe to call (we discuss unsafety in Chapter 19), there should be a section explaining why the function is unsafe and covering the invariants that the function expects callers to uphold.

5. Adding example code blocks in your documentation comments can help demonstrate how to use your library, and doing so has an additional bonus: running cargo test will run the code examples in your documentation as tests!

6. Another style of doc comment, `//!`, adds documentation to the item that contains the comments rather than adding documentation to the items following the comments. We typically use these doc comments inside the crate root file (src/lib.rs by convention) or inside a module to document the crate or the module as a whole.

7. You can re-export items to make a public structure that’s different from your private structure by using `pub use`.

8. Now that you’ve created an account, saved your API token, chosen a name for your crate, and specified the required metadata, you’re ready to publish

9. Be careful when publishing a crate because a publish is permanent. The version can never be overwritten, and the code cannot be deleted. 

10. When you’ve made changes to your crate and are ready to release a new version, you change the version value specified in your Cargo.toml file and republish.

11. Although you can’t remove previous versions of a crate, you can prevent any future projects from adding them as a new dependency. This is useful when a crate version is broken for one reason or another. In such situations, Cargo supports yanking a crate version.

12. Yanking a version prevents new projects from starting to depend on that version while allowing all existing projects that depend on it to continue to download and depend on that version.

### 14.3 Cargo Workspaces

1. A workspace is a set of packages that share the same Cargo.lock and output directory.

2. As your project grows, consider using a workspace: it’s easier to understand smaller, individual components than one big blob of code. Furthermore, keeping the crates in a workspace can make coordination between them easier if they are often changed at the same time.

3. We can run tests for one particular crate in a workspace from the top-level directory by using the -p flag and specifying the name of the crate we want to test.

### 14.4 Installing Binaries from Crates.io with cargo install

1. The `cargo install` command allows you to install and use binary crates locally. This isn’t intended to replace system packages; it’s meant to be a convenient way for Rust developers to install tools that others have shared on crates.io. Note that you can only install packages that have binary targets.

2. A binary target is the runnable program that is created if the crate has a src/main.rs file or another file specified as a binary, as opposed to a library target that isn’t runnable on its own but is suitable for including within other programs.

3. All binaries installed with cargo install are stored in the installation root’s bin folder. If you installed Rust using rustup.rs and don’t have any custom configurations, this directory will be $HOME/.cargo/bin. Ensure that directory is in your $PATH to be able to run programs you’ve installed with cargo install.

### 14.5 Extending Cargo with Custom Commands

1. Cargo is designed so you can extend it with new subcommands without having to modify Cargo. If a binary in your $PATH is named `cargo-something`, you can run it as if it was a Cargo subcommand by running `cargo something`. Custom commands like this are also listed when you run `cargo --list`. Being able to use cargo install to install extensions and then run them just like the built-in Cargo tools is a super convenient benefit of Cargo’s design!

