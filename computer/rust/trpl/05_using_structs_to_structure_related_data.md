# The Rust Programming Language

## 5 Using Structs to Structure Related Data

### 5.1 Defining and Instantiating Structs

1. Using the Field Init Shorthand when Variables and Fields Have the Same Name.

2. Creating Instances From Other Instances With Struct Update Syntax.

3. Unit-like structs can be useful in situations in which you need to implement a trait on some type but don’t have any data that you want to store in the type itself.

4. When we have larger structs, it’s useful to have output that’s a bit easier to read; in those cases, we can use {:#?} instead of {:?} in the println! string. When we use the {:#?} style in the example, the output will look like this:
```
rect1 is Rectangle {
    width: 30,
    height: 50
}
```

5. Rust has provided a number of traits for us to use with the derive annotation that can add useful behavior to our custom types. Those traits and their behaviors are listed in Appendix C.

### 5.3 Method Syntax

1. Methods are different from functions in that they’re defined within the context of a struct (or an enum or a trait object), and their first parameter is always self, which represents the instance of the struct the method is being called on.

2. The main benefit of using methods instead of functions, in addition to using method syntax and not having to repeat the type of self in every method’s signature, is for organization. We’ve put all the things we can do with an instance of a type in one impl block rather than making future users of our code search for capabilities of Rectangle in various places in the library we provide.

3. Another useful feature of impl blocks is that we’re allowed to define functions within impl blocks that don’t take self as a parameter. These are called associated functions because they’re associated with the struct.

4. Associated functions are often used for constructors that will return a new instance of the struct.
