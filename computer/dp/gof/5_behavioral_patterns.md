# 《Design Patterns》第5章学习笔记

## 5 Behavioral Patterns

1. basic introduction
    - Behavioral patterns are concerned with algorithms and the assignment of responsibilities between objects. 
    - Behavioral patterns describe not just patterns of objects or classes but also the patterns of communication between them. 
    - These patterns characterize complex control flow that's difficult to follow at run-time. They shift your focus away from flow of control to let you concentrate just on the way objects are interconnected.

2. class patterns vs object patterns
    - Behavioral class patterns use inheritance to distribute behavior between classes. This includes two such patterns: Template Method and Interpreter.
    - Behavioral object patterns use object composition rather than inheritance.

3. Some Behavioral object patterns describe how a group of peer objects cooperate to perform a task that no single object can carry out by itself. An important issue here is how peer objects know about each other. 
    - The mediator provides the indirection needed for loose coupling by introducing a mediator object between peers.
    - Chain of Responsibility provides even looser coupling. It lets you send requests to an object implicitly through a chain of candidate objects. Any candidate may fulfill the request depending on run-time conditions.
    - The Observer pattern defines and maintains a dependency between objects.

4. Other behavioral object patterns are concerned with encapsulating behavior in an object and delegating requests to it.
    - The Strategy pattern encapsulates an algorithm in an object.
    - The Command pattern encapsulates a request in an object.
    - The State pattern encapsulates the states of an object. 
    - Visitor encapsulates behavior that would otherwise be distributed across classes.
    - Iterator abstracts the way you access and traverse objects in an aggregate.

### 5.1 Chain of Responsibility

1. Intent: Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain until an object handles it. 

2. Motivation
    - What we need is a way to decouple the button that initiates the help request from the objects that might provide help information. The Chain of Responsibility pattern defines how that happens.
    
3. Applicability: Use Chain of Responsibility when
    - more than one object may handle a request, and the handler isn't known a priori. The handler should be ascertained automatically.
    - you want to issue a request to one of several objects without specifying the receiver explicitly.
    - the set of objects that can handle a request should be specified dynamically.

4. Consequences
    - Reduced coupling.
    - Added flexibility in assigning responsibilities to objects.
    - Receipt isn't guaranteed. 

5. Related Patterns: Chain of Responsibility is often applied in conjunction with Composite. There, a component's parent can act as its successor.

### 5.2 Command

1. Intent: Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue or log requests, and support undoable operations.

2. Motivation
    - Sometimes it's necessary to issue requests to objects without knowing anything about the operation being requested or the receiver of the request. For example, user interface toolkits include objects like buttons and menus that carry out a request in response to user input. 
    - The Command pattern lets toolkit objects make requests of unspecified application objects by turning the request itself into an object.
    - An application can provide both a menu and a push button interface to a feature just by making the menu and the push button share an instance of the same concrete Command subclass.

3. Applicability: Use the Command pattern when you want to
    - parameterize objects by an action to perform. Commands are an object-oriented replacement for callbacks.
    - specify, queue, and execute requests at different times.
    - support undo. 
    - support logging changes so that they can be reapplied in case of a system crash.
    - structure a system around high-level operations built on primitives operations. Such a structure is common in information systems that support transactions.

4. Consequences
    - Command decouples the object that invokes the operation from the one that knows how to perform it.
    - Commands are first-class objects. They can be manipulated and extended like any other object.
    - You can assemble commands into a composite command.
    - It's easy to add new Commands, because you don't have to change existing classes.

5. Related Patterns
    - A Composite can be used to implement MacroCommands.
    - A Memento can keep state the command requires to undo its effect.
    - A command that must be copied before being placed on the history list acts as a Prototype.

### 5.3 Interpreter

1. Intent: Given a language, define a represention for its grammar along with an interpreter that uses the representation to interpret sentences in the language.

2. Motivation
    - Searching for strings that match a pattern is a common problem. Regular expressions are a standard language for specifying patterns of strings. Rather than building custom algorithms to match each pattern against strings, search algorithms could interpret a regular expression that specifies a set of strings to match.
    - The Interpreter pattern describes how to define a grammar for simple languages, represent sentences in the language, and interpret these sentences. In this example, the pattern describes how to define a grammar for regular expressions, represent a particular regular expression, and how to interpret that regular expression.

3. Applicability: Use the Interpreter pattern when there is a language to interpret, and you can represent statements in the language as abstract syntax trees. The Interpreter pattern works best when
    - the grammar is simple.
    - efficiency is not a critical concern. 

4. Consequences
    - It's easy to change and extend the grammar.
    - Implementing the grammar is easy, too. 
    - Complex grammars are hard to maintain.
    - Adding new ways to interpret expressions.

5. Related Patterns
    - Composite: The abstract syntax tree is an instance of the Composite pattern.
    - Flyweight shows how to share terminal symbols within the abstract syntax tree.
    - Iterator: The interpreter can use an Iterator to traverse the structure.
    - Visitor can be used to maintain the behavior in each node in the abstract syntax tree in one class.

### 5.4 Iterator

1. Intent: Provide a way to access the elements of an aggregate object sequentially without exposing its underlying representation.

2. Motivation
    - An aggregate object such as a list should give you a way to access its elements without exposing its internal structure. Moreover, you might want to traverse the list in different ways, depending on what you want to accomplish. But you probably don't want to bloat the List interface with operations for different traversals, even if you could anticipate the ones you will need. You might also need to have more than one traversal pending on the same list.
    - The Iterator pattern lets you do all this. The key idea in this pattern is to take the responsibility for access and traversal out of the list object and put it into an iterator object. 

3. Applicability: Use the Iterator pattern
    - to access an aggregate object's contents without exposing its internal representation.
    - to support multiple traversals of aggregate objects.
    - to provide a uniform interface for traversing different aggregate structures (that is, to support polymorphic iteration).

4. Consequences
    - It supports variations in the traversal of an aggregate.
    - Iterators simplify the Aggregate interface.
    - More than one traversal can be pending on an aggregate.

5. Related Patterns
    - Composite: Iterators are often applied to recursive structures such as Composites.
    - Factory Method: Polymorphic iterators rely on factory methods to instantiate the appropriate Iterator subclass.
    - Memento is often used in conjunction with the Iterator pattern. An iterator can use a memento to capture the state of an iteration. The iterator stores the memento internally.

### 5.5 Mediator

1. Intent: Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

2. Motivation
    - Consider the implementation of dialog boxes in a graphical user interface. A dialog box uses a window to present a collection of widgets such as buttons, menus, and entry fields. Often there are dependencies between the widgets in the dialog.
    - You can avoid these problems by encapsulating collective behavior in a separate mediator object. A mediator is responsible for controlling and coordinating the interactions of a group of objects.

3. Applicability: Use the Mediator pattern when
    - a set of objects communicate in well-defined but complex ways. The resulting interdependencies are unstructured and difficult to understand.
    - reusing an object is difficult because it refers to and communicates with many other objects.
    - a behavior that's distributed between several classes should be customizable without a lot of subclassing.

4. Consequences
    - It limits subclassing.
    - It decouples colleagues.
    - It simplifies object protocols.
    - It abstracts how objects cooperate.
    - It centralizes control.

5. Related Patterns
    - Facade differs from Mediator in that it abstracts a subsystem of objects to provide a more convenient interface. Its protocol is unidirectional; that is, Facade objects make requests of the subsystem classes but not vice versa. In contrast, Mediator enables cooperative behavior that colleague objects don't or can't provide, and the protocol is multidirectional.
    - Colleagues can communicate with the mediator using the Observer pattern.

### 5.6 Memento

1. Intent: Without violating encapsulation, capture and externalize an object's internal state so that the object can be restored to this state later.

2. Motivation
    - Objects normally encapsulate some or all of their state, making it inaccessible to other objects and impossible to save externally. Exposing this state would violate encapsulation, which can compromise the application's reliability and extensibility.
    - We can solve this problem with the Memento pattern. A memento is an object that stores a snapshot of the internal state of another object—the memento's originator. 

3. Applicability: Use the Memento pattern when
    - a snapshot of (some portion of) an object's state must be saved so that it can be restored to that state later, and
    - a direct interface to obtaining the state would expose implementation details and break the object's encapsulation.

4. Consequences
    - Preserving encapsulation boundaries.
    - It simplifies Originator.
    - Using mementos might be expensive.
    - Defining narrow and wide interfaces.
    - Hidden costs in caring for mementos.

5. Related Patterns
    - Command: Commands can use mementos to maintain state for undoable operations.
    - Iterator: Mementos can be used for iteration as described earlier.

### 5.7 Observer

1. Intent: Define a one-to-many dependency between objects so that when one object changes state, all its dependents are notified and updated automatically.

2. Motivation
    - Many graphical user interface toolkits separate the presentational aspects of the user interface from the underlying application data.
    - This behavior implies that the spreadsheet and bar chart are dependent on the data object and therefore should be notified of any change in its state. And there's no reason to limit the number of dependent objects to two; there may be any number of different user interfaces to the same data.
    - The Observer pattern describes how to establish these relationships. The key objects in this pattern are subject and observer.
    - This kind of interaction is also known as publish-subscribe.

3. Applicability: Use the Observer pattern:
    - When an abstraction has two aspects, one dependent on the other. Encapsulating these aspects in separate objects lets you vary and reuse them independently.
    - When a change to one object requires changing others, and you don't know how many objects need to be changed.
    - When an object should be able to notify other objects without making assumptions about who these objects are. In other words, you don't want these objects tightly coupled.

4. Consequences
    - Abstract coupling between Subject and Observer. 
    - Support for broadcast communication.
    - Unexpected updates.

5. Related Patterns
    - Mediator: By encapsulating complex update semantics, the ChangeManager acts as mediator between subjects and observers.
    - Singleton: The ChangeManager may use the Singleton pattern to make it unique and globally accessible.

### 5.8 State

1. Intent: Allow an object to alter its behavior when its internal state changes. The object will appear to change its class.

2. Motivation
    - Consider a class TCPConnection that represents a network connection. A TCPConnection object can be in one of several different states: Established, Listening, Closed. 
    - The State pattern describes how TCPConnection can exhibit different behavior in each state.

3. Applicability: Use the State pattern in either of the following cases:
    - An object's behavior depends on its state, and it must change its behavior at runtime depending on that state.
    - Operations have large, multipart conditional statements that depend on the object's state. This state is usually represented by one or more enumerated constants. Often, several operations will contain this same conditional structure.
    - The State pattern puts each branch of the conditional in a separate class. This lets you treat the object's state as an object in its own right that can vary independently from other objects.

4. Consequences
    - It localizes state-specific behavior and partitions behavior for different states.
    - It makes state transitions explicit.
    - State objects can be shared.

5. Related Patterns
    - The Flyweight pattern explains when and how State objects can be shared.
    - State objects are often Singletons.

### 5.9 Strategy

1. Intent: Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

2. Motivation
    - Many algorithms exist for breaking a stream of text into lines. Hard-wiring all such algorithms into the classes that require them isn't desirable.
    - We can avoid these problems by defining classes that encapsulate different linebreaking algorithms. An algorithm that's encapsulated in this way is called a strategy.

3. Applicability: Use the Strategy pattern when
    - many related classes differ only in their behavior. Strategies provide a way to configure a class with one of many behaviors.
    - you need different variants of an algorithm. For example, you might define algorithms reflecting different space/time trade-offs. Strategies can be used when these variants are implemented as a class hierarchy of algorithms [HO87].
    - an algorithm uses data that clients shouldn't know about. Use the Strategy pattern to avoid exposing complex, algorithm-specific data structures.
    - a class defines many behaviors, and these appear as multiple conditional statements in its operations. Instead of many conditionals, move related conditional branches into their own Strategy class.

4. Consequences
    - Families of related algorithms.
    - An alternative to subclassing.
    - Strategies eliminate conditional statements.
    - A choice of implementations.
    - Clients must be aware of different Strategies.
    - Communication overhead between Strategy and Context.
    - Increased number of objects.

5. Related Patterns
    - Flyweight: Strategy objects often make good flyweights.

### 5.10 Template Method

1. Intent: Define the skeleton of an algorithm in an operation, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps of an algorithm without changing the algorithm's structure.

2. Motivation
    - Consider an application framework that provides Application and Document classes. 
    - OpenDocument defines each step for opening a document. It checks if the document can be opened, creates the application-specific Document object, adds it to its set of documents, and reads the Document from a file.
    - By defining some of the steps of an algorithm using abstract operations, the template method fixes their ordering, but it lets Application and Document subclasses vary those steps to suit their needs.

3. Applicability: The Template Method pattern should be 
    - used to implement the invariant parts of an algorithm once and leave it up to subclasses to implement the behavior that can vary.
    - when common behavior among subclasses should be factored and localized in a common class to avoid code duplication.
    - to control subclasses extensions. You can define a template method that calls "hook" operations (see Consequences) at specific points, thereby permitting extensions only at those points.

4. Consequences
    - Template methods are a fundamental technique for code reuse. They are particularly important in class libraries, because they are the means for factoring out common behavior in library classes.
    - Template methods lead to an inverted control structure that's sometimes referred to as "the Hollywood principle," that is, "Don't call us, we'll call you"  This refers to how a parent class calls the operations of a subclass and not the other way around.
    - Template methods call the following kinds of operations:
        - concrete operations (either on the ConcreteClass or on client classes);
        - concrete AbstractClass operations (i.e., operations that are generally useful to subclasses);
        - primitive operations (i.e., abstract operations);
        - factory methods;
        - hook operations, which provide default behavior that subclasses can extend if necessary. A hook operation often does nothing by default.

5. Related Patterns
    - Factory Methods are often called by template methods. In the Motivation example, the factory method DoCreateDocument is called by the template method OpenDocument.
    - Strategy: Template methods use inheritance to vary part of an algorithm. Strategies use delegation to vary the entire algorithm.

### 5.11 Visitor

1. Intent: Represent an operation to be performed on the elements of an object structure. Visitor lets you define a new operation without changing the classes of the elements on which it operates.

2. Motivation
    - Consider a compiler that represents programs as abstract syntax trees.
    - It would be better if each new operation could be added separately, and the node classes were independent of the operations that apply to them.
    - We can have both by packaging related operations from each class in a separate object, called a visitor, and passing it to elements of the abstract syntax tree as it's traversed.

3. Applicability: Use the Visitor pattern when
    - an object structure contains many classes of objects with differing interfaces, and you want to perform operations on these objects that depend on their concrete classes.
    - many distinct and unrelated operations need to be performed on objects in an object structure, and you want to avoid "polluting" their classes with these operations. Visitor lets you keep related operations together by defining them in one class. When the object structure is shared by many applications, use Visitor to put operations in just those applications that need them.
    - the classes defining the object structure rarely change, but you often want to define new operations over the structure. Changing the object structure classes requires redefining the interface to all visitors, which is potentially costly. If the object structure classes change often, then it's probably better to define the operations in those classes. 

4. Consequences
    - Visitor makes adding new operations easy.
    - A visitor gathers related operations and separates unrelated ones.
    - Adding new ConcreteElement classes is hard.
    - Visiting across class hierarchies.
    - Accumulating state.
    - Breaking encapsulation.

5. Related Patterns
    - Composite: Visitors can be used to apply an operation over an object structure defined by the Composite pattern.
    - Interpreter: Visitor may be applied to do the interpretation.
