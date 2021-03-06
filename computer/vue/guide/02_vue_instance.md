# 《Vue Guide: The Vue Instance》文档分析笔记

## Q1: 这个文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

答：实用类。计算机科学->前端框架。

## Q2：这个文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

## Q3：这个文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

## Q5：这个文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

- MVVM pattern
- Lifecycle Diagram

## Q6：这个文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

> Every Vue application starts by creating a new Vue instance with the Vue function.

> When you create a Vue instance, you pass in an **options object**.

> The only exception to this being the use of `Object.freeze()`, which prevents existing properties from being changed, which also means the reactivity system can’t track changes.

> Each Vue instance goes through a series of initialization steps when it’s created
  - Set up data observation,
  - compile the template,
  - mount the instance to the DOM,
  - Update the DOM when data changes.
  
> Along the way, it also runs functions called **lifecycle hooks**, giving users the opportunity to add their own code at specific stages.
  - created
  - mounted
  - updated
  - destroyed

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

## Q10：这个文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这个文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

## Q11：这个文档和我有什么关系？

> 备注：这个文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这个文档的理论应用到实践中？

