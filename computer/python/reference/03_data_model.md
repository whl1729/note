# 《Python Reference》文档分析笔记

## 3 Data model

### Q1：这一章的内容是什么？

### Q2：这一章的大纲是什么？

- Objects, values and types
- The standard type hierarchy
  - None
  - NotImplemented
  - Ellipsis
  - numbers.Number
  - Sequences
  - Set types
  - Mappings
  - Callable types
    - User-defined functions
    - Instance methods
    - Generator functions
    - Coroutine functions
    - Asynchronous generator functions
    - Built-in functions
    - Built-in methods
    - Classes
    - Class Instances
  - Modules
  - Custom classes
  - Class instances
  - I/O objects(or file objects)
  - Internal types
    - Code objects
    - Frame objects
    - Traceback objects
    - Slice objects
    - Static method objects
    - Class method objects
- Special method names
  - Basic customization
  - Customizing attribute access
  - Customizing class creation
  - Customizing instance and subclass checks
  - Emulating generic types
  - Emulating callable objects
  - Emulating container types
  - Emulating numeric types
  - With Statement Context Managers
  - Special method lookup
- Coroutines
  - Awaitable Objects
  - Coroutine Objects
  - Asynchronous Iterators
  - Asynchronous Context Managers

### Q3：作者想要解决什么问题？

### Q4：这一章的关键词是什么？

### Q5：这一章的关键句是什么？

#### 3.1 Objects, values and types

- Objects
  - Objects are Python’s abstraction for data.
  - All data in a Python program is represented by objects or by relations between objects.
  - Every object has an identity, a type and a value.

- Identity
  - An object’s identity never changes once it has been created; you may think of it as the object’s address in memory.
  - The ‘is’ operator compares the identity of two objects
  - The `id()` function returns an integer representing its identity.

- Type
  - An object’s type determines the **operations** that the object supports and also defines the possible **values** for objects of that type.
  - The `type()` function returns an object’s type (which is an object itself).
  - Like its identity, an object’s type is also unchangeable.

- Value
  - The value of some objects can change.
    - Objects whose value can change are said to be **mutable**
    - Objects whose value is unchangeable once they are created are called **immutable**.
  - Immutability is not strictly the same as having an unchangeable value, it is more subtle.
    - The value of an immutable container object that contains a reference to a mutable object can change when the latter’s value is changed.
    - However the container is still considered immutable, because the collection of objects it contains cannot be changed. 
  - An object’s mutability is determined by its type.
    - For instance, numbers, strings and tuples are immutable, while dictionaries and lists are mutable.

- Garbage collection
  - An implementation is allowed to postpone garbage collection or omit it altogether.
  - Do not depend on immediate finalization of objects when they become unreachable (so **you should always close files explicitly**).

- Types affect almost all aspects of object behavior. Even the importance of object identity is affected in some sense:
  - For immutable types, operations that compute new values may actually return a reference to any existing object with the same type and value, while for mutable objects this is not allowed.

#### 3.2 The standard type hierarchy

### Q6：作者是怎么论述的？

- Instance methods
  - When an instance method object is called, the underlying function (`__func__`) is called, inserting the class instance (`__self__`) in front of the argument list. For instance, when C is a class which contains a definition for a function f(), and x is an instance of C, calling x.f(1) is equivalent to calling C.f(x, 1).

> Question: 看不懂「Instance methods」这一节的描述。

### Q7：作者解决了什么问题？

### Q8：我有哪些疑问？

### Q9：这一章说得有道理吗？为什么？

### Q10：如何拓展这一章？

#### Q10.1：为什么是这样的？为什么发展成这样？为什么需要它？

#### Q10.2：有哪些相似的知识点？它们之间的联系是什么？

#### Q10.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

### Q11：这一章和我有什么关系？

