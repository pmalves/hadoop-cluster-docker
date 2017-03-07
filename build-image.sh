#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
docker build -t pmgalves/hadoop:2.6.5 .

echo ""
