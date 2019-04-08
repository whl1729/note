# 《C++ Primer》学习笔记

## 16 Templates and Generic Programming

1. OOP vs Generic Programming
    - Both object-oriented programming (OOP) and generic programming deal with types that are not known at the time the program is written. 
    - The distinction between the two is that OOP deals with types that are not known until run time, whereas in generic programming the types become known during compilation.

2. Templates are the foundation of generic programming. 

### Defining a Template

#### Function Templates
1. A template definition starts with the keyword template followed by a template parameter list, which is a comma-separated list of one or more template parameters bracketed by the less-than (<) and greater-than (>) tokens.

2. Instantiating a Function Template: When we call a function template, the compiler (ordinarily) uses the arguments of the call to deduce the template argument(s) for us, and then uses the deduced template parameter(s) to instantiate a specific version of the function for us. 

3. Each type parameter must be preceded by the keyword class or typename. These keywords have the same meaning and can be used interchangeably inside a template parameter list. A template parameter list can use both keywords.

4. We can define templates that take nontype parameters. A nontype parameter represents a value rather than a type. Nontype parameters are specified by using a specific type name instead of the class or typename keyword. Template arguments used for nontype template parameters must be constant expressions.

5. A function template can be declared inline or constexpr in the same ways as nontemplate functions. The inline or constexpr specifier follows the template parameter list and precedes the return type.

6. Template programs should try to minimize the number of requirements placed on the argument types.
    - By making the function parameters references to const, we ensure that our function can be used on types that cannot be copied. 
    - By writing the code using only the < operator, we reduce the requirements on types that can be used with our compare function. 

7. Template Compilation
    - When the compiler sees the definition of a template, it does not generate code. It generates code only when we instantiate a specific instance of the template.
    - To generate an instantiation, the compiler needs to have the code that defines a function template or class template member function. As a result, unlike nontemplate code, headers for templates typically include definitions as well as declarations. （没读懂？为什么模板的声明和定义要放在一起？）

8. Compilation Errors Are Mostly Reported during Instantiation. In general, there are three stages during which the compiler might flag an error. 
    - The first stage is when we compile the template itself. The compiler can detect syntax errors—such as forgetting a semicolon or misspelling a variable name—but not much else. 
    - The second error-detection time is when the compiler sees a use of the template. For a call to a function template, the compiler typically will check that the number of the arguments is appropriate. It can also detect whether two arguments that are supposed to have the same type do so. For a class template, the compiler can check that the right number of template arguments are provided but not much more. 
    - The third time when errors are detected is during instantiation. It is only then that type-related errors can be found. Depending on how the compiler manages instantiation, these errors may be reported at link time.

9. Warning: It is up to the caller to guarantee that the arguments passed to the template support any operations that template uses, and that those operations behave correctly in the context in which the template uses them.

#### Class Templates

1. Class templates differ from function templates in that the compiler cannot deduce the template parameter type(s) for a class template. Instead, as we’ve seen many times, to use a class template we must supply additional information inside angle brackets following the template’s name.

2. Each instantiation of a class template constitutes an independent class. The type Blob\<string\> has no relationship to, or any special access to, the members of any other Blob type.

3. A member function defined outside the class template body starts with the keyword template followed by the class’ template parameter list.
```
template <typename T>
ret-type Blob<T>::member-name(parm-list)
```

4. By default, a member of an instantiated class template is instantiated only if the member is used.

5. There is one exception to the rule that we must supply template arguments when we use a class template type. Inside the scope of the class template itself, we may use the name of the template without arguments

6. Class Templates and Friends
    - A class template that has a nontemplate friend grants that friend access to all the instantiations of the template. 
    - When the friend is itself a template, the class granting friendship controls whether friendship includes all instantiations of the template or only specific instantiation(s).
    - ***In order to refer to a specific instantiation of a template (class or function) we must first declare the template itself.***
    - To allow all instantiations as friends, the friend declaration must use template parameter(s) that differ from those used by the class itself.
    - Under the new standard, we can make a template type parameter a friend.

7. Template Type Aliases
```
typedef Blob<string> StrBlob;  // ok
typedef Blob<T> SomeBlob;  // error. We cannot define a typedef that refer to a template.
template<typename T> using twin = pair<T, T>  // ok.
template<typename T> using partNo = pair<T, unsigned>  / ok.
```

8. There must be exactly one definition of each static data member of a template class. However, there is a distinct object for each instantiation of a class template. As a result, we define a static data member as a template similarly to how we define the member functions of that template.

#### Template Parameters

1. Template Parameters and Scope
    - Template parameters follow normal scoping rules.
    - A name used as a template parameter may not be reused within the template.

2. Declarations for all the templates needed by a given file usually should appear together at the beginning of a file before any code that uses those names.

3. Using Class Members That Are Types
    - We use the scope operator (::) to access both static members and type members.
    - ***By default, the language assumes that a name accessed through the scope operator is not a type. If we want to use a type member of a template type parameter, we must explicitly tell the compiler that the name is a type. We do so by using the keyword typename.***

4. Whenever we use a class template, we must always follow the template’s name with brackets. The brackets indicate that a class must be instantiated from a template. In particular, if a class template provides default arguments for all of its template parameters, and we want to use those defaults, we must put an empty bracket pair following the template’s name.


#### Member Templates, Controlling Instantiations, Efficiency and Flexibility

1. When we define a member template outside the body of a class template, we must provide the template parameter list for the class template and for the function template. The parameter list for the class template comes first, followed by the member’s own template parameter list:
```
template <typename T> // type parameter for the class
template <typename It> // type parameter for the constructor
Blob<T>::Blob(It b, It e): data(std::make_shared<std::vector<T>>(b, e)) {}
```

2. An explicit instantiation has the form
```
extern template declaration; // instantiation declaration
template declaration; // instantiation definition
```
where declaration is a class or function declaration in which all the template parameters are replaced by the template arguments. 

3. There must be an explicit instantiation definition somewhere in the program for every instantiation declaration.

4. An instantiation definition can be used only for types that can be used with every member function of a class template.

5. By binding the deleter at compile time, unique_ptr avoids the run-time cost of an indirect call to its deleter. By binding the deleter at run time, shared_ptr makes it easier for users to override the deleter.

### Template Argument Deduction

1. The only other conversions performed in a call to a function template are 
    - const conversions: A function parameter that is a reference (or pointer) to a const can be passed a reference (or pointer) to a nonconst object. 
    - Array- or function-to-pointer conversions: If the function parameter is not a reference type, then the normal pointer conversion will be applied to arguments of array or function type. An array argument will be converted to a pointer to its first element. Similarly, a function argument will be converted to a pointer to the function’s type. 
    - Other conversions, such as the arithmetic conversions, derived-tobase, and user-defined conversions, are not performed.

2. A template type parameter can be used as the type of more than one function parameter. Because there are limited conversions, the arguments to such parameters must have essentially the same type.

3. Normal conversions are applied to arguments whose type is not a template parameter.

4. Explicit template argument(s) are matched to corresponding template parameter(s) from left to right. An explicit template argument may be omitted only for the trailing (right-most) parameters, and then only if these can be deduced from the function parameters.

5. If we explicitly specify the template parameter type, normal conversions apply. 

6. Sometimes we might want to write a function that takes a pair of iterators denoting a sequence and returns a reference to an element in the sequence, we can use a trailing return type. Because a trailing return appears after the parameter list, it can use the function’s parameters

7. Sometimes we do not have direct access to the type that we need, we can use a library type transformation template to obtain certain types. Each template has a public member named type that represents a type. If it is not possible (or not necessary) to transform the template’s parameter, the type member is the template parameter type itself.
```
remove_reference
add_const
add_lvalue_reference
add_rvalue_reference
remove_pointer
add_pointer
make_signed
make_unsigned
remove_extent: X[n] -> X
remove_all_extents: X[n1][n2]... -> X
```

8. Function Pointers and Argument Deduction
    - When we initialize or assign a function pointer from a function template, the compiler uses the type of the pointer to deduce the template argument(s).
    - It is an error if the template arguments cannot be determined from the function pointer type
    - We can disambiguate the call by using explicit template arguments.

9. Type Deduction from Lvalue Reference Function Parameters
    - When a function parameter is an ordinary (lvalue) reference to a template type parameter (i.e., that has the form T&), we can pass only an lvalue (e.g., a variable or an expression that returns a reference type).
    - If a function parameter has type const T&, normal binding rules say that we can pass any kind of argument—an object (const or otherwise), a temporary, or a literal value. 

10. Two exceptions to normal binding rules that allow bind an rvalue reference to an lvalue
    - When we pass an lvalue (e.g., i) to a function parameter that is an rvalue reference to a template type parameter (e.g, T&&), the compiler deduces the template type parameter as the argument’s lvalue reference type.
    - If we indirectly create a reference to a reference, then those references “collapse.” 
        - X& &, X& &&, and X&& & all collapse to type X&
        - The type X&& && collapses to X&&

11. An argument of any type can be passed to a function parameter that is an rvalue reference to a template parameter type (i.e., T&&). When an lvalue is passed to such a parameter, the function parameter is instantiated as an ordinary, lvalue reference (T&).

12. The fact that the template parameter can be deduced to a reference type can have surprising impacts on the code inside the template. It is surprisingly hard to write code that is correct when the types involved might be plain (nonreference) types or reference types (although the type transformation classes such as remove_reference can help).

13. In practice, rvalue reference parameters are used in one of two contexts: Either the template is forwarding its arguments, or the template is overloaded.

14. Even though we cannot implicitly convert an lvalue to an rvalue reference, we can explicitly cast an lvalue to an rvalue reference using static_cast.

15. std::forward
    - Forward returns an rvalue reference to that explicit argument type. That is, the return type of forward<T> is T&&.
    - We can preserve all the type information in an argument by defining its corresponding function parameter as an rvalue reference to a template type parameter. 
    - As with std::move, it’s a good idea not to provide a using declaration for std::forward.

### Overloading and Templates

1. Function matching is affected by the presence of function templates in the following ways: 
    - The candidate functions for a call include any function-template instantiation for which template argument deduction succeeds. 
    - As usual, the viable functions (template and nontemplate) are ranked by the conversions, if any, needed to make the call. 
    - Also as usual, if exactly one function provides a better match than any of the others, that function is selected. 
    - However, if there are several functions that provide an equally good match, then: 
        - If there is only one nontemplate function in the set of equally good matches, the nontemplate function is called. 
        - If there are no nontemplate functions in the set, but there are multiple function templates, and one of these templates is more specialized than any of the others, the more specialized function template is called. 
        - Otherwise, the call is ambiguous.

2. Declare every function in an overload set before you define any of the functions. That way you don’t have to worry whether the compiler will instantiate a call before it sees the function you intended to call.

### Variadic Templates

1. Template Parameter Pack vs Function Parameter Pack
```
template <typename T, typename... Args>
void foo(const T &t, const Args& ... rest);
```

2. sizeof... returns how many elements there are in a pack
```
template<typename ... Args> void g(Args ... args) {
    cout << sizeof...(Args) << endl; // number of type parameters
    cout << sizeof...(args) << endl; // number of function parameters
}
```

3. initializer_list vs Variadic Function
    - The arguments of initializer_list must have the same type (or types that are convertible to a common type). 
    - Variadic functions are used when we know neither the number nor the types of the arguments we want to process. 

4. Variadic functions are often recursive. The first call processes the first argument in the pack and calls itself on the remaining arguments.

5. A declaration for the nonvariadic version of print must be in scope when the variadic version is defined. Otherwise, the variadic function will recurse indefinitely.

6. The pattern in an expansion applies separately to each element in the pack.
```
template <typename T> string debug_rep(const T &t);
template <typename T, typename... Args>
    ostream &print(ostream &os, const T &t, const Args&... rest);
print(os, debug_rep(rest)...);  // ok
print(os, debug_rep(rest...));  // error
```

### Template Specializations

1. Specializations instantiate a template; they do not overload it. As a result, specializations do not affect function matching.

2. To indicate that we are specializing a template, we use the keyword template followed by an empty pair of angle brackets (< >). The empty brackets indicate that arguments will be supplied for all the template parameters of the original template.

3. Specializations instantiate a template; they do not overload it. As a result, specializations do not affect function matching.

4. Templates and their specializations should be declared in the same header file. Declarations for all the templates with a given name should appear first, followed by any specializations of those templates.

5. We can partially specialize only a class template. We cannot partially specialize a function template.

### TODO

1. Exercise 16.28 ~ 16.30
2. Exercise 16.61
