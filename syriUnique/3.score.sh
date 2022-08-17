genomeDir=""

run=$(basename $1)
echo "species,type,count,PC" > ${run}.csv
for bed in $1/*.bed
do
    tmp=$(basename $bed)
    file=${tmp%.*}
    spp=`echo $file | cut -f1 -d'~'`
    type=`echo $file | cut -f3 -d'~' | sed -e 's/_ref//g ; s/_qry//g'`

    len=`cut -f2 ${genomeDir}/${spp}.genome | paste -s -d+ | bc`  # get total genome size
    result=`awk -v L=$len 'BEGIN{sum = 0}{sum = sum + $3 - $2}END{print sum "," substr((sum/L),1,6)}' $bed`
    echo "${spp},${type},${result}" >> ${run}.csv
done
