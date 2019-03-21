# 《C++ Primer》第11章学习笔记

## Associative Containers

1. Associative and sequential containers differ from one another in a fundamental way:
    - Elements in an associative container are stored and retrieved by a key. 
    - Elements in a sequential container are stored and accessed sequentially by their position in the container.

2. map vs set
    - The elements in a map are key–value pairs: The key serves as an index into the map, and the value represents the data associated with that index. 
    - A set element contains only a key; a set supports efficient queries as to whether a given key is present.
    - The library provides eight associative containers, These eight differ along three dimensions: Each container is 
        - (1) a set or a map, 
        - (2) requires unique keys or allows multiple keys, 
        - (3) stores the elements in order or not.

3. Associative Container Type
    - map, multimap, unordered_map, unordered_multimap
    - set, multiset, unordered_set, unordered_multiset

4. A set is most useful when we simply want to know whether a value is present.

### Overview of the Associative Containers

1. We wrap each key–value pair inside curly braces `{key, value}` to indicate that the items together form one element in the map.

2. For the ordered containers—map, multimap, set, and multiset—the key type must define a way to compare the elements. By default, the library uses the < operator for the key type to compare the keys. 

3. We can supply our own operation to use in place of the < operator on keys. The specified operation must define a strict weak ordering over the key type. We can think of a strict weak ordering as “less than,” although our function might use a more complicated procedure.

4. The type of the operation that a container uses to organize its elements is part of the type of that container. To specify our own operation, we must supply the type of that operation when we define the type of an associative container. The operation type is specified following the element type inside the angle brackets that we use to say which type of container we are defining. For example: `multiset<Sales_data, decltype(compareIsbn)*> bookstore(compareIsbn);`

5. Operations on pairs
```
pair<T1, T2> p;
pair<T1, T2> p(v1, v2);
pair<T1, T2> p = {v1, v2};
make_pair(v1, v2);
p.first
p.second
p1 relop p2
p1 == p2
p1 != p2
```

6. Unlike other library types, the data members of pair are public. These members are named first and second, respectively.

### Operations on Associative Containers

1. Associative Container Additional Type Aliases
```
key_type
mapped_type
value_type  // For maps, pair<const key_type, mapped_type>
```

2. When we dereference an iterator, we get a reference to a value of the container’s value_type. In the case of map, the value_type is a pair in which first holds the const key and second holds the value.

3. Note: It is essential to remember that the value_type of a map is a pair and that we can change the value but not the key member of that pair.

4. When we use an iterator to traverse a map, multimap, set, or multiset, the iterators yield elements in ascending key order.

5. Four ways to add elements to a map
```
word_count.insert({word, 1});
word_count.insert(make_pair(word, 1));
word_count.insert(pair<string, size_t>(word, 1));
word_count.insert(map<string, size_t>::value_type(word, 1));
```

6. Associative Container insert Operations
```
c.insert(v)  // For map and set, returns pair<iter, bool>; For multi, returns iter
c.emplace(args) 
c.insert(b, e)  // returns void
c.insert(il)
c.insert(p, v)  // returns iter
c.emplace(p, args)
```

7. Removing Elements from an Associative Container
```
c.erase(k)  // Removes every element with key k from c. Returns a cout of how many elements were removed.
c.erase(p)  // Removes the element denoted by the iterator p from c. p must not be equal to c.end()
c.erase(b, e)
```

8. Subscripting a map
    - map and unordered_map support the subscript operator and at function
    - set don't support subscripting because there is no "value" associated with a key in a set.
    - We cannot subscript a multimap or an unordered_multimap because there may be more than one value associated with a given key.

9. Subscript Operation for map and unordered_map
```
c[k]  // Returns the element with key k; if k is not in c, adds a new, value-initialized element with key k.
c.at(k)  // Checked access to the element with key k; throws an out_of_range exception if k is not in c.
```

10. Note: Subscripting a map behaves quite differently from subscripting an array or vector: Using a key that is not already present adds an element with that key to the map.

11. Note: Unlike vector or string, the type returned by the map subscript operator differs from the type obtained by dereferencing a map iterator. When we subscript a map, we get a mapped_type object; when we dereference a map iterator, we get a value_type object.

12. Operations to Find Elements in an Associative Container
```
c.find(k)
c.count(k)
c.lower_bound(k)
c.upper_bound(k)
c.equal_range(k)  // Returns a pair of iterators denoting the elements with key k
```

13. If we want to know if an element with a given key is present without changing the map, we should use find instead of subscript.

14. When a multimap or multiset has multiple elements of a given key, those elements will be adjacent within the container.

15. Three ways to Find Elements in a multimap or multiset
    - find and count
    - lower_bound and upper_bound.
    - equal_range

16. Note: The iterator returned from lower_bound may or may not refer to an element with the given key. If the key is not in the container, then lower_bound refers to the first point at which this key can be inserted while preserving the element order within the container.

### The Unordered Containers

1. Use an unordered container if the key type is inherently unordered or if performance testing reveals problems that hashing might solve.

2. Because the elements are not stored in order, the output of a program that uses an unordered container will (ordinarily) differ from the same program using an ordered container.

3. The unordered containers are organized as a collection of buckets, each of which holds zero or more elements. These containers use a hash function to map elements to buckets. The performance of an unordered container depends on the quality of its hash function and on the number and size of its buckets.

4. Unordered Container Management Operations
```
// Bucket Interface
c.bucket_count()
c.max_bucket_count()
c.bucket_size(n)
c.bucket(k)
// Bucket Iteration
local_iterator
const_local_iterator
c.begin(n), c.end(n)
c.cbegin(n), c.cend(n)
// Hash Policy
c.load_factor()
c.max_load_factor()
c.rehash(n)
c.reserve(n)
```

5. Requirements on Key Type for Unordered Containers
    - We can directly define unordered containers whose key is one of the built-in types (including pointer types), or a string, or a smart pointer.
    - We cannot directly define an unordered container that uses a our own class types for its key type. Unlike the containers, we cannot use the hash template directly. Instead, we must supply our own version of the hash template.
    - To use Sales_data as the key, we’ll need to supply functions to replace both the == operator and to calculate a hash code.
