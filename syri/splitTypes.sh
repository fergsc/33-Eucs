#!/bin/bash

##########
#
# splits syri.out files into SR-type.out
# types : SYN INV NOTAL DUP INVDP INVTR TRANS
#
##########

syriDir=""
chrs=`cat genomes/chromosomes.lst`
mkdir -p SyRI

for SyRI in `find $syriDir -maxdepth 2 -name "syri.out"`
do
    tmp=$(dirname $SyRI)
    dir=$(basename $tmp)

    # check if this run has already been split
    [ -d SyRI/${dir} ] && continue

    echo "${dir}"
    mkdir -p SyRI/${dir}

    #### SYN + INV
    for type in SYN INV
    do
        grep -w ${type} $SyRI > SyRI/${dir}/${type}.out
        for chr in $chrs
        do
            grep -w ${chr} SyRI/${dir}/${type}.out > SyRI/${dir}/${type}_${chr}.out
        done
    done

    ### NOTAL
    grep -w "NOTAL" $SyRI > SyRI/${dir}/NOTAL.out
    for chr in $chrs
    do
        awk -v C=$chr '{if($1 == C && $6 == "-") print $0}' SyRI/${dir}/NOTAL.out > SyRI/${dir}/NOTAL_ref_${chr}.out
        awk -v C=$chr '{if($1 == "-" && $6 == C) print $0}' SyRI/${dir}/NOTAL.out > SyRI/${dir}/NOTAL_qry_${chr}.out
    done
    cat SyRI/${dir}/NOTAL_ref_Chr??.out > SyRI/${dir}/NOTAL_ref.out
    cat SyRI/${dir}/NOTAL_qry_Chr??.out > SyRI/${dir}/NOTAL_qry.out

    ### Duplications (DUP INVDP)
    for type in DUP INVDP
    do
        grep -w ${type} $SyRI > SyRI/${dir}/${type}.out
        for chr in $chrs
        do
            awk -v C=$chr '{if($1 == C && $12 == "copyloss"){print $0}}' SyRI/${dir}/${type}.out > SyRI/${dir}/${type}_ref_${chr}.out
            awk -v C=$chr '{if($6 == C && $12 == "copygain"){print $0}}' SyRI/${dir}/${type}.out > SyRI/${dir}/${type}_qry_${chr}.out
        done
    done

    ### Translocations (INVTR TRANS)
    for type in INVTR TRANS
    do
        grep -w ${type} $SyRI > SyRI/${dir}/${type}.out
        for chr in $chrs
        do
            awk -v C=$chr '{if($1 == C){print $0}}' SyRI/${dir}/${type}.out > SyRI/${dir}/${type}_ref_${chr}.out
            awk -v C=$chr '{if($6 == C){print $0}}' SyRI/${dir}/${type}.out > SyRI/${dir}/${type}_qry_${chr}.out
        done
    done
done
