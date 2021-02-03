# 《Getting started with HTML》文档分析笔记

## Q1: 这篇文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

答：实用类。计算机学科。

## Q2：这篇文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

答：简介HTML最基础的知识，包括HTML文档的基本组成结构、元素、属性等。

## Q3：这篇文档的大纲是什么？

> 备注：按照顺序与关系，列出全书的纲要及各个部分的纲要。

答：
- What is HTML?
- Anatomy of an HTML element
  - Nesting elements
  - Block versus inline elements
  - Empty elements
- Attributes
  - Boolean attributes
  - Omitting quotes around attribute values
  - Single or double quotes?
- Anatomy of an HTML document
  - Whitespace in HTML
  - Entity references: Including special characters in HTML
- HTML comments

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

答：作者想要介绍：HTML是什么？由哪些部分组成？有哪些基本概念？如何书写常见的HTML元素？

## Q5：这篇文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

答：
- element: HTML文档是由一系列元素组成的。元素是指由标签和内容组成的整体。比如HTML文档就是由一个html元素构成，这个html元素又由head元素和body元素组成，body元素又由script元素、p元素或img元素等组成。在html文档中所有元素可以组成一个树状结构，根节点便是html元素。
- empty elements: 空元素指只有一个标签的元素。
- attribute: 属性是元素的一个组成部分，用来修饰元素。属性包括全局属性和非全局属性。前者是所有元素都具有的，比如`class`和`id`等。非全局属性是某些元素才具有的，比如`href`。
- boolean attribute: 布尔属性是指取值要么为空、要么为跟属性名相同的字符串的属性。属性存在即代表布尔值为true，属性不存在即代表布尔值为false。
- entity: HTML实体是一段以连字符（`&`）开头、以分号（`;`）结尾的文本（字符串）。实体常用来显示保留字符和不可见的字符。

## Q6：这篇文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

1. HTML consists of a series of **elements**, which you use to enclose, wrap, or mark up different parts of content to make it appear or act in a certain way.

2. Anatomy of a typical HTML element
  - The opening tag
  - The content
  - The closing tag

3. Elements can be placed within other elements. This is called **nesting**. **The tags have to open and close in a way that they are inside or outside one another.**

4. Block versus inline elements
  - Block-level elements form a visible block on a page. A block-level element appears on a new line following the content that precedes it. Any content that follows a block-level element also appears on a new line.
  - Inline elements are contained within block-level elements, and surround only small parts of the document’s content (not entire paragraphs or groupings of content). An inline element will not cause a new line to appear in the document.
  - A block-level element wouldn't be nested inside an inline element, but it might be nested inside another block-level element.

5. **Empty elements**: Not all elements follow the pattern of an opening tag, content, and a closing tag. Some elements consist of a single tag, which is typically used to insert/embed something in the document.

6. Some attributes of anchor
  - href: specifies the web address for the link.
  - title: specifies extra information about the link, such as a description of the page that is being linked to. This appears as a tooltip when a cursor hovers over the element.
  - target: specifies the browsing context used to display the link.

7. **Boolean attributes**
  - The presence of a boolean attribute on an element represents the true value, and the absence of the attribute represents the false value.
  - If the attribute is present, its value must either be the empty string or a value that is an ASCII case-insensitive match for the attribute's canonical name, with no leading or trailing whitespace.

8. **Always include the attribute quotes.** It avoids unexpected problems, and results in more readable code.

9. You can wrap attributes in eithor double quotes or single quotes. But make sure you **don't mix single quotes and double quotes.**

10. No matter how much whitespace you use inside HTML element content (which can include one or more space character, but also line breaks), the HTML parser reduces each sequence of whitespace to a single space when rendering the code.

11. An HTML **entity** is a piece of text ("string") that begins with an ampersand (&) and ends with a semicolon (;) . Entities are frequently used to display reserved characters (which would otherwise be interpreted as HTML code), and invisible characters (like non-breaking spaces). You can also use them in place of other characters that are difficult to type with a standard keyboard.

12. In HTML, the characters `<`, `>`, `'` and `&` are **special characters**. So how do you include one of these special characters in your test? You do this with **character references**.

| Literal character | Character reference equivalent |
| -- | -- |
| < | `&lt;` |
| > | `&gt;` |
| " | `&quot;` |
| ' | `&apos;` |
| & | `&amp;` |

13. To write an HTML comment, wrap it in the special markers `<!--` and `-->`.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

答：一般采用下定义+举例+注解的方式来论述，通俗易懂。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

答：作者解决了他需要论述的所有问题，包括HTML的组成部分、元素、属性等关键概念。

## Q9：我有哪些疑问？

1. Q: 空元素有哪些？空元素有两种写法吗？（`<br>` 或`</br>`）
  A: 空元素有`<area>, <base>, <br>, <col>, <embed>, <hr>, <img>, <input>, <link>, <meta>, <param>, <source>, <track>, <wbr>`。HTML的空元素有两种写法：`<br>`或`<br\>`。其中前者是官方写法，后者是为了兼容XML/XHTML的写法。注意XML/XHTML中不支持前者的写法。

## Q10：这篇文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这篇文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

答：目前未发现问题。

## Q11：这篇文档和我有什么关系？

> 备注：这本书的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这本书的理论应用到实践中？

答：
1. 介绍了HTML文档的组成部分（含有head和body两部分等），使我对HTML文档的整体结构有了认识。
2. 介绍了HTML的关键概念——属性和元素，方便我以后修改元素及其属性。
3. 介绍了空白元素、布尔属性、实体等概念，使我以后在阅读HTML文档时遇到这些概念可以直接理解。
4. 介绍了引号的书写风格、注释等，以后编写HTML文档时需要参考这些规则。
