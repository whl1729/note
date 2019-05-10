# 《Inside the C++ Object Model》第7章读书笔记

## 7 On the Cusp of the Object Model

### Templates

1. There are three primary aspects of template support: 
    - Processing of the template declarations—essentially, what happens when you declare a template class, template class member function, and so on.
    - Instantiation of the class object and inline nonmember and member template functions. These are instances required within each compilation unit.
    - Instantiation of the nonmember and member template functions and static template class members. These are instances required only once within an executable. This is where the problems with templates generally arise.

2. I use instantiation to mean the process of binding actual types and expressions to the associated formal parameters of the template.

3. Standard C++ requires that member functions be instantiated only if they are used (current implementations do not strictly follow this requirement). There are two main reasons for the use-directed instantiation rule:
    - Space and time efficiency. If there are a hundred member functions associated with a class, but your program uses only two for one type and five for a second type, then instantiating the additional 193 can be a significant time and space hit.
    - Unimplemented functionality. Not all types with which a template is instantiated support all the operators (such as i/o and the relational operators) required by the complete set of member functions. By instantiating only those member functions actually used, a template is able to support types that otherwise would generate compile-time errors.

4. All type-dependent checking involving the template parameters must be deferred until an actual instantiation occurs.

5. In current implementation, a template declaration has only limited error checking applied to it prior to an instantiation of an actual set of parameters. 

6. Nonmember and member template functions are also not fully type-checked until instantiated. In current implementations, this leads to error-free compilations of some rather blatantly incorrect template declarations.

7. The program site of the resolution of a nonmember name within a template is determined by whether the use of the name is dependent on the parameter types used to instantiate the template. If the use is not dependent, then the scope of the template declaration determines the resolution of the name. If the use is dependent, then the scope of the template instantiation determines the resolution of the name.

8. An implementation must keep the following two scope contexts. And the compiler's resolution algorithm must determine which is the appropriate scope within which to search for the name.
    - The scope of the template declaration, which is fixed to the generic template class representation
    - The scope of the template instantiation, which is fixed to the representation of the particular instance 

### Exception Handling

1. The primary implementation task in supporting exception handling (EH) is to discover the appropriate catch clause to handle the thrown exception. 
    - This requires an implementation to somehow keep track of the active area of each function on the program stack (including keeping track of the local class objects active at that point in the function). 
    - Also, the implementation must provide some method of querying the exception object as to its actual type (this leads directly to some form of runtime type identification (RTTI)). 
    - Finally, there needs to be some mechanism for the management of the object thrown—its creation, storage, possible destruction (if it has an associated destructor), clean up, and general access. (There also may be multiple objects active at one time.) In general, the EH mechanism requires a tightly coupled handshake between compiler-generated data structures and a runtime exception library.

2. When an exception is thrown, control passes up the function call sequence until either an appropriate catch clause is matched or main() is reached without a handler's being found, at which point the default handler, terminate(), is invoked. As control passes up the call sequence, each function in turn is popped from the program stack (this process is called unwinding the stack). Prior to the popping of each function, the destructors of the function's local class objects are invoked.

3. When an exception is thrown, the compilation system must do the following:
    - Examine the function in which the throw occurred.
    - Determine if the throw occurred in a try block.
    - If so, then the compilation system must compare the type of the exception against the type of each catch clause.
    - If the types match, control must pass to the body of the catch clause.
    - If either it is not within a try block or none of the catch clauses match, then the system must 
        - (a) destruct any active local objects, 
        - (b) unwind the current function from the stack, and 
        - (c) go to the next active function on the stack and repeat items 2-5.

4. For each throw expression, the compiler must create a type descriptor encoding the type of the exception. If the type is a derived type, the encoding must include information on all of its base class types.

5. The type descriptor is necessary because the actual exception is handled at runtime when the object itself otherwise has no type information associated with it. RTTI is a necessary side effect of support for EH.

6. The compiler must also generate a type descriptor for each catch clause. The runtime exception handler compares the type descriptor of the object thrown with that of each catch clause's type descriptor until either a match is found or the stack has been unwound and terminate() invoked.

7. An exception table is generated for each function. It describes the regions associated with the function, the location of any necessary cleanup code (invocation of local class object destructors), and the location of catch clauses if a region is within an active try block.

8. When an exception is thrown, the exception object is created and placed generally on some form of exception data stack. Propagated from the throw site to each catch clause are the address of the exception object, the type descriptor (or the address of a function that returns the type descriptor object associated with the exception type), and possibly the address of the destructor for the exception object, if one if defined.

### Runtime Type Identification

1. Downcast means casting a base class down its inheritance hierarchy, thus forcing it into one of its more specialized derived classes. 

2. The C++ RTTI mechanism provides a type-safe downcast facility but only for those types exhibiting polymorphism (those that make use of inheritance and dynamic binding).

3. By our placing the address of the class-specific RTTI object within the virtual table (usually in the first slot), the additional overhead is reduced to one pointer per class (plus the type information object itself) rather than one pointer per class object. In addition, the pointer need be set only once. Also, it can be set statically by the compiler, rather than during runtime within the class construction as is done with the vptr.

4. type_info is the name of the class defined by the Standard to hold the required runtime type information. The first slot of the virtual table contains the address of the type_info object associated with the class type.

5. The Standard defines the type_info class as follows:
```
class type_info {
public:
    virtual ~type_info();
    bool operator==( const type_info& ) const;
    bool operator!=( const type_info& ) const;
    bool before( const type_info& ) const;
    const char* name() const;
private:
    // prevent memberwise init and copy
    type_info( const type_info& );
    type_info& operator=( const type_info& );
    // data members
};
```

### Efficient, but Inflexible?

1. There are certain domain areas — such as dynamically shared libraries, shared memory, and distributed objects — in which the C++ object model has proved somewhat inflexible. 

2. Ideally, a new release of a dynamically linked shared library should just "drop in." That is, the next time an application is run, it transparently picks up the new library version. The library release is noninvasive in that the application does not need to be rebuilt. 

3. This noninvasive drop-in model breaks under the C++ Object Model if the data layout of a class object changes in the new library version. This is because the size of the class and the offset location of each of its direct and inherited members is fixed at compile time (except for virtually inherited members). This results in efficient but inflexible binaries; a change in the object layout requires recompilation. 

4. When a shared library is dynamically loaded, its placement in memory is handled by a runtime linker and generally is of no concern to the executing process. This is not true, however, under the C++ Object Model when a class object supported by a dynamically shared library and containing virtual functions is placed in shared memory. The problem is not with the process that is placing the object in shared memory but with a second or any subsequent process wanting to attach to and invoke a virtual function through the shared object. Unless the dynamic shared library is loaded at exactly the same memory location as the process that loaded the shared object, the virtual function invocation fails badly. The likely result is either a segment fault or bus error. The problem is caused by the hardcoding within the virtual table of each virtual function. The current solution is program-based. It is the programmer who must guarantee placement of the shared libraries across processes at the same locations.
