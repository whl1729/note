# General Python FAQ

## Why was Python created in the first place?

The following summary was written by Guido van Rossum:

1. I had extensive experience with implementing an interpreted language in the ABC group at CWI, and from working with this group I had learned a lot about language design. This is the origin of many Python features, including the use of **indentation for statement grouping and the inclusion of very-high-level data types** (although the details are all different in Python).

2. Modula-3 is the origin of the syntax and semantics used for **exceptions**, and some other Python features.

3. My experience with error handling in Amoeba made me acutely aware of **the importance of exceptions as a programming language feature**.

4. It occurred to me that a scripting language with a syntax like ABC but with access to the Amoeba system calls would fill the need.（伍注：C++和Python语言的诞生，都来源于其发明者所参与的项目的需要。当现有编程语言无法满足需求时，就创造一门新语言。我认为这便是一种黑客精神。）

## How does the Python version numbering scheme work?

1. Python versions are numbered A.B.C or A.B. A is the major version number – it is only incremented for really major changes in the language. B is the minor version number, incremented for less earth-shattering changes. C is the micro-level – it is incremented for each bugfix release.

2. Not all releases are bugfix releases. In the run-up to a new major release, a series of development releases are made, denoted as alpha, beta, or release candidate. Alphas are early releases in which interfaces aren’t yet finalized; it’s not unexpected to see an interface change between two alpha releases. Betas are more stable, preserving existing interfaces but possibly adding new modules, and release candidates are frozen, making no changes except as needed to fix critical bug.

## How stable is Python?

1. There are two production-ready versions of Python: 2.x and 3.x. The recommended version is 3.x, which is supported by most widely used libraries. Although 2.x is still widely used, it will not be maintained after January 1, 2020.
