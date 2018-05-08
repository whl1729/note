## 如何写Makefile
参考资料：[跟我一起写Makefile](http://blog.csdn.net/haoel/article/details/2886)

### 基本语法
```
target target-name : prerequisite-file-name
command1
command2
...
```

### 一个示例
```
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

### 使用变量
原来的版本：
```
edit: main.o kbd.o command.o display.o \
      insert.o search.o files.o utils.o
    cc -o edit main.o kbd.o command.o display.o \
      insert.o search.o files.o utils.o

```
使用变量的版本：
```
objects =  main.o kbd.o command.o display.o \
      insert.o search.o files.o utils.o

edit: $(objects)
    cc -o edit $(objects)
```

### 让make自动推导
GNU的make看到一个somefile.o文件时，会自动的把对应的somefile.c文件加在依赖关系中，并且`cc -c somefile.c`也会被推导出来。这使得我们在写依赖关系时可以更简洁。
原来的版本：
```
main.o : main.c defs.h
    cc -c main.c
```
让make自动推导的版本：
```
main.o : defs.h
```

### 清空目标文件的规则
一般的风格是：
```
clean:
    rm edit $(objects)
```
