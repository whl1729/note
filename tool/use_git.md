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
