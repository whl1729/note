## 学习《数据结构与算法分析》的编程技巧

### 使用逻辑运算的短路性质来简化代码

问题：寻找链表中的某个元素。我的实现：
```
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
```
作者的实现：
```
Position Find(ElementType X, List L)
{
    Position P;

    P = L->Next;
    while (P != NULL && P->Element != X)
        P = P->Next;

    return P;
}
```

