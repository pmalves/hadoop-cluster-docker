#!/bin/bash

HADOOP_VERSION=2.7.3


# start hadoop master container
echo "Wiping spark-client container..."
docker rm -f spark-client 


echo Done
