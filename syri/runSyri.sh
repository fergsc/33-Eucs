#!/bin/bash
conda activate SyRI

refGenome=  # reference genome
qryGenome=  # query genom
delta=      # MUMmer delta file resulting from refGenome & qryGenome
coords=     # MUMmer coords file
syriDir=    # path to syri
numCPUs=    # number of threads
mumDir=     # path to mummer, for use for show-snps

getSNPs=0   # find SNPs & indels. 1 = yes, 0 = no

if [[ getSNPs == 1 ]]
then
   python ${syriDir}/bin/syri \
      -d $delta               \
      -c $coords              \
      -r $refGenome           \
      -q $qryGenome           \
      --nc $numCPUs           \
      -s ${mumDir}/show-snps
else
   python ${syriDir}/bin/syri \
      -d $delta               \
      -c $coords              \
      -r $refGenome           \
      -q $qryGenome           \
      --nc $numCPUs           \
      -s ${mumDir}/show-snps  \
      --nosnp
fi
