#!/bin/bash

# find all syri.out files in SyRIDir
# For each syri.out print out the size of all primary events

SyRIDir="/scratch/xe2/sf3809/all-Eucs/syri/data"

# copygain, i.e. genome B has the extra copy
# copyloss, i.e. genome A has the extra copy

[ -f data ] && rm -r data
mkdir data

for syri in `find $SyRIDir -name 'syri.out'`
do
    tmp=$(dirname $syri)
    comparison=$(basename $tmp)
    refSpp=`echo $comparison | cut -f1 -d'~'`
    qrySpp=`echo $comparison | cut -f2 -d'~'`

    [ -f ${refSpp}.csv ] || echo "type,length,uID,species" > data/${refSpp}.csv
    [ -f ${qrySpp}.csv ] || echo "type,length,uID,species" > data/${qrySpp}.csv

#    [ -f ${refSpp}~sizes_nested.csv ] || echo "type,length,uID,species" > ${refSpp}~sizes_nested.csv
#    [ -f ${qrySpp}~sizes_nested.csv ] || echo "type,length,uID,species" > ${qry}~sizes_nested.csv

    grep -w 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS' $syri | \
        awk -v O=${qrySpp} '{if($2 == "-"){next;} if($12 == "copygain") {next;}
        if($2 < $3) {print $11 "," $3-$2 "," $9 "," O} else {print $11 "," $2-$3+1 "," $9 "," O} }' >> data/${refSpp}.csv

#    grep -wv 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS\|SNP' $syri | \
#        awk -v O=${qrySpp} '{if($2 == "-"){next;} if($12 == "copygain") {next;}
#        if($2 < $3) {print $11 "," $3-$2 "," $9 "," O} else {print $11 "," $2-$3+1 "," $9 "," O} }' >> ${refSpp}~sizes_nested.csv


    grep -w 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS' $syri | \
        awk -v O=${refSpp} '{if($8 == "-"){next;} if($12 == "copyloss") {next;}
        if($7 < $8) {print $11 "," $8-$7 "," $9 "," O} else {print $11 "," $7-$8+1 "," $9 "," O} }' >> data/${qrySpp}.csv

#    grep -wv 'DUP\|INV\|INVDP\|INVTR\|NOTAL\|SYN\|TRANS\|SNP' $syri | \
#        awk -v O=${refSpp} '{if($8 == "-"){next;} if($12 == "copyloss") {next;}
#        if($7 < $8) {print $11 "," $8-$7 "," $9 "," O} else {print $11 "," $7-$8+1 "," $9 "," O} }' >> ${qrySpp}~sizes_nested.csv
done
