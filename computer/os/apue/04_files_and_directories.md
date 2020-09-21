# Advanced Programming in the Unix Environment

## 4 Files and Directories

### 4.2 stat, fstat, fstatat, and lstat Functions

1. stat, fstat, fstatat, and lstat Functions
```
#include <sys/stat.h>

int stat(const char *restrict pathname, struct stat *restrict buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *restrict pathname, struct stat *restrict buf);
int fstatat(int fd, const char *restrict pathname, struct stat *restrict buf, int flag);

// All four return: 0 if OK, −1 on error
```

2. The lstat function is similar to stat, but when the named file is a symbolic link, lstat returns information about the symbolic link, not the file referenced by the symbolic link.

### Question

1. 运行自己编写的stat测试程序，在程序运行结束前会报以下错误。尚未找到原因。
```
*** stack smashing detected ***: ./stat terminated
Aborted (core dumped)
```
