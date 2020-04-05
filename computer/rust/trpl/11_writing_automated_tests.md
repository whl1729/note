# The Rust Programming Language

## 11 Writing Automated Tests

### 11.1 How to Write Tests

1. Checking Results with the `assert!` Macro
    - The assert! macro, provided by the standard library, is useful when you want to ensure that some condition in a test evaluates to true.
    - We give the assert! macro an argument that evaluates to a Boolean. If the value is true, assert! does nothing and the test passes. If the value is false, the assert! macro calls the panic! macro, which causes the test to fail.

2. Testing Equality with the `assert_eq!` and `assert_ne!` Macros
    - In Rust, the parameters to the functions `assert_eq!` are called left and right, and the order in which we specify the value we expect and the value that the code under test produces doesn’t matter.
    - The `assert_ne!` macro is most useful for cases when we’re not sure what a value will be, but we know what the value definitely won’t be if our code is functioning as we intend.

3. PartialEq and Debug traits
    - Under the surface, the assert_eq! and assert_ne! macros use the operators == and !=, respectively. When the assertions fail, these macros print their arguments using debug formatting, which means the values being compared must implement the PartialEq and Debug traits. 
    - All the primitive types and most of the standard library types implement these traits. For structs and enums that you define, you’ll need to implement PartialEq to assert that values of those types are equal or not equal. You’ll need to implement Debug to print the values when the assertion fails. 
    - Because both traits are derivable traits, this is usually as straightforward as adding the #[derive(PartialEq, Debug)] annotation to your struct or enum definition. See Appendix C, “Derivable Traits,” for more details about these and other derivable traits.

4. You can also add a custom message to be printed with the failure message as optional arguments to the assert!, assert_eq!, and assert_ne! macros. Any arguments specified after the one required argument to assert! or the two required arguments to assert_eq! and assert_ne! are passed along to the format! macro, so you can pass a format string that contains {} placeholders and values to go in those placeholders.

5. The attribute `should_panic` makes a test pass if the code inside the function panics; the test will fail if the code inside the function doesn’t panic.

6. Writing tests so they return a `Result<T, E>` enables you to use the question mark operator in the body of tests, which can be a convenient way to write tests that should fail if any operation within them returns an Err variant.

### 11.2 Controlling How Tests Are Run

1. You can specify command line options to change the default behavior of cargo test. For example, the default behavior of the binary produced by cargo test is to run all the tests in parallel and capture output generated during test runs, preventing the output from being displayed and making it easier to read the output related to the test results.

2. Some command line options go to cargo test, and some go to the resulting test binary. To separate these two types of arguments, you list the arguments that go to cargo test followed by the separator -- and then the ones that go to the test binary. Running cargo test --help displays the options you can use with cargo test, and running cargo test -- --help displays the options you can use after the separator --.

3. `cargo test -- --test-threads=1` tells the program not to use any parallelism.

4. By default, if a test passes, Rust’s test library captures anything printed to standard output. If a test fails, we’ll see whatever was printed to standard output with the rest of the failure message.

5. `cargo test -- --show-output` tells Rust to also show the output of successful tests at the end with --show-output.

### 11.3 Test Organization

1. The Rust community thinks about tests in terms of two main categories: unit tests and integration tests. Unit tests are small and more focused, testing one module in isolation at a time, and can test private interfaces. Integration tests are entirely external to your library and use your code in the same way any other external code would, using only the public interface and potentially exercising multiple modules per test.

2. The purpose of unit tests is to test each unit of code in isolation from the rest of the code to quickly pinpoint where code is and isn’t working as expected. You’ll put unit tests in the src directory in each file with the code that they’re testing. The convention is to create a module named tests in each file to contain the test functions and to annotate the module with cfg(test).

3. The #[cfg(test)] annotation on the tests module tells Rust to compile and run the test code only when you run cargo test, not when you run cargo build. This saves compile time when you only want to build the library and saves space in the resulting compiled artifact because the tests are not included. You’ll see that because integration tests go in a different directory, they don’t need the #[cfg(test)] annotation. However, because unit tests go in the same files as the code, you’ll use #[cfg(test)] to specify that they shouldn’t be included in the compiled result.

4. The attribute cfg stands for configuration and tells Rust that the following item should only be included given a certain configuration option.

5. Rust’s privacy rules do allow you to test private functions. 

6. To run all the tests in a particular integration test file, use the --test argument of cargo test followed by the name of the file

7. Each file in the tests directory is a separate crate, so we need to bring our library into each test crate’s scope.

8. Files in subdirectories of the tests directory don’t get compiled as separate crates or have sections in the test output.

9. If our project is a binary crate that only contains a src/main.rs file and doesn’t have a src/lib.rs file, we can’t create integration tests in the tests directory and bring functions defined in the src/main.rs file into scope with a use statement. Only library crates expose functions that other crates can use; binary crates are meant to be run on their own.

10. This is one of the reasons Rust projects that provide a binary have a straightforward src/main.rs file that calls logic that lives in the src/lib.rs file. Using that structure, integration tests can test the library crate with use to make the important functionality available. If the important functionality works, the small amount of code in the src/main.rs file will work as well, and that small amount of code doesn’t need to be tested.
