#!/bin/bash

echo ""

echo -e "\nbuild docker spark image\n"
docker build -t pmgalves/spark:1.6.3 .

echo ""
