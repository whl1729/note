# spark使用笔记

## executor与driver的通信

1. 每个executor对应一个CoarseGrainedExecutorBackend进程。executor通过CoarseGrainedExecutorBackend向cluster manager汇报任务运行状态等信息。

2. job, stage and task: 一个job包括若干个stage，一个stage包括若干个task。
    * 当需要执行一个RDD的action时，会生成一个job。
    * 一个Job会被拆分为多组Task，每组任务被称为一个Stage， 就像Map Stage，Reduce Stage。Stage的划分在RDD的论文中有详细的介绍，简单的说是以shuffle和result这两种类型来划分。 
    * task是被送到 executor 上的工作单元。一般来说，一个 rdd 有多少个 partition，就会有多少个 task，因为每一个 task 只是处理一个 partition 上的数据。

## 查看spark调试信息

### 相关网页
1. fs.defaultFS => `hdfs://master:9000`
2. mapreduce.jobhistory.address => `master:10020`
3. mapreduce.jobhistory.webapp.address => `master:19888`
2. yarn.resourcemanager.address => `master:8032`
3. yarn.resourcemanager.webapp.address => `master:8088`

## 编译spark
```
./build/mvn -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.3 -DskipTests clean package
```

## 部署spark

### 修改配置文件

1. 修改`.bashrc`

2. 修改`spark-env.sh`
    * 配置Java路径`JAVA_HOME`
    * 配置`SPARK_DIST_CLASSPATH`
    * 配置hadoop配置文件路径`HADOOP_CONF_DIR`
    * 配置master节点的ip`SPARK_MASTER_IP`

3. 修改`slaves`
    * 配置slave节点的主机名

## 提交spark应用

1. 参考资料：[Submitting Applications](https://spark.apache.org/docs/latest/submitting-applications.html)

2. 使用`spark-submit`运行spark应用
```
./bin/spark-submit \
  --class <main-class> \
  --master <master-url> \
  --deploy-mode <deploy-mode> \
  --conf <key>=<value> \
  ... # other options
  <application-jar> \
  [application-arguments]
```

## 使用spark shell

1. 进入spark shell界面：
在终端输入`pyspark`或`spark-shell`。
退出spark shell界面：
输入`Ctrl-D`

2. 设置日志显示级别：
修改`${SPARK_HOME}/conf/log4j.properties`文件中的`log4j.rootCategory`配置，比如：`log4j.rootCategory=WARN, console`

3. 运行Python脚本：
在终端输入`spark-submit my_script.py`

## spark编程基础

1. 通过输入文件创建RDD：
`val lines = sc.textFile("README.md")`

2. 初始化SparkContext
```
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._

val conf = new SparkConf().setMaster("local").setAppName("My App")
val sc = new SparkContext(conf)
```

3. 常用操作
```
lines = sc.textFile("README.md")
pythonLines = lines.filter(lambda line: "Python" in line)
pythonLines.persist
pythonLines.first()
pythonLines.count()
msg = sc.parallelize(List("pandas", "i like pandas"))
```

4. 遍历RDD元素
```
lines.take(10).foreach(println)
println(lines.collect().mkString(","))
```

5. Scala函数传参
```
class SearchFunction(val query: String) {
    def isMatch(s: String): Boolean = {
        s.contains(query)
    }

    def getMatchesFunctionReference(rdd: RDD[String]): RDD[String] = {
        rdd.map(isMatch)
    }

    def getMatchesFieldReference(rdd: RDD[String]): RDD[String] = {
        rdd.map(x => x.split(query))
    }

    def getMatchesNoReference(rdd: RDD[String]): RDD[String] = {
        val query_ = this.query
        rdd.map(x => x.split(query_))
    }
}
```

6. flatMap与Map的区别
flatMap相当于先Map，再将Map出来的列表首尾相连。
```
var lines = sc.parallelize(List("Hello World", "Thank you"))
var map_line = lines.map(lambda line : line.split(" "))
var flatmap_line = lines.flatMap(lambda line : line.split(" "))
map_line.first()
flatmap_line.first()
```

7. 集合操作
```
var a = sc.parallelize(List("coffee", "coffee", "panda", "monkey", "tea"))
var b = sc.parallelize(List(""))
a.district()
a.union(b)
a.intersection(b)
a.subtract(b)
a.cartesian(b)
```

## spark分布式架构

1. master/slave架构
    * one central coordinator: driver
    * many distributed workers: executors

2. cluster managers: Mesos, YARN and standalone

### driver
1. driver: process where the main() methods of your program runs
    * creates a SparkContext
    * creates RDDs
    * performs transformations and actions

2. driver's duties
    * converting a user program into tasks
        * create DAG
        * convert DAG into a set of stages
        * each stage consists of multiple tasks
        * tasks are the smallest unit of work in Spark

    * scheduling tasks on executors
        * executors register themselves with the driver when they are started
        * each executor represents a process capable of running tasks and storing RDD data

3. DAG: Directed Acyclic Graph.
    * A Spark program implicitly creates a DAG of operations
    * Driver converts DAG into a physical execution plan

### executor
1. executor: worker process responsible for running the individual tasks in a given Spark job

2. executor's role
    * run the tasks that make up the application and return results to the driver
    * provide in-memory storage for RDDs that are cached by user programs, through Block Manager that lives within each executor

### cluster manager
1. Spark depends on a cluster manager to launch the driver and executors.

2. master/worker vs driver/executor
    * driver/executor are used to described the processes that execute each Spark application
    * master/slave are used to described the centralized and distributed portions of the cluster manager
    * Hadoop YARN runs a master daemons called Resource Manager, and several worker daemons called Node Managers
    * Spark can run both drivers and executors on the YARN worker nodes

3. spark-submit: a single script you can use to submit your program to the cluster manager

### run a spark application on a cluster
1. submits an application using spark-submit
2. spark-submit launches the driver program and invokes the main() method
3. the driver program ask the cluster manager for resources to launch executors
4. the cluster manager launches executors on behalf of the driver program
5. the driver process runs through the user application, sends work to executors in the form of tasks
6. tasks are run on executor processes to compute and save results
7. if the driver's main() method exits or it calls SparkContext.stop(), it will terminate the executors and release resources from the cluster manager

### BlockManager
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

