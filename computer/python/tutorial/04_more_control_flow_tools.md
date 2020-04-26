# The Python Tutorial

## 4 More Control Flow Tools

1. Rather than always iterating over an arithmetic progression of numbers (like in Pascal), or giving the user the ability to define both the iteration step and halting condition (as C), Python’s for statement **iterates over the items of any sequence (a list or a string)**, in the order that they appear in the sequence.

2. Code that modifies a collection while iterating over that same collection can be tricky to get right. Instead, it is usually more straight-forward to **loop over a copy of the collection or to create a new collection**.
    - Question: why?
```
# Strategy:  Iterate over a copy
for user, status in users.copy().items():
    if status == 'inactive':
        del users[user]

# Strategy:  Create a new collection
active_users = {}
for user, status in users.items():
    if status == 'active':
        active_users[user] = status
```

3. If you do need to iterate over a sequence of numbers, the built-in function `range()` comes in handy. To iterate over the indices of a sequence, you can combine `range()` and `len()` or use the `enumerate()` function.

4. We say such an object is **iterable**, that is, suitable as a target for functions and constructs that expect something from which they can obtain successive items until the supply is exhausted.

5. Get a list from a range:
```
>>> list(range(4))
[0, 1, 2, 3]
```
