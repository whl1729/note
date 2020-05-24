# JavaScript Modules

## 7 Arrays

### What is an array?

1. We can also mix data types in a single array — we do not have to limit ourselves to storing only numbers in one array, and in another only strings.（Question: js 数组元素可以是不同类型的，那么它是如何给数组分配内存的？）

### Some useful array methods

1. `split()` method takes a single parameter, the character you want to separate the string at, and returns the substrings between the separator as items in an array.

2. `join()` converts an array to a string with the separator you specified, while `toString()` always uses a comma.

3. `unshift()` and `shift()` work in exactly the same way as push() and pop(), respectively, except that they work on the beginning of the array, not the end.

4. `push()` allows you to add **one or more items** to the end of your array.

5. Use regular expressions to modify string:
```
let text = 'I am the biggest lover, I love my love';
text.replace(/love/g,'like');  // this will replace all instances of 'love' to 'like'.
```
