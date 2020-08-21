# 《The Roots of Lisp》学习笔记

1. In 1960, John McCarthy published a remarkable paper in which he did for programming something like what Euclid did for geometry. He showed how, given a handful of simple operators and a notation for functions, you can build a whole programming language. He called this language Lisp, for "List Processing," because one of his key ideas was to **use a simple data structure called a list for both code and data**.

2. The unusual thing about Lisp — in fact, the defining quality of Lisp — is that **it can be written in itself**.

## 1 Seven Primitive Operators

1. An **expression** is either an **atom**, which is s swquence of letters, or a **list** of zero or more expressions, separated by whitespace and enclosed by parentheses.

2. If an expression e yields a value v we say that **e returns v**.

3. If an expression is a list, we call the first element the **operator** and the remaining elements the **arguments**.

4. seven primitive operators: **quote, atom, eq, car, cdr, cons, cond**.

5. quote
    - `(quote x)` returns x.
    - We will abbreviate `(quote x)` as `'x`.
    - By quoting a list we protest it from evaluation.
    - `Quote` is closely tied to one of the most distinctive featuresA of Lisp: code and data are made out of the same data structures, and the quote operator is the way we distinguish between them.

6. `(atom x)` returns the atom **t** if the value of x is an atom or the empty list. Otherwise it returns (). In Lisp we conventionally use the atom t to represent truth, and the empty list to represent falsity.

7. `(eq x y)` returns t if the values of x and y are the same atom or both the empty list, and () otherwise.

8. `(car x)` expects the value of x to be a list, and returns its first element.

9. `(cdr x)` expects the value of x to be a list, and returns everything after the first element.

10. `(cons x y)` expects the value of y to be a list, and returns a list containing the value of x followed by the elements of the value of y.

11. `(cond (p1 e1) ... (pn en))` is evaluated as follows. The p expressions are evaluated in order until one returns t. When one is found, the value of the corresponding e expression is returned ad the value of the whole cond expression.

## 2 Denoting Functions

1. A **function** is expressed as `(lambda (p1 ... pn) e)`, where p1 ... pn are atoms (called parameters) and e is an expression.
