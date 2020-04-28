# 深入理解 Python

## 性能

### Python vs C/C++

#### [Is Python faster and lighter than C++?](https://stackoverflow.com/questions/801657/is-python-faster-and-lighter-than-c)

1. My experiences with Python show the same definite trend that Python is on the order of between 10 and 100 times slower than C++ when doing any serious number crunching. There are many reasons for this, the major ones being: a) Python is interpreted, while C++ is compiled; b) Python has no primitives, everything including the builtin types (int, float, etc.) are objects; c) a Python list can hold objects of different type, so each entry has to store additional data about its type. These all severely hinder both runtime and memory consumption.

2. This is no reason to ignore Python though. A lot of software doesn't require much time or memory even with the 100 time slowness factor. Development cost is where Python wins with the simple and concise style. This improvement on development cost often outweighs the cost of additional cpu and memory resources. When it doesn't, however, then C++ wins.
