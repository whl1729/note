# The Rust Programming Language

## 7 Managing Growing Projects with Packages, Crates, and Modules

1. Rust has a number of features that allow you to manage your code’s organization, including which details are exposed, which details are private, and what names are in each scope in your programs. These features, sometimes collectively referred to as the **module system**, include:
    - Packages: A Cargo feature that lets you build, test, and share crates
    - Crates: A tree of modules that produces a library or executable
    - Modules and use: Let you control the organization, scope, and privacy of paths
    - Paths: A way of naming an item, such as a struct, function, or module

### 7.1 Packages and Crates

1. A crate is a binary or library. The crate root is a source file that the Rust compiler starts from and makes up the root module of your crate section.
    - Cargo follows a convention that src/main.rs is the crate root of a binary crate with the same name as the package.
    - Cargo knows that if the package directory contains src/lib.rs, the package contains a library crate with the same name as the package, and src/lib.rs is its crate root.
    - Cargo passes the crate root files to rustc to build the library or binary.
    - If a package contains src/main.rs and src/lib.rs, it has two crates: a library and a binary, both with the same name as the package.
    - src/main.rs and src/lib.rs are called crate roots. The reason for their name is that the contents of either of these two files form a module named crate at the root of the crate’s module structure, known as the module tree.

> Question: I can't understand crate root?

2. A package is one or more crates that provide a set of functionality. A package contains a Cargo.toml file that describes how to build those crates.

3. A package must contain zero or one library crates, and no more. It can contain as many binary crates as you’d like, but it must contain at least one crate (either library or binary).

### 7.3 Paths for Referring to an Item in the Module Tree

1. If we want to call a function, we need to know its path. A path can take two forms:
    - An absolute path starts from a crate root by using a crate name or a literal crate.
    - A relative path starts from the current module and uses self, super, or an identifier in the current module.

2. Our preference is to specify absolute paths because it’s more likely to move code definitions and item calls independently of each other.

3. We can also construct relative paths that begin in the parent module by using super at the start of the path. This is like starting a filesystem path with the .. syntax.

4. If we use pub before a struct definition, we make the struct public, but the struct’s fields will still be private. In contrast, if we make an enum public, all of its variants are then public. We only need the pub before the enum keyword

### 7.4 Bringing Paths into Scope with the use Keyword

1. Create Idiomatic use Paths
    - Bringing the function’s parent module into scope with use so we have to specify the parent module when calling the function makes it clear that the function isn’t locally defined while still minimizing repetition of the full path.
    - When bringing in structs, enums, and other items with use, it’s idiomatic to specify the full path.

2. There’s another solution to the problem of bringing two types of the same name into the same scope with use: after the path, we can specify as and a new local name, or alias, for the type.

3. When we bring a name into scope with the use keyword, the name available in the new scope is private. To enable the code that calls our code to refer to that name as if it had been defined in that code’s scope, we can combine pub and use. This technique is called re-exporting because we’re bringing an item into scope but also making that item available for others to bring into their scope.
