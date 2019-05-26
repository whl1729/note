# 《ucore lab1 exercise1》实验报告

## 资源

1. [ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)
2. [我的ucore实验代码](https://github.com/whl1729/ucore_os_lab)

## 题目：理解通过make生成执行文件的过程

1. 列出本实验各练习中对应的OS原理的知识点，并说明本实验中的实现部分如何对应和体现了原理中的基本概念和关键知识点。  

2. 操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)

3. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

## 解答

### 题目1的解答
等完成lab1后再回头总结。

### 题目2的解答

首先具体分析Makefile的执行流程，然后再回答题目所问的ucore.img的生成过程。

#### 设置环境变量
第1~139行大部分是设置环境变量、编译选项等，其中关键是第117行和第136行，分别设置了libs和kern目录下的obj文件名，两者合并即为$(KOBJS)。

##### 第117行：生成libs目录下的obj文件名
1. 第117行语句是`$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)`，可见是调用了add_files_cc函数，输入参数有2个，第2个是libs（目录名），第1个是调用另一个函数listf_cc的返回值

2. listf_cc函数的定义为`listf_cc = $(call listf,$(1),$(CTYPE))`，可见listf_cc又调用了listf函数，调用时传入的第1个参数为`$(1) = $(LIBDIR) = libs`，第2个参数为`$(CTYPE) = c S`

3. listf函数的定义为`listf = $(filter $(if $(2),$(addprefix %.,$(2)),%), $(wildcard $(addsuffix $(SLASH)*,$(1))))`，将输入参数代入得：`listf = $(filter %.c %.S, libs/*)`，可见此处调用listf的返回结果为libs目录下的所有.c和.S文件。由于lab1的libs目录下只有.h和.c文件，因此最终返回.c文件。

4. 这时，第117行语句可化简为`add_files_cc(libs/*.c, libs)`

5. add_files_cc的定义为`add_files_cc = $(call add_files,$(1),$(CC),$(CFLAGS) $(3),$(2),$(4))`，结合4可化简为`add_files(libs/*.c, gcc, $(CFLAGS), libs)`

6. add_files的定义为`add_files = $(eval $(call do_add_files_to_packet,$(1),$(2),$(3),$(4),$(5)))`，而do_add_files_to_packet的定义为：
```
define do_add_files_to_packet
__temp_packet__ := $(call packetname,$(4))
ifeq ($$(origin $$(__temp_packet__)),undefined)
$$(__temp_packet__) :=
endif
__temp_objs__ := $(call toobj,$(1),$(5))
$$(foreach f,$(1),$$(eval $$(call cc_template,$$(f),$(2),$(3),$(5))))
$$(__temp_packet__) += $$(__temp_objs__)
endef
```

7. packetname的定义为`packetname = $(if $(1),$(addprefix $(OBJPREFIX),$(1)),$(OBJPREFIX))`，其中`$(OBJPREFIX)=__objs_`，而`$(1)=libs`，因此`__temp_packet_ = __objs_libs`

8. toobj的定义为`toobj = $(addprefix $(OBJDIR)$(SLASH)$(if $(2),$(2)$(SLASH)), $(addsuffix .o,$(basename $(1))))`，其中`$(OBJDIR)=obj, $(SLASH)=/`，而输入参数为`$(1)=libs/*.c, $(5)=''`，因此`__temp_objs_ = obj/libs/*.o`

9. 综上，第117行的最终效果是`__objs_libs = obj/libs/**/*.o`

##### 第136行：生成kern目录下的obj文件名
生成过程与第117行类似，不再赘述。第136行的实际效果是`__objs_kernel = obj/kern/**/*.o`

#### 生成kernel文件
第140～151行是生成kernel文件。由于脚本中的语句往往会引用到前面定义的变量，而前面定义的变量又可能引用到其他文件的变量，为便于分析，下面会将所有相关的语句集中放在一起。

1. 第141行设置生成的kernel目标名为`bin/kernel`
```
kernel = $(call totarget,kernel)
totarget = $(addprefix $(BINDIR)$(SLASH),$(1))
BINDIR	:= bin
SLASH	:= /
```

2. 第143行指出kernel目标文件需要依赖tools/kernel.ld文件，而kernel.ld文件是一个链接脚本，其中设置了输出的目标文件的入口地址及各个段的一些属性，包括各个段是由输入文件的哪些段组成、各个段的起始地址等。
```
$(kernel): tools/kernel.ld
```

3. 第145行指出kernel目标文件依赖的obj文件。最终效果为`KOBJS=obj/libs/*.o obj/kern/**/*.o`。
```
$(kernel): $(KOBJS)
KOBJS   = $(call read_packet,kernel libs)
read_packet = $(foreach p,$(call packetname,$(1)),$($(p)))
packetname = $(if $(1),$(addprefix $(OBJPREFIX),$(1)),$(OBJPREFIX))
OBJPREFIX	:= __objs_
```

4. 第146行打印kernel目标文件名
```
@echo + ld $@
// output: + ld bin/kernel
```

5. 第147行是链接所有生成的obj文件得到kernel文件
```
$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
V       := @
LD      := $(GCCPREFIX)ld
// GCCPREFIX = 'i386-elf-' or ''
// output: ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/stdio.o obj/kern/libs/readline.o obj/kern/debug/panic.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/picirq.o obj/kern/driver/intr.o obj/kern/trap/trap.o obj/kern/trap/vectors.o obj/kern/trap/trapentry.o obj/kern/mm/pmm.o  obj/libs/string.o obj/libs/printfmt.o
```

6. 第148行是使用objdump工具对kernel目标文件反汇编，以便后续调试。首先toobj返回obj/kernel.o，然后cgtype返回obj/kernel.asm，所以第148行相当于执行`objdump -S bin/kernel > obj/kernel.asm`，objdump的-S选项是交替显示将C源码和汇编代码。
```
@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
OBJDUMP := $(GCCPREFIX)objdump
// GCCPREFIX = 'i386-elf-' or ''
asmfile = $(call cgtype,$(call toobj,$(1)),o,asm)
cgtype = $(patsubst %.$(2),%.$(3),$(1))
toobj = $(addprefix $(OBJDIR)$(SLASH)$(if $(2),$(2)$(SLASH)),\
		$(addsuffix .o,$(basename $(1))))
OBJDIR	:= obj
SLASH	:= /
```

7. 第149行是使用objdump工具来解析kernel目标文件得到符号表。如果不关注格式处理，实际执行语句等效于`objdump -t bin/kernel > obj/kernel.sym`。
```
@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call sy    mfile,kernel)
OBJDUMP := $(GCCPREFIX)objdump
SED		:= sed
symfile = $(call cgtype,$(call toobj,$(1)),o,sym)
```

8. 第151行是调用create_target函数：`$(call create_target,kernel)`，而create_target的定义为`create_target = $(eval $(call do_create_target,$(1),$(2),$(3),$(4),$(5)))`，可见create_target只是进一步调用了do_create_target的函数：`do_create_target(kernel)`

9. do_create_target的定义如下。由于只有一个输入参数，temp_objs为空字符串，并且走的是else分支，因此感觉这里的函数调用是直接返回，啥也没干？
```
// add packets and objs to target (target, #packes, #objs[, cc, flags])
define do_create_target
__temp_target__ = $(call totarget,$(1))
__temp_objs__ = $$(foreach p,$(call packetname,$(2)),$$($$(p))) $(3)
TARGETS += $$(__temp_target__)
ifneq ($(4),)
$$(__temp_target__): $$(__temp_objs__) | $$$$(dir $$$$@)
	$(V)$(4) $(5) $$^ -o $$@
else
$$(__temp_target__): $$(__temp_objs__) | $$$$(dir $$$$@)
endif
endef
```

#### 生成bootblock

1. 第156行：`bootfiles = $(call listf_cc,boot)`，前面已经知道listf_cc函数是过滤出对应目录下的.c和.S文件，因此`bootfiles=boot/\*.c boot/\*.S`

2. 第157行：从字面含义也可以看出是编译bootfiles生成.o文件。
```
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))
cc_compile = $(eval $(call do_cc_compile,$(1),$(2),$(3),$(4)))
define do_cc_compile
$$(foreach f,$(1),$$(eval $$(call cc_template,$$(f),$(2),$(3),$(4))))
endef
```

3. cc_template的定义为
```
// cc compile template, generate rule for dep, obj: (file, cc[, flags, dir])
define cc_template
$$(call todep,$(1),$(4)): $(1) | $$$$(dir $$$$@)
	@$(2) -I$$(dir $(1)) $(3) -MM $$< -MT "$$(patsubst %.d,%.o,$$@) $$@"> $$@
$$(call toobj,$(1),$(4)): $(1) | $$$$(dir $$$$@)
	@echo + cc $$<
	$(V)$(2) -I$$(dir $(1)) $(3) -c $$< -o $$@
ALLOBJS += $$(call toobj,$(1),$(4))
endef
```

4. 第159行：`bootblock = $(call totarget,bootblock)`，前面已经知道totarget函数是给输入参数增加前缀"bin/"，因此`bootblock="bin/bootblock"`

5. 第161行声明bin/bootblock依赖于obj/boot/\*.o 和bin/sign文件：`$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)`。注意toobj函数的作用是给输入参数增加前缀obj/，并将文件后缀名改为.o

6. 第163行链接所有.o文件以生成obj/bootblock.o：`$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)`。这里要注意链接选项中的`-e start -Ttext 0x7C00`，大致意思是设置bootblock的入口地址为start标签，而且start标签的地址为0x7C00.（未理解-Ttext的含义）
	
7. 第164行反汇编obj/bootblock.o文件得到obj/bootblock.asm文件：`@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)`

8. 第165行使用objcopy将obj/bootblock.o转换生成obj/bootblock.out文件，其中***-S表示转换时去掉重定位和符号信息***：`@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)`
	
9. 第166行使用bin/sign工具将obj/bootblock.out转换生成bin/bootblock目标文件：`@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)`，从tools/sign.c代码中可知sign工具其实只做了一件事情：***将输入文件拷贝到输出文件，控制输出文件的大小为512字节，并将最后两个字节设置为0x55AA（也就是ELF文件的magic number）***

10. 第168行调用了create_target函数`$(call create_target,bootblock)`，根据上文的分析，由于只有一个输入参数，此处函数调用应该也是直接返回，啥也没干。

#### 生成sign工具

1. 第173行调用了add_files_host函数：`$(call add_files_host,tools/sign.c,sign,sign)`

2. add_files_host的定义为`add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))`，可见是调用了add_files函数：`add_files(tools/sign.c, gcc, $(HOSTCFLAGS), sign, sign)`

3. add_files的定义为`add_files = $(eval $(call do_add_files_to_packet,$(1),$(2),$(3),$(4),$(5)))`，根据前面的分析，do_add_files_to_packet的作用是生成obj文件，因此这里调用add_files的作用是设置`\_\_objs\_sign = obj/sign/tools/sign.o`

4. 第174行调用了create_target_host函数：`$(call create_target_host,sign,sign)`

5. create_target_host的定义为`create_target_host = $(call create_target,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS))`，可见是调用了create_target函数：`create_target(sign, sign, gcc, $(HOSTCFLAGS))`

6. create_target的定义为`create_target = $(eval $(call do_create_target,$(1),$(2),$(3),$(4),$(5)))`。根据前面的分析，do_create_target的作用是生成目标文件，因此这里调用create_target的作用是生成`obj/sign/tools/sign.o`

#### 生成ucore.img

1. 第179行设置了ucore.img的目标名：`UCOREIMG	:= $(call totarget,ucore.img)`，前面已经知道totarget的作用是添加bin/前缀，因此`UCOREIMG = bin/ucore.img`

2. 第181行指出bin/ucore.img依赖于bin/kernel和bin/bootblock：` $(UCOREIMG): $(kernel) $(bootblock)`

3. 第182行：`$(V)dd if=/dev/zero of=$@ count=10000`。这里为bin/ucore.img分配10000个block的内存空间，并全部初始化为0。由于没指定block的大小，因此为默认值512字节，则总大小为5000M，约5G。
> 备注：在类UNIX 操作系统中, /dev/zero 是一个特殊的文件，当你读它的时候，它会提供无限的空字符(NULL, ASCII NUL, 0x00)。其中的一个典型用法是用它提供的字符流来覆盖信息，另一个常见用法是产生一个特定大小的空白文件。BSD就是通过mmap把/dev/zero映射到虚地址空间实现共享内存的。可以使用mmap将/dev/zero映射到一个虚拟的内存空间，这个操作的效果等同于使用一段匿名的内存（没有和任何文件相关）。

4. 第183行：`$(V)dd if=$(bootblock) of=$@ conv=notrunc`。这里将bin/bootblock复制到bin/ucore.img

5. 第184行：`$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc`。继续将bin/kernel复制到bin/ucore.img，这里使用了选项`seek=1`，意思是：复制时跳过bin/ucore.img的第一个block，从第2个block也就是第512个字节后面开始拷贝bin/kernel的内容。原因是显然的：ucore.img的第1个block已经用来保存bootblock的内容了。

6. 第186行：`$(call create_target,ucore.img)`，由于只有一个输入参数，因此这里会直接返回。

#### 总结ucore.img的生成过程

1. 编译libs和kern目录下所有的.c和.S文件，生成.o文件，并链接得到bin/kernel文件

2. 编译boot目录下所有的.c和.S文件，生成.o文件，并链接得到bin/bootblock.out文件

3. 编译tools/sign.c文件，得到bin/sign文件

4. 利用bin/sign工具将bin/bootblock.out文件转化为512字节的bin/bootblock文件，并将bin/bootblock的最后两个字节设置为0x55AA，可见bin/bootblock是一个启动扇区。

5. 为bin/ucore.img分配5000MB的内存空间，并将bin/bootblock复制到bin/ucore.img的第一个block，紧接着将bin/kernel复制到bin/ucore.img第二个block开始的位置。可见ucore.img实际上包含启动扇区文件bin/bootblock和操作系统内核文件bin/kernel两部分。

### 题目3的解答

问题： 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？
答：
1. 大小为512字节
2. 最后两个字节为0x55AA
