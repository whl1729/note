# 《C++ Primer》第13章读书笔记

## 13 Copy Control

1. When we define a class, we specify—explicitly or implicitly—what happens when objects of that class type are copied, moved, assigned, and destroyed. A class controls these operations by defining five special member functions: copy constructor, copyassignment operator, move constructor, move-assignment operator, and destructor.

### Copy, Assign and Destroy

1. If a class does not define all of the copy-control members, the compiler automatically defines the missing operations. As a result, many classes can ignore copy control. However, for some classes, relying on the default definitions leads to disaster. Frequently, the hardest part of implementing copy-control operations is recognizing when we need to define them in the first place.

2. The Synthesized Copy Constructor
    - When we do not define a copy constructor for a class, the compiler synthesizes one for us. Unlike the synthesized default constructor, a copy constructor is synthesized even if we define other constructors.
    - The synthesized copy constructor for some classes prevents us from copying objects of that class type. Otherwise, the synthesized copy constructor memberwise copies the members of its argument into the object being created 
    - Members of class type are copied by the copy constructor for that class; members of built-in type are copied directly. Although we cannot directly copy an array, the synthesized copy constructor copies members of array type by copying each element.

3. ***direct initialization vs copy initialization***
    - When we use direct initialization, we are asking the compiler to use ordinary function matching to select the constructor that best matches the arguments we provide. 
    - When we use copy initialization, we are asking the compiler to copy the right-hand operand into the object being created, converting that operand if necessary

> can't understand ?

4. Copy initialization ordinarily uses the copy constructor. However, if a class has a move constructor, then copy initialization sometimes uses the move constructor instead of the copy constructor. 

5. Copy initialization happens not only when we define variables using an =, but also when we
    - Pass an object as an argument to a parameter of nonreference type
    - Return an object from a function that has a nonreference return type
    - Brace initialize the elements in an array or the members of an aggregate class

6. whether we use copy or direct initialization matters if we use an initializer that requires conversion by an explicit constructor.

7. During copy initialization, the compiler is permitted (but not obligated) to skip the copy/move constructor and create the object directly. 

8. The compiler call copy constructor when we difine variables using an =, but not when we reset variables using an =.
```
Point *heap = new Point(global); // here we call copy constructor
*heap = local;   // don't call copy constructor since *heap has been constructed
```

9. Copy-Assignment Operator
    - As with the copy constructor, the compiler synthesizes a copy-assignment operator if the class does not define its own.
    - Assignment operators ordinarily should return a reference to their left-hand operand.
    - Analogously to the copy constructor, for some classes the synthesized copy-assignment operator disallows assignment. Otherwise, it assigns each nonstatic member of the right-hand object to the corresponding member of the left-hand object using the copy-assignment operator for the type of that member. 
    - Array members are assigned by assigning each element of the array. The synthesized copy-assignment operator returns a reference to its left-hand object.

10. Destructor: The destructor is a member function with the name of the class prefixed by a tilde (~). It has no return value and takes no parameters: Because it takes no parameters, it cannot be overloaded. There is always only one destructor for a given class.

11. What a Destructor Does
    - In a destructor, the function body is executed first and then the members are destroyed. Members are destroyed in reverse order from the order in which they were initialized.
    - What happens when a member is destroyed depends on the type of the member. Members of class type are destroyed by running the member’s own destructor. The built-in types do not have destructors, so nothing is done to destroy members of built-in type. 
    - The implicit destruction of a member of built-in pointer type does not delete the object to which that pointer points. 
    - Unlike ordinary pointers, the smart pointers are class types and have destructors. As a result, unlike ordinary pointers, members that are smart pointers are automatically destroyed during the destruction phase.

12. When a Destructor Is Called
    - Variables are destroyed when they go out of scope.
    - Members of an object are destroyed when the object of which they are a part is destroyed.
    - Elements in a container—whether a library container or an array—are destroyed when the container is destroyed.
    - Dynamically allocated objects are destroyed when the delete operator is applied to a pointer to the object (§ 12.1.2, p. 460).
    - Temporary objects are destroyed at the end of the full expression in which the temporary was created
    - Note: The destructor is not run when a reference or a pointer to an object goes out of scope.

13. The Synthesized Destructor: The compiler defines a synthesized destructor for any class that does not define its own destructor. As with the copy constructor and the copy-assignment operator, for some classes, the synthesized destructor is defined to disallow objects of the type from being destroyed. Otherwise, the synthesized destructor has an empty function body.

15. The Rule of Three/Five
    - Ordinarily the operations to control copies of class objects should be thought of as a unit. In general, it is unusual to need one without needing to define them all.
    - Classes That Need Destructors Need Copy and Assignment
        - The synthesized destructor will not delete a data member that is a pointer. Therefore, a class needs to define a destructor to free the memory allocated by its constructor.
        - The synthesized versions of copy and assignment copy the pointer member, meaning that multiple objects may be pointing to the same memory, and that we may delete the same memory multiple times when they are destroyed.
    - Classes That Need Copy Need Assignment, and Vice Versa
    - Some classes have work that needs to be done to copy or assign objects but has no need for the destructor.

16. Using = default
    - We can explicitly ask the compiler to generate the synthesized versions of the copycontrol members by defining them as = default 
    - We can use = default only on member functions that have a synthesized version (i.e., the default constructor or a copy-control member).

17. Preventing Copies
    - Although most classes should (and generally do) define a copy constructor and a copy-assignment operator, for some classes, there really is no sensible meaning for these operations. For example, the iostream classes prevent copying to avoid letting multiple objects write to or read from the same IO buffer.
    - we can prevent copies by defining the copy constructor and copy-assignment operator as deleted functions. A deleted function is one that is declared but may not be used in any other way. We indicate that we want to define a function as deleted by following its parameter list with = delete

18. Using = delete
    - The = delete signals to the compiler (and to readers of our code) that we are intentionally not defining these members.
    - Unlike = default, = delete must appear on the first declaration of a deleted function.
    - unlike = default, we can specify = delete on any function. Although the primary use of deleted functions is to suppress the copy-control members, deleted functions are sometimes also useful when we want to guide the function-matching process.

19. The Destructor Should Not be a Deleted Member
    - If the destructor is deleted, then there is no way to destroy objects of that type. The compiler will not let us define variables or create temporaries of a type that has a deleted destructor. 
    - Moreover, we cannot define variables or temporaries of a class that has a member whose type has a deleted destructor. If a member has a deleted destructor, then that member cannot be destroyed. If a member can’t be destroyed, the object as a whole can’t be destroyed.
    - It is not possible to define an object or delete a pointer to a dynamically allocated object of a type with a deleted destructor.

20. The Copy-Control Members May Be Synthesized as Deleted. 
    - The synthesized destructor is defined as deleted if the class has a member whose own destructor is deleted or is inaccessible (e.g., private).
    - The synthesized copy constructor is defined as deleted if the class has a member whose own copy constructor is deleted or inaccessible. It is also deleted if the class has a member with a deleted or inaccessible destructor.
    - The synthesized copy-assignment operator is defined as deleted if a member has a deleted or inaccessible copy-assignment operator, or if the class has a const or reference member.
    - The synthesized default constructor is defined as deleted if the class has a member with a deleted or inaccessible destructor; or has a reference member that does not have an in-class initializer; or has a const member whose type does not explicitly define a default constructor and that member does not have an in-class initializer.

21. Note: In essence, these rules mean that if a class has a data member that cannot be default constructed, copied, assigned, or destroyed, then the corresponding member will be a deleted function.

### Copy Control and Resource management

1. We can define the copy operations to make the class behave like a value or like a pointer. Classes that behave like values have their own state. Classes that act like pointers share state. 

2. Valuelike Copy-Assignment Operator
    - There are two points to keep in mind when you write an assignment operator:
        - Assignment operators must work correctly if an object is assigned to itself. 
        - Most assignment operators share work with the destructor and copy constructor. 
    - A good pattern to use when you write an assignment operator is to first copy the right-hand operand into a local temporary. After the copy is done, it is safe to destroy the existing members of the left-hand operand. Once the lefthand operand is destroyed, copy the data from the temporary into the members of the left-hand operand.

3. Defining Classes That Act Like Pointers:
    - Sometimes we want to manage a resource directly. In such cases, it can be useful to use a reference count.
    - The operator must handle self-assignment. We do so by incrementing the count in rhs before decrementing the count in the left-hand object. That way if both objects are the same, the counter will have been incremented before we check to see if ps (and use) should be deleted

### Swap

1. Defining swap is particularly important for classes that we plan to use with algorithms that reorder elements. Such algorithms call swap whenever they need to exchange two elements.

2. Note: Unlike the copy-control members, swap is never necessary. However, defining swap can be an important optimization for classes that allocate resources.

3. swap Functions Should Call swap, Not std::swap.

4. Assignment operators that use copy and swap are automatically exception safe and correctly handle self-assignment.

### A Copy-Control Example

1. Resource management is not the only reason why a class might need to define these members. Some classes have bookkeeping or other actions that the copy-control members must perform.

2. Best Practices: The copy-assignment operator often does the same work as is needed in the copy constructor and destructor. In such cases, the common work should be put in private utility functions.

### Classes That Manage Dynamic Memory

1. Some classes need to allocate a varying amount of storage at run time. Such classes often can (and if they can, generally should) use a library container to hold their data. However, some classes need to do their own allocation. Such classes generally must define their own copy-control members to manage the memory they allocate.

## 疑问

1. 第512页实现Valuelike Copy-Assignment Operator，为什么不能直接修改string，而要先释放原string再重新分配一个新string？
```
// My Solution:
HasPtr& HasPtr::operator=(const HasPtr &rhs)
{
    *ps = *rhs.ps;
    i = rhp.i;
    return *this;
}

// Answer:
HasPtr& HasPtr::operator=(const HasPtr &rhs)
{
    auto newp = new string(*rhs.ps); // copy the underlying string
    delete ps; // free the old memory
    ps = newp; // copy data from rhs into this object
    i = rhs.i;
    return *this; // return this object
}
```

2. 第516页Exercise 13.28，TreeNode需不需要支持copy constructor和copy assignment？此外，delete BinStrTree提示“invalid pointer”，暂时没定位出原因。

3. 第519页Exercise 13.31，为什么sort并没调用我的swap函数？

