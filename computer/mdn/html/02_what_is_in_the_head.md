# 《What's in the head? Metadata in HTML》文档分析笔记

## Q1: 这篇文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

答：实用类。计算机学科。

## Q2：这篇文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

答：介绍HTML head的基础知识。

## Q3：这篇文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- What is the HTML head?
- Adding a title
- Metadata: the `<meta>` element
  - Specifying your document's character encoding
  - Adding an author and description
  - Other types of metadata
- Adding custom icons to your site
- Applying CSS and JavaScript to HTML
- Setting the primary language of the document

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

答：作者想要解决：HTML head是什么？目的是什么？有哪些重要元素？HTML head对整个HTML文档会产生什么影响？

## Q5：这篇文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- metadata: 元数据，描述数据的数据。典型的元数据是`<meta>`元素，而`<title>`元素或favicon等也是元数据。

## Q6：这篇文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

1. The head of an HTML document is the part that is not displayed in the web browser when the page is loaded. It contains information such as the page `<title>`, links to CSS (if you choose to style your HTML content with CSS), links to custom favicons, and other metadata (data about the HTML, such as the author, and important keywords that describe the document.)

2. The head's job is to contain metadata about the document.

3. **Metadata is data that describes data**, and HTML has an "official" way of adding metadata to a document — the `<meta>` element. Of course, the other stuff we are talking about in this article could also be thought of as metadata too.

> 伍注：metadata（元数据）不只是`<meta>`元素，其他非`<meta>`元素也可能是元数据，比如`<title>`元素。

4. The `<title>` element is metadata that represents the title of the overall HTML document (not the document's content.)

5. The `<title>` element contents are also used in other ways. For example, if you try bookmarking the page, you will see the `<title>` contents filled in as the suggested bookmark name.

6. Specifying your document's character encoding:
```
<meta charset="utf-8">
```

7. Adding an author and description
```
<meta name="author" content="Chris Mills">
<meta name="description" content="The MDN Web Docs Learning Area aims to provide
complete beginners to the Web with all they need to know to get
started with developing web sites and applications.">
```
8. Specifying an author is beneficial in many ways: it is useful to be able to understand who wrote the page, if you have any questions about the content and you would like to contact them. Some content management systems have facilities to automatically extract page author information and make it available for such purposes.

9. Specifying a description that includes keywords relating to the content of your page is useful as it has the potential to make your page appear higher in relevant searches performed in search engines.

10. A favicon can be added to your page by:
  - **Saving it in the same directory as the site's index page**, saved in .ico format (most browsers will support favicons in more common formats like .gif or .png, but using the ICO format will ensure it works as far back as Internet Explorer 6.) （伍注：为兼容IE6， icon文件建议放在与index页面同级的目录下）
  - Adding the following line into your HTML's `<head>` block to reference it:
  ```
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
  ```

11. A lot of the features you'll see on websites are **proprietary creations**, designed to provide certain sites (such as social networking sites) with specific pieces of information they can use.
  - **Open Graph Data** is a metadata protocol that Facebook invented to provide richer metadata for websites.
  - Twitter also has its own similar proprietary metadata called **Twitter Cards**.

12. The HTML External Resource **Link** element (`<link>`) specifies relationships between the current document and an external resource. This element is most commonly used to link to stylesheets, but is also used to establish site icons among other things.

13. **The `<link>` element should always go inside the head of your document.**

14. Applying CSS to HTML:
```
<link rel="stylesheet" href="my-css-file.css">
```

15. Applying JavaScript to HTML:
```
<script src="my-js-file.js" defer></script>
```

16. `defer` instructs the browser to load the JavaScript at the same time as the page's HTML. This is useful as it makes sure that the HTML is all loaded before the JavaScript runs, so that you don't get errors resulting from JavaScript trying to access an HTML element that doesn't exist on the page yet. There are actually a number of ways to handle loading JavaScript on your page, but this is the most foolproof one to use for modern browsers.

17. Setting the primary language of the document:
```
<html lang="en-US">
```

18. Setting the primary language is useful in many ways.
  - Your HTML document will be indexed more effectively by search engines if its language is set (allowing it to appear correctly in language-specific results, for example)
  - It is useful to people with visual impairments using screen readers (for example, the word "six" exists in both French and English, but is pronounced differently.)

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

答：作者一般通过举例+注解的方法来进行论述。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

答：作者解决了他提出的问题：

- HTML head是什么？
  - `<head>`元素的内容，含有关于当前文档的一些基本信息，比如标题、图标、字符编码、样式表路径等。
- HTML head的目的是什么？
  - 描述当前文档的一些基本信息，以便浏览器正确显示页面标题/图标、文字，并正常加载样式表来渲染页面等。
- HTML head有哪些重要元素？
  - title, charset, author, description, favicon, css, script and language.
- HTML head对整个HTML文档会产生什么影响？
  - 影响标题/图标/文字的显示、页面渲染、搜索效果等。

## Q9：我有哪些疑问？

1. Q: metadata 只存在于head中吗？可以出现在body中吗？
  - A: 看了一些网页的源代码，发现metadata 可以存在于head中，也可以出现在body中。

2. Q: `<link>`元素只存在于head中吗？可以出现在body中吗？
  - A: 是的，`<link>`元素只存在于head中，不可以在body中。因为`<link>`元素用来描述当前文档与外部资源的关系，应该放在头部。

3. Q: head元素里面的script一般用来干啥？如何决定一个script应该放在head还是body？
  - A: script放在head还是body，影响的是该script的被运行的时间。如果把script放在head，并且该脚本会做一些渲染的工作，而渲染的对象是定义在body中，会导致渲染失败。一般有以下惯例：
    - Place library script such as the jQuery library in the head section.
    - Place normal script in the head unless it becomes a performance/page load issue.
    - Place script that impacts the render of the page at the end of the body

4. Q: script文件的加载策略是怎样的？
  - A: 在没有特别注明的情况下，按照出现的顺序来加载。但我们也可以通过`async`或`defer`等方式来改变加载方式。下面列举影响加载策略的几种做法：
    - 一种老式的做法是把script元素放在body元素的最后面。这样能确保HTML DOM元素加载完成后才执行脚本，但可能带来性能损耗。
    - 可以把要执行的逻辑定义在一个函数内，然后监听到"DOMContentLoaded"事件后再执行这个函数。`document.addEventListener("DOMContentLoaded", function() { ... });`
    - 使用async属性，可以在不堵塞页面渲染的同时下载脚本，下载完就会执行脚本，因此不能保证脚本之间的执行顺序，也不能保证HTML DOM元素加载完成后才执行脚本。
    - 使用defer属性，可以保证HTML DOM加载完成后再执行脚本，并且按照script的出现顺序来执行。

5. Q: js 脚本间的作用域关系是怎样的？一个脚本如何调用另一个脚本的函数？

## Q10：这篇文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这篇文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

答：暂时没发现问题。

## Q11：这篇文档和我有什么关系？

> 备注：这篇文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这篇文档的理论应用到实践中？

答：了解html head的重要组成部分，学会一些重要的元素的写法。

