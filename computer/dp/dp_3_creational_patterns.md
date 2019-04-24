# 《Design Patterns》第3章学习笔记

## 3 Creational Patterns

### 3.1 Abstract Factory（抽象工厂）

1. Intent: Provide an interface for creating families of related or dependent objects without specifying their concrete classes.

2. Motivation
    - Consider a user interface toolkit that supports multiple look-and-feel standards, such as Motif and Presentation Manager. 
    - We can solve this problem by defining an abstract WidgetFactory class that declares an interface for creating each basic kind of widget. There's also an abstract class for each kind of widget, and concrete subclasses implement widgets for specific look-and-feel standards. 

3. Applicability
    - a system should be independent of how its products are created, composed, and represented.
    - a system should be configured with one of multiple families of products.
    - a family of related product objects is designed to be used together, and you need to enforce this constraint.
    - you want to provide a class library of products, and you want to reveal just their interfaces, not their implementations.

4. Consequences
    - It isolates concrete classes.
    - It makes exchanging product families easy.
    - It promotes consistency among products.
    - Supporting new kinds of products is difficult.

### 3.2 Builder（建造者）

1. Intent: Separate the construction of a complex object from its representation so that the same construction process can create different representations.

2. Motivation
    - A reader for the RTF (Rich Text Format) document exchange format should be able to convert RTF to many text formats. The problem is that the number of possible conversions is open-ended. So it should be easy to add a new conversion without modifying the reader.
    - A solution is to configure the RTFReader class with a TextConverter object that converts RTF to another textual representation. As the RTFReader parses the RTF document, it uses the TextConverter to perform the conversion.

3. Applicability
    - the algorithm for creating a complex object should be independent of the parts that make up the object and how they're assembled.
    - the construction process must allow different representations for the object that's constructed.

4. Consequences
    - It lets you vary a product's internal representation. 
    - It isolates code for construction and representation.
    - It gives you finer control over the construction process.

5. Builder vs Abstract Factory
    - Abstract Factory is similar to Builder in that it too may construct complex objects. 
    - The primary difference is that the Builder pattern focuses on constructing a complex object step by step. Abstract Factory's emphasis is on families of product objects (either simple or complex). 
    - Builder returns the product as a final step, but as far as the Abstract Factory pattern is concerned, the product gets returned immediately.

### 3.3 Factory Method（工厂方法）

1. Intent: Define an interface for creating an object, but let subclasses decide which class to instantiate. Factory Method lets a class defer instantiation to subclasses.

2. Motivation
    - Consider a framework for applications that can present multiple documents to the user. The framework must instantiate classes, but it only knows about abstract classes, which it cannot instantiate.
    - The Factory Method pattern offers a solution. It encapsulates the knowledge of which Document subclass to create and moves this knowledge out of the framework.

3. Applicability
    - a class can't anticipate the class of objects it must create.
    - a class wants its subclasses to specify the objects it creates.
    - classes delegate responsibility to one of several helper subclasses, and you want to localize the knowledge of which helper subclass is the delegate.

4. Consequences
    - Factory methods eliminate the need to bind application-specific classes into your code. The code only deals with the Product interface; therefore it can work with any userdefined ConcreteProduct classes.
    - A potential disadvantage of factory methods is that clients might have to subclass the Creator class just to create a particular ConcreteProduct object.
    - Provides hooks for subclasses.
    - Connects parallel class hierarchies. 

### 3.4 Prototype（原型）

1. Intent: Specify the kinds of objects to create using a prototypical instance, and create new objects by copying this prototype.

2. Motivation
    - How can the framework use Object Composition to parameterize instances of GraphicTool by the class of Graphic they're supposed to create?
    - The solution lies in making GraphicTool create a new Graphic by copying or "cloning" an instance of a Graphic subclass. We call this instance a prototype. 

3. Applicability: Use the Prototype pattern when a system should be independent of how its products are created, composed, and represented; and
    - when the classes to instantiate are specified at run-time, for example, by
dynamic loading; or
    - to avoid building a class hierarchy of factories that parallels the class hierarchy of products; or
    - when instances of a class can have one of only a few different combinations of state. 

4. Consequences
    - Adding and removing products at run-time.
    - Specifying new objects by varying values. 
    - Specifying new objects by varying structure.
    - Reduced subclassing. 
    -  Configuring an application with classes dynamically. 

5. The main liability of the Prototype pattern is that each subclass of Prototype must implement the Clone operation, which may be difficult.
    - Adding Clone is difficult when the classes under consideration already exist. 
    - Implementing Clone can be difficult when their internals include objects that don't support copying or have circular references.

### 3.5 Singleton（单例）

1. Intent: Ensure a class only has one instance, and provide a global point of access to it.

2. Motivation
    - It's important for some classes to have exactly one instance.
    - How do we ensure that a class has only one instance and that the instance is easily accessible? 
    - A better solution is to make the class itself responsible for keeping track of its sole instance. The class can ensure that no other instance can be created (by intercepting requests to create new objects), and it can provide a way to access the instance. This is the Singleton pattern.

3. Applicability
    - There must be exactly one instance of a class, and it must be accessible to clients from a well-known access point.
    - When the sole instance should be extensible by subclassing, and clients should be able to use an extended instance without modifying their code.

4. Consequences
    - Controlled access to sole instance.
    - Reduced name space.
    - Permits refinement of operations and representation. 
    - Permits a variable number of instances.
    - More flexible than class operations. 
