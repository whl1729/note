# 《ucore lab1 exercise1》实验报告

[ucore在线实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/)

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

4. 第146行`打印kernel目标文件名
```
@echo + ld $@
// output: `+ ld bin/kernel`
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

8. 第165行使用objcopy将obj/bootblock.o转换生成obj/bootblock.out文件，其中-S表示转换时去掉重定位和符号信息：`@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)`
	
9. 第166行使用bin/sign工具将obj/bootblock.out转换生成bin/bootblock目标文件：`@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)`，从tools/sign.c代码中可知sign工具其实只做了一件事情：将输入文件拷贝到输出文件，控制输出文件的大小为512字节，并将最后两个字节设置为0x55AA（也就是ELF文件的magic number）

10. 第168行： （这里没看懂？）
```
$(call create_target,bootblock)
create_target = $(eval $(call do_create_target,$(1),$(2),$(3),$(4),$(5)))
```

11. do_create_target的定义为
```
# add packets and objs to target (target, #packes, #objs[, cc, flags])
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

#### 生成sign工具

1. 第173行：
```
$(call add_files_host,tools/sign.c,sign,sign)
add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))
HOSTCC		:= gcc
HOSTCFLAGS	:= -g -Wall -O2
add_files = $(eval $(call do_add_files_to_packet,$(1),$(2),$(3),$(4),$(5)))
```

$(call create_target_host,sign,sign)

#### ucore.img的生成过程
