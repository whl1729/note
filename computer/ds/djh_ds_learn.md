# 《数据结构》学习笔记

本文是关于邓俊辉所著的《数据结构》的学习笔记。此处贴上邓老师对这门课的定位:

> 我喜欢将DSA比作汽车。  
熟悉基本的数据结构的基本功能与使用方法，犹如拿驾照会开车能上道。  
懂得不同DSA之间的差异及其适用场合，懂得针对问题需要选取适当的DSA，犹如懂得如何选购适宜于自己的汽车。  
懂得对DSA做适当的裁剪、扩充和改造，并优化组合，犹如玩车的行家里手，有DIY的能力和乐趣。  
探索DSA的优化极限，能够完成从内部优化到外部封装的整个过程，则是设计师与工程师的任务与要求。

## 疑问及待研究

1. 二叉树的迭代式遍历

2. 哈夫曼编码是最优编码的证明没看懂？

3. 双向连通域尚未完全理解？

4. 红黑树的删除操作不熟悉

5. kd-树未完全理解？

6. 跳转表未完全理解？

7. KMP算法复杂度分析时，通过观察k=2\*i-j的递增性来推出while循环最多执行2n次，如何想到观察k的？

8. 希尔排序未深入研究？

## 第1章 绪论

1. 就地算法：仅需常数规模即O(1)辅助空间的算法。

2. 复杂度
    * 常数时间复杂度：T(n) = O(1)
    * 对数时间复杂度：T(n) = O((log(n)^C))
    * 线性时间复杂度：T(n) = O(n)
    * 多项式时间复杂度：T(n) = O(f(n))，其中f(x)为多项式
    * 指数时间复杂度：T(n) = O(2^n)

3. 递归
    * 尾递归：递归调用在递归实例中恰好以最后一步操作的形式出现。尾递归很容易转为非递归形式。
    * 递归基：保证递归算法有穷性的平凡情况，如n=0或1的情况。

4. 分而治之有效的两个条件
    * 子问题划分及子解答合并要能高效实现
    * 子问题可独立求解

## 第2章 向量

1. 分摊复杂度分析的结论更符合真实情况。

2. 查找长度：所执行的元素大小比较操作的次数。

3. 这个符合语法吗？`(e < A[mi]) ? hi = mi : lo = mi;`

4. CBA：comparison-ased algorithm，基于比较式算法

## 第3章 列表

1. 数据结构支持的操作，分为静态和动态两类：前者仅从中获取信息，后者则会修改数据结构的局部甚至整体。
    * 向量：静态操作需要常数时间，动态操作需要线性时间
    * 链表：静态操作需要线性时间，动态操作需要的时间比向量少，在头尾两端插入时只需常数时间。

2. 无论链表是否有序，其查找算法的时间复杂度都是O(n)。

## 第4章 栈与队列

1. 函数调用
    * 每次函数调用时，都会相应地创建一个栈帧
    * 函数一旦运行完毕，对应的帧随即弹出，运行控制权将被交还给该函数的上层调用函数
    * 特别地，位于栈底的那帧必然对应于入口主函数main，若它从调用栈中弹出，则意味着整个程序的运行结束，此后控制权将交还给操作系统

2. 显式使用栈来避免递归：这样程序员可以精细地裁剪栈中各帧的内容，从而尽可能降低空间复杂度的常系数。

3. 栈所擅长解决的典型问题
    * 第一类：其解答以线性序列的形式给出，且以逆序计算输出；输入与输出规模不确定。如进制转换
    * 第二类：具有自相似性的问题多可嵌套地递归描述，但因分支位置和嵌套深度并不固定，其递归算法的复杂度不易控制。使用栈则可高效解决这类问题。如栈混洗、括号匹配。
    * 第三类：输入可分解为多个单元并通过迭代依次扫描处理，但过程中的各步计算往往滞后于扫描的进度，需要待到必要的信息已完整到一定程度之后，才能作出判断并实施计算。在这类场合，栈结构可以扮演数据缓冲区的角色。如表达式求值。
    * 第四类：需要在某个搜索空间寻找可行解的问题，可以使用试探回溯法。比如：八皇后、迷宫寻径问题。

> 备注：编程解决八皇后、迷宫寻径问题。

4. 编程技巧：使用数组来简化处理逻辑等
    * 进制转换算法中，使用digit数组来实现0~15到对应的数位符号的转化，适用于二进制至十六进制。
    * 表达式求值算法中，使用pri数组来实现运算符优先级的比较。
    * 表达式求值算法中，先压入一个'\0'字符作为哨兵，从而不需考虑表达式字符串何时结束。

5. 后缀表达式（逆波兰表达式）相比中缀表达式的优势
    * RPN表达式中云算法的执行次序，可更为简捷地确定，既不必在事先做任何约定，更无需借助括号强制改变优先级。
    * RPN表达式只需一个辅助栈来缓存操作数，而中缀表达式需要两个辅助栈分别缓存操作数和操作符。

## 第5章 二叉树

1. 树 vs 向量、链表、栈、队列
    * 向量、链表、栈、队列的查找或增删的时间复杂度为O(n)，而树的查找、更新、插入或删除操作的时间复杂度均为O(logn)。
    * 向量、链表、栈、队列的元素之间都存在一个自然的线性次序，故它们都属于所谓的线性结构；树中的元素之间并不存在天然的直接后继或直接前驱关系，不过只要附加某种约束（比如遍历），也可以在树中的元素之间确定某种线性次序，因此树属于半线性结构

2. 树结构在算法理论以及实际应用中扮演着最为关键的角色，原因是得益于其独特而又普适的逻辑结构。树是一种分层结构，而层次化这一特征几乎蕴含于所有事物及其联系当中，成为其本质属性之一。从文件系统、互联网域名系统和数据库系统，一直到地球生态系统乃至人类社会系统，层次化特征以及层次结构均无处不在。

3. 度、深度、高度
    * 度：节点v的孩子总数
    * 深度：沿每个节点v到根r的唯一通路所经过边的数目，称作v的深度。
    * 高度：树T中所有节点深度的最大值称作该树的高度。任一节点v的子树的高度称作该节点的高度。特别地，全树的高度亦即其根节点r的高度。

4. 任何有根有序的多叉树，都可等价地转化并实现为二叉树。如使用“长子 + 兄弟”法，即为每个节点设置两个指针，分别指向其“长子”和下一“兄弟”。

5. 二叉树节点是否增设成员变量depth或size的考虑：在二叉树结构改变频繁以至于动态操作远多于静态操作的场合，舍弃深度、子树规模等变量，转而在实际需要时再直接计算这些指标，应是更为明智的选择。

6. 每当某一节点的孩子的后代有所增减，其高度都有必要及时更新。然而实际上，节点自身很难发现后代的变化，因此不妨反过来采用另一处理策略：一旦有节点加入或离开二叉树，则更新其所有祖先的高度。

7. 完全二叉树中，设叶节点、内部节点数目分别为m和n，则m=n或m=n+1. 证明：先考虑满二叉树，此时m=n+1. 然后，减少最后一个叶节点，则m=m-1，此时m=n；继续减少一个叶节点，则n=n-1，此时m=n+1.（这种思路简单清晰！）

8. 编码树
    * 前缀无歧义编码：prefix-free code，简称PFC编码。实现PFC编码的简明策略：使用二叉编码树，只要所有字符都对应于叶节点，歧义现象即自然消除。
    * 根通路串：root path string，记作rps(v)。当然|rps(v)| = depth(v)就是v的深度，对应于字符x的编码长度。
    * 在线算法：基于PFC编码树的解码过程可以在二进制编码串的接收过程中实时进行，而不必等到所有比特位都到达之后才开始，因此属于在线算法。
    * 叶节点平均深度：average leaf depth，记作ald(T)
    * 叶节点带权平均深度：weighted average leaf depth，记作wald(T)

9. 最优编码树
    * 同一字符集的所有编码方案中，平均编码长度最小者称作最优方案，对应编码树的叶节点平均深度也达到最小，故称之为最优二叉编码树，简称最优编码树。
    * 最优二叉编码树必为真二叉树：内部节点的左、右孩子全双。原因：若内部节点p拥有唯一的孩子x，则可删除节点p并代之以子树x。
    * 最优二叉编码树中，各个叶节点的深度之差不得超过1.否则可以通过节点位置互换得到更优的编码树，导致矛盾。
    * 最优二叉树的叶节点只能出现于最低两层，故这类树的一种特例就是真完全树。
    * 若考虑各字符的出现频率，完全二叉树未必最优。

## 第6章 图

1. 相互之间均可能存在二元关系的一组对象，属于非线性结构。此类一般性的二元关系，属于图论的研究范畴。

2. 度：在无向图中，与顶点v关联的边数，称作v的度数，记作deg(v)。在有向图中，对于有向边e=(u, v)，e称为u的出边、v的入边。v的出边总数称为其出度，记作outdeg(v)，入边总数称为其入度，记作indeg(v)。

3. 通路与环路
    * 由m+1个顶点和m条边交替而成的序列，称为通路。其中沿途边的总数m称为通路的长度。
    * 沿途顶点互异的通路，称作简单通路。
    * 起止顶点相同的、长度m>1的通路，称作环路。
    * 不含任何环路的有向图，称作有向无环图。
    * 沿途除起止顶点外所有顶点均互异的环路，称作简单环路。
    * 经过途中各边一次且恰好一次的环路，称作欧拉环路。
    * 经过途中各顶点一次且恰好一次的环路，称作哈密尔顿环路。

4. 邻接矩阵空间效率低的原因：实际应用所处理的图，所含的边数通常远远少于O(n^2)，如稀疏图。也就是说，邻接矩阵中大量单元所对应的边都没在图中出现。

5. 邻接矩阵 vs 邻接表
    * 邻接矩阵：静态操作的时间性能为O(1)，动态操作的时间性能为O(n)，空间性能为O(n^2)
    * 邻接表：部分静态操作的时间性能为O(n)，动态操作的时间性能一般为O(n)，空间性能为O(n)
    * 尽管邻接表访问单条边的效率并不算高，却十分擅长于以批量方式，处理同一顶点的所有关联边。比如：枚举顶点v发出的所有边，仅需O(1 + outDegree(v))而非O(n)时间。
    * 总体而言，邻接表的效率较之邻接矩阵更高。

6. 图的遍历更加强调对处于特定状态顶点的甄别与查找，故也称作图搜索。

7. 有向无环图的拓扑排序必然存在。因为，在任一有限偏序集中，必有极值元素。任一有向无环图，必包含入度为零的顶点，只要将入度为零的顶点m及其关联边从图G中取出，则剩余的图G'依然是有向无环图。

8. 活跃期相互包含的顶点，在DFS树中都是“祖先-后代”关系，因此可以便捷地判定节点之间的承袭关系。故无论是对DFS搜索本身，还是对基于DFS的各种算法而言，时间标签都至关重要。

9. DFS的应用
    * 拓扑排序。注：DFS搜索善于检测环路的特性，恰好可以用来判别输入是否为有向无环图。具体地，搜索过程中一旦发现后向边，即可终止算法并报告“因非DAG而无法拓扑排序”。

## 第7章 搜索树

1. 若要控制单次查找在在最坏情况下的运行时间，须从控制二叉搜索树的高度入手。

2. 等价变换：上下可变，左右不乱。

3. Fib-AVL树：其中每个内部结点的左子树，都比右子树在高度上少一。Fib-AVL树也是在高度固定的前提下，节点总数最少的AVL树。其节点数为fib(h+3) - 1，这是高度为h的AVL树的节点数的最小值。

4. 在AVL树中插入一个节点，失衡的节点可能多达O(logn)个；在AVL树中删除一个节点，失衡的节点最多为1个。（伍注：但是调整好失衡节点后祖先节点可能会失衡）

5. 平衡因子：任一节点的平衡因子定义为“其左、右子树的高度差”。所谓AVL树，即平衡因子受限的二叉搜索树，其中各节点平衡因子的绝对值均不超过1.

6. 失衡传播：设删除节点x后，其祖先g(x)失衡。若g(x)原本属于某一更高祖先的更短分支，则因为该分支现在又进一步缩短，从而会致使该祖先使能。注意：插入节点时，仅需不超过两次旋转，即可使整树恢复平衡。因此插入节点不会导致失衡传播。

7. 统一重平衡算法：统一处理四种情况，比较巧妙。

8. 空节点 vs 外部节点：空节点通常对应于空孩子指针或引用，也可假想地等效为“真实”节点，后一方式不仅可简化算法描述以及退化情况的处理，也可直观地解释（B-树之类）纵贯多级存储层次的搜索树。故在后一场合，空节点也称为外部节点，并等效地当作叶节点的“孩子”。

## 第8章 高级搜索树

1. 高级搜索树种类
    * 伸展树：最坏情况下其单次操作需要O(n)时间，但分摊而言仍在O(logn)以内。
    * 平衡多路搜索树（如B-树）：有效弥合不同存储级别之间在访问速度上的巨大差异。
    * 红黑树：不仅能保持全树的适度平衡，而且可以将每次重平衡过程中执行的结构性调整，控制在常数次数以内，
    * kd-树：适用于平面范围查询应用，记忆计算几何类应用问题的求解。

2. 伸展树
    * 无需时刻都严格保持全树的平衡，但却能够在任何足够长的真实操作序列中，保持分摊意义上的高效。无需记录平衡因子或高度之类的额外信息
    * 逐层伸展的最坏情况：发生在按key单调的次序周期性地反复查找，此时每次访问都需要O(n)时间。
    * 注意zig-zig, zag-zag与两次逐层伸展的区别：前者是先旋转grandpa，再旋转当前节点；后者两次都是旋转当前节点。
    * zig-zig，zag-zag调整是双层伸展策略优于逐层伸展策略的关键所在。
    * 双层伸展策略可“智能”地“折叠”被访问的子树分支，从而有效地避免对长分支的连续访问。这就意味着，即使节点v的深度为O(n)，双层伸展策略既可将v推至树根，亦可令对应分支的长度以几何级数（大致折半）的速度收缩。

3. 外部存储器
    * 内存与磁盘单次访问延迟大致分别在纳秒和毫秒级别，也就是说，对内存而言的一秒/一天，相当于磁盘的一星期/两千年。因此，为减少对外存的一次访问，我们宁愿访问内存百次、千次甚至万次。
    * 外存的一个特性：就时间成本而言，读取物理地址连续的一千个字节，与读取单个字节几乎没有区别。因此，外部存储器更适宜于批量式访问。

4. 多路搜索树：以k层为间隔来重组，可将二叉搜索树转化为等价的2^k路搜索树。

5. 多路平衡搜索树
    * m阶B-树，即m路平衡搜索树（伍注：B应该是Balanced）。由于各节点的分支树介于(m/2)至m之间，故m阶B-树也称作(m/2, m)-树。（注：m/2向上取整，另外注意节点数比分支数少1）
    * B-树的外部节点未必意味着查找失败，而可能表示目标关键码存在于更低层次的某一外部存储系统中，顺着该节点的指示，既可深入至下一级存储系统并继续查找。因此，在计算B-树高度时，还需要计入其最底层的外部节点。（伍注：外部节点在当前存储环境下不存在，是假想式的）
    * 作为与二叉搜索树等价的“扁平化”版本，B-树的宽度（亦即最底层外部节点的数目）往往远大于其高度。
    * B-树结构非常适宜于在相对更小的内存中，实现对大规模数据的高效操作。可以将大数据集组织为B-树并存放在外存。对于活跃的B-树，其根节点会常驻于内存；此外，任何时刻通常只有另一节点（称作当前节点）留驻于内存。
    * 对存有N个关键码的m阶B-树的每次查找操作，耗时不超过O(logmN)。相对而言极其耗时的I/O操作的次数，已大致缩减为原先的1/log2m。鉴于m通常取值在256至1024之间，较之此前大致降低一个数量级，故使用B-树后，实际的访问效率将有十分可观的提高。
    * 上溢修复过程中所做分裂操作的次数，必不超过全树的高度，即O(logmN)。
    * B-树长高的唯一可能：分裂一直传递至根节点，并最终导致全树高度增加一层。
    * B-树待删除节点不是叶节点时，可先将它与其直接后继交还位置，从而变成叶节点。

6. 红黑树
    * AVL树的缺点：AVL树须在节点中嵌入平衡因子等标识，而且删除操作之后的重平衡可能需做多达O(logn)次旋转，从而频繁地导致全树整体拓扑结构的大幅度变化。
    * 红黑树即是针对AVL树的不足的改进。通过对节点指定颜色，并巧妙地动态调整，红黑树可保证：在每次插入或删除操作之后的重平衡过程中，全树拓扑结构的更新仅涉及常数个节点。尽管最坏情况下需对多达O(logn)个节点重染色，但就分摊意义而言仅为O(1)个。
    * 黑深度：从根节点通往任一节点的沿途所经黑节点的总数。根节点的黑深度为0.所有外部节点的黑深度相同。
    * 黑高度：从任一节点通往其任一后代外部节点的沿途缩颈黑节点的总数。所有外部节点的黑高度为0.根节点的黑高度称为全树的黑高度，在数值上等于外部节点的黑深度。
    * 红黑树可高效率支持各种操作的基础：红黑树的高度控制在最小高度的两倍以内，从渐进的角度看仍是O(logn)，依然保证了适度平衡。

7. 离线方式 vs 在线方式
    * 离线方式：输入点集P通常会在相当长的时间内保持相对固定。（伍注：即待处理的数据已经固定）
    * 在线方式：对于同一输入点集，往往需要针对大量的随机定义的区间R，反复地进行查询（伍注：即待处理的数据会实时变化）

8. 输出敏感的算法：需要同时根据问题的输入规模和输出规模来估计时间复杂度

9. 平衡二叉搜索树：叶节点存放输入点，内部节点等于左子树中的最大者。如此在空间上所做的些许牺牲，可以换来足够大的收益：查找的过程中，在每一节点处，至多只需做一次（而不是两次）关键码的比较。

## 第9章 词典

1. 符号表
    * 词典结构，是由一组数据构成的集合，其中各元素都是由关键码和数据项合成的词条。
    * 映射要求不同词条的关键码互异，词典允许多个词条拥有相同的关键码。两者都支持静态查找和动态更新，统称为符号表
    * 符号表不要求词条之间能够根据关键码比较大小
    * 循值访问： 以散列表为代表的符号表结构，依据数据项的数值，直接做逻辑查找和物理定位

2. 插入词典中已经存在的词条时，插入效果等同于用新词条替换已有词条。这一处理方式被包括Python和Perl在内的众多编程语言普遍采用。

3. 跳转表
    * 查询和维护操作的平均时间性能均为O(logn)

4. 散列表
    * 桶：散列表在逻辑上由一系列可存放词条（或其引用）的单元组成，故这些单元也可称作桶或桶单元。
    * 桶数组：散列表往往直接使用数组实现，此时的散列表也称作桶数组。
    * 地址空间：若桶数组的容量为R，则其中合法秩的区间[0,R)也称作地址空间。
    * 完美散列：在时间和空间性能方面均达到最优的散列。如Bitmap结构可理解为完美散列的一个实例
    * 散列函数：从关键码空间到桶数组地址空间的函数。记作：hash(): key --> hash(key)。hash(key)也称作key的散列地址。散列函数hash()的作用可理解为，将关键码空间[0, R)压缩为散列地址空间[0, M)。
    * 装载因子：散列表中非空桶的数目与桶单元总数的比值。
    * 散列函数设计原则中最重要的一条：关键码映射到个痛的概率应尽量接近于1/M，这也是任意一对关键码相互冲突的概率。
    
5. 散列函数
    * 除余法的缺点：依然残留有某种连续性。比如，相邻关键码所对应的散列地址，总是彼此相邻；极小的关键码，通常都被击中映射到散列表的起始区段。
    * 任何一个（伪）随机数发生器，本身就是一个好的散列函数。比如：rand(key) mod M

6. 散列冲突解决
    * 独立链的缺点：因需要引入次级关联结构，实现相关算法的代码自身的复杂程度和出错概率都将大大增加。反过来，因不能保证物理上的关联性，对于稍大规模的词条集，查找过程中将需做更多的I/O操作。
    * 开放定址：散列地址空间对所有词条开放。即每个桶单元都有可能存放任一词条。也称作闭散列。而多槽位、独立链策略亦称作封闭定址或开散列。
    * 线性试探法：其组成各查找链的词条，在物理上保持一定的连贯性，具有良好的数据局部性，故系统缓存的作用可以充分发挥，查找过程中几乎无需I/O操作。
    * 懒惰删除：为每个桶另设一个标志位，指示该桶尽管目前为空，但此前确曾存放过词条。
    * 只要将装填因子控制在适当范围内，闭散列策略的平均效率通常都可保持在较为理想的水平。一般的建议是装填因子是小于0.5.而独立链法建议的装填因子上限为0.9.
    * 平方试探法对数据局部性影响不大：鉴于目前常规的I/O页面规模已经足够大，只有在查找链极长的时候，才有可能引发额外的I/O操作。
    * 只要散列表长度M为素数且装填因子不大于50%，则平方试探法迟早必将终止于某个空桶。
    * rehashing vs double-hashing: 前者是重散列，指当装填因子过大时，采取“逐一取出再插入”的策略，对桶数组扩容；后者是再散列，即设计一个二级散列函数，当插入词条时发现ht[hash(key)]已被占用，则以hash2(key)为偏移增量继续尝试，直至发现一个空桶。

7. 散列码转换
    * 对long long和double之类长度超过32位的基本类型，可以将高32位和低32位分别看做两个32位证书，将二者之和作为散列码。（冲突概率不大吗？）
    * 字符串内各字符之间的次序具有特定含义，故在做散列码转换时，务必考虑它们之间的次序。

8. 桶排序算法
    * 问题：给定[0,M)内的n个允许重复整数，如何高效地对其排序？
    * 空间复杂度O(M)，时间复杂度为O(n + M)

## 第10章 优先级队列

1. 循优先级访问：根据数据对象之间相对优先级对其进行访问的方式。优先级队列使用这种访问方式。

2. 对于常规的查找、插入或删除等操作，优先级队列的效率的效率并不低于此前的结构；而对于数据集的批量构建及相互合并等操作，其性能却更胜一筹。这是因为优先级队列不会也不必维护全序关系，而是维护一个偏序关系。

3. 词典结构仅要求关键码支持判等操作，不要求必须能比较大小；而优先级队列要求关键码之间必须可以比较大小。

4. 堆
    * 当关键码均匀独立分布时，最坏情况极其罕见，每个节点的上滤操作平均仅需常数时间。
    * 蛮力算法是“自上而下的上滤”，其时间复杂度为O(nlogn)；Floyd算法是“自下而上的下滤”，其时间复杂度为O(n)。

5. 堆排序：除了用于支持词条交换的一个辅助单元，几乎不需要更多的辅助空间，故属于就地算法。得益于向量结构的简洁性，该算法不仅可简明地编码，其实际运行效率也因此往往要高于其他O(nlogn)的算法。

6. 左式堆
    * 优点：可高效地支持堆合并操作
    * 基本思路：在保持堆序性的前提下附加新的条件，使得在堆的合并过程中，只需调整很少量的节点。
    * 节点x的空节点路径长度（null path length）：记作npl(x)。若x为外部节点，则npl(x)=npl(NULL)=0，否则npl(x) = 1 + min(npl(lc(x)), npl(rc(x)))
    * npl(x)的意义：等于x到外部节点的最近距离，也等于以x为根的最大满子树的高度，还等于其最右侧通路的长度。
    * 左式堆：npl(lc(x)) >= npl(rc(x))

## 第11章 串

1. KMP算法
    * 为保证P与T的对齐位置（指针i）从不后退，同时又不致遗漏任何可能的匹配，应在集合N(P, j)中挑选最大的t。也就是说，当有多个值得试探的右移方案时，应该保守地选择其中移动距离最短者。
    * 思路：当前比对一旦失配，即利用此前的比对（无论成功或失败）所提供的信息，尽可能长距离地移动模式串。其精妙之处在于，无需显式地反复保存或更新比对的历史，而是独立于具体的文本串，事先根据模式串预测出所有可能出现的失配情况，并将这些信息“浓缩”为一张next表
    * next表：根据模式串失衡位置的子字符串中真前缀与真后缀重合的情况，以及重合的下一位置不相等来跳转。
    * KMP算法的时间复杂度为O(n+m)，而蛮力法的时间复杂度为O(mn)

2. 画笔算法：若将BC表比作一块画布，则其中各项的更新过程，就犹如画家在不同位置堆积不同的油彩。而画布上各处最终的颜色，仅取决于在对应位置所堆积的最后一笔。这类算法，也因此称作为“画家算法”。

3. BM算法
    * BM算法本身进行串模式匹配所需的时间与具体的输入十分相关，最好情况下时间复杂度为O(n/m) ，最坏情况下为O(nm)
    * 在兼顾了坏字符与好后缀两种策略后，BM算法的运行时间为O(n+m)，其最好情况下的时间性能则可以达到O(n/m)。而KMP算法的性能则稳定在O(n+m)。这是因为，KMP算法始终是对文本串逐个扫描，而BM算法最好情况下每次可以步进m个字符。

4. 单次比对成功概率Pr
    * 单次比对成功概率，是决定串匹配算法时间效率的一项关键因素
    * 对于同一算法，计算时间与Pr具有单调正相关关系。消耗于每一对齐位置的平均时间成本随Pr的提高而增加
    * 当字符集规模较小时，单次比对的成功概率较高，此时KMP算法稳定的线性复杂度更能体现优势；当字符集规模较大时，蛮力算法也能接近于线性的复杂度，KMP算法的优势并不明显，而采用BC表的BM算法，则会因比对失败的概率增加，可以大跨度地向前移动。

5. 万物皆数：散列之所以可实现极高的效率，正在于它突破了通常对关键码的狭义理解，允许操作对象不必支持大小比较，从而在一般类型的对象（词条）与自然数（散列地址）之间，建立起直接的联系。

6. Karp-Rabin算法：利用散列，将“判断模式串P是否与文本串T匹配”的问题，转化为“判断T中是否有某个子串与模式串P拥有相同的指纹”的问题。

## 第12章 排序

1. 归并排序 vs 快速排序
    * 归并排序的计算量主要消耗于有序子向量的归并操作，而子向量的划分却几乎不费时间
    * 快速排序可以在O(1)时间内（几乎是立即），由子问题的解直接得到原问题的解；但为了将原问题划分为两个子问题，却需要O(n)时间

2. 快速排序
    * 快速排序并不能保证最坏情况下的O(nlogn)时间复杂度，但在实际应用中往往成为首选的排序算法。原因在于：快速排序算法易于实现，代码结构紧凑简练，而且对于按通常规律随机分布的输入序列，快速排序算法实际的平均运行时间较之同类算法更少。
    * 在大多数情况下，快速排序算法的平均效率依然可以达到O(nlogn)，而且较之其他排序算法，其时间复杂度中的常系数更小。
    * 较之固定选择某个元素或随机选择单个元素的策略，三者取中法的效果更好，尽管还不能彻底杜绝最坏情况。
