# The Python Library

## Functions

### @classmethod

1. `@classmethod` Transform a method into a class method.

2. A class method receives the class as implicit first argument, just like an instance method receives the instance. To declare a class method, use this idiom:
```
class C:
    @classmethod
    def f(cls, arg1, arg2, ...): ...
```

3. A class method can be called either on the class (such as C.f()) or on an instance (such as C().f()). The instance is ignored except for its class. If a class method is called for a derived class, the derived class object is passed as the implied first argument.

4. One use people have found for class methods is to create inheritable alternative constructors.

