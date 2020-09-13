# linux使用笔记

## 开发环境

1. 根据结构体某个成员的指针获得对应结构体的指针
```
#define list_entry(ptr, type, member)  ({       \
        const typeof(((type *)0)->member) *_mptr = (ptr);   \
        (type *)( (char *)_mptr - offsetof(type, member));})
```

## 查询系统信息

1. 查看字节序 `lscpu | grep "Byte Order"`

## 进程管理

1. 进程在前台与后台间切换
    - `ctrl-z` 停止进程
    - `bg` 将进程放到后台运行
    - `fg` 将进程放在前台运行

## 文件系统

1. sticky bit
    - In computing, the sticky bit is a user ownership access right flag that can be assigned to files and directories on Unix-like systems.（注：如果一个文件设置了sticky bit，ls时对应权限位为t）
    - When a directory's sticky bit is set, the filesystem treats the files in such directories in a special way so only the file's owner, the directory's owner, or root user can rename or delete the file. Without the sticky bit set, any user with write and execute permissions for the directory can rename or delete contained files, regardless of the file's owner. Typically this is set on the /tmp directory to prevent ordinary users from deleting or moving other users' files.

## 软件开发工具

1. exuberant-ctags：可以为程序语言对象生成索引，其结果能够被一个文本编辑器或者其他工具简捷迅速的定位。支持的编辑器有 Vim、Emacs 等。习惯GUI的同学可以使用understand或source insight等软件。
    - 使用`ctags -h=.h.c.S -R`来生成索引文件
    - 使用 “ctrl + ]” 可以跳转到相应的声明或者定义处，使用 “ctrl + t” 返回（查询堆栈） 等。

2. diff & patch：实验中可能会在 proj_b 中应用前一个实验proj_a 中对文件进行的修改，可以使用如下命令。习惯GUI的同学可以使用meld、kdiff3和UltraCompare等软件。
```
diff -r -u -P proj_a_original proj_a_mine > diff.patch
cd proj_b
patch -p1 -u < ../diff.patch
```

3. gcc：
    - 如果你还没装gcc编译环境或自己不确定装没装，不妨先执行 ：`sudo apt-get install build-essential`
    - 选项 -Wall 开启编译器几乎所有常用的警告──强烈建议你始终使用该选项。编译器有很多其他的警告选项，但-Wall 是最常用的。默认情况下GCC 不会产生任何警告信息。

4. Understand工具
    - [安装教程](https://blog.csdn.net/shixiaolu63/article/details/81937440)
    - code: 09E58CD1FB79

### 网络管理

1. scp：远程拷贝，加上`-r`选项可以拷贝一个目录。

2. 查看端口占用情况：`lsof -i :8080`

3. 设置防火墙
```
// wlsp2s0 过滤 192.168.0.104
iptables -A INPUT -i wlp2s0 -s 192.168.0.104 -j DROP
// 删除过滤条件（先找出对应行号再删除）
iptables -L --line-numbers
iptables -D INPUT some-number
```

4. 使用curl来发送oauth 2.0请求：参考[How do I perform common OAuth 2.0 tasks using curl commands](https://backstage.forgerock.com/knowledge/kb/article/a45882528)
```
// requesting an access token
curl -X POST -u "some_client_id:some_client_secret" -d "grant_type=password&username=some_user&password=some_pw&scope=cn"
// refreshing an access token
curl -X POST -u "some_client_id:some_client_secret" -d "grant_type=refresh_token&refresh_token=some_refresh_token"
// post with access token
curl -X POST -i -H 'Content-Type: application/json' -H 'Authorization: Bearer some_access_token' -d '{"serialNo": "1209000903H-2007060058"}'
```
