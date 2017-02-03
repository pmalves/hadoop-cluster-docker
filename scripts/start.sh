#!/bin/bash

BASEDIR=$(dirname $0)
cd $BASEDIR


service ssh start

HOSTNAME=$( hostname )

if [ "$HOSTNAME" == "hadoop-master" ]
then

        echo I am the master!

				$HADOOP_HOME/sbin/start-dfs.sh
				$HADOOP_HOME/sbin/start-yarn.sh

				# On the first execution, we need to copy the stuff to hdfs
				if [ ! -f /root/INITIALIZED ]
				then

					echo Initializing cluster. Copying spark jars...

					$HADOOP_HOME/bin/hdfs dfs -mkdir -p /spark/
					$HADOOP_HOME/bin/hdfs dfs -copyFromLocal /usr/local/spark/jars/* /spark/ 



					touch /root/INITIALIZED

				fi

fi


tail -F /usr/local/hadoop/logs/*

