#!/bin/bash

macseJar="/g/data/xe2/scott/gadi_modules/macse_v2.03.jar"
macseMEM=31

mkdir -p aligned-macse
cd aligned-macse

for fna in `cat ../genes-use.lst`
do
    gene="../genes/${fna}"
    java -Xmx${macseMEM}G -jar $macseJar -prog alignSequences -seq $gene -out_NT $(basename $fna .fna).nt -out_AA $(basename $fna .fna).aa
done

cd ../
