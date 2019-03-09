# 《C++ Primer》第3章学习笔记

## 3 Strings, Vectors, and Arrays

### Strings
1. namespace using
    - A using declaration lets us use a name from a namespace without qualifying the name with a namespace_name:: prefix. A using declaration has the form: `using namespace::name;`
    - There must be a using declaration for each name we use, and each declaration must end in a semicolon
    - Headers Should Not Include using Declarations. The reason is that the contents of a header are copied into the including program’s text. If a header has a using declaration, then every program that includes that header gets that same using declaration. As a result, a program that didn’t intend to use the specified library name might encounter unexpected name conflicts.

2. copy initialization vs direct initialization
    - When we initialize a variable using =, we are asking the compiler to copy initialize the object by copying the initializer on the right-hand side into the object being created. Otherwise, when we omit the =, we use direct initialization.
    - When we have a single initializer, we can use either the direct or copy form of initialization. When we initialize a variable from more than one value, such as in the initialization of s4 above, we must use the direct form of initialization.
```
string s5 = "hiya";  // copy initialization
string s6("hiya");   // direct initialization
string s7(10, 'c');  // direct initialization; s7 is cccccccccc
```

3. Ways to Initialize a string
```
string s1;  // Default initialization; s1 is the empty string
string s2(s1);  // s2 is a copy of s1.
string s2 = s1; // Equivalent to s2(s1), s2 is a copy of s1.
string s3("value");   // s3 is a copy of the string literal, not including the null
string s3 = "value";  // Equivalent to s3("value"), s3 is a copy of the string literal.
string s4(n, 'c');  // Initialize s4 with n copies of the character 'c'
```

4. string operations
    - The string input operator `is >> s` reads and discards any leading whitespace (e.g., spaces, newlines, tabs). It then reads characters until the next whitespace character is encountered.
    - `getline(is, s)` reads the given stream up to and including the first newline and stores what it read—not including the newline—in its string argument. After getline sees a newline, even if it is the first character in the input, it stops reading and returns. If the first character in the input is a newline, then the resulting string is the empty string.
    - `s.empty()` returns true if s is empty, otherwise returns false.
    - `s.size()` returns the number of characters in s.

5. string::size_type
    - one of companion types, makes it possible to use the library types in a machineindependent manner. 
    - is an unsigned type big enough to hold the size of any string. Any variable used to store the result from the string size operation should be of type string::size_type.
    - you can use auto instead of typing `string::size_type`
    - Because size returns an unsigned type, it is essential to remember that expressions that mix signed and unsigned data can have surprising results. You can avoid problems due to conversion between unsigned and int by not using ints in expressions that use size().
    - When we mix strings and string or character literals, at least one operand to each + operator must be of string type

6. Adding Literals and strings
    - When we mix strings and string or character literals, at least one operand to each + operator must be of string type
    ```
    string s4 = s1 + ", "; // ok: adding a string and a literal
    string s5 = "hello" + ", "; // error: no string operand
    string s6 = s1 + ", " + "world"; // ok: each + has a string operand
    string s7 = "hello" + ", " + s2; // error: can't add string literals
    ```
    - For historical reasons, and for compatibility with C, string literals are not standard library strings. It is important to remember that these types differ when you use string literals and library strings.

7. Advice: Ordinarily, C++ programs should use the cname versions of headers and not the name .h versions. That way names from the standard library are consistently found in the std namespace. Note that the names defined in the cname headers are defined inside the std namespace, whereas those defined in the .h versions are not. 

8. dealing with the characters in a string
    - use the range for statement: `for (auto c : str)`
    - If we want to change the value of the characters in a string, we must define the loop variable as a reference type : `for (auto &c: str)`
    - There are two ways to access individual characters in a string: We can use a subscript or an iterator.
    - The values we use to subscript a string must be >= 0 and < size(). The result of using an index outside this range is undefined. By implication, subscripting an empty string is undefined.
    - One way to simplify code that uses subscripts is always to use a variable of type string::size_type as the subscript. Because that type is unsigned, we need to check only that our subscript is less than value returned by size()

### Vectors

1. vectors as a class template
    - A vector is a class template. C++ has both class and function templates. 
    - Instantiation: Templates are not themselves functions or classes. Instead, they can be thought of as instructions to the compiler for generating classes or functions. The process that the compiler uses to create classes or functions from templates is called instantiation.
    - vector is a template, not a type. Types generated from vector must include the element type, for example, vector<int>.
    - Because references are not objects, we cannot have a vector of references.
    - Some compilers may require the old-style declarations for a vector of vectors, for example, vector<vector<int> >.

2. restrictions of the forms of initialization
    - when we use the copy initialization form (i.e., when we use =) , we can supply only a single initializer
    - when we supply an in-class initializer, we must either use copy initialization or use curly braces.
    - we can supply a list of element values only by using list initialization in which the initializers are enclosed in curly braces. We cannot supply a list of initializers using parentheses.
```
string s7(10, 'c'); // direct initialization; s7 is cccccccccc
string s7 = String(10, 'c');     // ok
string s7 = (10, 'c'); // error  // error
vector<string> v1{"a", "an", "the"}; // list initialization
vector<string> v2("a", "an", "the"); // error
```

3. ways to initialize a vector
```
vectors<T> v1;  // default initialization; v1 is empty
vector<T> v2(v1);  // v2 has a copy of each element in v1.
vector<T> v2 = v1; // Equivalent to v2(v1), v2 is a copy of the elements in v1
vector<T> v3(n, val);  // v3 has n elements with value val.
vector<T> v4(n);  // v4 has n copies of a valie-initialized object.
vector<T> v5{a, b, c ...}  // v5 has as many elements as there are initializers; elements are initialized by corresponding initializers.
vector<T> v5 = {a, b, c ...};  // Equivalent to v5{a, b, c ...}.
```

4. curly braces or parentheses
    - In a few cases, what initialization means depends upon whether we use curly braces or parentheses to pass the initializer(s). 
    ```
    vector<int> v1(10); // v1 has ten elements with value 0
    vector<int> v2{10}; // v2 has one element with value 10
    vector<int> v3(10, 1); // v3 has ten elements with value 1
    vector<int> v4{10, 1}; // v4 has two elements with values 10 and 1
    ```
    - When we use parentheses, we are saying that the values we supply are to be used to construct the object.
    - When we use curly braces, {...}, we’re saying that, if possible, we want to list initialize the object. That is, if there is a way to use the values inside the curly braces as a list of element initializers, the class will do so. Only if it is not possible to list initialize the object will those values be used to construct the object. 
    ```
    vector<string> v5{"hi"}; // list initialization: v5 has one element
    vector<string> v6("hi"); // error: can't construct a vector from a string literal
    vector<string> v7{10}; // v7 has ten default-initialized elements
    vector<string> v8{10, "hi"}; // v8 has ten elements with value "hi"
    ```

5.  Because vectors grow efficiently, it is often unnecessary—and can result in poorer performance—to define a vector of a specific size. The exception to this rule is if all the elements actually need the same value. If differing element values are needed, it is usually more efficient to define an empty vector and add elements as the values we need become known at run time. 

6. we cannot use a range for if the body of the loop adds elements to the vector. Warning: The body of a range for must not change the size of the sequence over which it is iterating.

7. To use size_type, we must name the type in which it is defined. A vector type always includes its element type.
```
vector<int>::size_type // ok
vector::size_type      // error
```

8. We can compare two vectors only if we can compare the elements in those vectors.

9. Advice: A good way to ensure that subscripts are in range is to avoid subscripting altogether by using a range for whenever possible.

### Iterators

1. All of the library containers have iterators, but only a few of them support the subscript operator. Technically speaking, a string is not a container type, but string supports many of the container operations. As we’ve seen string, like vector has a subscript operator. Like vectors, strings also have iterators.

2.  A valid iterator either denotes an element or denotes a position one past the last element in a container. All other iterator values are invalid.

3. If the container is empty, the iterators returned by begin and end are equal — they are both off-the-end iterators.

4. Because the iterator returned from end does not denote an element, it may not be incremented or dereferenced.

5. Key Concept: Generic Programming
    - Programmers coming to C++ from C or Java might be surprised that we used != rather than < in our for loops. C++ programmers use != as a matter of habit. They do so for the same reason that they use iterators rather than subscripts: This coding style applies equally well to various kinds of containers provided by the library. 
    - As we’ve seen, only a few library types, vector and string being among them, have the subscript operator. Similarly, all of the library containers have iterators that define the == and != operators. Most of those iterators do not have the < operator. By routinely using iterators and !=, we don’t have to worry about the precise type of container we’re processing.

6. iterator types
    - iterator and const_iterator
    ```
    vector<int>::iterator it; // it can read and write vector<int> elements
    string::iterator it2; // it2 can read and write characters in a string
    vector<int>::const_iterator it3; // it3 can read but not write elements
    string::const_iterator it4; // it4 can read but not write characters
    ```
    - If a vector or string is const, we may use only its const_iterator type. With a nonconst vector or string, we can use either iterator or const_iterator.
    - The type returned by begin and end depends on whether the object on which they operator is const. If the object is const, then begin and end return a const_iterator; if the object is not const, they return iterator.
    - To let us ask specifically for the const_iterator type, the new standard introduced two new functions named cbegin and cend.

7. Combining Dereference and Member Access
    - When we dereference an iterator, we get the object that the iterator denotes.
    - Assuming it is an iterator into this vector, we can check whether the string that it denotes is empty as follows: `(\*it).empty()`. Note that the parentheses in (\*it).empty() are necessary, because 成员选择运算符优先级高于取址运算符。
    - To simplify expressions such as this one, the language defines the arrow operator (the -> operator). The arrow operator combines dereference and member access into a single operation. That is, it->mem is a synonym for (\* it).mem.

8. Any operation, such as push_back, that changes the size of a vector potentially invalidates all iterators into that vector. 

### Initializers

1. List Initialization:  
    - use curly braces for initialization
    - Braced lists of initializers can now be used whenever we initialize an object and in some cases when we assign a new value to an object.
    - The compiler will not let us list initialize variables of built-in type if the initializer might lead to the loss of information.

2. Default Initialization:
    - When we define a variable without an initializer, the variable is default initialized. Such variables are given the “default” value. What that default value is depends on the type of the variable and may also depend on where the variable is defined. 
    - The value of an object of built-in type that is not explicitly initialized depends on where it is defined. Variables defined outside any function body are initialized to zero. With one exception, variables of built-in type defined inside a function are uninitialized. The value of an uninitialized variable of built-in type is undefined.

3. Value Initialization: 
    - We can usually omit the value and supply only a size. In this case the library creates a value-initialized element initializer for us. This library-generated value is used to initialize each element in the container. The value of the element initializer depends on the type of the elements stored in the vector. 
    - If the vector holds elements of a built-in type, such as int, then the element initializer has a value of 0. If the elements are of a class type, such as string, then the element initializer is itself default initialized.

### Arrays

1. Explicitly Initializing Array Elements 
    - If we omit the dimension, the compiler infers it from the number of initializers. 
    - If the dimension is greater than the number of initializers, the initializers are used for the first elements and any remaining elements are value initialized.
```
int a1[5] = {0, 1, 2};  // a1[] = {0, 1, 2, 0, 0}
int a2[5];  // the elements in a2 are undefined.
int a3[5] = {};  // a3[] = {0, 0, 0, 0, 0}
```

2. Character Arrays Are Special: 
    - Character arrays have an additional form of initialization: We can initialize such arrays from a string literal.
    - When we use this form of initialization, it is important to remember that string literals end with a null character. That null character is copied into the array along with the characters in the literal.

3. Understanding complicated array declarations
    - By default, type modifiers bind right to left. 
    - If there are parentheses, start by observing the things inside the parentheses.
    - It can be easier to understand array declarations by starting with the array’s name and reading them from the inside out.

4. When we use a variable to subscript an array, we normally should define that variable to have type size_t. size_t is a machine-specific unsigned type that is guaranteed to be large enough to hold the size of any object in memory. The size_t type is defined in the cstddef header.  

5. In most expressions, when we use an object of array type, we are really using a pointer to the first element in that array.

6. Using auto and decltype to deduce array's type
```
int ia[] = {0,1,2,3,4,5,6,7,8,9}; // ia is an array of ten ints
auto ia2(ia); // ia2 is an int* that points to the first element in ia
decltype(ia) ia3 = {0,1,2,3,4,5,6,7,8,9};  // ia3 is an array of ten ints
ia3 = p; // error: can't assign an int* to an array
```

7.  To make it easier and safer to use pointers, the new library includes two functions, named begin and end. However, arrays are not class types, so these functions are not member functions. Instead, they take an argument that is an array: begin returns a pointer to the first, and end returns a pointer one past the last element in the given array. These functions are defined in the iterator header.
```
int ia[] = {0,1,2,3,4,5,6,7,8,9}; // ia is an array of ten ints
int *beg = begin(ia); // pointer to the first element in ia
int *last = end(ia); // pointer one past the last element in ia
```

8. Unlike subscripts for vector and string, the index of the built-in subscript operator is not an unsigned type.
```
int *p = &ia[2]; // p points to the element indexed by 2
int j = p[1]; // p[1] is equivalent to *(p + 1),
// p[1] is the same element as ia[3]
int k = p[-2]; // p[-2] is the same element as ia[0]
```

9. For most applications, in addition to being safer, it is also more efficient to use library strings rather than C-style strings.

10. Mixing Library strings and C-Style Strings
    - we can use a null-terminated character array anywhere that we can use a string literal:
        - We can use a null-terminated character array to initialize or assign a string.
        - We can use a null-terminated character array as one operand (but not both
operands) to the string addition operator or as the right-hand operand in the
string compound assignment (+=) operator.
    - The reverse functionality is not provided: There is no direct way to use a library string when a C-style string is required. For example, there is no way to initialize a character pointer from a string. There is, however, a string member function named c_str that we can often use to accomplish what we want:
    ```
    char *str = s; // error: can't initialize a char* from a string
    const char *str = s.c_str(); // ok
    ```
    - If a program needs continuing access to the contents of the array returned by str(), the program must copy the array returned by c_str.

11. We can use an array to initialize a vector. To do so, we specify the address of the first element and one past the last element that we wish to copy:
```
int int_arr[] = {0, 1, 2, 3, 4, 5};
// ivec has six elements; each is a copy of the corresponding element in int_arr
vector<int> ivec(begin(int_arr), end(int_arr));
```

12. Advice: Use Library Types Instead of Arrays. Modern C++ programs should use vectors and iterators instead of built-in arrays and pointers, and use strings rather than C-style array-based character strings.

13. To use a multidimensional array in a range for, the loop control variable for all but the innermost array must be references.
```
for (const auto &row : ia) // for every element in the outer array
    for (auto col : row) // for every element in the inner array
        cout << col << endl;
```

### Questions  

1. Iterator是如何实现的？

