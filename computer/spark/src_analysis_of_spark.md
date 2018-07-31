# spark源码分析

## spark submit
```
bin/spark-submit -->
    exec bin/spark-class org.apache.spark.deploy.SparkSubmit "$@" -->
        
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
