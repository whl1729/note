# The Python Tutorial

## 8 Errors and Exceptions

1. There are (at least) two distinguishable kinds of errors: syntax errors and exceptions.

2. Errors detected during execution are called exceptions and are not unconditionally fatal: you will soon learn how to handle them in Python programs. Most exceptions are not handled by programs, however, and result in error messages.

### 8.3 Handling Exceptions

1. The try statement works as follows.
    - First, the try clause (the statement(s) between the try and except keywords) is executed.
    - If no exception occurs, the except clause is skipped and execution of the try statement is finished.
    - If an exception occurs during execution of the try clause, the rest of the clause is skipped. Then if its type matches the exception named after the except keyword, the except clause is executed, and then execution continues after the try statement.
    - If an exception occurs which does not match the exception named in the except clause, it is passed on to outer try statements; if no handler is found, it is an unhandled exception and execution stops with a message as shown above.

2. An except clause may name multiple exceptions as a parenthesized tuple, for example:
```
... except (RuntimeError, TypeError, NameError):
...     pass
```

3. A class in an except clause is compatible with an exception if it is the same class or a base class thereof (but not the other way around — an except clause listing a derived class is not compatible with a base class).（伍注：抛出derived exception可以被base exception接收，反之则不可以）

4. The last except clause may omit the exception name(s), to serve as a wildcard. Use this with extreme caution, since it is easy to mask a real programming error in this way! It can also be used to print an error message and then re-raise the exception (allowing a caller to handle the exception as well).

5. The `try … except` statement has an optional `else` clause, which, when present, must follow all except clauses. It is useful for code that must be executed if the try clause does not raise an exception.

6. The use of the `else` clause is better than adding additional code to the try clause because it avoids accidentally catching an exception that wasn’t raised by the code being protected by the `try … except` statement. (Question: not understand? 是指additional code可能抛出其他异常吗？）

7. The except clause may specify a variable after the exception name. The variable is bound to an exception instance with the arguments stored in instance.args. For convenience, the exception instance defines `__str__()` so the arguments can be printed directly without having to reference .args. One may also instantiate an exception first before raising it and add any attributes to it as desired.

8. Exception handlers don’t just handle exceptions if they occur immediately in the try clause, but also if they occur inside functions that are called (even indirectly) in the try clause.

### 8.4. Raising Exceptions

1. The sole argument to raise indicates the exception to be raised. This must be either an exception instance or an exception class (a class that derives from Exception). If an exception class is passed, it will be implicitly instantiated by calling its constructor with no arguments.

2. If you need to determine whether an exception was raised but don’t intend to handle it, a simpler form of the raise statement allows you to re-raise the exception.

### 8.5. User-defined Exceptions

1. When creating a module that can raise several distinct errors, a common practice is to create a base class for exceptions defined by that module, and subclass that to create specific exception classes for different error conditions.

2. Most exceptions are defined with names that end in “Error”, similar to the naming of the standard exceptions.

### 8.6. Defining Clean-up Actions

1. If a finally clause is present, the finally clause will execute as the last task before the try statement completes. The finally clause runs whether or not the try statement produces an exception. The following points discuss more complex cases when an exception occurs:
    - If an exception occurs during execution of the try clause, the exception may be handled by an except clause. If the exception is not handled by an except clause, the exception is re-raised after the finally clause has been executed.
    - An exception could occur during execution of an except or else clause. Again, the exception is re-raised after the finally clause has been executed.
    - If the try statement reaches a break, continue or return statement, the finally clause will execute just prior to the break, continue or return statement’s execution.
    - If a finally clause includes a return statement, the returned value will be the one from the finally clause’s return statement, not the value from the try clause’s return statement.

2. In real world applications, the finally clause is useful for releasing external resources (such as files or network connections), regardless of whether the use of the resource was successful.

### 8.7. Predefined Clean-up Actions

1. Some objects define standard clean-up actions to be undertaken when the object is no longer needed, regardless of whether or not the operation using the object succeeded or failed. For example, the `with` statement allows objects like files to be used in a way that ensures they are always cleaned up promptly and correctly.
