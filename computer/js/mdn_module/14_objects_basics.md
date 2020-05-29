# JavaScript MDN

## 14 JavaScript object basics

### Object basics

1. An object is a collection of related data and/or functionality (which usually consists of several variables and functions -- which are called **properties** and **methods** when they are inside objects.)

2. Object literal
    - When we define an **object literal**, we've literally written out the object contents as we've come to create it.
    - It is very common to create an object using an object literal when you want to transfer a series of structured, related data items in some manner, for example sending a request to the server to be put into a database.
    - Sending a single object is much more efficient than sending several items individually, and it is easier to work with than an array, when you want to identify individual items by name.

3. The object name (person) acts as the namespace -- it must be entered first to access anything encapsulated inside the object.

4. Bracket notation
    - There is another way to access object properties -- using **bracket notation**.
    - It is no wonder that objects are sometimes called **associative arrays** -- they map strings to values in the same way that arrays map numbers to values.
    - One useful aspect of bracket notation is that it can be used to set not only member values dynamically, but **member names** too.

### You've been using objects all along

1. For each webpage loaded, an instance of Document is created, called document, which represents the entire page's structure, content, and other features such as its URL. Again, this means that it has several common methods and properties available on it.

2. It is useful to think about the way objects communicate as **message passing** -- when an object needs another object to perform some kind of action often it sends a message to another object via one of its methods, and waits for a response, which we know as a return value.
