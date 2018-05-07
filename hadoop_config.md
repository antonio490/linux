
### Setting up Hadoop single cluster

> Install software

<code> sudo apt-get install ssh </code>

<code> sudo apt-get install rsync </code>

<code> Download distribution from:(http://www.apache.org/dyn/closer.cgi/hadoop/common/)
</code>

### Pseudo-Distributed Operation

> Configuration

<code> open /etc/hadoop/core-site.xml </code>


    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://localhost:9000</value>
        </property>
    </configuration>


<code> open /etc/hadoop/hdfs-site.xml </code>


    <configuration>
        <property>
            <name>dfs.replication</name>
            <value>1</value>
        </property>
    </configuration>


> Set up passphrase ssh

<code> ssh localhost </code>

$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
$ chmod 0600 ~/.ssh/authorized_keys


> Execution

In order to run a MapReduce job locally follow next commands:

Format the filesystem:

<code> bin/hdfs namenode -format </code>

Start Namenode and Datanode daemons:

<code> sbin/start-dfs.sh </code>

Web interface for the Namenode is available here:

<code> http://localhost:50070 </code>

Make some tryouts copying files into the distributed filesystem, running some of the examples and checking the outpus files from the distributed filesystem to the local filesystem.

When you are done, stop the daemons:

<code> sbin/stop-dfs.sh </code>

### Logs

<code> $HADOOP_HOME/logs </code>

### Helpful links

1. (https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)

2. (https://www.digitalocean.com/community/tutorials/how-to-install-hadoop-in-stand-alone-mode-on-ubuntu-16-04)
