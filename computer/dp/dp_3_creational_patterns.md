# 《Design Patterns》第3章学习笔记

## 3 Creational Patterns

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
