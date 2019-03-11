# 《C++ Primer》第5章学习笔记

## Statements

1. Advice: Null statements should be commented. That way anyone reading the code can see that the statement was omitted intentionally.

2. Warning: Extraneous null statements are not always harmless.
```
// disaster: extra semicolon: loop body is this null statement
while (iter != svec.end()) ; // the while body is the empty statement
    ++iter; // increment is not part of the loop
```

3. A compound statement, usually referred to as a block, is a (possibly empty) sequence of statements and declarations surrounded by a pair of curly braces. A block is a scope.

4. Most statements in C++ end with a semicolon. But there is also exception: A block is not terminated by a semicolon.

5. We also can define an empty block by writing a pair of curlies with no statements. An empty block is equivalent to a null statement.

6. Advice: Watch your Braces
    - some coding styles recommend always using braces after an if or an else (and also around the bodies of while and for statements). Doing so avoids any possible confusion. It also means that the braces are already in place if later modifications of the code require adding statements.
    - Many editors and development environments have tools to automatically indent source code to match its structure. It is a good idea to use such tools if they are available.

7. Dangling else:  In C++ the ambiguity is resolved by specifying that each else is matched with the closest preceding unmatched if.

8. If the expression matches the value of a case label, execution begins with the first statement following that label. Execution continues normally from that statement through the end of the switch or until a break statement.

9. case labels must be integral constant expressions

10. Advice: Omitting a break at the end of a case happens rarely. If you do omit a break, include a comment explaining the logic.

11. Advice: Although it is not necessary to include a break after the last label of a switch, the safest course is to provide one. That way, if an additional case is added later, the break is already in place.

12. Advice: It can be useful to define a default label even if there is no work for the default case. Defining an empty default section indicates to subsequent readers that the case was considered.

13. The operator>> eats whitespace (space, tab, newline). Use yourstream.get() to read each character. or use `cin >> std::noskipws >> ch`.

14. Variables defined in a while condition or while body are created and destroyed on each iteration.

15. A while loop is generally used when we want to iterate indefinitely, such as when we read input. A while is also useful when we want access to the value of the loop control variable after the loop finishes.

16. A for header can omit any (or all) of init-statement, condition, or expression.

17. Range for statement: expression must represent a sequence, such as a braced initializer list, an array, or an object of a type such as vector or string that has begin and end members that return iterators
```
for (declaration : expression)
    statement
```

18. In a range for, the value of end() is cached. If we add elements to (or remove them from) the sequence, the value of end might be invalidated.

19. A do while ends with a semicolon after the parenthesized condition.

20. Because the condition is not evaluated until after the statement or block is executed, the do while loop does not allow variable definitions inside the condition.

21. A break statement terminates the nearest enclosing while, do while, for, or switch statement. Execution resumes at the statement immediately following the terminated statement. A break can appear only within an iteration statement or switch statement (including inside statements or blocks nested inside such loops). A break affects only the nearest enclosing loop or switch.

22. A continue statement terminates the current iteration of the nearest enclosing loop and immediately begins the next iteration. A continue can appear only inside a for, while, or do while loop, including inside statements or blocks nested inside such loops. Like the break statement, a continue inside a nested loop affects only the nearest enclosing loop. Unlike a break, a continue may appear inside a switch only if that switch is embedded inside an iterative statement.

23. Advice: Programs should not use gotos. gotos make programs hard to understand and hard to modify.

24. In C++, exception handling involves
    - throw expressions, which the detecting part uses to indicate that it encountered something it can’t handle. We say that a throw raises an exception. 
    - try blocks, which the handling part uses to deal with an exception. A try block starts with the keyword try and ends with one or more catch clauses.C++ Primer, Fifth Edition Exceptions thrown from code executed inside a try block are usually handled by one of the catch clauses. Because they “handle” the exception, catch clauses are also known as exception handlers. 
    - A set of exception classes that are used to pass information about what happened between a throw and an associated catch.

25. The search for a handler reverses the call chain. If no appropriate catch is found, execution is transferred to a library function named terminate. The behavior of that function is system dependent but is guaranteed to stop further execution of the program. If a program has no try blocks and an exception occurs, then terminate is called and the program is exited.

26. Caution: Writing Exception Safe Code is Hard. Programs that properly “clean up” during exception handling are said to be exception safe. Programs that do handle exceptions and continue processing generally must be constantly aware of whether an exception might occur and what the program must do to ensure that objects are valid, that resources don’t leak, and that the program is restored to an appropriate state.

27. The C++ library defines several classes that it uses to report problems encountered in the functions in the standard library. These classes are defined in four headers:
    - The exception header defines the most general kind of exception class named exception. It communicates only that an exception occurred but provides no additional information.
    - The stdexcept header defines several general-purpose exception classes.
    - The new header defines the bad_alloc exception type.
    - The type_info header defines the bad_cast exception type.

28. Initialize objects of exception types:
    - We can only default initialize exception, bad_alloc, and bad_cast objects; it is not possible to provide an initializer for objects of these exception types.
    - The other exception types have the opposite behavior: We can initialize those objects from either a string or a C-style string, but we cannot default initialize them.

29. The exception types define only a single operation named what. The purpose of this C-style character string is to provide some sort of textual description of the exception thrown.

## 疑问

1. 异常处理try-catch机制的实现原理？

