#!/bin/bash

iqTreeDir="."

mkdir iqtree
cd iqtree

for nt in ../cleaned-macse/*.nt
do
    ${iqTreeDir}/iqtree -s $nt -pre $(basename $nt .nt) &> $(basename $nt .nt).LOG
done
