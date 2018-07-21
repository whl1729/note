# spark源码分析

## executor管理

1. 初始化executor数目：

## CacheRecoveryManager

### 基础知识

#### Future
Future指的是一类占位符对象，用于指代某些尚未完成的计算的结果。详见[FUTURE和PROMISE](https://docs.scala-lang.org/zh-cn/overviews/core/futures.html)

1. 回调函数：在future中注册一个回调，future完成后执行这个回调的方式称为异步回调。注册回调一般使用`OnComplete`方法，即创建一个`Try[T] => U`类型的回调函数。future执行成功，则回调函数会得到Success[T]类型的值，否则得到Failture[T]类型的值。如果只想处理成功或失败的结果，也可以定义`OnSuccess`或`OnFailture`回调函数。

#### 函数结合子
参考资料：[函数组合子（Functional Combinators）](https://twitter.github.io/scala_school/zh_cn/collections.html)

1. map: 对列表中的每个元素应用一个函数，返回应用后的元素所组成的列表。
2. foreach：类似map，但没有返回值。
3. filter：移除任何对传入函数计算结果为false的元素。
4. flatten：将嵌套结构扁平化一个层级。
5. flatMap：相对于先mapping再flattening。flatMap需要一个处理嵌套列表的函数，然后将结果串联起来。
6. partition：使用给定的谓词函数分割列表。将列表分割为满足谓词函数、不满足谓词函数的两个子列表。
7. splitAt: 根据输入的索引，将列表分割成两个子列表。

#### BlockManager
blockManager是一个块管理者，每个executor中都会有一个BlockManager。

1. blockManager的应用场景
    * spark shuffle过程的数据就是通过blockManager来存储的
    * spark broadcast 将task调度到多个executor的时候，broadCast底层使用的数据存储就是blockManager。
    * 对一个rdd进行cache的时候，cache的数据就是通过blockManager来存放的。
    * spark streaming中一个ReceiverInputDStream接受到的数据也是先放在BlockManager中，然后封装为一个BlockRdd进行下一步运算的。

2. blockManager四大对象
    * ConnectionManager: 负责与其他的BlockManager连接
    * BlockTransferService: 与其他的BlockManager连接成功后负责进行数据的传输。
    * MemoryStore: 负责管理内存中的数据。
    * DiskStore: 负责管理磁盘上的数据。

#### RPC
参考资料：[Spark RPC三剑客](https://www.jianshu.com/p/228b274faa51)

1. RpcEndpointRef发送消息给RpcEnv，RpcEnv查询注册消息将消息路由到指定的RpcEndpoint，RpcEndpoint接收到消息后进行处理（模式匹配的方式）

#### Set
参考资料：[集合](https://docs.scala-lang.org/zh-cn/overviews/collections/sets.html)。

1. 判断集合是否包含某元素
    * xs contains x
    * xs(x)
    * xs subsetOf ys

#### Seq
表示序列。所谓序列，指的是一类具有一定长度的可迭代访问的对象，其中每个元素均带有一个从0开始计数的固定索引位置。参考资料：
[序列TRAIT：SEQ、INDEXEDSEQ及LINEARSEQ](https://docs.scala-lang.org/zh-cn/overviews/collections/seqs.html)

1. scan：迭代对序列中的元素进行某个操作。参考资料：
[Map, Scan, Fold and Reduce functions](http://scaledcode.blogspot.com/2014/02/map-scan-fold-and-reduce-functions.html)

#### 其他
1. extend：定义一个class时，如果需要继承另一个class，则使用extend，并提供构造函数所需的参数及base class中声明的函数的具体实现。


3. searled trait：只能在同一文件中被扩展作为其声明，通常被用来作为枚举的替代物。

4. CacheBuilder: 一种缓存器。其中`expireAfterWrite`是将缓存的移出策略设置为最后一次写入后的一段时间移出，`put`是将key-value加入缓存。参考资料：
[Class CacheBuilder](https://google.github.io/guava/releases/16.0/api/docs/com/google/common/cache/CacheBuilder.html)和[Guava缓存器源码分析——CacheBuilder](https://blog.csdn.net/desilting/article/details/11768773)

5. 占位符语法：
`words.map(w => w.toLowerCase)`等价于`words.map(_.toLowerCase)`。

6. 访问N元组的字段：_1表示访问第一个字段，_2表示访问第二个字段，如此类推。

7. 模式匹配型的匿名函数：由一系列模式匹配样例组成的，不过没有match。有时我们只使用了一个匹配案例（即一个case），因为我们知道这个样例总是会匹配成功。

