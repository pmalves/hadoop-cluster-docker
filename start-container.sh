#!/bin/bash

HADOOP_VERSION=2.6.5

# the default node number is 2
N=${1:-2}

# start hadoop slave containers
i=1
while [ $i -le $N ]
do
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                pmgalves/hadoop:${HADOOP_VERSION} &> /dev/null
	i=$(( $i + 1 ))
done 

# start hadoop master container
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 4040:4040 \
                --name hadoop-master \
                --hostname hadoop-master \
                pmgalves/hadoop:${HADOOP_VERSION} &> /dev/null



# get into hadoop master container
docker exec -it hadoop-master bash
