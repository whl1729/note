# The Rust Programming Language

## 8 Common Collections

1. Unlike the built-in array and tuple types, the data these collections point to is stored on the heap, which means the amount of data does not need to be known at compile time and can grow or shrink as the program runs.

### 8.1 Storing Lists of Values with Vectors

1. We don't need the type annotation if Rust can infers it from the data.
    - [Solved] Q: So the Rust compiler will be more complicated ?
    - A: Yes.
```
let mut v = Vec::new();
v.push(5);
```

2. Like any other struct, a vector is freed when it goes out of scope.

3. Two ways to reference an element of a vector:
```
let v = vec![1, 2, 3, 4, 5];

let does_not_exist = &v[100];  // panic
let does_not_exist = v.get(100);  // doesn't panic
```

4. Why should a reference to the first element care about what changes at the end of the vector? This error is due to the way vectors work: adding a new element onto the end of the vector might require allocating new memory and copying the old elements to the new space, if there isn’t enough room to put all the elements next to each other where the vector currently is. In that case, the reference to the first element would be pointing to deallocated memory. The borrowing rules prevent programs from ending up in that situation.

5. When we need to store elements of a different type in a vector, we can define and use an enum.

### 8.2 Storing UTF-8 Encoded Text with Strings

1. String vs str
    - Rust has only one string type in the core language, which is the string slice str that is usually seen in its borrowed form &str. (String slices are references to some UTF-8 encoded string data stored elsewhere.)
    - The String type, which is provided by Rust’s standard library rather than coded into the core language, is a growable, mutable, owned, UTF-8 encoded string type.

2. UTF-8 (8-bit Unicode Transformation Format) is a variable width character encoding capable of encoding all 1,112,064 valid code points in Unicode using **one to four** one-byte (8-bit) code units.

3. Concatenation with the + Operator
```
let s1 = String::from("Hello, ");
let s2 = String::from("world!");
let s3 = s1 + &s2; // note s1 has been moved here and can no longer be used
```

4. Rust strings don’t support indexing. But why not?
    - An index into the string’s bytes will not always correlate to a valid Unicode scalar value.
    - Indexing operations are expected to always take constant time (O(1)). But it isn’t possible to guarantee that performance with a String, because Rust would have to walk through the contents from the beginning to the index to determine how many valid characters there were.
    - Indexing into a string is often a bad idea because it’s not clear what the return type of the string-indexing operation should be: a byte value, a character, a grapheme cluster, or a string slice.

5. There are actually three relevant ways to look at strings from Rust’s perspective: as bytes, scalar values, and grapheme clusters (the closest thing to what we would call letters).

6. Rust has chosen to make the correct handling of String data the default behavior for all Rust programs, which means programmers have to put more thought into handling UTF-8 data upfront. This trade-off exposes more of the complexity of strings than is apparent in other programming languages, but it prevents you from having to handle errors involving non-ASCII characters later in your development life cycle.

### 8.3 Storing Keys with Associated Values in Hash Maps

1. Note that we need to first use the HashMap from the collections portion of the standard library. Of our three common collections, this one is the least often used, so it’s not included in the features brought into scope automatically in the prelude. Hash maps also have less support from the standard library; there’s no built-in macro to construct them, for example.

2. If we insert references to values into the hash map, the values won’t be moved into the hash map. The values that the references point to must be valid for at least as long as the hash map is valid.

3. By default, HashMap uses a “cryptographically strong”1 hashing function that can provide resistance to Denial of Service (DoS) attacks. This is not the fastest hashing algorithm available, but the trade-off for better security that comes with the drop in performance is worth it. If you profile your code and find that the default hash function is too slow for your purposes, you can switch to another function by specifying a different hasher. A hasher is a type that implements the BuildHasher trait.
