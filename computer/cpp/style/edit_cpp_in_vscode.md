# 《Edit C++ in Visual Studio Code》文档分析笔记

## Q1: 这个文档属于哪一类别的文档？

> 备注：是实用类还是理论类？哪个学科？

实用类/计算机技术。

## Q2：这个文档的内容是什么？

> 备注：用一句话或最多几句话来回答。

## Q3：这个文档的大纲是什么？

> 备注：按照顺序与关系，列出整篇文档的纲要及各个部分的纲要。

- Editing features
  - specify additional include directories
- List members
- Code formatting
- Enhanced semantic colorization
- Quick Info
- Peek Definition
- Navigate source code
  - Search for symbols
  - Go to Definition

## Q4：作者想要解决什么问题？

> 备注：如果问题很复杂，又分成很多部分，你还要说出次要的问题是什么。

## Q5：这个文档的关键词是什么？

> 备注：找出关键词，并确认这些关键词在使用时的含义。

## Q6：这个文档的关键句是什么？

> 备注：找出关键句，并确认这些关键句所表达的主旨。

> To specify additional include directories to be searched, place your cursor over any #include directive that displays a green squiggle, then click the lightbulb action when it appears. This opens the file `c_cpp_properties.json` for editing; here you can specify additional include directories for each platform configuration individually by adding more directories to the **'includePath'** property.

> The C/C++ extension for Visual Studio Code supports source code formatting using **clang-format** which is included with the extension.

> You can format an entire file with Format Document (Ctrl+Shift+I) or just the current selection with Format Selection (Ctrl+K Ctrl+F) in right-click context menu. You can also configure auto-formatting with the following settings:

editor.formatOnSave - to format when you save your file.
editor.formatOnType - to format as you type (triggered on the ; character).
> By default, the clang-format style is set to "file" which means it looks for a .clang-format file inside your workspace. If the .clang-format file is found, formatting is applied according to the settings specified in the file. If no .clang-format file is found in your workspace, formatting is applied based on a default style specified in the C_Cpp.clang_format_fallbackStyle setting instead.

> To use a different version of clang-format than the one that ships with the extension, change the C_Cpp.clang_format_path setting to the path where the clang-format binary is installed.

## Q7：作者是怎么论述的？

> 备注：从关键句中找出作者的论述结构。

## Q8：作者解决了什么问题？

> 备注：作者已经解决了哪些问题？未解决哪些问题？在未解决的问题当中，哪些是作者认为自己无法解决的？

## Q9：我有哪些疑问？

## Q10：这个文档说得有道理吗？为什么？

> 备注：1. 是全部有道理，还是部分有道理？我质疑哪些部分？2. 回答该问题时，需要先读懂这个文档、不要争强好辩、有理论依据。3. 反对作者时，可以从四方面入手：知识不足/知识有误/逻辑有误/分析不够完整。

## Q11：如何拓展这个文档？

### Q11.1：为什么是这样的？为什么发展成这样？为什么需要它？

> 备注：深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。简单地说就是问为什么：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

### Q11.2：有哪些相似的知识点？它们之间的联系是什么？

> 备注：水平拓展，指类比相似的知识点。知识点的载体可以是书籍、网站、视频等。相似点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

### Q11.3：其他领域/学科有没有相关的知识点？日常生活中有没有类似的现象？

> 备注：纵向拓展，指在看似无关联的知识点之间寻找联系。可以应用比喻法和内在化法来进行纵向拓展。

## Q12：这个文档和我有什么关系？

> 备注：这个文档的内容有什么意义？有什么用？有哪些值得我学习的地方？我怎样将这个文档的理论应用到实践中？

## 参考资料

1. [Edit C++ in Visual Studio Code](https://code.visualstudio.com/docs/cpp/cpp-ide)
