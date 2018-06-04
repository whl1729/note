# hadoop使用笔记

## hadoop部署

### 设置slave节点主机名和ip
修改/etc/hosts文件即可。

### 修改hadoop配置文件

1. 修改`bashrc`
    * 设置hadoop路径

2. 修改`hadoop_env.sh` 
    * 设置JAVA路径`JAVA_HOME`

3. 修改`core-site.xml`
    * 设置`fs.defaultFS`
    * 设置tmp目录路径`hadoop.tmp.dir`

4. 修改`hdfs-site.xml`
    * 设置`dfs.namenode.secondary.http-address`
    * 设置`dfs.replication`
    * 设置`dfs.namenode.name.dir`
    * 设置`dfs.datanode.data.dir`
    * 设置`dfs.permissions`

5. 修改`yarn-site.xml`
    * 设置`yarn.nodemanager.pmem-check-enabled`为`false`
    * 设置`yarn.nodemanager.vmem-check-enabled`为`false`

6. 修改`mapred-site.xml`
    * 设置`mapreduce.framework.name`为`yarn`

7. 修改slaves
    * 设置所有slave节点的主机名

### 格式化namenode

执行命令`hdfs namenode -format`。
