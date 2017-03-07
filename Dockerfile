FROM ubuntu:16.04

MAINTAINER Pedro Alves <pmgalves@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y software-properties-common openssh-server openjdk-8-jdk wget curl supervisor net-tools iputils-ping vim less

ENV HADOOP_VERSION=2.7.3
ENV SPARK_VERSION=2.1.0
ENV SPARK_HADOOP_VERSION=2.7

# install hadoop && Spark
RUN \
		curl http://mirror.ox.ac.uk/sites/rsync.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C /usr/local && \
	ln -s /usr/local/hadoop-* /usr/local/hadoop && \
	curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
	ln -s /usr/local/spark-* /usr/local/spark

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin:/usr/local/spark/sbin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/
COPY scripts/* /root/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/*.xml $HADOOP_HOME/etc/hadoop/ && \ 
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
		echo spark.yarn.jars hdfs://hadoop-master:8020/spark/* > $SPARK_HOME/conf/spark-defaults.conf

# Start and format namenode

RUN chmod +x ~/*.sh && \
 		/usr/local/hadoop/bin/hdfs namenode -format


ENTRYPOINT ["bash", "/root/start.sh"]
