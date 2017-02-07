#!/bin/bash

echo ""

echo -e "\nbuild docker spark image\n"
docker build -t pmgalves/spark:2.1.0 .

echo ""
