# spark源码分析

## stage开始阶段的流程分析

1. 由submitStage开始往下分析
```
DAGScheduler. handleJobSubmitted , handleMapStageSubmitted -->
    DAGScheduler.submitStage(stage: Stage) -->
        DAGScheduler.submitMissingTasks(stage, jobId) -->
            listenerBus.post(SparkListenerStageSubmitted(stage.latestInfo, properties))  /* send msg */
            ExecutorAllocationManager.onStageSubmitted(SparkListenerStageSubmitted)  /* recv msg */
```

2. 分析handleJobSubmitted -> submitStage 流程
```
SparkContext.submitJob -->
    DAGScheduler.submitJob -->
        DAGScheduler.handleJobSubmitted -->
            DAGScheduler.submitStage(stage: Stage) -->
```

3. 分析handleMapStageSubmitted -> submitStage 流程

## executor执行任务的流程

1. executor产生过程
阅读思路：
    * 从`output_kmeans_run.log`中的executor创建信息出发，找到相关代码。
```
CoarseGrainedSchedulerBackend.receiveAndReply -->
    case RegisterExecutor(executorId):
        listenerBus.post(SparkListenerExecutorAdded(executorId, data))  /* send msg */ 
        SparkListenerBus.doPostEvent  /* recv msg */
            case SparkListenerExecutorAdded:  
                onExecutorAdded(executorId)
```
    * 从executorDataMap开始，找到添加executor的地方，往回找调用者。
```
    CoarseGrainedExecutorBackend.onStart -->
        ref.ask[Boolean](RegisterExecutor(executorId, self, hostname, cores, extractLogUrls))  /* send */
        case RegisterExecutor(executorId, executorRef, hostname, cores, logUrls) /* recv */  =>
            val data = new ExecutorData(executorRef, executorAddress, hostname, cores, cores, logUrls)
            executorDataMap.put(executorId, data)
    case RegisteredExecutor =>
        executor = new Executor(executorId, hostname, env, userClassPath, isLocal = false)
```

2. 将task分配给executor
阅读思路：从ExecutorAllocationManager.onTaskStart函数开始往回找调用者。

```
makeOffers() -->
    activeExecutors = executorDataMap.filterKeys(executorIsAlive)
    resourceOffer(execId, host) -->
        info = new TaskInfo(taskId, index, attemptNum, curTime, execId, host, taskLocality, speculative)
        taskStarted(task, TaskInfo) -->
            eventProcessLoop.post(BeginEvent(task, taskInfo)) /* send */
            handleBeginEvent(TaskInfo) /* recv */ -->
                listenerBus.post(SparkListenerTaskStart(task.stageId, stageAttemptId, taskInfo))  /* send */
                ExecutorAllocationManager.onTaskStart(SparkListenerTaskStart)  /* recv */
```

3. 分析executor launchTask过程
```
CoarseGrainedExecutorBackend.statusUpdate(taskId: Long, state: TaskState, data: ByteBuffer) -->
    val msg = StatusUpdate(executorId, taskId, state, data)
    driverRef.send(msg) --> /* send msg */
    CoarseGrainedSchedulerBackend.receive -->  /* recv msg */
        case StatusUpdate(executorId, taskId, state, data) -->
            CoarseGrainedSchedulerBackend.makeOffers -->
                CoarseGrainedSchedulerBackend.launchTasks -->
                    executorData.executorEndpoint.send(LaunchTask)  /* send msg */
                    CoarseGrainedExecutorBackend.receive -->  /* recv msg */
                        case LaunchTask:  executor.launchTask(this, taskDesc)
```

## executor metrics

### 数据获取
```
getCurrentMetrics() -->
    MetricGetter.values.map(_.getMetricValue(memoryManager)).toArray -->
        JVMHeapMemory.getMetricValue(memoryManager: MemoryManager) -->
            ManagementFactory.getMemoryMXBean.getHeapMemoryUsage().getUsed()
```

### 数据更新
```
Heartbeater.start() -->
    reportHeartbeat() -->
        driverUpdates = _heartbeater.getCurrentMetrics()
        listenerBus.post(SparkListenerExecutorMetricsUpdate("driver", accumUpdates, Some(driverUpdates))) -->
            doPostEvent(listener, event) --> 
                listener.onExecutorMetricsUpdate(metricsUpdate) -->
                    peakMetrics.compareAndUpdate(executorUpdates)
```

## spark集群启动

### start-all.sh

1. 总流程
```
sbin/start-all.sh -->
    sbin/spark-config.sh // 设置python路径
    sbin/start-master.sh
    sbin/start-slaves.sh
```

2. 启动master
```
sbin/start-master.sh -->
    // CLASS="org.apache.spark.deploy.master.Master"
    sbin/spark-daemon.sh start $CLASS 1 --host $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT $ORIGINAL_ARGS -->
        run_command class "$@" -->
            spark_rotate_log "$log"
            execute_command nice -n "$SPARK_NICENESS" "${SPARK_HOME}"/bin/spark-class "$command" "$@" -->
                java -Xmx128m -cp "$LAUNCH_CLASSPATH" org.apache.spark.launcher.Main "$@"
```

3. 启动slave
```
sbin/start-slaves.sh -->
    // CLASS="org.apache.spark.deploy.worker.Worker"
    sbin/spark-daemon.sh start $CLASS $WORKER_NUM --webui-port "$WEBUI_PORT" $PORT_FLAG $PORT_NUM $MASTER "$@"
```

### Master.scala

1. 总流程
```
main -->
    Utils.initDaemon(log)
    startRpcEnvAndEndpoint(args.host, args.port, args.webUiPort, conf) -->
        val masterEndpoint = rpcEnv.setupEndpoint(ENDPOINT_NAME, new Master(rpcEnv, rpcEnv.address, webUiPort, securityMgr, conf)) -->
            dispatcher.registerRpcEndpoint(name, endpoint)
        val portsResponse = masterEndpoint.askSync[BoundPortsResponse](BoundPortsRequest)
```

2. onStart
```
onStart -->
    forwardMessageThread.scheduleAtFixedRate -->
        self.send(CheckForWorkerTimeOut)
    masterMetricsSystem.registerSource(masterSource)
    masterMetricsSystem.start()
    applicationMetricsSystem.start()
```

## spark submit
```
bin/spark-submit -->
    exec bin/spark-class org.apache.spark.deploy.SparkSubmit "$@" -->
        . bin/load-spark-env.sh
        // LAUNCH_CLASSPATH=assembly/target/scala-$SPARK_SCALA_VERSION/jars/*:launcher/target/scala-$SPARK_SCALA_VERSION/classes
        java -Xmx128m -cp "$LAUNCH_CLASSPATH" org.apache.spark.launcher.Main "$@"
```
