# The Rust Programming Language

## 9 Error Handling

1. Rust groups errors into two major categories: **recoverable and unrecoverable errors**. For a recoverable error, such as a file not found error, it’s reasonable to report the problem to the user and retry the operation. Unrecoverable errors are always symptoms of bugs, like trying to access a location beyond the end of an array.

2. Rust doesn’t have exceptions. Instead, it has the type `Result<T, E>` for recoverable errors and the `panic!` macro that stops execution when the program encounters an unrecoverable error.

### 9.1 Unrecoverable Errors with panic!

1. When the panic! macro executes, your program will print a failure message, unwind and clean up the stack, and then quit. This most commonly occurs when a bug of some kind has been detected and it’s not clear to the programmer how to handle the error.

2. Unwinding the Stack or Aborting in Response to a Panic
    - By default, when a panic occurs, the program starts unwinding, which means Rust walks back up the stack and cleans up the data from each function it encounters.
    - But this walking back and cleanup is a lot of work. The alternative is to immediately abort, which ends the program without cleaning up. Memory that the program was using will then need to be cleaned up by the operating system.
    - If in your project you need to make the resulting binary as small as possible, you can switch from unwinding to aborting upon a panic by adding panic = 'abort' to the appropriate [profile] sections in your Cargo.toml file.

3. RUST_BACKTRACE
    - We can set the RUST_BACKTRACE environment variable to get a backtrace of exactly what happened to cause the error. A backtrace is a list of all the functions that have been called to get to this point.
    - Backtraces in Rust work as they do in other languages: the key to reading the backtrace is to start from the top and read until you see files you wrote. That’s the spot where the problem originated. The lines above the lines mentioning your files are code that your code called; the lines below are code that called your code. These lines might include core Rust code, standard library code, or crates that you’re using.
    - In order to get backtraces with this information, debug symbols must be enabled. Debug symbols are enabled by default when using cargo build or cargo run without the --release flag, as we have here.

### 9.2 Recoverable Errors with Result

1. Using expect instead of unwrap and providing good error messages can convey your intent and make tracking down the source of a panic easier.

2. Propagating Errors: When you’re writing a function whose implementation calls something that might fail, instead of handling the error within this function, you can return the error to the calling code so that it can decide what to do. This is known as propagating the error and gives more control to the calling code, where there might be more information or logic that dictates how the error should be handled than what you have available in the context of your code.

3. Reading a file into a string is a fairly common operation, so Rust provides the convenient fs::read_to_string function that opens the file, creates a new String, reads the contents of the file, puts the contents into that String, and returns it.

## To panic! or Not to panic!

1. Returning Result is a good default choice when you’re defining a function that might fail.

2. It’s appropriate to panic in examples, prototype code, and tests.

3. It would also be appropriate to call unwrap when you have some other logic that ensures the Result will have an Ok value, but the logic isn’t something the compiler understands.

4. It’s advisable to have your code panic when it’s possible that your code could end up in a bad state. In this context, a bad state is when some assumption, guarantee, contract, or invariant has been broken, such as when invalid values, contradictory values, or missing values are passed to your code—plus one or more of the following:
    - The bad state is not something that’s expected to happen occasionally.
    - Your code after this point needs to rely on not being in this bad state.
    - There’s not a good way to encode this information in the types you use.

5. If someone calls your code and passes in values that don’t make sense, the best choice might be to call panic! and alert the person using your library to the bug in their code so they can fix it during development. Similarly, panic! is often appropriate if you’re calling external code that is out of your control and it returns an invalid state that you have no way of fixing.

6. When failure is expected, it’s more appropriate to return a Result than to make a panic! call.

7. Functions often have contracts: their behavior is only guaranteed if the inputs meet particular requirements. Panicking when the contract is violated makes sense because a contract violation always indicates a caller-side bug and it’s not a kind of error you want the calling code to have to explicitly handle. In fact, there’s no reasonable way for calling code to recover; the calling programmers need to fix the code. Contracts for a function, especially when a violation will cause a panic, should be explained in the API documentation for the function.

8. You can use Rust’s type system (and thus the type checking the compiler does) to do many of the checks for you.
