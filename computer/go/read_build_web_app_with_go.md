# 《build-web-application-with-golang》学习笔记

[build-web-application-with-golang](https://github.com/astaxie/build-web-application-with-golang/tree/master/zh)

## 1 GO环境配置

1. Go标准包安装：Go提供了每个平台打好包的一键安装，这些包默认会安装到如下目录：/usr/local/go (Windows系统：c:\Go)，当然你可以改变他们的安装位置，但是改变之后你必须在你的环境变量中设置如下信息：
```
export GOROOT=$HOME/go  
export GOPATH=$HOME/gopath
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```

2. go命令依赖一个重要的环境变量`$GOPATH`， $GOPATH 目录约定有三个子目录：
    - src 存放源代码（比如：.go .c .h .s等）
    - pkg 编译后生成的文件（比如：.a）
    - bin 编译后生成的可执行文件（为了方便，可以把此目录加入到 $PATH 变量中，如果有多个gopath，那么使用${GOPATH//://bin:}/bin添加所有的bin目录）
