# 深入理解 Python

## 性能

### Python vs C/C++

#### [Is Python faster and lighter than C++?](https://stackoverflow.com/questions/801657/is-python-faster-and-lighter-than-c)

1. My experiences with Python show the same definite trend that Python is on the order of between 10 and 100 times slower than C++ when doing any serious number crunching. There are many reasons for this, the major ones being: a) Python is interpreted, while C++ is compiled; b) Python has no primitives, everything including the builtin types (int, float, etc.) are objects; c) a Python list can hold objects of different type, so each entry has to store additional data about its type. These all severely hinder both runtime and memory consumption.

2. This is no reason to ignore Python though. A lot of software doesn't require much time or memory even with the 100 time slowness factor. Development cost is where Python wins with the simple and concise style. This improvement on development cost often outweighs the cost of additional cpu and memory resources. When it doesn't, however, then C++ wins.

## 版本

## Python 2 vs Python 3


Basis of comparison	          | Python 3 | Python 2 |
----------------------------- | -------- | -------- |
Release Date                  | 2008	   | 2000     |
Function print                | print ("hello") | print "hello" |
Division of Integers	      | Whenever two integers are divided, you get a float value. | When two integers are divided, you always provide integer value.    |
Unicode                       | In Python 3, default storing of strings is Unicode.       | To store Unicode string value, you require to define them with "u". |
Syntax                        | The syntax is simpler and easily understandable.	      | The syntax of Python 2 was comparatively difficult to understand.   |
Rules of ordering Comparisons | In this version, Rules of ordering comparisons have been simplified. | Rules of ordering comparison are very complex.           |
Iteration                     | The new Range() function introduced to perform iterations. |In Python 2, the xrange() is used for iterations.                   |
Exceptions                    | It should be enclosed in parenthesis.                     | It should be enclosed in notations.                                 |
Leak of variables             | The value of variables never changes. | The value of the global variable will change while using it inside for-loop. |
Backward compatibility	      | Not difficult to port python 2 to python 3 but it is never reliable. | Python version 3 is not backwardly compatible with Python 2. |
Library                       | Many recent developers are creating libraries which you can only use with Python 3.	| Many older libraries created for Python 2 is not forward-compatible. |
