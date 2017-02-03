#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
docker build -t pmgalves/hadoop:2.7.3 .

echo ""
