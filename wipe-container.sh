#!/bin/bash

HADOOP_VERSION=2.6.5

# the default node number is 3
N=${1:-5}


# start hadoop master container
echo "Wiping hadoop-master container..."
docker rm -f hadoop-master 

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	echo "Wiping hadoop-slave$i container..."
	docker rm -f hadoop-slave$i 
	i=$(( $i + 1 ))
done 

echo Done
