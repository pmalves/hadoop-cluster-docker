#!/bin/bash

SPARK_VERSION=2.1.0


# start spark client container
echo "start spark-client container..."
docker run -itd \
                --net=hadoop \
                --name spark-client \
                --hostname spark-client \
								-p 5901:5901 -p 6901:6901 \
                pmgalves/spark:${SPARK_VERSION} &> /dev/null


echo -e "\nnoVNC HTML client started:\n\t=> connect via http://127.0.0.1:6901/vnc_auto.html?password=pentaho"

# get into hadoop master container
docker exec -it spark-client bash
