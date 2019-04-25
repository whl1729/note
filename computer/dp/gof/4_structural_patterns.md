# 《Design Pattern》都4章学习笔记

## 4 Structural Patterns

1. Structural patterns are concerned with how classes and objects are composed to form larger structures. 

### 4.1 Adapter

1. Intent: Convert the interface of a class into another interface clients expect. Adapter lets classes work together that couldn't otherwise because of incompatible interfaces.

2. Motivation
    - We'd like to reuse TextView to implement TextShape, but the toolkit wasn't designed with Shape classes in mind. So we can't use TextView and Shape objects interchangeably.
    - We can do this in one of two ways: (1) by inheriting Shape's interface and TextView's implementation or (2) by composing a TextView instance within a TextShape and implementing TextShape in terms of TextView's interface. These two approaches correspond to the class and object versions of the Adapter pattern. We call TextShape an adapter.

3. Applicability: Use the Adapter pattern when
    - you want to use an existing class, and its interface does not match the one you need.
    - you want to create a reusable class that cooperates with unrelated or unforeseen classes, that is, classes that don't necessarily have compatible interfaces.
    - (object adapter only) you need to use several existing subclasses, but it's impractical to adapt their interface by subclassing every one. An object adapter can adapt the interface of its parent class.

4. Consequences
    - A class adapter adapts Adaptee to Target by committing to a concrete Adapter class.
    - A class adapter lets Adapter override some of Adaptee's behavior, since Adapter is a subclass of Adaptee.
    - A class adapter introduces only one object, and no additional pointer indirection is needed to get to the adaptee.
    - A object adapter lets a single Adapter work with many Adaptees—that is, the Adaptee itself and all of its subclasses (if any). The Adapter can also add functionality to all Adaptees at once.
    - A object makes it harder to override Adaptee behavior. It will require subclassing Adaptee and making Adapter refer to the subclass rather than the Adaptee itself.

5. Implementation
    - In a C++ implementation of a class adapter, Adapter would inherit publicly from Target and privately from Adaptee.
    - A class adapter uses multiple inheritance to adapt interfaces. The key to class adapters is to use one inheritance branch to inherit the interface and another branch to inherit the implementation. 
    - The object adapter uses object composition to combine classes with different interfaces.
