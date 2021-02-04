# 《Creating hyperlinks》文档分析笔记

## Q1: 这篇文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

实用类。计算机学科。

## Q2：这篇文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

这篇文档介绍HTML文档中链接的语法及最佳实践。

## Q3：这篇文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- What is a hyperlink?
- Anatomy of a link
  - Adding supporting information with the title attribute
  - Block level links
- A quick primer on URLs and paths
  - Document fragments
  - Absolute versus relative URLs
- Link best practices
  - Use clear link wording
  - Use relative links wherever possible
  - Linking to non-HTML resources - leave clear signposts
  - Use the download attribute when linking to a download
- E-mail links
  - Specifying details

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

作者想要介绍如何高效实现链接，以及如何把多个文件链接到一起。

## Q5：这篇文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- absolute URL: 完整的URL地址，包括协议和域名。
- relative URL: 相对当前HTML文档的URL地址，一般用于同一个服务器内的文档之间的跳转，因此省略协议和域名等信息。

## Q6：这篇文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

1. A basic link is created by wrapping the text or other content, see **Block level links**, inside an `<a>` element and using the **href** attribute, also known as a Hypertext Reference, or target, that contains the web address.

伍注：HTML link的content不局限于文字，也可以是图片或任何block-level elements。

2. **A link title is only revealed on mouse hover**, which means that people relying on keyboard controls or touchscreens to navigate web pages will have difficulty accessing title information. If a title's information is truly important to the usability of the page, then you should present it in a manner that will be accessible to all users, for example by putting it in the regular text.

3. Block level link uses block-level element as its content.
```
<a href="https://www.mozilla.org/en-US/">
  <img src="mozilla-image.png" alt="mozilla logo that links to the mozilla homepage">
</a>
```

4. It's possible to link to a specific part of an HTML document, known as a **document fragment**, rather than just to the top of the document.
  - To do this you first have to assign an **id** attribute to the element you want to link to. It normally makes sense to link to a specific heading:
  ```
  <h2 id="Mailing_address">Mailing address</h2>
  ```
  - To link to that specific id, you'd include it at the end of the URL, preceded by a hash/pound symbol (#):
  ```
  <p>Want to write us a letter? Use our <a href="contacts.html#Mailing_address">mailing address</a>.</p>
  ```

5. Absoulte versus relative URLs
  - absolute URL: Points to a location defined by its absolute location on the web, including protocol and domain name.
  - relative URL: Points to a location that is relative to the file you are linking from.

6. Link best practices
  - Use clear link wording.
    - Don't repeat the URL as part of the link text.
    - Don't say "link" or "links to" in the link text — it's just noise.
    - Keep your link text as short as possible — this is helpful because screen readers need to interpret the entire link text.
    - Minimize instances where multiple copies of the same text are linked to different places.
  - Use relative links wherever possible.
    - It's easier to scan your code.
    - It's more efficient to use relative URLs wherever possible.
  - Linking to non-HTML resources — leave clear signposts.
    - When linking to a resource that will be downloaded (like a PDF or Word document), streamed (like video or audio), or has another potentially unexpected effect (opens a popup window, or loads a Flash movie), you should add clear wording to reduce any confusion.
  - Use the **download** attribute when linking to a download.
    - When you are linking to a resource that's to be downloaded rather than opened in the browser, you can use the download attribute to provide a default save filename.

7. When you use an absolute URL, the browser starts by looking up the real location of the server on the Domain Name System (DNS). Then it goes to that server and finds the file that's being requested. With a relative URL, the browser just looks up the file that's being requested on the same server. If you use absolute URLs where relative URLs would do, you're constantly making your browser do extra work, meaning that it will perform less efficiently.

8. It's possible to create links or buttons that, when clicked, open a new outgoing email message rather than linking to a resource or page. This is done using the `<a>` element and the `mailto: URL` scheme.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

答：下定义+列举规则+举例说明（常用screen reader作为例子）+代码示例+练习。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

答：作者解决了：超链接是什么？由什么组成？如何编写高效的超链接？

## Q9：我有哪些疑问？

暂无。

## Q10：这篇文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这篇文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

答：暂没发现问题。

## Q11：这篇文档和我有什么关系？

> 备注：这篇文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这篇文档的理论应用到实践中？

答：
1. 掌握了链接的一些基础知识。包括block-level link和document fragment等。
2. 知道了书写好的链接的规范。包括尽可能使用相对链接、精简content、对于非HTML的资源要增加注解等。
