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

### 4.2 Bridge

1. Intent: Decouple an abstraction from its implementation so that the two can vary independently.

2. Motivation
    - Consider the implementation of a portable Window abstraction in a user interface toolkit.
    - The Bridge pattern addresses these problems by putting the Window abstraction and its implementation in separate class hierarchies.

3. Applicability: Use the Bridge pattern when
    - you want to avoid a permanent binding between an abstraction and its implementation. 
    - both the abstractions and their implementations should be extensible by subclassing.
    - changes in the implementation of an abstraction should have no impact on clients; that is, their code should not have to be recompiled.
    - you want to hide the implementation of an abstraction completely from clients. In C++ the representation of a class is visible in the class interface.
    - you want to share an implementation among multiple objects (perhaps using reference counting), and this fact should be hidden from the client. 

4. Consequences
    - Decoupling interface and implementation. 
    - Improved extensibility. You can extend the Abstraction and Implementor hierarchies independently.
    - Hiding implementation details from clients.

5. Related Patterns
    - An Abstract Factory can create and configure a particular Bridge.
    - The Adapter pattern is geared toward making unrelated classes work together. It is usually applied to systems after they're designed. Bridge, on the other hand, is used upfront in a design to let abstractions and implementations vary independently.

### 4.3 Composite

1. Intent: Compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions of objects uniformly.

2. Motivation
    - Graphics applications like drawing editors and schematic capture systems let users build complex diagrams out of simple components.
    - The Composite pattern describes how to use recursive composition so that clients don't have to make this distinction.
    - The key to the Composite pattern is an abstract class that represents both primitives and their containers.

3. Applicability: Use the Composite pattern when
    - you want to represent part-whole hierarchies of objects.
    - you want clients to be able to ignore the difference between compositions of objects and individual objects. Clients will treat all objects in the composite structure uniformly.

4. Consequences
    - defines class hierarchies consisting of primitive objects and composite objects.
    - makes the client simple. 
    - makes it easier to add new kinds of components.
    - can make your design overly general.

5. Related Patterns
    - Often the component-parent link is used for a Chain of Responsibility.
    - Decorator is often used with Composite. When decorators and composites are used together, they will usually have a common parent class. So decorators will have to support the Component interface with operations like Add, Remove, and GetChild.
    - Flyweight lets you share components, but they can no longer refer to their parents.
    - Iterator can be used to traverse composites.
    - Visitor localizes operations and behavior that would otherwise be distributed across Composite and Leaf classes.

### 4.4 Decorator

1. Intent: Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.

2. Motivation
    - Sometimes we want to add responsibilities to individual objects, not to an entire class. A graphical user interface toolkit, for example, should let you add properties like borders or behaviors like scrolling to any user interface component.
    - A more flexible approach is to enclose the component in another object that adds the border. The enclosing object is called a decorator.

3. Applicability: Use Decorator
    - to add responsibilities to individual objects dynamically and transparently, that is, without affecting other objects.
    - for responsibilities that can be withdrawn.
    - when extension by subclassing is impractical. Sometimes a large number of independent extensions are possible and would produce an explosion of subclasses to support every combination. Or a class definition may be hidden or otherwise unavailable for subclassing.

4. Consequences: The Decorator pattern has at least two key benefits and two liabilities:
    - More flexibility than static inheritance.
    - Avoids feature-laden classes high up in the hierarchy.
    - A decorator and its component aren't identical.
    - Lots of little objects.

5. Related Patterns
    - Adapter: A decorator is different from an adapter in that a decorator only changes an object's responsibilities, not its interface; an adapter will give an object a completely new interface.
    - Composite: A decorator can be viewed as a degenerate composite with only one component. However, a decorator adds additional responsibilities—it isn't intended for object aggregation.
    - Strategy: A decorator lets you change the skin of an object; a strategy lets you change the guts. These are two alternative ways of changing an object.

### 4.5 Facade

1. Intent: Provide a unified interface to a set of interfaces in a subsystem. Facade defines a higherlevel interface that makes the subsystem easier to use.

2. Motivation
    - Structuring a system into subsystems helps reduce complexity. A common design goal is to minimize the communication and dependencies between subsystems. One way to achieve this goal is to introduce a facade object that provides a single, simplified interface to the more general facilities of a subsystem.
    - The compiler facade makes life easier for most programmers without hiding the lower-level functionality from the few that need it.

3. Applicability: Use the facade pattern when
    - you want to provide a simple interface to a complex subsystem. 
    - there are many dependencies between clients and the implementation classes of an abstraction.
    - you want to layer your subsystems. Use a facade to define an entry point to each subsystem level. 

4. Consequences
    - It shields clients from subsystem components, thereby reducing the number of objects that clients deal with and making the subsystem easier to use.
    - It promotes weak coupling between the subsystem and its clients.
    - It doesn't prevent applications from using subsystem classes if they need to. Thus you can choose between ease of use and generality.

5. Related Patterns
    - Abstract Factory can be used with Facade to provide an interface for creating subsystem objects in a subsystem-independent way. Abstract Factory can also be used as an alternative to Facade to hide platform-specific classes.
    - Mediator is similar to Facade in that it abstracts functionality of existing classes. However, Mediator's purpose is to abstract arbitrary communication between colleague objects, often centralizing functionality that doesn't belong in any one of them. A 182mediator's colleagues are aware of and communicate with the mediator instead of communicating with each other directly. In contrast, a facade merely abstracts the interface to subsystem objects to make them easier to use; it doesn't define new functionality, and subsystem classes don't know about it.
    - Usually only one Facade object is required. Thus Facade objects are often Singletons.

### 4.6 Flyweight

1. Intent: Use sharing to support large numbers of fine-grained objects efficiently.

2. Motivation
    - Most document editor implementations have text formatting and editing facilities that are modularized to some extent. 
    - Even moderate-sized documents may require hundreds of thousands of character objects, which will consume lots of memory and may incur unacceptable run-time overhead. The Flyweight pattern describes how to share objects to allow their use at fine granularities without prohibitive cost.

3. Applicability: Apply the Flyweight pattern when all of the following are true:
    - An application uses a large number of objects.
    - Storage costs are high because of the sheer quantity of objects.
    - Most object state can be made extrinsic.
    - Many groups of objects may be replaced by relatively few shared objects once extrinsic state is removed.
    - The application doesn't depend on object identity. Since flyweight objects may be shared, identity tests will return true for conceptually distinct objects.

4. Consequences
    - Flyweights may introduce run-time costs associated with transferring, finding, and/or computing extrinsic state, especially if it was formerly stored as intrinsic state. However, such costs are offset by space savings, which increase as more flyweights are shared.
    - Storage savings are a function of several factors:
        - the reduction in the total number of instances that comes from sharing
        - the amount of intrinsic state per object
        - whether extrinsic state is computed or stored.
    - The more flyweights are shared, the greater the storage savings. The savings increase with the amount of shared state. 

5. Related Patterns
    - The Flyweight pattern is often combined with the Composite pattern to implement a logically hierarchical structure in terms of a directed-acyclic graph with shared leaf nodes.
    - It's often best to implement State and Strategy objects as flyweights.

### 4.7 Proxy

1. Intent: Provide a surrogate or placeholder for another object to control access to it.

2. Motivation
    - Consider a document editor that can embed graphical objects in a document. Some graphical objects, like large raster images, can be expensive to create. But opening a document should be fast, so we should avoid creating all the expensive objects at once when the document is opened. 
    - The solution is to use another object, an image proxy, that acts as a stand-in for the real image. The proxy acts just like the image and takes care of instantiating it when it's required.

3. Applicability
    - A remote proxy provides a local representative for an object in a different address space.
    - A virtual proxy creates expensive objects on demand.
    - A protection proxy controls access to the original object. Protection proxies are useful when objects should have different access rights.
    - A smart reference is a replacement for a bare pointer that performs additional actions when an object is accessed. Typical uses include
        - counting the number of references to the real object so that it can be freed automatically when there are no more references (also called smart pointers).
        - loading a persistent object into memory when it's first referenced.
        - checking that the real object is locked before it's accessed to ensure that no other object can change it.

4. Consequences
    - A remote proxy can hide the fact that an object resides in a different address space.
    - A virtual proxy can perform optimizations such as creating an object on demand.
    - Both protection proxies and smart references allow additional housekeeping tasks when an object is accessed.
    - There's another optimization that the Proxy pattern can hide from the client. It's called copy-on-write, and it's related to creation on demand. 

5. To make copy-on-write work, the subject must be reference counted. Copying the proxy will do nothing more than increment this reference count. Only when the client requests an operation that modifies the subject does the proxy actually copy it. In that case the proxy must also decrement the subject's reference count. When the reference count goes to zero, the subject gets deleted. 

6. Related Patterns
    - Adapter: An adapter provides a different interface to the object it adapts. In contrast, a proxy provides the same interface as its subject. However, a proxy used for access protection might refuse to perform an operation that the subject will perform, so its interface may be effectively a subset of the subject's.
    - Decorator: Although decorators can have similar implementations as proxies, decorators have a different purpose. A decorator adds one or more responsibilities to an object, whereas a proxy controls access to an object.
    - Proxies vary in the degree to which they are implemented like a decorator. A protection proxy might be implemented exactly like a decorator. On the other hand, a remote proxy will not contain a direct reference to its real subject but only an indirect reference, such as "host ID and local address on host." A virtual proxy will start off with an indirect reference such as a file name but will eventually obtain and use a direct reference.

### 4.8 Discussion of Structural Patterns

1. You may have noticed similarities between the structural patterns, especially in their participants and collaborations. This is so probably because structural patterns rely on the same small set of language mechanisms for structuring code and objects: single and multiple inheritance for class-based patterns, and object composition for object patterns. But the similarities belie the different intents among these patterns. 

2. Adapter vs Bridge
    - Similarities
        - Both promote flexibility by providing a level of indirection to another object. 
        - Both involve forwarding requests to this object from an interface other than its own.
    - Differences
        - The key difference between these patterns lies in their intents. Adapter focuses on resolving incompatibilities between two existing interfaces. Bridge bridges an abstraction and its (potentially numerous) implementations so as to provides a stable interface to clients.
        - Adapter and Bridge are often used at different points in the software lifecycle. The Adapter pattern makes things work after they're designed; Bridge makes them work before they are. 

3. Adapter vs Facade: a facade defines a new interface, whereas an adapter reuses an old interface. Remember that an adapter makes two existing interfaces work together as opposed to defining an entirely new one.

4. Composite vs Decorator
    - Both have similar structure diagrams, reflecting the fact that both rely on recursive composition to organize an open-ended number of objects. 
    - Decorator is designed to let you add responsibilities to objects without subclassing. It avoids the explosion of subclasses that can arise from trying to cover every combination of responsibilities statically. 
    - Composite focuses on structuring classes so that many related objects can be treated uniformly, and multiple objects can be treated as one. Its focus is not on embellishment but on representation. 
    - The Composite and Decorator patterns are often used in concert. Both lead to the kind of design in which you can build applications just by plugging objects together without defining any new classes. 

5. Decorator vs Proxy
    - Both patterns describe how to provide a level of indirection to an object, and the implementations of both the proxy and decorator object keep a reference to another object to which they forward requests. 
    - Proxy's intent is to provide a stand-in for a subject when it's inconvenient or undesirable to access the subject directly because, for example, it lives on a remote machine, has restricted access, or is persistent.
    - Decorator addresses the situation where an object's total functionality can't be determined at compile time, at least not conveniently. That open-endedness makes recursive composition an essential part of Decorator. That isn't the case in Proxy, because Proxy focuses on one relationship—between the proxy and its subject—and that relationship can be expressed statically.
