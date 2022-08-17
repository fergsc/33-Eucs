#!/bin/bash

[ -d data ] && rm -r data
mkdir data

spp1=`head -n 1 speciesOrder.lst`
for spp2 in `tail -n +2 speciesOrder.lst`
do
    good=0

    if [[ -f "/scratch/xe2/sf3809/all-Eucs/syri/SyRI/${spp1}~${spp2}/SYN.out" ]]
    then
        mkdir data/${spp1}~${spp2}
        cp /scratch/xe2/sf3809/all-Eucs/syri/SyRI/${spp1}~${spp2}/SYN_Chr*.out data/${spp1}~${spp2}
        echo "${spp1}~${spp2}" >> syri.lst
        good=1
    fi

    if [[ -f "/scratch/xe2/sf3809/all-Eucs/syri/SyRI/${spp2}~${spp1}/SYN.out" ]]
    then
        mkdir data/${spp2}~${spp1}
        cp /scratch/xe2/sf3809/all-Eucs/syri/SyRI/${spp2}~${spp1}/SYN_Chr*.out data/${spp2}~${spp1}
        echo "${spp2}~${spp1}" >> syri.lst
        good=1
    fi
    [[ $good != 1 ]] && echo "missing: $run"
    spp1=$spp2
done
