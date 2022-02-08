# git 使用笔记

## 常见用法

- [Delete a submodule][11]
  - Delete the relevant line from the `.gitmodules` file.
  - Stage the .gitmodules changes: `git add .gitmodules`
  - Delete the relevant section from `.git/config`.
  - Remove the submodule files from the working tree and index: `git rm --cached path_to_submodule` (no trailing slash).
  - Remove the submodule's .git directory: `rm -rf .git/modules/path_to_submodule`
  - Commit the superproject: `git commit -m "Removed submodule <name>"`
  - Delete the now untracked submodule files: `rm -rf path_to_submodule`

- [Delete large files][10]

  ```shell
  git filter-branch --prune-empty -d /dev/shm/scratch \
    --index-filter "git rm --cached -f --ignore-unmatch oops.iso" \
    -- --all
  ```

  ```shell
  git update-ref -d refs/original/refs/heads/master
  git reflog expire --expire=now --all
  git gc --prune=now
  ```

- [Delete a branch locally and remotely][9]

  ```shell
  git push -d <remote_name> <branch_name>
  git branch -d <branch_name>
  ```

- [git lola][8]

  ```
  [alias]
          lol = log --graph --decorate --pretty=oneline --abbrev-commit
          lola = log --graph --decorate --pretty=oneline --abbrev-commit --all
  ```

- [Replace master branch with another branch][1]

  ```shell
  git checkout seotweaks
  git merge -s ours master
  git checkout master
  git merge seotweaks
  ```

- git lfs
  - ubuntu 16.04使用`sudo apt install git-lfs`安装git-lfs时，下载deb文件的速度可能很慢，这时可以到官网下载tar.gz文件到本地，解压后再安装。
  - git pull 或 git clone 一个使用git lfs管理大文件的仓库时，只会拉取最新版本的大文件到本地，而不是拉取所有历史版本的大文件，
    等到需要时（比如切换到一个历史分支）再拉取，这样可以提高效率和节省空间。

  ```shell
  git lfs install
  git lfs track "*.avi"
  git add .gitattributes
  ```

- 设置 git pull 默认 rebase

  ```shell
  git config --global pull.base true
  ```

- 使用alias来精简命令：

  ```shell
  git config --global alias.ci 'commit'
  ```

- 设置默认push的远程仓库：

  ```shell
  git config --global push.default simple
  ```

- 设置git使用的编辑器：

  ```shell
  git config --global core.editor "vim"
  ```

- 查看远程仓库的地址：

  ```shell
  git remote -v
  ```

- 添加远程仓库：

  ```shell
  git remote add whl git@github.com:whl1729/spark.git
  ```

- `git diff`命令详解：
  - `git diff <filename>`：查看文件在工作目录与暂存区的差别。如果还没 add 进暂存区，则查看文件自身修改前后的差别。
  - `git diff <branch> <filename>`：查看当前分支的文件和另一分支的区别。
  - `git diff <commit> <filename>`：查看工作目录同Git仓库指定 commit 的内容的差异。`<commit>=HEAD` 时：查看工作目录同最近一次 commit 的内容的差异。
                                    HEAD表示最近一次commit，HEAD^表示上次commit。
  - `git diff --cached <filename>`：查看已经 add 进暂存区但是尚未 commit 的内容同最新一次 commit 时的内容的差异。
  - `git diff --cached <commit> <filename>`：查看已经 add 进暂存区但是尚未 commit 的内容同某一次 commit 的内容差异。
  - `git diff <commit> <commit>`：查看某两次commit之间的差别。

- [Git User Manual][2]

- 查看某次提交的详细修改信息：`git show COMMIT`

- `git log`
  - `git log --name-status` 每次修改的文件列表, 显示状态
  - `git log --name-only` 每次修改的文件列表
  - `git log --stat` 每次修改的文件列表, 及文件修改的统计
  - `git log -p` 按补丁格式显示每个更新之间的差异。
  - `git log -5 --name-status` 显示最近5次修改的文件列表
  - `git whatchanged` 每次修改的文件列表
  - `git whatchanged --stat` 每次修改的文件列表, 及文件修改的统计
  - `git show` 显示最后一次的文件改变的具体内容
  - `git log -S string --source --all -p` 显示字符串的修改历史

- [突破github的100M单个大文件上传限制][3]

- 解决git pull/push每次都需要输入密码问题：`git config --global credential.helper store`

- git commit规范
  - [Conventional Commits][4]
  - commit type
    - fix
    - feat
    - chore
    - docs
    - style
    - refactor
    - perf
    - test

- [Git - Windows AND linux line-endings][5]
  - On Windows: `git config --global core.autocrlf true`
  - On Linux: `git config --global core.autocrlf input`

## 参考资料

1. [Git Immersion][6]
2. [Git Reference][7]

  [1]: https://stackoverflow.com/questions/2862590/how-to-replace-master-branch-in-git-entirely-from-another-branch
  [2]: https://mirrors.edge.kernel.org/pub/software/scm/git/docs/user-manual.html
  [3]: https://blog.csdn.net/Tyro_java/article/details/53440666
  [4]: https://www.conventionalcommits.org/en/v--0/
  [5]: https://stackoverflow.com/questions/34610705/git-windows-and-linux-line-endings
  [6]: https://gitimmersion.com/index.html
  [7]: http://git.github.io/git-reference/
  [8]: http://blog.kfish.org/2010/04/git-lola.html
  [9]: https://stackoverflow.com/questions/2003505/how-do-i-delete-a-git-branch-locally-and-remotely
  [10]: https://stackoverflow.com/questions/2100907/how-to-remove-delete-a-large-file-from-commit-history-in-the-git-repository/2158271#2158271
  [11]: https://stackoverflow.com/a/1260982/11467929
