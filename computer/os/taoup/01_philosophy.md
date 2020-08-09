# The Art of Unix Programming

## Chapter 1. Philosophy

### The Durability of Unix

> Robert Metcalf [the inventor of Ethernet] says that if something comes along to replace Ethernet, it will be called “Ethernet”, so therefore Ethernet will never die.[4] Unix has already undergone several such transformations.

> -- Ken Thompson

1. There's a bedrock of **unchanging basics** — languages, system calls, and tool invocations — that one can actually keep using for years, even decades. Elsewhere it is impossible to predict what will be stable; even entire operating systems cycle out of use. Under Unix, there is a fairly sharp distinction between transient knowledge and lasting knowledge, and one can know ahead of time (with about 90% certainty) which category something is likely to fall in when one learns it. Thus the loyalty Unix commands.

> 注：如刘未鹏所说，重视知识的本质，抓住不变量。

2. Much of Unix's stability and success has to be attributed to its inherent strengths, to design decisions Ken Thompson, Dennis Ritchie, Brian Kernighan, Doug McIlroy, Rob Pike and other early Unix developers made back at the beginning; decisions that have been proven sound over and over. But just as much is due to the **design philosophy, art of programming, and technical culture **that grew up around Unix in the early days.

### What Unix Gets Wrong

1. Perhaps the most enduring objections to Unix are consequences of a feature of its philosophy first made explicit by the designers of the X windowing system. X strives to **provide “mechanism, not policy”**, supporting an **extremely general** set of graphics operations and deferring decisions about toolkits and interface look-and-feel (the policy) up to application level. Unix's other system-level services display similar tendencies; **final choices about behavior are pushed as far toward the user as possible**. Unix users can choose among multiple shells. Unix programs normally provide many behavior options and sport elaborate preference facilities.

2. This tendency reflects Unix's heritage as an operating system **designed primarily for technical users, and a consequent belief that users know better than operating-system designers what their own needs are.**

3. In the short term, Unix's laissez-faire approach may lose it a good many nontechnical users. In the long term, however, it may turn out that this ‘mistake’ confers a critical advantage — because **policy tends to have a short lifetime, mechanism a long one.**

### What Unix Gets Right

1. Unix is still the only operating system that can present a consistent, documented application programming interface (API) across a heterogeneous mix of computers, vendors, and special-purpose hardware. It is the only operating system that can scale from embedded chips and handhelds, up through desktop machines, through servers, and all the way to special-purpose number-crunching behemoths and database back ends.

2. The Unix API is the closest thing to a hardware-independent standard for writing truly portable software that exists.

3. Unix tradition lays heavy emphasis on keeping programming interfaces relatively small, clean, and orthogonal — another trait that produces flexibility in depth. Throughout a Unix system, easy things are easy and hard things are at least possible.

### Basics of the Unix Philosophy

1. The Unix philosophy (like successful folk traditions in other engineering disciplines) is bottom-up, not top-down. It is pragmatic and grounded in experience. It is not to be found in official methods and standards, but rather in the implicit half-reflexive knowledge, the expertise that the Unix culture transmits. It encourages a sense of proportion and skepticism — and shows both by having a sense of (often subversive) humor.

2. Doug McIlroy, the inventor of Unix pipes and one of the founders of the Unix tradition, had this to say at the time:
    - Make each program do one thing well. To do a new job, build afresh rather than complicate old programs by adding new features.
    - Expect the output of every program to become the input to another, as yet unknown, program. Don't clutter output with extraneous information. Avoid stringently columnar or binary input formats. Don't insist on interactive input.
    - Design and build software, even operating systems, to be tried early, ideally within weeks. Don't hesitate to throw away the clumsy parts and rebuild them.
    - Use tools in preference to unskilled help to lighten a programming task, even if you have to detour to build the tools and expect to throw some of them out after you've finished using them.

3. Doug McIlroy later summarized it this way (quoted in A Quarter Century of Unix):

> This is the Unix philosophy: Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface.

4. Rob Pike, who became one of the great masters of C, offers a slightly different angle in Notes on C Programming:
    - Rule 1. You can't tell where a program is going to spend its time. Bottlenecks occur in surprising places, so don't try to second guess and put in a speed hack until you've proven that's where the bottleneck is.
    - Rule 2. Measure. Don't tune for speed until you've measured, and even then don't unless one part of the code overwhelms the rest.
    - Rule 3. Fancy algorithms are slow when n is small, and n is usually small. Fancy algorithms have big constants. Until you know that n is frequently going to be big, don't get fancy. (Even if n does get big, use Rule 2 first.)
    - Rule 4. Fancy algorithms are buggier than simple ones, and they're much harder to implement. Use simple algorithms as well as simple data structures.
    - Rule 5. Data dominates. If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming.[9]
    - Rule 6. There is no Rule 6.

5. Ken Thompson, the man who designed and implemented the first Unix, reinforced Pike's rule 4 with a gnomic maxim worthy of a Zen patriarch:
> When in doubt, use brute force.

6. More of the Unix philosophy was implied not by what these elders said but by what they did and the example Unix itself set. Looking at the whole, we can abstract the following ideas:
    - Rule of Modularity: Write simple parts connected by clean interfaces.
    - Rule of Clarity: Clarity is better than cleverness.
    - Rule of Composition: Design programs to be connected to other programs.
    - Rule of Separation: Separate policy from mechanism; separate interfaces from engines.
    - Rule of Simplicity: Design for simplicity; add complexity only where you must.
    - Rule of Parsimony: Write a big program only when it is clear by demonstration that nothing else will do.
    - Rule of Transparency: Design for visibility to make inspection and debugging easier.
    - Rule of Robustness: Robustness is the child of transparency and simplicity.
    - Rule of Representation: Fold knowledge into data so program logic can be stupid and robust.
    - Rule of Least Surprise: In interface design, always do the least surprising thing.
    - Rule of Silence: When a program has nothing surprising to say, it should say nothing.
    - Rule of Repair: When you must fail, fail noisily and as soon as possible.
    - Rule of Economy: Programmer time is expensive; conserve it in preference to machine time.
    - Rule of Generation: Avoid hand-hacking; write programs to write programs when you can.
    - Rule of Optimization: Prototype before polishing. Get it working before you optimize it.
    - Rule of Diversity: Distrust all claims for “one true way”.
    - Rule of Extensibility: Design for the future, because it will be here sooner than you think.

7. As Brian Kernighan once observed, "Controlling complexity is the essence of computer programming".

8. Unix tradition strongly encourages writing programs that read and write simple, textual, stream-oriented, device-independent formats. Under classic Unix, as many programs as possible are written as simple filters, which take a simple text stream on input and process it into another simple text stream on output.

9. At minimum, it implies that **debugging options should not be minimal afterthoughts**. Rather, they should be designed in from the beginning — from the point of view that the program should be able to both demonstrate its own correctness and communicate to future developers the original developer's mental model of the problem it solves.

10. For a program to demonstrate its own correctness, it needs to be using input and output formats **sufficiently simple** so that the proper relationship between valid input and correct output is easy to check.

11. A software system is transparent when you can look at it and immediately understand what it is doing and how. It is discoverable when it has facilities for monitoring and display of internal state so that your program not only functions well but can be seen to function well.

12. The way to make robust programs is to make their internals easy for human beings to reason about. There are two main ways to do that: transparency and simplicity.

13. One very important tactic for being robust under odd inputs is to **avoid having special cases** in your code. Bugs often lurk in the code for handling special cases, and in the interactions among parts of the code intended to handle different special cases.

> Question: But how to avoid having special cases?

14. Data is more tractable than program logic. It follows that where you see a choice between complexity in data structures and complexity in code, choose the former. More: in evolving a design, you should actively seek ways to shift complexity from code to data.

15. Software should be transparent in the way that it fails, as well as in normal operation. It's best when software can cope with unexpected conditions by adapting to them, but the worst kinds of bugs are those in which **the repair doesn't succeed and the problem quietly causes corruption that doesn't show up until much later**.

16. Therefore, write your software to cope with incorrect inputs and its own execution errors as gracefully as possible. But when it cannot, make it fail in a way that makes diagnosis of the problem as easy as possible.

17. When you design protocols or file formats, make them sufficiently self-describing to be extensible. Always, always either include a version number, or compose the format from self-contained, self-describing clauses in such a way that new clauses can be readily added and old ones dropped without confusing format-reading code. Unix experience tells us that the marginal extra overhead of making data layouts self-describing is paid back a thousandfold by the ability to evolve them forward without breaking things.

### The Unix Philosophy in One Lesson

1. All the philosophy really boils down to one iron law, the hallowed ‘KISS principle’ of master engineers everywhere:

> Keep It Simple, Stupid!

### Applying the Unix Philosophy

These philosophical principles aren't just vague generalities. In the Unix world they come straight from experience and lead to specific prescriptions, some of which we've already developed above. Here's a by no means exhaustive list:
    - Everything that can be a source- and destination-independent filter should be one.
    - Data streams should if at all possible be textual (so they can be viewed and filtered with standard tools).
    - Database layouts and application protocols should if at all possible be textual (human-readable and human-editable).
    - Complex front ends (user interfaces) should be cleanly separated from complex back ends.
    - Whenever possible, prototype in an interpreted language before coding C.
    - Mixing languages is better than writing everything in one, if and only if using only that one is likely to overcomplicate the program.
    - Be generous in what you accept, rigorous in what you emit.
    - When filtering, never throw away information you don't need to.
    - Small is beautiful. Write programs that do as little as is consistent with getting the job done.

### Attitude Matters Too

1. To do the Unix philosophy right, you have to be loyal to excellence. You have to believe that software design is a craft worth all the intelligence, creativity, and passion you can muster. Otherwise you won't look past the easy, stereotyped ways of approaching design and implementation; you'll rush into coding when you should be thinking. You'll carelessly complicate when you should be relentlessly simplifying — and then you'll wonder why your code bloats and debugging is so hard.

2. To do the Unix philosophy right, you have to value your own time enough never to waste it. If someone has already solved a problem once, don't let pride or politics suck you into solving it a second time rather than re-using. And never work harder than you have to; work smarter instead, and save the extra effort for when you need it. Lean on your tools and automate everything you can.

3. Software design and implementation should be a joyous art, a kind of high-level play. If this attitude seems preposterous or vaguely embarrassing to you, stop and think; ask yourself what you've forgotten. Why do you design software instead of doing something else to make money or pass the time? You must have thought software was worthy of your passion once....

4. To do the Unix philosophy right, you need to have (or recover) that attitude. You need to care. You need to play. You need to be willing to explore.
