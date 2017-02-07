#!/bin/bash

SPARK_VERSION=2.1.0


# start spark client container
echo "start spark-client container..."
docker run -itd \
                --net=hadoop \
                --name spark-client \
                --hostname spark-client \
                pmgalves/spark:${SPARK_VERSION} &> /dev/null


# get into hadoop master container
docker exec -it spark-client bash
