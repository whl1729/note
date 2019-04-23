# 《Design Pattern》第一章学习笔记

## 1 Introduction

### 1.1 What Is a Design Pattern?

1. Christopher Alexander says, "Each pattern describes a problem which occurs over and over again in our environment, and then describes the core of the solution to that problem, in such a way that you can use this solution a million times over, without ever doing it the same way twice".

2. A pattern has four essential elements
    - pattern name
    - problem
    - solution
    - consequences: the results and trade-offs of applying the pattern

3. The design patterns in this book are descriptions of communicating objects and classes that are customized to solve a general design problem in a particular context.

### 1.2 Design Patterns in Smalltalk MVC

1. The Model/View/Controller (MVC) consists of three kinds of objects. The Model is the application object, the View is its screen presentation, and the Controller defines the way the user interface reacts to user input. 

2. The main relationships in MVC are given by the Observer, Composite, and Strategy design patterns.（伍注：尚未完全理解MVC中使用到的设计模式？）

### 1.5 Organizing the Catalog

1. Patterns can have either creational, structural, or behavioral purpose.
    - Creational patterns concern the process of object creation. 
    - Structural patterns deal with the composition of classes or objects. 
    - Behavioral patterns characterize the ways in which classes or objects interact and distribute responsibility.

2. The called scope specifies whether the pattern applies primarily to classes or to objects. Class patterns deal with relationships between classes and their subclasses. These relationships are established through inheritance, so they are static— fixed at compile-time. Object patterns deal with object relationships, which can be changed at run-time and are more dynamic.

3. Some patterns are often used together. For example, Composite is often used with Iterator or Visitor. Some patterns are alternatives: Prototype is often an alternative to Abstract Factory. Some patterns result in similar designs even though the patterns have different intents. For example, the structure diagrams of Composite and Decorator are similar.

### 1.6 How Design Patterns Solve Design Problems

1. How Design Patterns Solve Design Problems
    - Finding Appropriate Objects
    - Determining Object Granularity
    - Specifying Object Interfaces
    - Specifying Object Implementations
    - Putting Reuse Mechanisms to Work
        - Inheritance
        - Composition
        - Delegation
    - Relating Run-Time and Compile-Time Structures
    - Designing for Change

2. Principles of reusable object-oriented design
    - Program to an interface, not an implementation.
    - Favor object composition over class inheritance.

3. Here are some common causes of redesign
    - Creating an object by specifying a class explicitly
    - Dependence on specific operations
    - Dependence on hardware and software platform
    - Dependence on object representations or implementations
    - Algorithmic dependencies
    - Tight coupling
    - Extending functionality by subclassing
    - Inability to alter classes conveniently

4. When you use a toolkit (or a conventional subroutine library for that matter), you write the main body of the application and call the code you want to reuse. When you use a framework, you reuse the main body and write the code it calls. 

### 1.8 How to Use a Design Pattern

1. Design patterns should not be applied indiscriminately. Often they achieve flexibility and variability by introducing additional levels of indirection, and that can complicate a design and/or cost you some performance. A design pattern should only be applied when the flexibility it affords is actually needed. 
