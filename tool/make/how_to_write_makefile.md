# 如何写Makefile

## 实用技巧

- 如何实现默认情况下不打印Makefile中的命令，而用户给出要求时可以打印？
  - 在Makefile定义`V=@`，在执行编译链接等语句前都加上`$(V)`，这样直接make时不会打印Makefile中的命令，而输入`make "V="`时则会打印。

## 基本语法

```make
target target-name : prerequisite-file-name
    command1
    command2
    ...
```

- makefile 的规则
  - prerequisites 中如果有一个以上的文件比 target 文件要新的话， command 所定义的命令就会被执行。

## 基本原理

- makefile 的工作过程
  - make 会一层又一层地去找文件的依赖关系，直到最终编译出第一个目标文件。
  - 在找寻的过程中，如果出现错误，比如最后被依赖的文件找不到，那么 make 就会直接退出，并报错。
  - 对于所定义的命令的错误，或是编译不成功， make 根本不理。
  - make 只管文件的依赖性，即，如果在我找了依赖关系之后，冒号后面的文件还是不在，那么对不起，我就不工作啦。

- `make clean` 的工作原理
  - 由于 clean 没有被第一个目标文件直接或间接关联，那么它后面所定义的命令将不会被自动执行。
  - 我们可以通过执行 `make clean` 显式要 make 执行，以此来清除所有的目标文件，以便重编译。
  - 下面是更稳健的clean写法。
    - `.PHONY` 表示 clean 是一个「伪目标」。
    - rm 命令前面加了一个小减号的意思就是，也许某些文件出现问题，但不要管，继续做后面的事。
    - 如果没有 `.PHONY` 语句显式声明这是伪目标，则存在以下问题：
      如果当前目录中，正好有一个文件叫做clean，那么这个命令不会执行。
      因为Make发现clean文件已经存在，就认为没有必要重新构建了，就不会执行指定的rm命令。

  ```make
  .PHONY: clean
  clean:
      -rm edit $(objects)
  ```

- GNU make 的执行步骤
  - 读入所有的 Makefile。
  - 读入被 include 的其它 Makefile。
  - 初始化文件中的变量。
  - 推导隐晦规则，并分析所有规则。
  - 为所有的目标文件创建依赖关系链。
  - 根据依赖关系，决定哪些目标要重新生成。
  - 执行生成命令。

- 对 GNU make 执行步骤的注释
  - 第 1-5 步为第一个阶段， 第 6-7 步为第二个阶段。
  - 第一个阶段中，如果定义的变量被使用了，那么， make会把其展开在使用的位置。
  - 但 make 并不会完全马上展开， make 使用的是拖延战术，
    如果变量出现在依赖关系的规则中，那么仅当这条依赖被决定要使用了，变量才会在其内部展开。

- Makefile 每行命令在一个单独的 shell 中执行
  - 这些 shell 之间没有继承关系
  - 比如下面代码执行后，取不到 foo 的值， 因为两行命令在两个不同的进程执行。
  - 解决办法一是将两行命令写在一行，中间用分号分隔。
  - 解决办法二是在换行符前加反斜杠转义。

  ```make
  export foo=bar
  echo "foo=[$$foo]"
  ```

- GNU make 寻找默认 Makefile 的规则
  - 在当前目录下依次找三个文件：GNUmakefile、makefile、Makefile。
  - 按顺序寻找这三个文件，一旦找到，就开始读取这个文件并执行。

- 为 make 命令指定一个特殊名字的 Makefile
  - 使用 make的 `-f` 或 `--file` 参数。
  - 举例：`make –f hchen.mk`

- make 的最终目标
  - 一般来说， make 的最终目标是 makefile 中的第一个目标，而其它目标一般是由这个目标连带出来的。这是 make 的默认行为。
  - 当然，如果你的 makefile 中的第一个目标是由许多个目标组成，你可以指示 make，让其完成你所指定的目标。比如 `make clean`

- make 的常见功能
  - 在 Unix 世界中，软件发布时，特别是 GNU 这种开源软件的发布时，其 makefile 都包含了编译、安装、打包等功能。
  - 我们可以参照这种规则来书写我们的 makefile 中的目标。

- make 的常见目标
  - all: 这个伪目标是所有目标的目标，其功能一般是编译所有的目标。
  - clean: 这个伪目标功能是删除所有被 make 创建的文件。
  - install: 这个伪目标功能是安装已编译好的程序，其实就是把目标执行文件拷贝到指定的目标中去。
  - print: 这个伪目标的功能是例出改变过的源文件。
  - tar: 这个伪目标功能是把源程序打包备份。也就是一个 tar 文件。
  - dist: 这个伪目标功能是创建一个压缩文件，一般是把 tar 文件压成 Z 文件。或是 gz 文件。
  - TAGS: 这个伪目标功能是更新所有的目标，以备完整地重编译使用。
  - check 和 test: 这两个伪目标一般用来测试 makefile 的流程。

## 书写规则

- `wildcard`
  - 功能
    - 在Makefile规则中，通配符会被自动展开。但在变量的定义和函数引用时，通配符将失效。
    - 这种情况下如果需要通配符有效，就需要使用函数`wildcard`
  - 用法
    - `$(wildcard PATTERN...)`
    - `$(wildcard \*.c)` 获取工作目录下的所有的 `.c` 文件列表。
    - `$(patsubst %.c,%.o,$(wildcard \*.c))`，获取工作目录下的所有的 `.o` 文件列表。
  - 工作原理
    - 在 Makefile 中，它被展开为已经存在的、使用空格分开的、匹配此模式的所有文件列表。
    - 如果不存在任何符合此模式的文件，函数会忽略模式字符并返回空。

- [Setting Variables][1]
  - Variables defined with `=` are recursively expanded variables.
  - Variables defined with `:=` or `::=` are simply expanded variables;
    these definitions can contain variable references which will be expanded before the definition is made.
  - Variables defined with `?=` are set to a value only if they'are not already set.

- 静态模式
  - 比如下面的例子，指明了我们的目标从 $object 中获取.
  - `%.o` 表明要所有以 `.o` 结尾的目标，也就是 `foo.o bar.o` ，也就是变量 $object 集合的模式。
  - 依赖模式 `%.c` 则取模式 `%.o` 的 `%` ，也就是 `foo bar`，并为其加下 `.c` 的后缀，于是，我们的依赖目标就是 `foo.c bar.c`。

  ```make
  objects = foo.o bar.o
  all: $(objects)
  $(objects): %.o: %.c
      $(CC) -c $(CFLAGS) $^ -o $@
  ```

- `-M` 或 `-MM`
  - 大多数的 C/C++ 编译器都支持一个 `-M` 的选项，即自动找寻源文件中包含的头文件，并生成一个依赖关系。
  - 如果你使用 GNU 的 C/C++ 编译器，你得用 `-MM` 参数，因为 `-M` 参数会把一些标准库的头文件也包含进来。

- 依赖关系单独放在一个文件中
  - GNU 组织建议把编译器为每一个源文件的自动生成的依赖关系放到一个文件中
  - 为每一个 `name.c` 的文件都生成一个 `name.d` 的 Makefile 文件， `.d` 文件中就存放对应 `.c` 文件的依赖关系。

## 书写命令

- `@` 关闭命令显示
  - 通常 make 会把其要执行的命令行在命令执行前输出到屏幕上。当我们用 `@` 字符在命令行前，那么，这个命令将不被 make 显示出来。

- `;` 在同一个 shell 里面执行多条命令
  - 如果你要让上一条命令的结果应用在下一条命令时，你应该使用分号分隔这两条命令。
  - 比如你的第一条命令是 cd 命令，你希望第二条命令得在 cd 之后的基础上运行，那么你应该把这两条命令写在一行上，用分号分隔。

- `-` 忽略错误
  - 有时我们需要忽略命令的出错（比如创建一个目录，如果目录已存在也不报错），
    可以在 Makefile 的命令行前加一个减号 - （在 Tab 键之后），标记为不管命令出不出错都认为是成功的。

- `$(MAKE)`
  - makefile 脚本中往往定义 $(MAKE) 宏变量，其原因是：也许我们的 make 需要一些参数，所以定义成一个变量比较利于维护。

- makefile 参数传递
  - 我们把根目录下的 Makefile 叫做「总控 Makefile」
  - 总控 Makefile 的变量可以传递到下级的Makefile 中（如果你显式的声明），但是不会覆盖下层的 Makefile 中所定义的变量，除非指定了 `-e` 参数。
  - 如果你要传递变量到下级 Makefile 中，那么你可以使用这样的声明：`export <variable ...>;`
  - 如果你不想让某些变量传递到下级 Makefile 中，那么你可以这样声明: `unexport <variable ...>;`
  - 不管你是否 export，`SHELL` 和 `MAKEFLAGS` 这两个变量总是传递到下层 Makefile 中
    - MAKEFLAGS 是一个系统级的环境变量
    - MAKEFLAGS 变量包含了 make 的参数信息
    - 如果我们执行「总控 Makefile」时有 make 参数或是在上层 Makefile 中定义了这个变量，
      那么 MAKEFLAGS变量将会是这些参数，并会传递到下层 Makefile 中。
  - make 命令中的有几个参数并不往下传递，它们是：-C, -f, -h, -o 和 -W。
  - 如果你定义了环境变量 MAKEFLAGS ，那么你得确信其中的选项是大家都会用到的，
    如果其中有 -t, -n 和 -q 参数，那么将会有让你意想不到的结果，或许会让你异常地恐慌
  - `-w` 或 `--print-directory` 会在 make 的过程中输出一些信息，让你看到目前的工作目录

## 使用变量

- 变量在声明时需要给予初值。

- 变量在使用时，需要在变量名前加上 $ 符号，但最好用小括号 `()` 或是大括号 `{}` 把变量括起来。

- 如果你要使用真实的 $ 字符，那么你需要用 $$ 来表示。

- 变量会在使用它的地方精确地展开，就像 C/C++ 中的宏一样。

- 变量替换

  ```make
  # 把变量 var 中所有以 a 字串结尾的 a 替换成 b 字串
  $(var:a=b)
  # or
  ${var:a=b}

  # 把变量 foo 中所有以 .o 结尾的字符串中的 .o 替换成 .c
  bar := $(foo:.o=.c)
  # or
  bar := $(foo:%.o=%.c)`
  ```

- `+=`
  - += 操作符给变量追加值。
  - 如果之前没有定义过该变量，那么， += 会自动变成 =
  - 如果之前定义过该变量，那么 += 会继承于前次操作的赋值符。
  - 如果前一次定义时使用的操作符是 := ，那么 += 会以 := 作为其赋值符。

- override
  - 如果某变量通常是在 make 的命令行参数设置的，那么 Makefile 中对这个变量的赋值会被忽略。
  - 如果你想在 Makefile 中设置这类参数的值，那么你可以使用 `override` 指示符。

- 环境变量
  - 如果我们在环境变量中设置了 CFLAGS 环境变量，那么我们就可以在所有的 Makefile 中使用这个变量了。
    这对于我们使用统一的编译参数有比较大的好处。
  - 如果 Makefile 中定义了 CFLAGS，那么则会使用 Makefile 中的这个变量，如果没有定义则使用系统环境变量的值。
    一个共性和个性的统一，很像「全局变量」和「局部变量」的特性。

### 自动变量

- `$@` 指代当前目标，就是 Make 命令当前构建的那个目标。比如，`make foo` 的 `$@` 就指代 foo。

- `$<` 指代第一个前置条件。比如，规则为 `t: p1 p2`，那么 `$<` 就指代 p1。

- `$?` 指代比目标更新的所有前置条件，之间以空格分隔。比如，规则为 `t: p1 p2`，其中 p2 的时间戳比 t 新，`$?` 就指代 p2。

- `$^` 指代所有前置条件，之间以空格分隔。比如，规则为 `t: p1 p2`，那么 `$^` 就指代 p1 p2 。

- `$*` 指代匹配符 % 匹配的部分， 比如 % 匹配 f1.txt 中的 f1 ，`$*` 就表示 f1。

- `$(@D)` 和 `$(@F)` 分别指向 `$@` 的目录名和文件名。比如，`$@` 是 src/input.c，那么 `$(@D)` 的值为 src ，`$(@F)` 的值为 input.c。

- `$(<D)` 和 `$(<F)` 分别指向 `$<` 的目录名和文件名。

## 使用条件判断

- `ifdef <variable-name>` 如果变量 variable-name 的值非空，那么表达式为真。否则，表达式为假。

## 使用函数

### 字符串处理函数

- `$(subst <from>,<to>,<text>)`
  - 把字串 `<text>` 中的 `<from>` 字符串替换成 `<to>` ，并返回被替换过后的字符串。

- `$(patsubst <pattern>,<replacement>,<text>)`
  - 查找 `<text>` 中的单词（单词以空格、Tab、回车符或换行符分隔）是否符合模式 `<pattern>`，如果匹配的话，则以 `<replacement>` 替换。
  - `<pattern>` 可以包括通配符 % ，表示任意长度的字串。
  - 如果 `<replacement>` 中也包含 % ，那么， `<replacement>` 中的这个 % 将是 `<pattern>` 中的那个 % 所代表的字串。
  - 如果要表示真实含义的 % 字符，可以用 `\%`。
  - 返回被替换过后的字符串。

- `$(strip <string>)`
  - 去掉 `<string>` 字串中开头和结尾的空字符。

- `$(findstring <find>,<in>)`
  - 在字串 `<in>` 中查找 `<find>` 字串。如果找到，那么返回 `<find>` ，否则返回空字符串。

- `$(filter <pattern...>,<text>)`
  - 以 `<pattern>` 模式过滤 `<text>` 字符串中的单词，保留符合模式 `<pattern>` 的单词。可以有多个模式。
  - 最终返回符合模式 `<pattern>` 的字串。

- `$(filter-out <pattern...>,<text>)`
  - 以 `<pattern>` 模式过滤 `<text>` 字符串中的单词，去除符合模式 `<pattern>` 的单词。可以有多个模式。
  - 最终返回不符合模式 `<pattern>` 的字串。

- `$(sort <list>)`
  - 给字符串 `<list>` 中的单词排序（升序）。返回排序后的字符串。

- `$(word <n>,<text>)`
  - 返回字符串 `<text>` 中第 n 个单词。
  - 如果 n 比 `<text>` 中的单词数要大，那么返回空字符串。

- `$(wordlist <s>,<e>,<text>)`
  - 返回字符串 `<text>` 中取从 s 开始到 e 的单词串。 s 和 e 是一个数字。
  - 如果 s 比 `<text>` 中的单词数要大，那么返回空字符串。
  - 如果 e 比 `<text>` 中的单词数要大，那么返回从 s 开始，到 `<text>` 结束的单词串。

- `$(words <text>)`
  - 返回 `<text>` 中的单词数。

- `$(firstword <text>)`
  - 取字符串 `<text>` 中的第一个单词。

### 文件名处理函数

- `$(dir <names...>)`
  - 从文件名序列 `<names>` 中取出目录部分。目录部分是指最后一个反斜杠（/ ）之前的部分。
  - 如果没有反斜杠，那么返回 `./`。

- `$(notdir <names...>)`
  - 从文件名序列 `<names>` 中取出非目录部分。非目录部分是指最後一个反斜杠（/ ）之后的部分。

- `$(suffix <names...>)`
  - 从文件名序列 `<names>` 中取出各个文件名的后缀。
  - 返回文件名序列 `<names>` 的后缀序列，如果文件没有后缀，则返回空字串。

- `$(basename <names...>)`
  - 从文件名序列 `<names>` 中取出各个文件名的前缀部分。
  - 返回文件名序列 `<names>` 的前缀序列，如果文件没有前缀，则返回空字串。

- `$(addsuffix <suffix>,<names...>)`
  - 把后缀 `<suffix>` 加到 `<names>` 中的每个单词后面。返回加过后缀的文件名序列。

- `$(addprefix <prefix>,<names...>)`
  - 把前缀 `<prefix>` 加到 `<names>` 中的每个单词后面。返回加过前缀的文件名序列。

- `$(join <list1>,<list2>)`
  - 把 `<list2>` 中的单词对应地加到 `<list1>` 的单词后面。
  - 如果 `<list1>` 的单词个数要比 `<list2>` 的多，那么 `<list1>` 中的多出来的单词将保持原样。
  - 如果 `<list2>` 的单词个数要比 `<list1>` 的多，那么 `<list2>` 多出来的单词将被复制到 `<list1>` 中。
  - 返回连接过后的字符串。

### 其他

- `$(foreach <var>,<list>,<text>)`
  - 把参数 `<list>` 中的单词逐一取出放到参数 `<var>` 所指定的变量中，然后再执行 `<text>` 所包含的表达式。
  - 每一次 `<text>` 会返回一个字符串，循环过程中， `<text>` 的所返回的每个字符串会以空格分隔。
  - 最后当整个循环结束时， `<text>` 所返回的每个字符串所组成的整个字符串（以空格分隔）将会是 foreach 函数的返回值。

- `$(call <expression>,<parm1>,<parm2>,...,<parmn>)`
  - call 函数是唯一一个可以用来创建新的参数化的函数。
  - 你可以写一个非常复杂的表达式，这个表达式中，你可以定义许多参数，然后你可以 call 函数来向这个表达式传递参数。
  - 当 make 执行这个函数时， `<expression>` 参数中的变量，如 `$(1)`、`$(2)` 等，会被参数 `<parm1>`、`<parm2>`、`<parm3>` 依次取代。
  - `<expression>` 的返回值就是 call 函数的返回值。

- `$(origin <variable>)`
  - origin 函数不像其它的函数，它并不操作变量的值，它只是告诉你你的这个变量是哪里来的。
  - 注意，`<variable>` 是变量的名字，不应该是引用。所以你最好不要在 `<variable>` 中使用 $ 字符。
  - origin 函数会以其返回值来告诉你这个变量的「出生情况」：
    - undefined 如果 `<variable>` 从来没有定义过， origin 函数返回这个值 undefined
    - default 如果 `<variable>` 是一个默认的定义，比如“CC”这个变量，这种变量我们将在后面讲述。
    - environment 如果 `<variable>` 是一个环境变量，并且当 Makefile 被执行时， -e 参数没有被打开。
    - file 如果 `<variable>` 这个变量被定义在 Makefile 中。
    - command line 如果 `<variable>` 这个变量是被命令行定义的。
    - override 如果 `<variable>` 是被 override 指示符重新定义的。
    - automatic 如果 `<variable>` 是一个命令运行中的自动化变量。

- 慎用 shell 函数
  - 这个函数会新生成一个 Shell 程序来执行命令，所以你要注意其运行性能。
  - 如果你的Makefile 中有一些比较复杂的规则，并大量使用了这个函数，那么对于你的系统性能是有害的。
  - 特别是 Makefile 的隐晦的规则可能会让你的 shell 函数执行的次数比你想像的多得多。

## 一个示例

### 原始版本

```make
edit : main.o kbd.o command.o display.o \
       insert.o search.o files.o utils.o
    cc -o edit main.o kbd.o command.o display.o \
           insert.o search.o files.o

main.o : main.c defs.h
    cc -c main.c

kbd.o : kbd.c defs.h command.h
    cc -c kbd.c

command.o : command.c defs.h command.h
    cc -c command.c

display.o : display.c defs.h buffer.h
    cc -c display.c

insert.o : insert.c defs.h buffer.h
    cc -c insert.c

search.o : search.c defs.h buffer.h
    cc -c search.c

files.o : files.c defs.h buffer.h command.h
    cc -c files.c

utils.o : utils.c defs.h
    cc -c utils.c

clean:
    rm edit main.o kbd.o command.o display.o \
    insert.o search.o files.o utils.o
```

注意：定义好依赖关系后，后续的那一行command必须以一个Tab键作为开头。

### 优化1：使用变量

```make
objects =  main.o kbd.o command.o display.o \
      insert.o search.o files.o utils.o

edit: $(objects)
    cc -o edit $(objects)
```

### 优化2：让 make 自动推导

GNU make 看到一个 somefile.o 文件时，会自动的把对应的 somefile.c 文件加在依赖关系中，并且`cc -c somefile.c`也会被推导出来。
这使得我们在写依赖关系时可以更简洁。

```make
# 由于 make 会自动推导出来 make.c，此处省略不写。
main.o : defs.h
```

## 参考资料

- [跟我一起写Makefile](http://wiki.ubuntu.com.cn/index.php?title=%E8%B7%9F%E6%88%91%E4%B8%80%E8%B5%B7%E5%86%99Makefile&variant=zh-cn)

- [跟我一起写 Makefile （seisman整理的版本）](https://github.com/seisman/how-to-write-makefile)

- [阮一峰：Make 命令教程](https://blog.csdn.net/a_ran/article/details/43937041)

- [GNU make's manual](https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents)

  [1]: https://www.gnu.org/software/make/manual/html_node/Setting.html
