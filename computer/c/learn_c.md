# C语言学习笔记

## 生成随机数
```
#include "stdlib.h"

/* void srand(unsigned int seed)*/
srand((unsigned)time(0));
num = rand() % 100;
```
