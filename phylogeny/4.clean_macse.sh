#!/bin/bash

hmmCleaner="HmmCleaner.pl"
macseJar="/g/data/xe2/scott/gadi_modules/macse_v2.03.jar"
cp -r aligned-macse cleaned-macse
cd cleaned-macse

sed -i 's/*$/---/g' *.aa # external stop codons
sed -i 's/*/NNN/g'  *.aa # internal stop codons
sed -i 's/!/---/g'  *.aa # all frame shift codons

$hmmCleaner *.aa --changeID &> HmmCleaner.log
sed -i 's/_hmmcleaned//g' *_hmm.fasta

for nt in *.nt
do
    gene=$(basename $nt .nt)

    java -jar $macseJar \
        -prog reportMaskAA2NT \
        -align_AA ${gene}_hmm.fasta \
        -align $nt \
        -min_NT_to_keep_seq 30 \
        -mask_AA $  \
        -min_seq_to_keep_site 4 \
        -min_percent_NT_at_ends 0.3 \
        -dist_isolate_AA 3 \
        -min_homology_to_keep_seq 0.3 \
        -min_internal_homology_to_keep_seq 0.5 \
        -out_mask_detail ${gene}_mask.nt
done
cd ..
