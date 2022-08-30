#!/bin/bash

syriDir="../syri/out"
echo "refSpecies,qrySpecies,type,bp" > all.csv
for syri in `ls ${syriDir}/*.out`
do
    run=$(basename $syri .out)
    spp1=`echo $run | cut -f1 -d'~'`
    spp2=`echo $run | cut -f2 -d'~'`

    awk -v OFS="," -v REF=${spp1} -v QRY=${spp2} 'function abs(x) {return x < 0 ? -x : x}
    {
        if($1 != "-"){countsRef[$11] += abs($3-$2)}
        if($6 != "-"){countsQry[$11] += abs($8-$7)}
    }
    END{
        print REF,QRY,"SYN",countsRef["SYN"];
        print REF,QRY,"NOTAL",countsRef["NOTAL"];
        print REF,QRY,"INV",countsRef["INV"];
        print REF,QRY,"DUP",countsRef["DUP"]+countsRef["INVDP"];
        print REF,QRY,"TRANS",countsRef["TRANS"]+countsRef["INVTR"];

        print QRY,REF,"SYN",countsQry["SYN"];
        print QRY,REF,"NOTAL",countsQry["NOTAL"];
        print QRY,REF,"INV",countsQry["INV"];
        print QRY,REF,"DUP",countsQry["DUP"]+countsQry["INVDP"];
        print QRY,REF,"TRANS",countsQry["TRANS"]+countsQry["INVTR"]}' $syri >> all.csv
done

# calculate % of genome and add to csv
for csv in `ls *.csv`
do
    echo "refSpecies,qrySpecies,bp,pc" > tmp
    for gne in `ls ../genomes/*.genome`
    do
        spp=$(basename $gne .genome)
        size=`cut -f2 $gne | paste -s -d+ | bc`
        awk -v REF=${spp} -v SIZE=${size} -v OFS="," -v FS="," '$1 == REF{print $0, $4/SIZE}' $csv >> tmp
    done
    mv tmp $csv
done

