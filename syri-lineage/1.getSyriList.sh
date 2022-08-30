#!/bin/bash

lst="adnataria.lst"

#outgroup="E_brandiana"
#outgroup="E_cladocalyx"
outgroup="E_leucophloia"

SyRIDir="/scratch/xe2/sf3809/all-Eucs/syri/out"
find $SyRIDir -name '*.out' | grep -w $outgroup | grep -wf $lst > ${outgroup}.lst
