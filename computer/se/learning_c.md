# C语言学习杂记

## 2020年6月3日

### 缺少头文件导致"Segmentation fault (core dumped)"

今天在研究根据主机名获取ip地址的C语言程序，一开始我没有包含`inet_ntoa`函数对应的头文件`arpa/inet.h`，编译时会有`warning: assignment makes pointer from integer without a cast [-Wint-conversion]`的警告，运行时则直接崩溃`Segmentation fault (core dumped)`。我猜想在编译阶段，由于gcc找不到该函数的声明，则默认该函数返回int型，至于具体数值是多少则无从得知。后面再把这个int型转为char\*型指针，并试图访问其指向的地址，导致内存访问越界。附关键代码片段（省略返回值判断等语句0：
```
    char host_buffer[BUF_LEN] = {0};
    char *ip_buffer;
    struct hostent *host_entry;
    int result;

    result = gethostname(host_buffer, sizeof(host_buffer));
    host_entry = gethostbyname(host_buffer);
    ip_buffer = inet_ntoa(*((struct in_addr*) host_entry->h_addr_list[0]));
```
