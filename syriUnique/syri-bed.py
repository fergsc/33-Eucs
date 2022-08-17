import sys
import csv
import math
#import numpy as np
import ntpath

SYRI_DIR = "/scratch/xe2/sf3809/all-Eucs/syri/SyRI"
GENOME_DIR = "/scratch/xe2/sf3809/all-Eucs/genomes"

def fillCoords(base, index):
    return base * index

def incrementList(list, x = 1):
    '''
    Increment (default 1) all values in the passed in list
    If using adding a minus number, will nott go below 0.
    '''
    xxx = []
    for n in list:
        if n+x < 0:
            xxx.append(0)
        else:
            xxx.append(n+x)
    return xxx

def getGenomeSize(chromosomes, chr):
    '''
    Takes in the genome file and returns the
    chromosome size of the requested chromosome
    '''
    for x in chromosomes:
        if (x[0] == chr):
            return int(x[1])

def bedRanges(chromosome, minBP):
    '''
    Takes a chromosome with counts for the number of events at each base.
    Finds ranges where base == ch and returns these ranges.
    '''
    nums = [i for i, letter in enumerate(chromosome) if letter == int(minBP)]
    gaps = [[s, e] for s, e in zip(nums, nums[1:]) if s+1 < e]
    edges = iter(nums[:1] + sum(gaps, []) + nums[-1:])
    beds = list(zip(edges, edges))
    return [(s,e+1) for s,e in beds]

### Read in command line arguments
# syriListFile = speciesName.csv with all syri file names for a species
# minScore = the minimum number of overlaping events to find within alignments
syriListFile = sys.argv[1]
minScore = sys.argv[2]

### setup starting data
species = ntpath.basename(syriListFile).split(".")[0]
with open(syriListFile) as f:
    syriList = f.read().splitlines()
chroms = ["Chr01", "Chr02", "Chr03", "Chr04", "Chr05", "Chr06", "Chr07", "Chr08", "Chr09", "Chr10", "Chr11"]
numComparisons = len(syriList)

### what is going on?
print(species)
print("  compares:{}".format(numComparisons))
[print("  {}".format(a)) for a in syriList]

### read in genome file & set up score matrix
with open("{}/{}.genome".format(GENOME_DIR, species)) as f:
    genome = f.read().splitlines()
genome = [(x.split("\t")) for x in genome]


### loop over chromosomes and score each one
fileHeader = False
for index, currChrom in enumerate(chroms):
    gSize = getGenomeSize(genome, currChrom)
    scoreSYN = [0] * gSize
    scoreNOTAL = [0] * gSize
    scoreREARRANGED = [numComparisons] * gSize

    # loop through all syri comparisons
    for currComparison in syriList:

        syriRef = currComparison.split("~")[0]
        syriQry = currComparison.split("~")[1]

        if species == syriRef:
            #print("reference")
            chrIndex = 0
            startIndex = 1
            endIndex = 2
            notalFile = "NOTAL_ref"
        else:
            #print("query")
            chrIndex = 5
            startIndex = 6
            endIndex = 7
            notalFile = "NOTAL_qry"

        ### syntenic regions
        tsvFile = open("{}/{}/SYN_{}.out".format(SYRI_DIR, currComparison, currChrom), "r")
        syriEvents = csv.reader(tsvFile, delimiter="\t")

        for event in syriEvents:
            sStart = int(event[startIndex])
            sEnd = int(event[endIndex])
            if sStart > sEnd:
                sStart , sEnd = sEnd, sStart
            scoreSYN[sStart:sEnd] = incrementList(scoreSYN[sStart:sEnd])
            scoreREARRANGED[sStart:sEnd] = incrementList(scoreREARRANGED[sStart:sEnd], -1)
        tsvFile.close()

        ### not-aligned regions
        tsvFile = open("{}/{}/{}_{}.out".format(SYRI_DIR, currComparison, notalFile, currChrom), "r")
        syriEvents = csv.reader(tsvFile, delimiter="\t")

        for event in syriEvents:
            sStart = int(event[startIndex])
            sEnd = int(event[endIndex])
            if sStart > sEnd:
                sStart , sEnd = sEnd, sStart
            scoreNOTAL[sStart:sEnd] = incrementList(scoreNOTAL[sStart:sEnd])
            scoreREARRANGED[sStart:sEnd] = incrementList(scoreREARRANGED[sStart:sEnd], -1)
        tsvFile.close()

    ### save results
    with open("{}~{}~SYN.bed".format(species, minScore), "a+") as outfile:
        for (s,e) in bedRanges(scoreSYN, minScore):
            outfile.write("{}\t{}\t{}\n".format(currChrom, s, e))

    with open("{}~{}~NOTAL.bed".format(species, minScore), "a+") as outfile:
        for (s,e) in bedRanges(scoreNOTAL, minScore):
            outfile.write("{}\t{}\t{}\n".format(currChrom, s, e))

    with open("{}~{}~REARRANGED.bed".format(species, minScore), "a+") as outfile:
        for (s,e) in bedRanges(scoreREARRANGED, minScore):
            outfile.write("{}\t{}\t{}\n".format(currChrom, s, e))
