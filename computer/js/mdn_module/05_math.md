# JavaScript Modules

## 05 Basic math in JavaScript — numbers and operators

### Types of numbers

1. Unlike some other programming languages, JavaScript only has one data type for numbers, both integers and decimals — you guessed it, **Number**. This means that whatever type of numbers you are dealing with in JavaScript, you handle them in exactly the same way.

2. Actually, JavaScript has a second number type, **BigInt**, used for very, very large integers.

### Useful Number methods

1. Use the `toFixed()` method to round your number to a fixed number of decimal places.

2. Use the `Number()` to return a number version of the string value.

### Comparison operators

1.  You may see some people using == and != in their tests for equality and non-equality. These are valid operators in JavaScript, but they differ from ===/!==. The former versions test whether the values are the same but not whether the values' datatypes are the same. The latter, strict versions test the equality of both the values and their datatypes. The strict versions tend to result in fewer errors, so we recommend you use them.
