# C语言学习笔记

1. 生成随机数
```
#include "stdlib.h"

/* void srand(unsigned int seed)*/
srand((unsigned)time(0));
num = rand() % 100;
```

2. 获取系统时间：[参考资料](https://www.tutorialspoint.com/c_standard_library/c_function_clock.htm)
```
#include <time.h>

clock_t start_t = clock();
```
