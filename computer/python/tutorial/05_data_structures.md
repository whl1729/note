# The Python Tutorial

## 5 Data Structures

### 5.1 More on Lists

1. You might have noticed that methods like insert, remove or sort that only modify the list have **no return value** printed – they return the default None. This is a design principle for all mutable data structures in Python. Other languages may return the mutated object, which allows **method chaining**, such as `d->insert("a")->remove("b")->sort();`
    - Question: Since returning the mutate object allows method channing, why does Python choose to return None?

2. While appends and pops from the end of list are fast, **doing inserts or pops from the beginning of a list is slow** (because all of the other elements have to be shifted by one).（伍注：Python list内部是以动态数组的方式来实现的。）

3. To implement a queue, use collections.deque which was designed to have fast appends and pops from both ends: `append` and `popleft`.

4. A **list comprehension** consists of brackets containing an expression followed by a for clause, then zero or more for or if clauses. The result will be a new list resulting from evaluating the expression in the context of the for and if clauses which follow it.

### 5.2 The del statement

1. There is a way to remove an item from a list given its index instead of its value: the `del` statement. This differs from the pop() method which returns a value. The del statement can also be used to remove slices from a list or clear the entire list.

2. `del` can also be used to delete entire variables.

### 5.3 Tuples and Sequences

1. Though tuples may seem similar to lists, they are often used in different situations and for different purposes. Tuples are immutable, and usually contain a heterogeneous sequence of elements that are accessed via unpacking or indexing (or even by attribute in the case of namedtuples). Lists are mutable, and their elements are usually homogeneous and are accessed by iterating over the list.

2. Empty tuples are constructed by an empty pair of parentheses; a tuple with one item is constructed by following a value with a **comma** (it is not sufficient to enclose a single value in parentheses). Ugly, but effective.

3. **Tuple packing**
```
t = 12345, 54321, 'hello!'
```

4. **Sequence unpacking** requires that there are as many variables on the left side of the equals sign as there are elements in the sequence.
```
x, y, z = t
```

5. **Multiple assignment** is really just a combination of tuple packing and sequence unpacking.

### 5.4 Sets

1. Curly braces or the set() function can be used to create sets. Note: **to create an empty set you have to use set(), not {}; the latter creates an empty dictionary.**

2. Similarly to list comprehensions, **set comprehensions** are also supported.

### 5.5 Dictionaries

1. Unlike sequences, which are indexed by a range of numbers, dictionaries are indexed by keys, which can be any **immutable type**; strings and numbers can always be keys. Tuples can be used as keys if they contain only strings, numbers, or tuples; if a tuple contains any mutable object either directly or indirectly, it cannot be used as a key. You can’t use lists as keys, since lists can be modified in place using index assignments, slice assignments, or methods like append() and extend().

2. It is best to think of a dictionary as a set of key: value pairs, with the requirement that the keys are unique (within one dictionary).

3. A pair of braces creates an empty dictionary: `{}`.

4. If you store using a key that is already in use, the old value associated with that key is forgotten. It is an error to extract a value using a non-existent key.

5. Performing `list(d)` on a dictionary returns a list of all the keys used in the dictionary, in insertion order (if you want it sorted, just use `sorted(d)` instead).

6. The `dict()` constructor builds dictionaries directly from sequences of key-value pairs.
```
>>> dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```

7. **Dict comprehensions** can be used to create dictionaries from arbitrary key and value expressions:
```
>>> {x: x**2 for x in (2, 4, 6)}
{2: 4, 4: 16, 6: 36}
```

8. When the keys are simple strings, it is sometimes easier to specify pairs using **keyword arguments**:
```
>>> dict(sape=4139, guido=4127, jack=4098)
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```

### 5.6 Looping Techniques

1. When looping through **dictionaries**, the key and corresponding value can be retrieved at the same time using the `items()` method.

2. When looping through a **sequence**, the position index and corresponding value can be retrieved at the same time using the `enumerate()` function.

3. To loop over **two or more sequences** at the same time, the entries can be paired with the `zip()` function.

4. To loop over a **sequence in reverse**, first specify the sequence in a forward direction and then call the `reversed()` function.

5. To loop over a **sequence in sorted order**, use the `sorted()` function which returns a new sorted list while leaving the source unaltered.

### 5.7 More on Conditions

1. The comparison operators `in` and `not in` check whether a value occurs (does not occur) in a sequence. The operators `is` and `is not` compare whether two objects are really the same object; this only matters for mutable objects like lists. All comparison operators have the same priority, which is lower than that of all numerical operators.

2. Comparisons may be combined using the Boolean operators `and` and `or`, and the outcome of a comparison (or of any other Boolean expression) may be negated with `not`. These have **lower priorities** than comparison operators; between them, `not` has the **highest** priority and `or` the **lowest**, so that `A and not B or C` is equivalent to `(A and (not B)) or C`. As always, parentheses can be used to express the desired composition.

3. The Boolean operators and and or are so-called **short-circuit** operators: their arguments are evaluated from left to right, and evaluation stops as soon as the outcome is determined. When used as a general value and not as a Boolean, the return value of a short-circuit operator is the **last evaluated** argument.

4. In Python, unlike C, assignment inside expressions must be done explicitly with the **walru operator** :=. This avoids a common class of problems encountered in C programs: typing = in an expression when == was intended.

### 5.8. Comparing Sequences and Other Types

1. Sequence objects typically may be compared to other objects with the same sequence type. The comparison uses **lexicographical ordering**: first the first two items are compared, and if they differ this determines the outcome of the comparison; if they are equal, the next two items are compared, and so on, until either sequence is exhausted. If two items to be compared are themselves sequences of the same type, the lexicographical comparison is carried out recursively. If all items of two sequences compare equal, the sequences are considered equal. If one sequence is an initial sub-sequence of the other, the shorter sequence is the smaller (lesser) one. Lexicographical ordering for strings uses the Unicode code point number to order individual characters.
