# JavaScript Modules

## 1 What is JavaScript?

1. JavaScript (JS) is a lightweight, interpreted, or just-in-time compiled programming language with **first-class** functions.

> A programming language is said to have First-class functions when functions in that language are treated like any other variable. For example, in such a language, a function can be passed as an argument to other functions, can be returned by another function and can be assigned as a value to a variable.

2. JavaScript is a prototype-based, multi-paradigm, single-threaded, dynamic language, supporting object-oriented, imperative, and declarative (e.g. functional programming) styles.

3. Objects are created programmatically in JavaScript, by attaching methods and properties to otherwise empty objects at run time, as opposed to the syntactic class definitions common in compiled languages like C++ and Java. Once an object has been constructed it can be used as a blueprint (or prototype) for creating similar objects.

4. JavaScript's dynamic capabilities include runtime object construction, variable parameter lists, function variables, dynamic script creation (via eval), object introspection (via for ... in), and source code recovery (JavaScript programs can decompile function bodies back into their source text). (Question: what are dynamic script creation, object introspection and source code recovery?)

### So what can it really do?

1. So-called Application Programming Interfaces (APIs) provide you with extra superpowers to use in your JavaScript code. They generally fall into two categories.
    - **Browers APIs** are built into your web browser, and are able to expose data from the surrounding computer environment, or do useful complex things.
    - **Third party APIs** are not built into the browser by default, and you generally have to grab their code and information from somewhere on the Web.

### What is JavaScript doing on your page?

1. A very common use of JavaScript is to dynamically modify HTML and CSS to update a user interface, via the Document Object Model API (as mentioned above). Note that the code in your web documents is generally loaded and executed in the order it appears on the page. If the JavaScript loads and tries to run before the HTML and CSS it is affecting has been loaded, errors can occur.

2. From a technical standpoint, most modern JavaScript interpreters actually use a technique called **just-in-time compiling** to improve performance; the JavaScript source code gets compiled into a faster, binary format while the script is being used, so that it can be run as quickly as possible. However, JavaScript is still considered an interpreteted language, since the compilation is handled at run time, rather than ahead of time.

### How do you add JavaScript to your page?

1. There are a number of issues involved with getting scripts to load at the right time. Nothing is as simple as it seems! A common problem is that all the HTML on a page is loaded in the order in which it appears. If you are using JavaScript to manipulate elements on the page (or more accurately, the Document Object Model), your code won't work if the JavaScript is loaded and parsed before the HTML you are trying to do something to.

2. In the external example, we use a more modern JavaScript feature to solve the problem, the defer attribute, which tells the browser to continue downloading the HTML content once the `<script>` tag element has been reached.
```
<script src="script.js" defer></script>
```

3. There are actually two modern features we can use to bypass the problem of the blocking script — `async` and `defer`.
    - `async` and defer both instruct the browser to download the script(s) in a separate thread, while the rest of the page (the DOM, etc.) is downloading, so the page loading is not blocked by the scripts.
    - If your scripts should be run immediately and they don't have any dependencies, then use `async`.
    - If your scripts need to wait for parsing and depend on other scripts and/or the DOM being in place, load them using `defer` and put their corresponding `<script>` elements in the order you want the browser to execute them.
