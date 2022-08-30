#!/usr/bin/env python

import ntpath
import os
import sys
import glob
import csv
from intervaltree import Interval, IntervalTree

globalFuzz = int(50)
minEventSize = int(1000)
# all available types: ["NOTAL", "INV", "SYN", "INVDP", "INVTR", "DUP", "TRANS"]
useTypes = ["INV", "INVTR", "TRANS", "DUP", "INVDP"]
chromList = ["Chr01", "Chr02", "Chr03", "Chr04", "Chr05", "Chr06", "Chr07", "Chr08", "Chr09", "Chr10", "Chr11"]


# does x == y +- fuzz
def fuzzyEqual(x, y, fuzz = globalFuzz):
    return abs(int(x) - int(y)) <= fuzz

# find and return the indexes to use for the syri file.
# want to get event coorodinates for the non reference species
def refQry(refSpecies, file):
    sp1 = ntpath.basename(file).split("~")[0]
    sp2 = ntpath.basename(file).split("~")[1].split(".")[0]
    if refSpecies == sp1:
        qrySpecies = sp2
        indexChr = 0
        indexStart = 1
        indexStop = 2
    else:
        qrySpecies = sp1
        indexChr = 5
        indexStart = 6
        indexStop = 7
    return qrySpecies, [indexChr, indexStart, indexStop]


##########
### Start
# get file name of syri list
# and reference species name from file name.
syriFiles = sys.argv[1]
refSpp = ntpath.basename(syriFiles.split(".")[0])
print("Base species:{}".format(refSpp))

##########
### get list of syri files to use
with open(syriFiles, "r") as f:
    syriList = [line.rstrip() for line in f]

##########
### Initialise dict of trees
syriCommons = {}
for chrom in chromList:
    syriCommons[chrom] = IntervalTree()

##########
### processes all files
# get all events and add to tree if new, or append to existing event if not new.
for currFile in syriList:
    print("processing:{}".format(ntpath.basename(currFile)))
    qrySpp, index = refQry(refSpp, currFile)
    with open(currFile, "r") as file:
        for event in csv.reader(file, delimiter="\t"):
            if event[10] not in useTypes:
                continue
            chromChk = event[index[0]]
            if chromChk == "-":
                continue
            startChk = int(event[index[1]])
            endChk = int(event[index[2]])
            if startChk > endChk:
                startChk, endChk = endChk, startChk
            uIDsChk = "{}:{}".format(qrySpp, event[8])
            if abs(endChk - startChk) < minEventSize: # is this event too small to record?
                continue
            saved = False
            for interval in syriCommons[chromChk][(startChk-globalFuzz):(endChk+globalFuzz)]: # get matching intervals.
                startSyri = int(interval[0])
                endSyri = int(interval[1])
                data = interval[2]
                startEqual = fuzzyEqual(startChk, startSyri)
                endEqual = fuzzyEqual(endChk, endSyri)
                if startEqual and endEqual:
                    syriCommons[chromChk].remove(interval)
                    syriCommons[chromChk].add(Interval(startSyri, endSyri, "{}~{}".format(data,uIDsChk)))
                    saved = True
                    break # dont need to test any remaining intervals.
            if saved == False: # if not saved it is a new event.
                syriCommons[chromChk].add(Interval(startChk, endChk, uIDsChk))
    print("  end.")

##########
### save results.
with open("{}~commonEvents.csv".format(refSpp), "w") as outFile:
    for chromosome in syriCommons.keys():
        for interval in syriCommons[chromosome]:
            start = interval[0]
            end = interval[1]
            ids = interval[2]
            outFile.write("{},{},{},{}\n".format(chromosome,start,end,ids))
