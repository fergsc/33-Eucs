#!/bin/bash

max=`head -n 1 fna-counts.lst | cut -f1 -d' '`
str="^$max"
grep "^${max}" fna-counts.lst |wc -l | awk -v S="${max}" '{printf("%s <> %i = %.2f%\n", S, $1, $1/23.13)}'
for ((c = $((36-1)); c > $((max/2)); c--))
do
    str="${str}\|^${c}"
    grep "${str}" fna-counts.lst |wc -l | awk -v S="${max}-${c}" '{printf("%s <> %i = %.2f%\n", S, $1, $1/23.13)}'
done

echo ""
echo "slect grep range from above and run the correct grep command to get genes list"
str="^$max"
for ((c = $((36-1)); c > $((max/2)); c--))
do
    str="${str}\|^${c}"
    echo "${max}-${c}: grep \"$str\" fna-counts.lst | cut -f2 -d' ' > genes-use.lst"
done
