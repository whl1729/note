# 《HTML text fundamentals》文档分析笔记

## Q1: 这篇文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

答：实用类。计算机学科。

## Q2：这篇文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

答：这篇文档介绍建立文本结构的方法，包括添加标题、段落、列表、强调字词等。

## Q3：这篇文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- The basics: headings and paragraphs
  - Implementing structural hierarchy
  - Why do we need structure?
  - Why do we need semantics?
- Lists
  - Unordered
  - Ordered
  - Nesting Lists
- Emphasis and importance
  - Emphasis
  - Strong importance
  - Italic, bold, underline...

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

答：作者想要介绍如何给文本添加结构。

## Q5：这篇文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

## Q6：这篇文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

1. In HTML, each paragraph has to be wrapped in a `<p>` element

2. There are six heading elements: `<h1>, <h2>, <h3>, <h4>, <h5>, and <h6>`.

3. A few best practices of implementing structural hierarchy:
  - Preferably, you should use a single `<h1>` per page—this is the top level heading, and all others sit below this in the hierarchy.
  - Make sure you use the headings in the correct order in the hierarchy.
  - Of the six heading levels available, you should aim to use no more than three per page, unless you feel it is necessary. Documents with many levels (i.e., a deep heading hierarchy) become unwieldy and difficult to navigate. On such occasions, it is advisable to spread the content over multiple pages if possible.

4. Every **unordered list** starts off with a `<ul>` element—this wraps around all the list items. The last step is to wrap each list item in a `<li>` (list item) element.

5. Every **Ordered list** starts off with a `<ol>` element—this wraps around all the list items. The last step is to wrap each list item in a `<li>` (list item) element.

6. In HTML we use the `<em>` (emphasis) element to stress certain words. Browsers style this as italic by default, but you shouldn't use this tag purely to get italic styling. To do that, you'd use a `<span>` element and some CSS, or perhaps an `<i>` element.

7. In HTML we use the `<strong>` (strong importance) element to emphasize important words. Browsers style this as bold text by default, but you shouldn't use this tag purely to get bold styling. To do that, you'd use a `<span>` element and some CSS, or perhaps a `<b>` element.

8. Elements like `<b>, <i>, <u>`, which only affect presentation and not semantics, are known as **presentational elements** and should no longer be used because, as we've seen before, semantics is so important to accessibility, SEO, etc. Note: `<b>` means bold, `<i>` means italic, `u` means underline.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

答：举例+注解+提供练习。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

答：作者解决了他提出的问题，即如何给html文档添加结构。

## Q9：我有哪些疑问？

1. Q: `<strong>`与`<b>`元素有什么区别？
  - A: `<strong>` 表达一种语义（semantics）——强调重要的词语，浏览器目前默认是渲染为加粗的效果。而`<b>`仅表达显示效果，无语义层面的意思。

## Q10：这篇文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这篇文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

答：暂未发现问题。

## Q11：这篇文档和我有什么关系？

> 备注：这篇文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这篇文档的理论应用到实践中？

答：学会了如何书写标题、段落、列表、强调重要字词的方法，方便以后阅读和编写HTML文档。
