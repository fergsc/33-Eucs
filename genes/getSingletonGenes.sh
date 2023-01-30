#!bin/bash

##########
# Get all genes for each species that were unassigned to an OG.

mkdir singletonGenes
for i in {2..33}
do
    awk -v I="$i" -v FS="\t" '{if(NR == 1){fileName = $I;print fileName; next}if($I != ""){print $I > "singletonGenes/"fileName".txt"}}' OF-all_eucs/Orthogroups/Orthogroups_UnassignedGenes.tsv
done
