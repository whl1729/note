# C语言学习笔记

1. 生成随机数
```
#include "stdlib.h"

/* void srand(unsigned int seed)*/
srand((unsigned)time(0));
num = rand() % 100;
```

2. 获取系统时间：
    - [C library function: clock()](https://www.tutorialspoint.com/c_standard_library/c_function_clock.htm)
    - The C library function clock_t clock(void) returns the number of clock ticks elapsed since the program was launched. To get the number of seconds used by the CPU, you will need to divide by CLOCKS_PER_SEC.On a 32 bit system where CLOCKS_PER_SEC equals 1000000 this function will return the same value approximately every 72 minutes.
```
#include <time.h>
#include <stdio.h>

int main () {
   clock_t start_t, end_t, total_t;
   int i;

   start_t = clock();

   for(i=0; i< 10000000; i++);

   end_t = clock();

   total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;

   return(0);
}
```

## 编程技巧

1. 使用逻辑运算的短路性质来简化代码。比如，《数据结构与算法分析》有道习题需要寻找链表中的某个元素。
```
// 我的实现：
Position Find(ElementType X, List L)
{
    Position P = L;

    while (P != NULL)
    {
        if (P->Element == X)
            break;
        P = P->Next;
    }

    return P;
}

// 作者的实现：
Position Find(ElementType X, List L)
{
    Position P;

    P = L->Next;
    while (P != NULL && P->Element != X)
        P = P->Next;

    return P;
}
```

