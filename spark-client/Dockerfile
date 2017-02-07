FROM ubuntu:16.04

MAINTAINER Pedro Alves <pmgalves@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget curl

ENV HADOOP_VERSION=2.7.3
ENV SPARK_VERSION=2.1.0
ENV SPARK_HADOOP_VERSION=2.7

# instal Spark 2.1.0
RUN \
	curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
	ln -s /usr/local/spark-* /usr/local/spark

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin:/usr/local/spark/sbin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


COPY /config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
		mkdir -p $HADOOP_CONF_DIR && \
    mv /tmp/*.xml $HADOOP_CONF_DIR && \ 
		echo spark.yarn.jars hdfs://hadoop-master:9000/spark/* > $SPARK_HOME/conf/spark-defaults.conf


ENTRYPOINT ["bash"]

