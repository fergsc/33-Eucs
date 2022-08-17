alignmentDepth=0

for lst in `find . -name '*.lst'`
do
    python3 syri-bed.py $lst $alignmentDepth
done
