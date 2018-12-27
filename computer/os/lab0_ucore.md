# 《ucore lab 00》实验笔记

[uCore OS在线实验指导书：](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

## 实验目的
* 了解操作系统开发实验环境
* 熟悉命令行方式的编译、调试工程
* 掌握基于硬件模拟器的调试技术
* 熟悉C语言编程和指针的概念
* 了解X86汇编语言

## 设置实验环境

1. 通过Virtual使用Ubuntu时的一个问题：ubuntu分辨率太小，仅为800\*640，而我电脑分辨率是2560\*1600。解决方案：在setting - Display - Screen中，将Video Memory调到最大（128MB），并且勾选“Enable 3D Acceleration”，再启动ubuntu，在ubuntu界面上方的Device菜单下面勾选“Insert Guest Additions CD Image...”，在弹出的提示框中点击Run，运行完成后重启即可。

2. 后台进程：如果您有一个命令将占用很多时间，您想把它放入后台运行，也很简单。只要在命令运行时按下ctrl-z，它就会停止。然后键入 bg使其转入后台。fg 命令可使其转回前台。

3. apt-get：适用于 deb 包管理式的操作系统，主要用于自动从互联网软件库中搜索、安装、升级以及卸载软件或者操作系统。
    * apt-get remove <package>：移除 <package> 以及所有依赖的软件包。
    * apt-cache search <pattern>：搜索满足 <pattern> 的软件包。
    * apt-cache show/showpkg <package>：显示软件包 <package> 的完整描述。

4. Ubuntu的软件包获取依赖升级源，可以通过修改 “/etc/apt/sources.list” 文件来修改升级源（需要 root 权限） ；或者修改新立得软件包管理器中 “设置 > 软件库”。

5. exuberant-ctags：可以为程序语言对象生成索引，其结果能够被一个文本编辑器或者其他工具简捷迅速的定位。支持的编辑器有 Vim、Emacs 等。习惯GUI的同学可以使用understand或source insight等软件。
    * 使用`ctags -h=.h.c.S -R`来生成索引文件
    * 使用 “ctrl + ]” 可以跳转到相应的声明或者定义处，使用 “ctrl + t” 返回（查询堆栈） 等。

6. diff & patch：实验中可能会在 proj_b 中应用前一个实验proj_a 中对文件进行的修改，可以使用如下命令。习惯GUI的同学可以使用meld、kdiff3和UltraCompare等软件。
```
diff -r -u -P proj_a_original proj_a_mine > diff.patch
cd proj_b
patch -p1 -u < ../diff.patch
```

7. gcc：
    * 如果你还没装gcc编译环境或自己不确定装没装，不妨先执行 ：`sudo apt-get install build-essential`
    * 选项 -Wall 开启编译器几乎所有常用的警告──强烈建议你始终使用该选项。编译器有很多其他的警告选项，但-Wall 是最常用的。默认情况下GCC 不会产生任何警告信息。

8. 


