##参考资料

* [Writing on Github: Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
* [Github Guides: Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
* [Writing on GitHub: Working with advanced formatting](https://help.github.com/articles/working-with-advanced-formatting/)
* [markdown tutorial](http://www.markdowntutorial.com/)
* [markdown preview for vim](https://github.com/iamcco/markdown-preview.vim)

##语法

###标题  
在文本前面加1~6个井号(#)，可将文本变成1～6级标题。示例：  
输入内容：
>\#\#\#\#四级标题  
>\#\#\#\#\#五级标题  
>\#\#\#\#\#\#六级标题

显示结果：
>####四级标题 
>#####五级标题 
>######六级标题 

###样式
在文本前后各加一个下划线(\_)，可将该文本变成斜体。  
在文本前后各加两个星号(\*\*)，可将该文本加粗。  
在文本前后各加两个波浪号(\~\~)，可将该文本划掉。示例：

>样式 | 输入内容 | 显示结果
>---- | -------- | --------
>斜体 | \_hello world\_ | _hello world_
>加粗 | \*\*hello world\*\* | **hello world**
>划掉 | \~\~hello world\~\~ | ~~hello world~~

###链接
* 文本链接
用中括号[]括住链接文本，用小括号()括住URL地址即可。示例：

输入内容:
>\[mastering MarkDown\]\(https://guides.github.com/features/mastering-markdown/\) 

显示结果：
>[mastering MarkDown](https://guides.github.com/features/mastering-markdown/)

* 图片链接
与文本链接类似，区别是在中括号前要加一个感叹号(!)。示例：

输入内容： 
>\!\[cat\]\(http://octodex.github.com/images/octdrey-catburn.jpg\) 

显示结果:
<img src="http://octodex.github.com/images/octdrey-catburn.jpg" width=100 height=100 align=center />

###引用
在引用别人的话前面加上右括号(>)即可。
