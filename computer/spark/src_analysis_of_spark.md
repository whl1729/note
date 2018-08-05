# spark源码分析

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
