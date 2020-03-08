# cargo 使用笔记

## cargo guide

1. To start a new package with Cargo, use `cargo new`. Cargo defaults to --bin to make a binary program. To make a library, we'd pass --lib.

2. `cargo new` also initializes a new git repository by default. If you don't want it to do that, pass --vcs none.

3. Once you’re ready for release, you can use cargo build --release to compile your files with optimizations turned on. cargo build --release puts the resulting binary in target/release instead of target/debug.

4. Cargo.toml vs Cargo.lock
    - Cargo.toml is about describing your dependencies in a broad sense, and is written by you.
    - Cargo.lock contains exact information about your dependencies. It is maintained by Cargo and should not be manually edited.
    - if you’re building a non-end product, such as a rust library that other rust packages will depend on, put Cargo.lock in your .gitignore. If you’re building an end product, which are executable like command-line tool or an application, or a system library with crate-type of staticlib or cdylib, check Cargo.lock into git. I

## Semantic Versioning

1. [Semantic Version](https://semver.org/)

2. Given a version number MAJOR.MINOR.PATCH, increment the:
    - MAJOR version when you make incompatible API changes,
    - MINOR version when you add functionality in a backwards compatible manner, and
    - PATCH version when you make backwards compatible bug fixes.
    - Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
