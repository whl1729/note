# The Rust Programming Language

## 12 An I/O Project: Building a Command Line Program

### 12.1 Accepting Command Line Arguments

1. `std::env::args` returns an iterator of the command line arguments.

### 12.3 Separation of Concerns for Binary Projects

1. The Rust community has developed a process to use as a guideline for splitting the separate concerns of a binary program when main starts getting large. The process has the following steps:
    - Split your program into a main.rs and a lib.rs and move your program’s logic to lib.rs.
    - As long as your command line parsing logic is small, it can remain in main.rs.
    - When the command line parsing logic starts getting complicated, extract it from main.rs and move it to lib.rs.
    
2. The responsibilities that remain in the main function after this process should be limited to the following:
    - Calling the command line parsing logic with the argument values
    - Setting up any other configuration
    - Calling a run function in lib.rs
    - Handling the error if run returns an error

3. This pattern is about separating concerns: main.rs handles running the program, and lib.rs handles all the logic of the task at hand. Because you can’t test the main function directly, this structure lets you test all of your program’s logic by moving it into functions in lib.rs. The only code that remains in main.rs will be small enough to verify its correctness by reading it.

4. It’s good to check your progress often, to help identify the cause of problems when they occur.

5. Using primitive values when a complex type would be more appropriate is an anti-pattern known as primitive obsession.

6. Box<dyn Error> means the function will return a type that implements the Error trait, but we don’t have to specify what particular type the return value will be. This gives us flexibility to return error values that may be of different types in different error cases. The dyn keyword is short for “dynamic.”

### 12.4 Developing the Library’s Functionality with Test-Driven Development

1. Test-driven development (TDD): This software development technique follows these steps:
    - Write a test that fails and run it to make sure it fails for the reason you expect.
    - Write or modify just enough code to make the new test pass.
    - Refactor the code you just added or changed and make sure the tests continue to pass.
    - Repeat from step 1!

### 12.5 Working with Environment Variables

1. The env::var function returns a Result that will be the successful Ok variant that contains the value of the environment variable if the environment variable is set. It will return the Err variant if the environment variable is not set.

### 12.6 Writing Error Messages to Standard Error Instead of Standard Output

1. Most terminals provide two kinds of output: standard output (stdout) for general information and standard error (stderr) for error messages. This distinction enables users to choose to direct the successful output of a program to a file but still print error messages to the screen.

2. The standard library provides the `eprintln!` macro that prints to the standard error stream.
