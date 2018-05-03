
## 参考资料

1. 论文：《MapReduce: Simplified data processing on large clusters》
2. 博客：[MapReduce Shuffle过程详解](https://blog.csdn.net/u014374284/article/details/49205885)

### MapReduce计算模型
MapReduce计算模型主要包含三个阶段：Map、Shuffle、Reduce。

1. Map：映射，将原始数据转化为键值对。
2. Reduce：合并，将具有相同key值的value进行处理后，输出新的键值对作为最终结果。
3. Shuffle：将Map输出结果进一步整理并交给Reduce的过程。比如将相同key的键值对合并并排序。

## MapReduce计算流程举例
以计算单词出现的次数为例。假设有M个Map任务，R个Reduce任务

1. MapReduce程序将输入文件分成M份，每份一般16～64MB。
2. master选出空闲的worker，并且给每个worker分配一个map或reduce任务。
3. map worker读入相应输入文件的内容，解析出键值对（如下），并缓存在内存中。
```
for each word w in value:
    EmitIntermediate(w, "1");
```
4. 缓存的键值对会定期写到磁盘中，并且划分为R个区域。worker会把键值对在磁盘中的位置汇报给master。
5. reduce worker收到master关于键值对的位置的通知后，通过远程函数调用来读取map worker的磁盘中的缓存区数据，然后对键值对进行排序，使得相同key的键值被分到一起。
6. reduce worker依次处理相同key的键值对，将输出结果附加到最终输出文件中。
7. 当所有map和reduce任务完成后，master唤醒用户程序，让用户程序继续往下运行。

