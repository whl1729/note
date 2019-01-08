# git使用笔记

1. 使用alias来精简命令：
在\~/.bashrc文件里增加相应alias命令，比如`alias gad='git add .'`

2. 设置默认push的远程仓库：
`git config --global push.default simple`

3. 设置git使用的编辑器：
`git config --global core.editor "vim"`

4. 查看远程仓库的地址：
`git remote -v`

5. 添加远程仓库：
`git remote add whl git@github.com:whl1729/spark.git`

6. `git diff`命令详解：
    * `git diff <filename>`：查看文件在工作目录与暂存区的差别。如果还没 add 进暂存区，则查看文件自身修改前后的差别。
    * `git diff <branch> <filename>`：查看当前分支的文件和另一分支的区别。
    * `git diff <commit> <filename>`：查看工作目录同Git仓库指定 commit 的内容的差异。<commit>=HEAD 时：查看工作目录同最近一次 commit 的内容的差异。HEAD表示最近一次commit，HEAD^表示上次commit。
    * `git diff --cached <filename>`：查看已经 add 进暂存区但是尚未 commit 的内容同最新一次 commit 时的内容的差异。 
    * `git diff --cached <commit> <filename>`：查看已经 add 进暂存区但是尚未 commit 的内容同某一次 commit 的内容差异。
    * `git diff <commit> <commit>`：查看某两次commit之间的差别。

7. [Git User Manual](https://mirrors.edge.kernel.org/pub/software/scm/git/docs/user-manual.html)

8. 查看某次提交的详细修改信息：`git show COMMIT`

9. `git log`
    - `git log --name-status ` 每次修改的文件列表, 显示状态
    - `git log --name-only ` 每次修改的文件列表
    - `git log --stat ` 每次修改的文件列表, 及文件修改的统计
    - `git log -p`	按补丁格式显示每个更新之间的差异。
    - `git log -5 --name-status` 显示最近5次修改的文件列表
    - `git whatchanged ` 每次修改的文件列表
    - `git whatchanged --stat ` 每次修改的文件列表, 及文件修改的统计
    - `git show ` 显示最后一次的文件改变的具体内容
