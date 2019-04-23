# 《Design Pattern》第2章学习笔记

## 2 A Case Study: Designing a Document Editor

This chapter presents a case study in the design of a "What-You-See-Is-What-You-Get" (or "WYSIWYG") document editor called Lexi.

### 2.1 Design Problems

We will examine seven problems in Lexi's design:

1. Document structure. The choice of internal representation for the document affects nearly every aspect of Lexi's design. All editing, formatting, displaying, and textual analysis will require traversing the representation. The way we organize this information will impact the design of the rest of the application.

2. Formatting. How does Lexi actually arrange text and graphics into lines and columns? What objects are responsible for carrying out different formatting policies? How do these policies interact with the document's internal representation?

3. Embellishing the user interface. Lexi's user interface includes scroll bars, borders, and drop shadows that embellish the WYSIWYG document interface. Such embellishments are likely to change as Lexi's user interface evolves. Hence it's important to be able to add and remove embellishments easily without affecting the rest of the application.

4. Supporting multiple look-and-feel standards. Lexi should adapt easily to different look-and-feel standards such as Motif and Presentation Manager (PM) without major modification.

5. Supporting multiple window systems. Different look-and-feel standards are usually implemented on different window systems. Lexi's design should be as independent of the window system as possible.

6. User operations. Users control Lexi through various user interfaces, including buttons and pull-down menus. The functionality behind these interfaces is scattered throughout the objects in the application. The challenge here is to provide a uniform mechanism both for accessing this scattered functionality and for undoing its effects.

7. Spelling checking and hyphenation. How does Lexi support analytical operations such as checking for misspelled words and determining hyphenation points? How can we minimize the number of classes we have to modify to add a new analytical operation?

### 2.2 Document structure

1. In particular, the internal representation should support the following:
    - Maintaining the document's physical structure, that is, the arrangement of text and graphics into lines, columns, tables, etc.
    - Generating and presenting the document visually.
    - Mapping positions on the display to elements in the internal representation. This lets Lexi determine what the user is referring to when he points to something in the visual representation.

2. In addition to these goals are some constraints. 
    - We should treat text and graphics uniformly. 
    - Our implementation shouldn't have to distinguish between single elements and groups of elements in the internal representation. 
    - Need to analyze the text for such things as spelling errors and potential hyphenation points.

3. A common way to represent hierarchically structured information is through a technique called Recursive Composition, which entails building increasingly complex elements out of simpler ones. 

4. We'll define a Glyph abstract class for all objects that can appear in a document structure. Its subclasses define both primitive graphical elements (like characters and images) and structural elements (like rows and columns). 

5. Composite Pattern

### 2.3 Formatting

1. we'll restrict "formatting" to mean breaking a collection of glyphs into lines. In fact, we'll use the terms "formatting" and "linebreaking" interchangeably.

2. Encapsulating the Formatting Algorithm
    - an important trade-off to consider is the balance between formatting quality and formatting speed.
    - it's also desirable to keep them well-contained or—better yet—completely independent of the document structure.

3. We can isolate the algorithm and make it easily replaceable at the same time by encapsulating it in an object. More specifically, we'll define a separate class hierarchy for objects that encapsulate formatting algorithms. The root of the hierarchy will define an interface that supports a wide range of formatting algorithms, and each subclass will implement the interface to carry out a particular algorithm. Then we can introduce a Glyph subclass that will structure its children automatically using a given algorithm object.

4. Compositor and Composition
    - We'll define a Compositor class for objects that can encapsulate a formatting algorithm. The interface lets the compositor know what glyphs to format and when to do the formatting. 
    - The glyphs it formats are the children of a special Glyph subclass called Composition. A composition gets an instance of a Compositor subclass (specialized for a particular linebreaking algorithm) when it is created, and it tells the compositor to Compose its glyphs when necessary, for example, when the user changes a document.

5. Strategy Pattern

### 2.4 Embellishing the User Interface

1. We consider two embellishments in Lexi's user interface. 
    - The first adds a border around the text editing area to demarcate the page of text. 
    - The second adds scroll bars that let the user view different parts of the page. 

2. Transparent Enclosure
    - transparent enclosure combines the notions of (1) single-child (or single-component) composition and (2) compatible interfaces. 
    - Clients generally can't tell whether they're dealing with the component or its enclosure (i.e., the child's parent), especially if the enclosure simply delegates all its operations to its component. 
    - But the enclosure can also augment the component's behavior by doing 51work of its own before and/or after delegating an operation. The enclosure can also effectively add state to the component. 

3. We'll define a subclass of Glyph called MonoGlyph to serve as an abstract class for "embellishment glyphs," like Border. MonoGlyph stores a reference to a component and forwards all requests to it. That makes MonoGlyph totally transparent to clients by default. （疑问：为什么需要定义MonoGlyph，导致多了一层继承关系？Border和Scroller不可以直接继承Glyph吗？）

4. Decorator Pattern:  In the Decorator pattern, embellishment refers to anything that adds responsibilities to an object.

### 2.5 Supporting Multiple Look-and-Feel standards

1. One obstacle to portability is the diversity of look-and-feel standards, which are intended to enforce uniformity between applications. 

2. Our design goals are to make Lexi conform to multiple existing look-and-feel standards and to make it easy to add support for new standards as they (invariably) emerge. We also want our design to support the ultimate in flexibility: changing Lexi's look and feel at run-time.

3. We'll assume we have two sets of widget glyph classes with which to implement multiple look-and-feel standards: 
    - A set of abstract Glyph subclasses for each category of widget glyph. For example, an abstract class ScrollBar will augment the basic glyph interface to add general scrolling operations; Button is an abstract class that adds buttonoriented operations; and so on. 
    - A set of concrete subclasses for each abstract subclass that implement different look-and-feel standards. For example, ScrollBar might have MotifScrollBar and PMScrollBar subclasses that implement Motif and Presentation Manager-style scroll bars, respectively.

4. Lexi needs a way to determine the look-and-feel standard that's being targeted in order to create the appropriate widgets. Not only must we avoid making explicit constructor calls; we must also be able to replace an entire widget set easily. We can achieve both by abstracting the process of object creation.

5. Abstract Factory Pattern
    - This pattern captures how to create families of related product objects without instantiating classes directly. It's most appropriate when the number and general kinds of product objects stay constant, and there are differences in specific product families
    - The Abstract Factory pattern's emphasis on families of products distinguishes it from other creational patterns, which involve only one kind of product object.

### 2.6 Supporting Multiple Window Systems

1. Suppose we already have several class hierarchies from different vendors, one for each look-and-feel standard. Of course, it's highly unlikely these hierarchies are compatible in any way. Hence we won't have a common abstract product class for each kind of widget (ScrollBar, Button, Menu, etc.)—and the Abstract Factory pattern won't work without those crucial classes. 

2. Encapsulate the concept that varies
    - What varies in this case is the window system implementation. If we encapsulate a window system's functionality in an object, then we can implement our Window class and subclasses in terms of that object's interface. 
    - Moreover, if that interface can serve all the window systems we're interested in, then we won't have to change Window or any of its subclasses to support different window systems.

3. We can define an abstract factory class WindowSystemFactory that provides an interface for creating different kinds of window system-dependent implementation objects.

4. Bridge Pattern: The intent behind Bridge is to allow separate class hierarchies to work together even as they evolve independently. 

### 2.7 User Operations

1. Requirements
    - We don't want to associate a particular user operation with a particular user interface, because we may want multiple user interfaces to the same operation (you can turn the page using either a page button or a menu operation, for example). We may also want to change the interface in the future.
    - We as implementors want to access their functionality without creating a lot of dependencies between implementation and user interface classes. 
    - We want Lexi to support undo and redo of most but not all its functionality. 

2. First we define a Command abstract class to provide an interface for issuing a request. The basic interface consists of a single abstract operation called "Execute." Subclasses of Command implement Execute in different ways to fulfill different requests.

3. Undo/redo
    - Undo/redo is an important capability in interactive applications. To undo and redo commands, we add an Unexecute operation to Command's interface. 
    - To determine if a command is undoable, we add an abstract Reversible operation to the Command interface. Reversible returns a Boolean value. 
    - The final step in supporting arbitrary-level undo and redo is to define a command history, or list of commands that have been executed (or unexecuted, if some commands have been undone). 

4. Command pattern: prescribes a uniform interface for issuing requests that lets you configure clients to handle different requests. 

### 2.8 Spelling Checking and Hyphenation

1. Requirements
    - We want to support multiple algorithms. A diverse set of algorithms can provide a choice of space/time/quality trade-offs. We should make it easy to add new algorithms as well.
    - We also want to avoid wiring this functionality into the document structure. We don't want to change the Glyph class and all its subclasses every time we introduce new functionality of this sort.

2. There are actually two pieces to this puzzle: 
    - accessing the information to be analyzed, which we have scattered over the glyphs in the document structure, and 
    - doing the analysis.

3. Accessing Scattered Information
    - To examine text in such a structure, we need an access mechanism that has knowledge about the data structures in which objects are stored. 
    - An added complication is that different analyses access information in different ways.

4. Once again, a better solution is to encapsulate the concept that varies, in this case the access and traversal mechanisms. We can introduce a class of objects called iterators whose sole purpose is to define different sets of these mechanisms. We can use inheritance to let us access different data structures uniformly and support new kinds of traversals as well. 

5. Iterator Pattern:  captures techniques for supporting access and traversal over object structures.

6. We need to encapsulate the analysis in a separate object. We could use an instance of this class in conjunction with an appropriate iterator. The iterator would "carry" the instance to each glyph in the structure. The analysis object could then perform a piece of the analysis at each point in the traversal.

7. Visitor Pattern
