# The Rust Programming Language

## 18 Patterns and Matching

1. A pattern consists of some combination of the following:
    - Literals
    - Destructured arrays, enums, structs, or tuples
    - Variables
    - Wildcards
    - Placeholders

### 18.1 All the Places Patterns Can Be Used

1. One requirement for match expressions is that they need to be exhaustive in the sense that all possibilities for the value in the match expression must be accounted for. One way to ensure you’ve covered every possibility is to have a catchall pattern for the last arm.

2. A particular pattern _ will match anything, but it never binds to a variable, so it’s often used in the last match arm. The _ pattern can be useful when you want to ignore any value not specified, for example.

3. The downside of using if let expressions is that the compiler doesn’t check exhaustiveness, whereas with match expressions it does. If we omitted the last else block and therefore missed handling some cases, the compiler would not alert us to the possible logic bug.

4. If we wanted to ignore one or more of the values in the tuple, we could use `_` or `..`

### 18.2 Refutability: Whether a Pattern Might Fail to Match

1. Patterns come in two forms: refutable and irrefutable.
    - Patterns that will match for any possible value passed are irrefutable.
    - Patterns that can fail to match for some possible value are refutable.

2. Function parameters, let statements, and for loops can only accept irrefutable patterns, because the program cannot do anything meaningful when values don’t match. The if let and while let expressions accept refutable and irrefutable patterns, but the compiler warns against irrefutable patterns because by definition they’re intended to handle possible failure: the functionality of a conditional is in its ability to perform differently depending on success or failure.

### 18.3 Pattern Syntax

1. In match expressions, you can match multiple patterns using the `|` syntax, which means or.

2. The `..=` syntax allows us to match to an inclusive range of values.

3. Ranges are only allowed with numeric values or char values, because the compiler checks that the range isn’t empty at compile time. The only types for which Rust can tell if a range is empty or not are char and numeric values.

4. There is a shorthand for patterns that match struct fields: you only need to list the name of the struct field, and the variables created from the pattern will have the same names.

5. There are a few ways to ignore entire values or parts of values in a pattern: using the _ pattern (which you’ve seen), using the _ pattern within another pattern, using a name that starts with an underscore, or using .. to ignore remaining parts of a value.

6. Ignoring a function parameter can be especially useful in some cases, for example, when implementing a trait when you need a certain type signature but the function body in your implementation doesn’t need one of the parameters. The compiler will then not warn about unused function parameters, as it would if you used a name instead.

7. We can also use _ inside another pattern to ignore just part of a value, for example, when we want to test for only part of a value but have no use for the other parts in the corresponding code we want to run.

8. There is a subtle difference between using only _ and using a name that starts with an underscore. The syntax _x still binds the value to the variable, whereas _ doesn’t bind at all.

9. With values that have many parts, we can use the .. syntax to use only a few parts and ignore the rest, avoiding the need to list underscores for each ignored value. The .. pattern ignores any parts of a value that we haven’t explicitly matched in the rest of the pattern.

10. Using .. must be unambiguous. If it is unclear which values are intended for matching and which should be ignored, Rust will give us an error.

11. You can also use the or operator | in a match guard to specify multiple patterns; the match guard condition will apply to all the patterns.

12. The at operator (@) lets us create a variable that holds a value at the same time we’re testing that value to see whether it matches a pattern. Using @ lets us test a value and save it in a variable within one pattern.
