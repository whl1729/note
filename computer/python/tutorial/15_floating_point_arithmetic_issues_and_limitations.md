# The Python Tutorial

## 15. Floating Point Arithmetic: Issues and Limitations

1. For use cases which require exact decimal representation, try using the `decimal` module which implements decimal arithmetic suitable for accounting applications and high-precision applications.

2. Another form of exact arithmetic is supported by the `fractions` module which implements arithmetic based on rational numbers (so the numbers like 1/3 can be represented exactly).

3. Python provides tools that may help on those rare occasions when you really do want to know the exact value of a float. The `float.as_integer_ratio()` method expresses the value of a float as a fraction.

4. The float.hex() method expresses a float in hexadecimal (base 16), again giving the exact value stored by your computer.

5. Another helpful tool is the `math.fsum()` function which helps mitigate loss-of-precision during summation. It tracks “lost digits” as values are added onto a running total. That can make a difference in overall accuracy so that the errors do not accumulate to the point where they affect the final total:

6. **Representation error** refers to the fact that some (most, actually) decimal fractions cannot be represented exactly as binary (base 2) fractions. This is the chief reason why Python (or Perl, C, C++, Java, Fortran, and many others) often won’t display the exact decimal number you expect.
