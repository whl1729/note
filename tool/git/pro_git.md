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

- HEAD: 从存在形态来看，HEAD是位于.git目录下的一个文件，里面记录着一个分支(?)，比如`refs/heads/master`。

- blob: certain version of a file in the git repository

- fast-forward: when you try to merge one commit with a commit that can be reached by following the first commit’s history, Git simplifies things by moving the pointer forward because there is no divergent work to merge together.

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
  - `--stat` see some abbreviated stats for each commit.
  - `--pretty` changes the log output formats. The value can be `oneline, short, full, fuller`.
  - `--graph` adds a nice little ASCII graph.
  - `--name-only` show the list of files modified.
  - `--name-status` show the list of files affected with added/modified/deleted information as well.
  - `--decorate` show where the branch pointers are pointing.
  - `--all` show commit history for all branch.
  - `<some-branch>` show commit history for some-branch.

- Limiting Log Output
  - `--since`
  - `--until`
  - `--author`
  - `--grep`
  - `-S function_name` takes a string and shows only those commits that changed the number of occurrences of that string.
  - `-- path/to/file`  limit the log output to commits that introduced a change to certained files. This is always the last option and is generally preceded by double dashes (--) to separate the paths from the options.

- Undo Things
  - Unstaging a Staged File: `git reset HEAD READ.md`
  - Unmodifying a Modified File: `git checkout -- READ.md`

- Working with Remotes
  - `git remote -v`
  - `git remote add <shortname> <url>`
  - `git fetch <remote>` goes out to that remote project and pulls down all the data from that remote project that you don’t have yet. After you do this, you should have references to **all the branches** from that remote.
  - `git pull <remote>` automatically fetch and then merge that remote branch into your current branch.
  - `git remote show origin` see more information about a particular remote
  - `git remote rename pb paul`
  - `git remote remove`

- Taggings
  - `git tag -l` or `git tag --list`
  - `git tag -a v1.4 -m "my version 1.4 [certain-commit-checksum]` annotated tags
  - `git tag v1.4-lw`
  - `git show v1.4-lw`
  - `git push origin --tags` By default, the git push command doesn’t transfer tags to remote servers.
  - `git tag -d v1.4-lw`

- Aliases
```
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.ll 'log --oneline'
git config --global alias.rv 'remote -v'
git config --global alias.d 'diff'
git config --global alias.ph 'push'
git config --global alias.pl 'pull'
git config --global alias.gl 'config --global -l'
```

### 3 Git branching

- When you make a commit, Git stores a commit object that
  - contains a pointer to the snapshot of the content you staged
  - pointers to the commit or commits that directly came before this commit

- Staging the files
  - computes a checksum for each one
  - stores that version of the file in the Git repository
  - adds that checksum to the staging area

> 伍注：以上解释了`git add`时发生了什么。

- Running git commit
  - Git checksums each subdirectory
  - Stores them as a tree object in the Git repository
  - Creates a commit object that has the metadata and a pointer to the root project tree so it can re-create that snapshot when needed.  

> 伍注：以上解释了`git commit`时发生了什么。

- A branch in Git is simply a lightweight movable pointer to one of these commits.

> 伍注：以上解释了 git branch 的本质：指向某个 commit 的指针。

- Switching branches
  - moves HEAD to point to that branch.

> 伍注：以上解释了`git checkout`时发生了什么：HEAD将指向那个分支。

- Because a branch in Git is actually a simple file that contains the 40 character SHA-1 checksum of the commit it points to, branches are cheap to create and destroy. Creating a new branch is as quick and simple as writing 41 bytes to a file (40 characters and a newline).

> 伍注：在 Git 中创建分支非常简单、迅速和高效。

- After you’ve resolved each of these sections in each conflicted file, run git add on each file to mark it as resolved. **Staging the file marks it as resolved in Git.**

- `git mergetool` use a graphical tool to resolve conflicts.

- `git branch`
  - `-v` see the last commit on each branch.
  - `--merged` and `--no-merged` filter branches that you have or have not yet merged into the branch you're currently on.

- When a branch contains work that isn’t merged in yet, trying to delete it with `git branch -d` will fail, you can force it with `-D`.

- git workflows
  - Long-Running Branched: several levels of stability
    - master: having only code that is entirely **stable**
    - develop or next: they aren't necessarily always stable
  - Topic Branches
    - hotfix, iss53 (issue #53), dumbidea

- remote branches
  - Remote-tracking branches are references to the state of remote branches.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。可以列举出作者的主要论点及次要论点，并分析其层次关系和逻辑关系。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

### Q9.1: Git 如何记录更改？

### Q9.2: Git 是如何实现其设计目标的？

> 备注：《Pro Git》第1.2节提到：Git的设计目标包括Speed, Simple design等。

### Q9.3: Git 是如何保存数据的？

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

