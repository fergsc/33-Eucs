BUSCODir="/g/data/xe2/scott/genomes/BUSCO5/scaffolded"
sppCut=9 # want to get species name from busco gene directory, use this location when performing cut.

echo "get genes"
mkdir genes
cd genes
for busco in `find $BUSCODir -name 'single_copy_busco_sequences' -type d`
do
    spp=`echo $busco | cut -f${sppCut} -d'/'`
    for fna in `ls ${busco}/*.fna`
    do
        number=`grep '^>' $fna | wc -l`
        if [  $number == "1" ] # only want single copy genes.
        then
            gene=$(basename $fna)
            bioawk -c fastx -v S=${spp} '{print ">" S "\n" $seq}' $fna >> $gene
        fi
    done
done
cd ..

echo "count genes"
for fna in genes/*.fna
do
   gene=$(basename $fna)
   number=`grep '^>' $fna | wc -l`
   echo "$number $gene"
done | sort -k1 -hr >fna-counts.lst
