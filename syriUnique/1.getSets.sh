#!/bin/bash

syriDir="/scratch/xe2/sf3809/all-Eucs/syri/data"

for dir in `find $syriDir -maxdepth 1 -type d`
do
    run=$(basename $dir)
    spp1=`echo $run | cut -f1 -d'~'`
    spp2=`echo $run | cut -f2 -d'~'`

    echo $run >> syriSets/$spp1.lst
    echo $run >> syriSets/$spp2.lst
done
