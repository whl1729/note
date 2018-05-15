# spark学习笔记

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
