inputFile=$1

awk -v FS="," -v OFS="," '
{
    n=split($4,a,"~")
    for(i=0; i<=n; ++i)
    {
        split(a[i],b,":")
        lll[b[1]] += 1
    }
    for(i in lll)
    {
        if(i != "")
        {
            str=str  ";"  i
        }
    }
    print $1,$2,$3,substr(str,2,length(str))
    delete lll
    str=""
}' $inputFile > $(basename $inputFile .csv)~res.csv

sed -i 's/E_melliodora_x_E_sideroxylon/mellxsider/g' $(basename $inputFile .csv)~res.csv # do this to avoid incorrectly counting hybid and melliodora/sideroxylon together

echo "ALL: $(cat $(basename $inputFile .csv)~res.csv| wc -l)"
echo "E_victrix E_coolabah E_shirleyi E_paniculata E_fibrosa E_caleyi E_polyanthemos E_dawsonii E_lansdowneana E_albens E_melliodora E_sideroxylon mellxsider  = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_polyanthemos" | grep -w "E_dawsonii" | grep -w "E_lansdowneana" | grep -w "E_albens" | grep -w "E_melliodora" | grep -w "E_sideroxylon" | grep -w "mellxsider" | grep -w "E_victrix" | grep -w "E_coolabah" | grep -w "E_shirleyi" | grep -w "E_paniculata" | grep -w "E_fibrosa" | grep -w "E_caleyi" | wc -l)"
echo "E_victrix E_coolabah = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_victrix" | grep -w "E_coolabah" | wc -l)"
echo "E_shirleyi E_paniculata E_fibrosa E_caleyi = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_shirleyi" | grep -w "E_paniculata" | grep -w "E_fibrosa" | grep -w "E_caleyi" | wc -l)"
echo "E_victrix E_coolabah E_shirleyi E_paniculata E_fibrosa E_caleyi = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_victrix" | grep -w "E_coolabah" | grep -w "E_shirleyi" | grep -w "E_paniculata" | grep -w "E_fibrosa" | grep -w "E_caleyi" | wc -l)"
echo "E_paniculata E_fibrosa E_caleyi = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_paniculata" | grep -w "E_fibrosa" | grep -w "E_caleyi" | wc -l)"
echo "E_fibrosa E_caleyi = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_fibrosa" | grep -w "E_caleyi" | wc -l)"
echo "E_polyanthemos E_dawsonii E_lansdowneana E_albens E_melliodora E_sideroxylon mellxsider = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_polyanthemos" | grep -w "E_dawsonii" | grep -w "E_lansdowneana" | grep -w "E_albens" | grep -w "E_melliodora" | grep -w "E_sideroxylon" | grep -w "mellxsider" | wc -l)"
echo "E_polyanthemos E_dawsonii = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_polyanthemos" | grep -w "E_dawsonii" | wc -l)"
echo "E_lansdowneana E_albens E_melliodora E_sideroxylon mellxsider = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_lansdowneana" | grep -w "E_albens" | grep -w "E_melliodora" | grep -w "E_sideroxylon" | grep -w "mellxsider" | wc -l)"
echo "E_albens E_melliodora E_sideroxylon mellxsider = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_albens" | grep -w "E_melliodora" | grep -w "E_sideroxylon" | grep -w "mellxsider" | wc -l)"
echo "E_melliodora E_sideroxylon mellxsider = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_melliodora" | grep -w "E_sideroxylon" | grep -w "mellxsider" | wc -l)"
echo "E_sideroxylon E_melliodora_x_E_sideroxylon = $(cat $(basename $inputFile .csv)~res.csv | grep -w "E_sideroxylon" | grep -w "mellxsider" | wc -l)"

echo "E_victrix = $(grep -w "E_victrix" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_coolabah = $(grep -w "E_coolabah" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_shirleyi = $(grep -w "E_shirleyi" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_paniculata = $(grep -w "E_paniculata" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_fibrosa = $(grep -w "E_fibrosa" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_caleyi = $(grep -w "E_caleyi" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_polyanthemos = $(grep -w "E_polyanthemos" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_dawsonii = $(grep -w "E_dawsonii" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_lansdowneana = $(grep -w "E_lansdowneana" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_albens = $(grep -w "E_albens" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_melliodora = $(grep -w "E_melliodora" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_sideroxylon = $(grep -w "E_sideroxylon" $(basename $inputFile .csv)~res.csv | wc -l)"
echo "E_melliodora_x_E_sideroxylon = $(grep -w "mellxsider" $(basename $inputFile .csv)~res.csv | wc -l)"

##########
### size distributions
echo ""
echo "Size:"
awk -v FS="," -v OFS="," '
    BEGIN{min=999999999999; max = -1}
    {
        size = $3-$2;
        if(size > max){max = size};
        if(size < min){min = size};
        avg += size;
        lines +=1;
        x+=size;
        y+=size^2;
    }
    END{
        sd = sqrt(y/NR-(x/NR)^2);
        print "min:"min"\navg:"avg/lines"\nmax:"max"\nsd:"sd"\nTotal:"avg"\n";
    }' $inputFile

rm $(basename $inputFile .csv)~res.csv


##########
### number of genomes per event
awk -v FS="," -v OFS="," '
{
    n=split($4,a,"~")
    for(i=0; i<=n; ++i)
    {
        split(a[i],b,":")
        lll[b[1]] += 1
    }
    for(i in lll)
    {
        if(i != "")
        {
            count+=1
        }
    }
    print count
    delete lll
    count = 0
}' $inputFile |sort | uniq -c | sort -k2,2h | awk 'BEGIN{print numSpecies,numEvents} {print $2,$1}'
