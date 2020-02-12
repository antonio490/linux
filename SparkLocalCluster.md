
# Apache Spark Local Cluster

       ____              __
      / __/__  ___ _____/ /__
     _\ \/ _ \/ _ `/ __/  '_/
    /__ / .__/\_,_/_/ /_/\_\   
       /_/



Steps we have to follow in order to run our own pre built local cluster.

<h4>Prerequisites</h4>

> Linux SO
> 
> Download a Spark pre-built package release 


### A. Start up

Create a folder where we will store the download package.

    $ mkdir /home/ubuntu/Spark

Download last version Spark 2.4.4 and pre-built Hadoop 2.7 or later
https://spark.apache.org/downloads.html 

Open the download file and extract its content keeping the same structure.

### B. Launch Master node

Before running the master we need to change the configuration on <b>/home/ubuntu/Spark/spark-2.4.4-bin-hadoop2.7/conf</b>

- Copy spark-env.sh.template to spark-env.sh
- Check IP address with <b>ifconfig</b>
- Add SPARK_MASTER_HOST=150.244.67.68

Open a terminal window just on the machine where we want to launch our master node.

    $ cd /home/ubuntu/Spark/spark-2.4.4-bin-hadoop2.7
    $ ./sbin/start-master.sh

To assure everything works fine we can take a look at the logs on </b>/home/ubuntu/Spark/spark-2.4.4-bin-hadoop2.7/logs</b>

Now we can access the web interface on <b>http://<ip_address>:8080</b>

### C. Launch Worker nodes

Now on each machine where is going to run a worker node we must execute the next script:

    $ cd /home/ubuntu/Spark/spark-2.4.4-bin-hadoop2.7
    $ ./sbin/start-slave.sh <ip_address>:7077

Every worker node executed correctly should appear on the master dashboard.

### D. Run a Spark application

Let's start opening a pyspark terminaland executing a dummy example:

    $ ./bin/pyspark

    rdd = sc.range(10000)
    rdd.reduce(lambda a,b: a+b)

    sc.getConf().get('spark.master')

    c =sc.getConf().getAll()
    import pprint
    pprint.pprint(c)


### E. Tune server parameters

>spark-defaults.conf

    spark.cores.max=8

>spark-env.sh

    PYSPARK_PYTHON=python3

### F. Read files

In order to read files from pyspark we just need to decalre the whole path of the file:

    rdd = sc.textFile('/media/DiscoLocal/BigData/Spark/flights.csv.bz2')

    rdd.count()

We can repeat the same count operation but distributing the load between all the worker nodes:

    num = rdd.getNumPartitions()
    rdd2 = rdd.repartition(num)
    rdd2.count()

Read files as dataframes using:

    df = spark.read.csv('/media/DiscoLocal/BigData/Spark/flights.csv.bz2',
    header=True)
    
    df.count()

    # check table schema
    df.printSchema()

### G. Run Spark examples

    # Running an example
    ./bin/run-example --master spark://10.250.13.32:7077 --name <name> --conf spark.driver.host=<IP> SparkPi

    # Run an example using spark-submit
    ./bin/spark-submit --master spark://10.250.13.32:7077 --name <name>
    --conf spark.driver.host=<IP> examples/jars/spark-examples_2.11-2.4.4.jar

    # Other examples
    ./bin/run-example --master spark://10.250.13.32:7077 --name <name>
    --conf spark.driver.host=<IP> SparkLR | SparkALS | SparkTC

    # Run an example with a file
    ./bin/run-example --master spark://10.250.13.32:7077 --name <name>
    --conf spark.driver.host=<IP>
    mllib.LDAExample file:///opt/spark/current/data/mllib/sample_lda_data.txt