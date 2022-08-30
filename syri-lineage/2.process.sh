#!/bin/bash

inputFile=$1

python3 syri.py $inputFile
bash score.sh $(basename $inputFile .lst)~commonEvents.csv
