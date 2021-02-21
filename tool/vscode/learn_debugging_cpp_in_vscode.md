# 使用vscode调试C++程序

## Q1: 它的本质是什么？

1. 使用vscode调试C++程序，实际上是使用gdb、lldb或Windows Debugger这些调试器来调试程序。而vscode在这些调试器的基础上提供了更加友好的UI。比如gdb是通过命令行进行调试的，查看某个变量要使用print命令，而在vscode下只需把鼠标焦点移到变量名上即可查看。

2. 调试器的本质是什么？调试的原理是什么？

## Q2: 它的第一原理是什么？

调试的原理。

## Q3: 它的知识结构是怎样的？

- 调试的原理
  - 为什么能调试一个程序
  - 调试程序时究竟发生了什么
- 调试的方法
- gdb调试技巧
- vscode UI操作

## Q4: 它的知识细节是怎样的？

1. `Ctl-X A` will switch gdb to TUI mode (assuming it’s been configured in your gdb build). It provides a multi-pane text-mode interface that’s often convenient.

2. [How can one become as efficient at using GDB as in using a visual debugger?][efficient_gdb]
  - First, achieve functional parity with a GUI debugger, with higher productivity with keystroke efficiency.
  - Secondly, learn about the advanced features of gdb.
    - You can assign variables new values and continue execution.
    - You can cast data on the fly to inspect it in an alternate form.
    - You can use temporary conditional breakpoints to get into the thick of a loop
    - under certain complex conditions while skipping a lot of tedious stepping.
    - You can use variable completion to access symbol names quickly with a minimal amount of inputs and potential for typos.
    - You can attach to running processes, or you can debug cores.
    - You can capture the output of what you are doing to log files for future reference, and easy sharing with others.
  - Finally, it is time to unleash to real power of gdb, using **macros**.

  [efficient_gdb]: https://www.quora.com/How-can-one-become-as-efficient-at-using-GDB-as-in-using-a-visual-debugger

## Q5: 我有哪些疑问？

### Q5.1: gdb, lldb和Windows Debugger有哪些区别？孰优孰劣？

1. 它们所隶属的组织不同，相关的编译工具链也不同。
  - gdb 是GNU项目组织的标准调试器，和GNU编译器配合工作。
  - lldb 是LLVM项目组织的标准调试器，和LLVM编译器配合工作。
  - Windows Debugger是Windows系统下才能使用的调试工具，和MSVC编译器配合工作。

2. 用户界面不同。
  - gdb/lldb都是命令行界面。而gdb和lldb所使用的调试命令也有所差异。
  - Windows Debugger是图形界面。

3. 孰优孰劣？暂时不知。

### Q5.2: 软件调试的原理是什么？

### Q5.3: 我们能调试一个正在运行的程序吗？

### Q5.4: gdb macros是什么？有什么用？怎么使用？

## 深度拓展

深度拓展，指理解知识的来龙去脉，知其然也要知其所以然。这里要解决的问题是：为什么是这样的？为什么发展成这样的？为什么需要它？（有一点点像深度搜索）

## 水平拓展

水平拓展，指联系相似或相关的知识点。这里要解决的问题是：有哪些类似或相关的知识点？它们之间的联系是什么？相似点或相关点可以是时间、地点、发现者、主题、核心思想等等。（有一点点像广度搜索）

- lldb -> llvm -> clang

## 纵向拓展

纵向拓展，指在看似无关联的知识点之间寻找联系。这里要解决的问题是：能否将它与生活中的例子、自然事物、历史事件或其他领域联系起来？可以应用比喻法和内在化法来进行纵向拓展。

## 应用

怎么把它应用到实践中？
