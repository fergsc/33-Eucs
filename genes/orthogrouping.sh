#!/bin/bash

# Run orthofinder
# make a directory containing a faa file for each genome
# faa files contain all primary transcripts.
# results will be sace to faa directory

geneDir="" # this Dir will contain a XXX.faa file for each genome, containing amino transcript sequences
threads=

orthofinderDir=


${orthofinderDir}/orthofinder -t $threads -f $geneDir
