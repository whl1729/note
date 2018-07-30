# HiBench源码分析

## kmeans源码分析

### 执行入口
```
bin/workloads/ml/kmeans/prepare/prepare.sh
bin/workloads/ml/kmeans/spark/run.sh
```

#### prepare.sh
```
bin/workloads/ml/kmeans/prepare/prepare.sh -->
    bin/functions/load_bench_config.sh -->
        bin/functions/workload_functions.sh

    workload_config=conf/workloads/ml/kmeans.conf

    enter_bench HadoopPrepareKmeans ${workload_config} ${current_dir} -->
        bin/functions/load_config.py

    show_bannar start

    rmr_hdfs $INPUT_HDFS || true

    run_hadoop_job ${DATATOOLS} org.apache.mahout.clustering.kmeans.GenKMeansDataset -D hadoop.job.history.user.location=${INPUT_SAMPLE} ${OPTION}

    show_bannar finish
    leave_bench
```

#### run.sh
```
bin/workloads/ml/kmeans/spark/run.sh -->
    bin/functions/load_bench_config.sh -->
        bin/functions/workload_functions.sh

    enter_bench ScalaSparkKmeans ${workload_config} ${current_dir}
    show_bannar start

    rmr_hdfs $OUTPUT_HDFS || true

    run_spark_job com.intel.hibench.sparkbench.ml.DenseKMeans -k $K --numIterations $MAX_ITERATION $INPUT_HDFS/samples

    show_bannar finish
    leave_bench
```

#### workload_functions.sh
```
// run_hadoop_job
${HADOOP_EXECUTABLE} --config ${HADOOP_CONF_DIR} jar $job_jar $job_name $tail_arguments

// run_spark_job
// LIB_JARS=
// SPARK_PROP_CONF=report/kmeans/spark/conf/sparkbench/spark.conf
${SPARK_HOME}/bin/spark-submit ${LIB_JARS} --properties-file ${SPARK_PROP_CONF} --master ${SPARK_MASTER} ${YARN_OPTS} ${CLS} $@
```
