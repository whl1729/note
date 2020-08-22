# The Art of Unix Programming

## Chapter 4 Modularity

> There are two ways of constructing a software design. One is to make it so simple that there are obviously no deficiencies; the other is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult.

> -- C. A. R. Hoare The Emperor's Old Clothes, CACM February 1981

1. How hierarchy of code-partitioning methods evolves
    - one big lump of machine code
    - subroutine
    - service libraries
    - separated address spaces and communicating processes
    - distribute program systems

2. The Rule of Modularity bears amplification here: **The only way to write complex software that won't fall on its face is to build it out of simple modules connected by well-defined interfaces, so that most problems are local and you can have some hope of fixing or optimizing a part without breaking the whole.**

## 4.1 Encapsulation and Optimal Module Size

1. Well-encapsulated modules don't expose their internals to each other. They don't call into the middle of each others' implementations, and they don't promiscuously share global data. They communicate using **application programming interfaces (APIs)** — narrow, well-defined sets of procedure calls and data structures.

2. One good test for whether an API is well designed is this one: **if you try to write a description of it in purely human language (with no source-code extracts allowed), does it make sense?** It is a very good idea to get into the habit of writing informal descriptions of your APIs before you code them. Indeed, some of the most able developers start by defining their interfaces, writing brief comments to describe them, and then writing the code — since the process of writing the comment clarifies what the code must do. Such descriptions help you organize your thoughts, they make useful module comments, and eventually you might want to turn them into a roadmap document for future readers of the code.

3. When one plots defect density versus module size, the curve is **U-shaped** and concave upwards. Very small and very large modules are associated with more bugs than those of intermediate size.

4. In nonmathematical terms, Hatton's empirical results imply a sweet spot **between 200 and 400 logical lines** of code that minimizes probable defect density, all other factors (such as programmer skill) being equal. This size is independent of the language being used.

## 4.2 Compactness and Orthogonality

### 4.2.1 Compactness

1. Compactness is the property that **a design can fit inside a human being's head**. A good practical test for compactness is this: Does an experienced user normally need a manual? If not, then the design (or at least the subset of it that covers normal use) is compact.

2. **The Magical Number Seven, Plus or Minus Two: Some Limits on Our Capacity for Processing Information** is one of the foundation papers in cognitive psychology. It showed that the number of discrete items of information human beings can hold in short-term memory is seven, plus or minus two. This gives us a good rule of thumb for evaluating the compactness of APIs: Does a programmer have to remember more than seven entry points? Anything larger than this is unlikely to be strictly compact.

3. Noncompact designs are not automatically doomed or bad, however. Some problem domains are simply too complex for a compact design to span them. Sometimes it's necessary to trade away compactness for some other virtue, like raw power and range. Troff markup is a good example of this. So is the BSD sockets API.

### 4.2.2 Orthogonality

1. Orthogonality is one of the most important properties that can help make even complex designs compact. In a purely orthogonal design, operations do not have side effects; each action (whether it's an API call, a macro invocation, or a language operation) changes just one thing without affecting others. There is one and only one way to change each property of whatever system you are controlling.

2. The problems with non-orthogonality arise when **side effects** complicate a programmer's or user's mental model, and beg to be forgotten, with results ranging from inconvenient to dire. Even when you do not forget the side effects, you're often forced to do extra work to suppress them or work around them.

### 4.2.3 The SPOT Rule

1. The **SPOT(Single Point Of Truth)** rule(similar to **"Dont't Repeat Yourself"** rule): every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

2. Constants, tables, and metadata should be declared and initialized once and imported elsewhere. **Any time you see duplicate code, that's a danger sign.** Complexity is a cost; don't pay it twice.

3. Often it's possible to **remove code duplication by refactoring**; that is, changing the organization of your code without changing the core algorithms.

4. Data duplication sometimes appears to be forced on you. But when you see it, here are some valuable questions to ask:
    - If you have duplicated data in your code because it has to have two different representations in two different places, can you write a function, tool or code generator to make one representation from the other, or both from a common source?
    - If your documentation duplicates knowledge in your code, can you generate parts of the documentation from parts of the code, or vice-versa, or both from a common higher-level representation?
    - If your header files and interface declarations duplicate knowledge in your implementation code, is there a way you can generate the header files and interface declarations from the code?

5. There is an analog of the SPOT rule for data structures: "**No junk, no confusion**".

6. From deeper within the Unix tradition, we can add some of our own corollaries of the SPOT rule:
    - Are you duplicating data because you're caching intermediate results of some computation or lookup? Consider carefully whether this is premature optimization; stale caches (and the layers of code needed to keep caches synchronized) are a fertile source of bugs, and can even slow down overall performance if (as often happens) the cache-management overhead is higher than you expected.
    - If you see lots of duplicative boilerplate code, can you generate all of it from a single higher-level representation, twiddling a few knobs to generate the different cases?

### 4.2.4 Compactness and the Strong Single Center

1. One subtle but powerful way to promote compactness in a design is to organize it around a **strong core algorithm** addressing a clear formal definition of the problem, avoiding heuristics and fudging.

> Formalization often clarifies a task spectacularly. It is not enough for a programmer to recognize that bits of his task fall within standard computer-science categories — a little depth-first search here and a quicksort there. The best results occur when the nub of the task can be formalized, and a clear model of the job at hand can be constructed. It is not necessary that ultimate users comprehend the model. The very existence of a unifying core will provide a comfortable feel, unencumbered with the why-in-hell-did-they-do-that moments that are so prevalent in using Swiss-army-knife programs.

> -- Doug McIlroy

### 4.2.5 The Value of Detachment

1. One of the famous quotes from that paper observes "...constraint has encouraged not only economy, but also a certain elegance of design". That simplicity came from trying to think not about how much a language or operating system could do, but of how little it could do — not by carrying assumptions but by starting from zero.

## 4.3 Software Is a Many-Layered Thing

1. Broadly speaking, there are two directions one can go in designing a hierarchy of functions or objects.
    - Bottom-up, from concrete to abstract — working up from the specific operations in the problem domain that you know you will need to perform.
    - Top-down, abstract to concrete — from the highest-level specification describing the project as a whole, or the application logic, downwards to individual operations.

2. Top-down tends to be good practice when three preconditions are true: (a) you can specify in advance precisely what the program is to do, (b) the specification is unlikely to change significantly during implementation, and (c) you have a lot of freedom in choosing, at a low level, how the program is to get that job done.

3. Unix programmers inherit a tradition that is centered in systems programming, where the low-level primitives are hardware-level operations that are fixed in character and extremely important. They therefore lean, by learned instinct, more toward **bottom-up** programming.

4. The top layer of application logic and the bottom layer of domain primitives have to be impedance-matched by a layer of **glue** logic.

5. One of the lessons Unix programmers have learned over decades is that glue is nasty stuff and that it is vitally important to **keep glue layers as thin as possible**. Glue should stick things together, but should not be used to hide cracks and unevenness in the layers.

> "Perfection is attained not when there is nothing more to add, but when there is nothing more to remove." -- Antoine de Saint-Exupéry

## 4.4 Libraries

1. An important form of library layering is the **plugin**, a library with a set of known entry points that is dynamically loaded after startup time to perform a specialized task. For plugins to work, the calling program has to be organized largely as a documented service library that the plugin can call back into.

## 4.5 Unix and Object-Oriented Languages

1. OO languages make abstraction easy — perhaps too easy. **They encourage architectures with thick glue and elaborate layers.** This can be good when the problem domain is truly complex and demands a lot of abstraction, but it can backfire badly if coders end up doing simple things in complex ways just because they can.

2. Too many layers destroy transparency: It becomes too difficult to see down through them and mentally model what the code is actually doing.

3. Another side effect of OO abstraction is that opportunities for optimization tend to disappear.

4. One reason that OO has succeeded most where it has (GUIs, simulation, graphics) may be because it's relatively difficult to get the ontology of types wrong in those domains. In GUIs and graphics, for example, there is generally a rather natural mapping between manipulable visual objects and classes. If you find yourself proliferating classes that have no obvious mapping to what goes on in the display, it is correspondingly easy to notice that **the glue has gotten too thick**.

5. One of the central challenges of design in the Unix style is how to **combine the virtue of detachment (simplifying and generalizing problems from their original context) with the virtue of thin glue and shallow, flat, transparent hierarchies of code and design**.

## 4.6 Coding for Modularity

1. Here are some questions to ask about any code you work on that might help you improve its modularity:
    - How many global variables does it have? Global variables are modularity poison, an easy way for components to leak information to each other in careless and promiscuous ways.[48]
    - Is the size of your individual modules in Hatton's sweet spot? If your answer is “No, many are larger”, you may have a long-term maintenance problem. Do you know what your own sweet spot is? Do you know what it is for other programmers you are cooperating with? If not, best be conservative and stick to sizes near the low end of Hatton's range.
    - Are the individual functions in your modules too large? This is not so much a matter of line count as it is of internal complexity. If you can't informally describe a function's contract with its callers in one line, the function is probably too large.
    - Does your code have internal APIs — that is, collections of function calls and data structures that you can describe to others as units, each sealing off some layer of function from the rest of the code? A good API makes sense and is understandable without looking at the implementation behind it. The classic test is this: Try to describe it to another programmer over the phone. If you fail, it is very probably too complex, and poorly designed.
    - Do any of your APIs have more than seven entry points? Do any of your classes have more than seven methods each? Do your data structures have more than seven members?
    - What is the distribution of the number of entry points per module across the project?[50] Does it seem uneven? Do the modules with lots of entry points really need that many? Module complexity tends to rise as the square of the number of entry points, too — yet another reason simple APIs are better than complicated ones.
