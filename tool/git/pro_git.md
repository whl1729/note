# 《Pro Git》书籍分析笔记

## Q1：这本书属于哪一类别的书？

> 备注：虚构类还是论说类？如果是虚构类，是小说、戏剧、史诗、抒情诗抑或其他？如果是论说类，是实用类还是理论类？属于历史、科学、哲学还是其他？

答：论说类/实用类/工具类。

## Q2：这本书的内容是什么？

> 备注：用一句话或最多几句话来回答。

答：介绍Git的原理及用法。

## Q3：这本书的大纲是什么？

> 备注：按照顺序与关系，列出全书的纲要及各个部分的纲要。

- Getting Started
- Git Basics
- Git Branching
- Git on the Server
- Distributed Git
- Github
- Git Tools
- Customizing Git
- Git and Other Systems
- Git Internals
- Appendix A: Git in Other Environments
- Appendix B: Embedding Git in your Applications
- Appendix C: Git Commands

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

## Q5：这本书的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

## Q6：这本书的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

### 1 Getting Started

- Some of the goals of the new system were as follows:
  - Speed
  - Simple design
  - Strong support for non-linear development (thousands of parallel branches)
  - Fully distributed
  - Able to handle large projects like the Linux kernel efficiently (speed and data size)

- Snapshots, Not Differences.
  - The major difference between Git and any other VCS (Subversion and friends included) is **the way Git thinks about its data**.
  - Most other systems store information as a list of file-based changes.
  - Git thinks about its data more like a stream of snapshots.

- Nearly Every Operation Is Local.

- Git Has Integrity.
  - Everything in Git is checksummed before it is stored and is then referred to by that checksum.
  - The mechanism that Git uses for this checksumming is called a **SHA-1 hash**.

- Git Generally Only Adds Data.

- Git has three main states that your files can reside in: **modified, staged, and committed**. This leads us to the three main sections of a Git project: **the working tree, the staging area, and the Git directory**.

- You can view all of your settings and where they are coming from using:
  ```
  $ git config --list --show-origin
  ```

- 3 equvialent ways to get help
  ```
  $ git help <verb>
  $ git <verb> --help
  $ man git-<verb>
  ```

- You can ask for the more concise "help" output with the `-h` option, such as `git add -h`

### 2 Git Basics

- Short Status
```
git status -s or git status --short
```

- The rules for the patterns you can put in the .gitignore file are as follows:
  - Blank lines or lines starting with # are ignored.
  - Standard **glob patterns** work, and will be applied recursively throughout the entire working tree.
  - You can start patterns with a forward slash (/) to avoid recursivity.
  - You can end patterns with a forward slash (/) to specify a directory.
  - You can negate a pattern by starting it with an exclamation point (!).

- `git rm` removes a file both from your tracked files and from your working directory.

- `git mv` renames a file.

- `git log`
  - `-p` or `--patch` shows the difference (the patch output) introduced in each commit.
  - `-2` limits the number of log entries.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。可以列举出作者的主要论点及次要论点，并分析其层次关系和逻辑关系。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

### Q9.1: Git 如何记录更改？

### Q9.2: Git 是如何实现其设计目标的？

> 备注：《Pro Git》第1.2节提到：Git的设计目标包括Speed, Simple design等。

## Q10：这本书说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这本书、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

## Q11：如何拓展这本书？

### Q11.1：为什么是这样的？为什么发展成这样？为什么需要它？

> 备注：深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。简单地说就是问为什么：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

### Q11.2：有哪些相似的知识点？它们之间的联系是什么？

> 备注：水平拓展，指类比相似的知识点。知识点的载体可以是书籍、网站、视频等。相似点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

### Q11.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

## Q12：这本书和我有什么关系？

> 备注：这本书的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这本书的理论应用到实践中？

