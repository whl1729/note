## 参考资料

* [Writing on Github: Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
* [Github Guides: Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
* [Writing on GitHub: Working with advanced formatting](https://help.github.com/articles/working-with-advanced-formatting/)
* [markdown tutorial](http://www.markdowntutorial.com/)
* [markdown preview for vim](https://github.com/iamcco/markdown-preview.vim)

## 语法

### 标题  

在文本前面加1~6个井号(# )，可将文本变成1～6级标题。示例：  

输入内容：

	#### 四级标题  
	##### 五级标题  
	###### 六级标题

显示结果：
>#### 四级标题 
>##### 五级标题 
>###### 六级标题 

### 样式

在文本前后各加一个下划线(\_)，可将该文本变成斜体。  
在文本前后各加两个星号(\*\*)，可将该文本加粗。  
在文本前后各加两个波浪号(\~\~)，可将该文本划掉。示例：

>样式 | 输入内容 | 显示结果
>---- | -------- | --------
>斜体 | \_hello world\_ | _hello world_
>加粗 | \*\*hello world\*\* | **hello world**
>划掉 | \~\~hello world\~\~ | ~~hello world~~

### 链接

* 文本链接

用中括号[]括住链接文本，用小括号()括住URL地址即可。示例：

输入内容:

    \[mastering MarkDown\]\(https://guides.github.com/features/mastering-markdown/\) 

显示结果：

>[mastering MarkDown](https://guides.github.com/features/mastering-markdown/)


* 图片链接

与文本链接类似，区别是在中括号前要加一个感叹号(!)。示例：

输入内容：

    \!\[cat\]\(http://octodex.github.com/images/octdrey-catburn.jpg\) 

显示结果:

<img src="http://octodex.github.com/images/octdrey-catburn.jpg" width=100 height=100 align=center />

### 引用

* 引用文本

在文本前面加上右箭头(>)，即可引用该文本。示例：

输入内容：

> 我喜欢尼采的一句话：
>    \>凡不能毁灭我的，必将使我强大。

输出内容：

>我喜欢尼采的一句话：
>>凡不能毁灭我的，必将使我强大。

* 引用代码

引用单行的少量代码，用一对反引号(\`\`)括起来即可。示例：

输入内容：

>Linux系统可以使用\`shutdown now\`命令来关机。

输出内容：
>Linux系统可以使用`shutdown now`命令来关机。

引用多行的代码块，在代码块前面和后面分别加上三个反引号(\`\`\`)即可。示例：

输入内容：
    
>这是几乎所有初学C语言的同学都会接触过的一段代码：
>\`\`\`
>int main()
>{
>   printf("Hello world.\n");
>	return 0;
>}
>\`\`\`

输出内容：

>这是几乎所有初学C语言的同学都会接触过的一段代码：
>```
>int main()
>{
>   printf("Hello world.\n");
>   return 0;
>}
>```

### 列表

* 无序列表

要把多行文本以无序列表方式显示，只需在每行文本前加上加号(+)、减号(-)或乘号(*)即可。示例：

输入内容：

    - 费因曼
    - 图灵
    - 香农

输出内容：

>- 费因曼
>- 图灵
>- 香农

* 有序列表

要把多行文本以有序列表显示，只需在每行文本前加上数字编号即可。示例：

输入内容：

    1. 中国史纲
    2. 乡土中国
    3. 江村经济

输出内容：

>1. 中国史纲
>2. 乡土中国
>3. 江村经济

* 嵌套列表

无序列表或有序列表均可嵌套，每一级嵌套需要缩进四个空格。

输入内容：

	1. 文学
	    1. 黄金时代
	    2. 罪与罚
	2. 哲学
	    - 西方哲学史
	    - 纯粹理性批判
	    - 权力意志
	3. 计算机科学

输出内容：

>1. 文学
>    1. 黄金时代
>    2. 罪与罚
>2. 哲学
>    - 西方哲学史
>    - 纯粹理性批判
>    - 权力意志
>3. 计算机科学

### 任务列表

在每项任务前加上中括号[]，即可创建任务列表。在中括号内填上x，则表示该任务已完成。示例：

输入内容：

	- [x] 学习MardDown用法
	- [ ] 使用MardDown写vim学习笔记
	- [ ] 学习shell脚本基础

输出内容：

>- [x] 学习MardDown用法
>- [ ] 使用MardDown写vim学习笔记
>- [ ] 学习shell脚本基础

### 表格

要想创建一个表格，用竖杠(\|)分开每行中的不同项，并在第一行后用横线分割一下即可。示例：

输入内容：

    粤语歌 | 国语歌
    ------ | ------
    明年今日 | 十年
    富士山下 | 爱情转移

输出内容：

>粤语歌 | 国语歌
>------ | ------
>明年今日 | 十年
>富士山下 | 爱情转移

要想表格中某一列向左对齐，在横线左边加上冒号(\:)；向右对齐，则在横线右边加上冒号；中间对齐，则在横线两边均加上冒号。示例：

输入内容：

	左对齐 | 居中对齐 | 右对齐
	 :---  | :---:    | ---:
	 活着  | 活着     | 活着
	 追忆似水年华 | 追忆似水年华 | 追忆似水年华

输出内容：

>左对齐 | 居中对齐 | 右对齐
> :---  | :---:    | ---:
> 活着  | 活着     | 活着
> 追忆似水年华 | 追忆似水年华 | 追忆似水年华




### 段落
在文本之间增加一个空行，即可创建一个新段落。

### 忽略MarkDown格式
在Markdown字符前加上反斜杠(\\)，可以让编辑器忽略Markdown字符，并按照字符的字面含义解析之。

## 补充

1. 换行：空格+空格+回车。

## Markdown书写数学公式

参考资料：
1. [Markdown中写数学公式](http://jzqt.github.io/2015/06/30/Markdown%E4%B8%AD%E5%86%99%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F/)
2. [MarkDown 插入数学公式实验大集合](https://juejin.im/post/5a6721bd518825733201c4a2)

### 插入数学公式

1. 在Markdown中插入数学公式的语法是`$formula$`和`$$formula$$`。前者是行内公式，即公式在文中与文字等混编，不独占一行；后者是独立公式，即公式独占一行，不与文中其他文字等混编。

2. 行内公式示例：`质能方程$E = mc^2$`显示为：

质能方程$E = mc^2$

3. 独立公式示例：`质能方程$$E = mc^2$$`显示为：

质能方程$$E = mc^2$$

### 上下标

1. 使用`^`来表示上标，`_`来表示下标，如果上下标的内容多于一个字符，则使用`{}`来将这些内容括起来。示例：`$$x = a_{1}^n + a_{2}^n + a_{3}^n$$`显示为$$x = a_{1}^n + a_{2}^n + a_{3}^n$$.

2. 上下标是可以嵌套的。示例：`$e^{x^2}$`显示为$e^{x^2}$.

3. 如果希望左右两边都能有上下标，可以使用`\sideset`语法。示例：`$\sideset{^1_2}{^3_4}A$`显示为$\sideset{^1_2}{^3_4}A$.

### 括号
`()`，`[]`和`|`都表示它们自己，但是`{}`因为有特殊作用，因此当需要显示大括号时一般使用`\lbrace \rbrace`来表示。示例：`$$f(x, y) = 100 * \lbrace[(x + y) * 3] - 5\rbrace$$`显示为$$f(x, y) = 100 * \lbrace[(x + y) * 3] - 5\rbrace$$.

### 分数
分数使用`\frac{分母}{分子}`这样的语法，不过推荐使用`\cfrac`来代替`\frac`，显示公式不会太挤。示例：`$$\frac{1}{3} 与 \cfrac{1}{3}$$`显示为$$\frac{1}{3} 与 \cfrac{1}{3}$$.

### 开方
开方使用`\sqrt[次数][被开方数]`这样的语法。示例：`$$\sqrt[3]{X}$$`显示为$$\sqrt[3]{x}$$，`$$\sqrt{5 - x}$$`显示为$$\sqrt{5 - x}$$.

### 希腊字母

代码    |    大写    |    代码    |    小写
------- | ---------- | ---------- | -------
`A`     | A       | `\alpha` | \alpha
`B`     | B       | `\beta`  | \beta
`\Gamma` | \Gamma | `\gamma` | \gamma
`\Delta` | \Delta | `\delta` | \delta
`E`     | E       | `\epsilon` | \epsilon
`Z`     | Z       | `\zeta`  | \zeta
`H`     | H       | `\eta`   | \eta
`\Theta` | \Theta | `\theta` | \theta
`I`     | I       | `\iota`  | \iota
`K`     | K       | `\kappa` | \kappa
`\Lambda` | \Lambda | `lambda` | \lambda
`M`     | M       | `\mu`    | \mu
`N`     | N       | `\nu`    | \nu
`\Xi`   | \Xi     | `\xi`    | \xi
`O`     | O       | `\omicron` | \omicron
`\Pi`   | \Pi     | `\pi`    | \pi
`P`     | P       | `\rho`   | \rho
`\Sigma` | \Sigma | `\sigma` | \sigma
`T`     | T       | \tau     | \tau
`\Upsilon` | \Upsilon | `\upsilon` | \upsilon
`\Phi`  | \Phi    | `\phi`   | \phi
`X`     | X       | `\chi`   | \chi
`\Psi`  | \Psi    | `\psi`   | \psi
`\Omega` | \Omega | `\omega` | \omega

### 关系字符串

代码     |     符号
-------- | --------
`\pm`      | \pm
`\times`   | \times
`\div`     | \div
`\mid`     | \mid
`\nmid`    | \nmid
`\cdot`    | \cdot
`\circ`    | \circ
`\ast`     | \ast
`\bigodot` | \bigodot
`\bigotimes` | \bigotimes
`\bigoplus` | \bigoplus
`\leq`     | \leq
`\geq`     | \geq
`\neq`     | \neq
`\approx`  | \approx
`\equiv`   | \equiv
`\sum`     | \sum
`\prod`    | \prod
`\coprod`  | \coprod

### 集合运算符

代码     |     符号
-------- | --------
`\emptyset` | \emptyset
`\in`      | \in
`\notin`   | \notin
`\subset`  | \subset
`\supset`  | \supset
`\subseteq` | \subseteq
`\supseteq` | \supseteq
`\bigcap`  | \bigcap
`\bigcup`  | \bigcup
`\bigvee`  | \bigvee
`\bigwedge` | \bigwedge
`\biguplus` | \biguplus
`\bigsqcup` | \bigsqcup

### 对数运算符

代码     |     符号
-------- | --------
`\log`     | \log
`\lg`      | \lg
`\ln`      | \ln

### 三角运算符

代码     |     符号
-------- | --------
\bot     | \bot
\angle   | \algle
\sin     | \sin
\cos     | \cos
\tan     | \tan
\cot     | \cot
\sec     | \sec
\csc     | \csc

### 微积分运算符

代码     |     符号
-------- | --------
`\prime`   | \prime
`\int`     | \int
`\iint`    | \iint
`\iiint`   | \iiint
`\iiiint`  | \iiiint
`\oint`    | \oint
`\lim`     | \lim
`\infty`   | \infty
`\nabla`   | \nabla
`\mathrm{d}` | \mathrm{d}
