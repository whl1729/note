# The Python Tutorial

## 11. Brief Tour of the Standard Library — Part II

### 11.1. Output Formatting

1. The reprlib module provides a version of repr() customized for abbreviated displays of large or deeply nested containers.

2. The pprint module offers more sophisticated control over printing both built-in and user defined objects in a way that is readable by the interpreter. When the result is longer than one line, the “pretty printer” adds line breaks and indentation to more clearly reveal data structure.

3. The textwrap module formats paragraphs of text to fit a given screen width.

4. The locale module accesses a database of culture specific data formats. The grouping attribute of locale’s format function provides a direct way of formatting numbers with group separators.

### 11.2. Templating

1. The string module includes a versatile Template class with a simplified syntax suitable for editing by end-users. This allows users to customize their applications without having to alter the application.

2. The substitute() method raises a KeyError when a placeholder is not supplied in a dictionary or a keyword argument. For mail-merge style applications, user supplied data may be incomplete and the safe_substitute() method may be more appropriate — it will leave placeholders unchanged if data is missing.

3. Template subclasses can specify a custom delimiter.

### 11.3. Working with Binary Data Record Layouts

1. The struct module provides pack() and unpack() functions for working with variable length binary record formats.

### 11.4. Multi-threading

1. The principal challenge of multi-threaded applications is coordinating threads that share data or other resources. To that end, the threading module provides a number of synchronization primitives including locks, events, condition variables, and semaphores.

2. While those tools are powerful, minor design errors can result in problems that are difficult to reproduce. So, the preferred approach to task coordination is to concentrate all access to a resource in a single thread and then use the `queue` module to feed that thread with requests from other threads. Applications using Queue objects for inter-thread communication and coordination are easier to design, more readable, and more reliable.

### 11.5. Logging

1. The logging module offers a full featured and flexible logging system. At its simplest, log messages are sent to a file or to sys.stderr.

### 11.6. Weak References

1. Python does automatic memory management (reference counting for most objects and garbage collection to eliminate cycles). The memory is freed shortly after the last reference to it has been eliminated.

2. This approach works fine for most applications but occasionally there is a need to track objects only as long as they are being used by something else. Unfortunately, just tracking them creates a reference that makes them permanent. The weakref module provides tools for tracking objects without creating a reference. When the object is no longer needed, it is automatically removed from a weakref table and a callback is triggered for weakref objects. Typical applications include caching objects that are expensive to create. (Question: not understand the application of weakref?)

### 11.7. Tools for Working with Lists

1. The array module provides an array() object that is like a list that stores only homogeneous data and stores it more compactly.

2. The collections module provides a deque() object that is like a list with faster appends and pops from the left side but slower lookups in the middle.

3. In addition to alternative list implementations, the library also offers other tools such as the bisect module with functions for manipulating sorted lists.

4. The heapq module provides functions for implementing heaps based on regular lists. The lowest valued entry is always kept at position zero. This is useful for applications which repeatedly access the smallest element but do not want to run a full list sort.

### 11.8. Decimal Floating Point Arithmetic

1. The decimal module offers a Decimal datatype for decimal floating point arithmetic. Compared to the built-in float implementation of binary floating point, the class is especially helpful for
    - financial applications and other uses which require exact decimal representation,
    - control over precision,
    - control over rounding to meet legal or regulatory requirements,
    - tracking of significant decimal places, or
    - applications where the user expects the results to match calculations done by hand.

2. Exact representation enables the Decimal class to perform modulo calculations and equality tests that are unsuitable for binary floating point.

3. The decimal module provides arithmetic with as much precision as needed.
