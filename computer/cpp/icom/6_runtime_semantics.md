# 《Inside the C++ Object Model》第6章学习笔记

## 6 Runtime Semantics

1. This is one of the hard things about C++: the difficulty of knowing the complexity of an expression simply by inspecting the source code.

### Object Construction and Destruction

1. When there are multiple exits from a block or function. The destructor must be placed at each exit point at which the object is "alive".

2. In general, place an object as close as possible to the code segment actually using it. Doing this can save you unnecessary object creation and destruction.

3.  A global object with an associated constructor and destructor is said to require both static initialization and deallocation.

4. All globally visible objects in C++ are placed within the program data segment. If an explicit initial value is specified, the object is initialized with that value; otherwise, the memory associated with the object is initialized to 0. 

5. Although the class object can be placed within the data segment during compilation with its memory zeroed out, its constructor cannot be applied until program startup. The need to evaluate an initialization expression for an object stored within the program's data segment is what is meant by an object's requiring static initialization.（疑问：未完全看懂？）

6. The System V Executable and Linking Format (ELF) was extended to provide .init and .fini sections that contain information on the objects requiring, respectively, static initialization and deallocation. Implementation-specific startup routines (usually named something like crt0.o) complete the platformspecific support for static initialization and deallocation.

7. There are a number of drawbacks to using statically initialized objects. 
    - If exception handling is supported, these objects cannot be placed within try blocks. This can be particularly unsatisfactory with statically invoked constructors because any throw will by necessity trigger the default terminate() function within the exception handling library. 
    - Another drawback is the complexity involved in controlling order dependency of objects that require static initialization across modules. 
    
8. I recommend your not using global objects that require static initialization. Actually, I recommend your not using global objects at all 

9. A temporary was introduced to guard mat_identity's initialization. On the first pass through identity(), the temporary evaluated as false. Then the constructor was invoked, and the temporary was set to true. This solved the construction problem. On the reverse end, the destructor needed to be conditionally applied to mat_identity, but only if mat_identity had been constructed. Determining whether it had was simple: If the guard was true, it had been constructed.
```
const Matrix& identity() {
    static Matrix mat_identity;
    // ...
    return mat_identity;
}
```

### Operators new and delete

1. The general library implementation of operator new is relatively straightforward, although there are two subtleties worth examining. (Note: The following version does not account for exception handling.)
```
extern void * operator new( size_t size )
{
    if ( size == 0 )
        size = 1;
    void *last_alloc;
    while ( !( last_alloc = malloc( size )))
    {
        if ( _new_handler )
            ( *_new_handler )();
        else return 0;
    }
    return last_alloc;
}
```

2. Operator new in practice has always been implemented in terms of the standard C malloc(), although there is no requirement to do so (and therefore one should not presume it will always be done). Similarly, operator delete has, in practice, always been implemented in terms of the standard C free().

3. The compiler searches for a dimension size only if the bracket is present. Otherwise, it assumes a single object is being deleted. If the programmer fails to provide the necessary bracket, such as `delete p_array;` then only the first element of the array is destructed. The remaining elements are undestructed, although their associated memory is reclaimed. 

### Temporary Objects

1. The assignment statement `c = a + b;` cannot safely eliminate the temporary.

2. The call to `printf( "%s\n", s + t );` could not be proved to be generally safe, since its correctness depended on when the temporary associated with s + t was destroyed.

3. Temporary objects are destroyed as the last step in evaluating the full-expression that (lexically) contains the point where they were created. (Note: A full-expression is the outermost containing ex-pression.)
