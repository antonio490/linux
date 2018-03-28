
## Setting up Hadoop single cluster

> Install software

<code> sudo apt-get install ssh </code>

<code> sudo apt-get install rsync </code>

<code> Download distribution from:(http://www.apache.org/dyn/closer.cgi/hadoop/common/)
</code>

### Pseudo-Distributed Operation

> Configuration

<code> open /etc/hadoop/core-site.xml </code>

<code> 
    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://localhost:9000</value>
        </property>
    </configuration>
</code>

<code> open /etc/hadoop/hdfs-site.xml </code>

<code>
    <configuration>
        <property>
            <name>dfs.replication</name>
            <value>1</value>
        </property>
    </configuration>
</code>

> Set up passphrase ssh

<code> ssh localhost </code>

<code>
    $ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
    $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    $ chmod 0600 ~/.ssh/authorized_keys
</code>

> Execution
In order to run a MapReduce job locally follow next commands:

Format the filesystem:
<code> bin/hdfs namenode -format </code>

Start Namenode and Datanode daemons:
<code> sbin/start-dfs.sh </code>

### Logs

<code> $HADOOP_HOME/logs </code>

### Helpful links

1. (https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)