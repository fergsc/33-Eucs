#!/bin/bash
astralDir="/g/data/xe2/scott/gadi_modules/Astral/astral.5.7.3.jar"

cat iqtree/*.treefile > all.treefile
java -jar $astralJar -i all.treefile -o  species.tre 2> astral.LOG
