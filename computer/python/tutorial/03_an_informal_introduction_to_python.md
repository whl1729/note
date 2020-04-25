# The Python Tutorial

## 3 An Informal Introduction to Python

1. Comments in Python start with the hash character, #, and extend to the end of the physical line. A comment may appear at the start of a line or following whitespace or code, but not within a string literal. **A hash character within a string literal is just a hash character.**

2. Division (/) always returns a float. To do floor division and get an integer result (discarding any fractional result) you can use the // operator; to calculate the remainder you can use %.（注：在python2中，/ 也是返回整数）

3. In interactive mode, the last printed expression is assigned to the variable \_.

4. In the interactive interpreter, the output string is enclosed in quotes and special characters are escaped with backslashes. The string is enclosed in double quotes if the string contains a single quote and no double quotes, otherwise it is enclosed in **single quotes**. The print() function produces a more readable output, by **omitting the enclosing quotes and by printing escaped and special characters**.

5. If you don’t want characters prefaced by \ to be interpreted as special characters, you can use raw strings by adding an r before the first quote.

6. String literals can span multiple lines. One way is using triple-quotes: """...""" or '''...'''. End of lines are automatically included in the string, but it’s possible to prevent this by adding a \ at the end of the line.

7. Strings can be concatenated (glued together) with the + operator, and repeated with \*. This only works with two literals though, not with variables or expressions.

8. Attempting to use an index that is too large will result in an error. However, out of range slice indexes are handled gracefully when used for slicing.
```
>>> word = 'Python'
>>> word[4:42]
'on'
>>> word[42:]
''
```

9. Python strings cannot be changed — they are immutable. Therefore, assigning to an indexed position in the string results in an error.

10. Multiple assignment: the expressions on the right-hand side are all evaluated first before any of the assignments take place. The right-hand side expressions are evaluated from the left to the right.

11. The keyword argument `end` can be used to avoid the newline after the output, or end the output with a different string.
```
print(a, end=',')
```
