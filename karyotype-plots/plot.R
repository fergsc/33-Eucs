library(karyoploteR)
library(data.table)

setwd("/home/scott/Documents/writing/all-eucs2/")
genomeDir = "data/genomes"
syriDir = "data/karyo-plots"
chromosomes = c("Chr01", "Chr02", "Chr03", "Chr04", "Chr05", "Chr06", "Chr07", "Chr08", "Chr09", "Chr10", "Chr11")
syriFiles = fread("data/karyo-plots/syri.lst", sep = "\n", header = FALSE)
plotOrder = fread("data/karyo-plots/speciesOrder.lst", sep = "\n", header = FALSE)
saveLocation = "plots/karotype"
dir.create(saveLocation)

##########
### get chromosome sizes
# use: genomes[, "ssp"] to get all sizes for species ssp
# use genomes["Chr01", ] to get chromosome sizes
genomes = matrix(ncol = length(plotOrder$V1), nrow = 11, dimnames = list(chromosomes, plotOrder$V1))
for(species in plotOrder$V1)
{
  genomes[, species] = unlist(fread(sprintf("%s/%s.genome", genomeDir, species))[,2])
}


blankRegion = toGRanges(plotOrder[1], start = 1, end = 2) # used to get links to not display karyotypes

##########
### individual plots
# these will need to be combined in paint
for(chr in chromosomes)
{
  ### setup
  currGenome = toGRanges(data.frame(chr=colnames(genomes), start=rep(1, length(plotOrder)), 
                                    end=genomes[chr,]))
  ### print a blank karyotype
  png(sprintf("%s/%s~blank.png", saveLocation, chr), width = 2048, height = 1536)
  kp = plotKaryotype(genome = currGenome)
  dev.off()
  
  firstRun = TRUE
  for(currSyri in syriFiles$V1)
  {
    print(currSyri)
    currSyn = fread(sprintf("%s/%s/SYN_%s.out", syriDir, currSyri, chr))
    synRef = data.frame(unlist(strsplit(currSyri, "~"))[1], currSyn$V2, currSyn$V3, currSyn$V9, "stalk")
    synQuery = data.frame(unlist(strsplit(currSyri, "~"))[2], currSyn$V7, currSyn$V8, currSyn$V9, "stalk")
    colnames(synRef) = c("chr", "start", "end", "name", "gieStain")
    colnames(synQuery) = c("chr", "start", "end", "name", "gieStain")
    if(firstRun)
    {
      a = synRef
      b = synQuery
      firstRun = FALSE
    }
    else
    {
      a = rbind(a, synRef)
      b = rbind(b, synQuery)
    } 
  }
  synBands = toGRanges(rbind(a,b))
  inv1 = toGRanges(a)
  inv2 = toGRanges(b)
  
  png(sprintf("%s/%s~links.png", saveLocation, chr), width = 2048, height = 1272, bg = "transparent")#1536
  kp = plotKaryotype(genome = currGenome, plot.type = 1, main = chr, cytobands = blankRegion)
  kp = kpPlotLinks(kp, data=inv1, data2=inv2, col = "#647FA4", ymin=0.17, arch.height = 0.3)#, ymax=1 )
  dev.off()
}


##########
### plot combined
for(chr in chromosomes)
{

  ### setup
  currGenome = toGRanges(data.frame(chr=colnames(genomes), start=rep(1, length(plotOrder)), 
                                    end=genomes[chr,]))
  firstRun = TRUE
  for(currSyri in syriFiles$V1)
  {
    print(currSyri)
    currSyn = fread(sprintf("%s/%s/SYN_%s.out", syriDir, currSyri, chr))
    synRef = data.frame(unlist(strsplit(currSyri, "~"))[1], currSyn$V2, currSyn$V3, currSyn$V9, "stalk")
    synQuery = data.frame(unlist(strsplit(currSyri, "~"))[2], currSyn$V7, currSyn$V8, currSyn$V9, "stalk")
    colnames(synRef) = c("chr", "start", "end", "name", "gieStain")
    colnames(synQuery) = c("chr", "start", "end", "name", "gieStain")
    if(firstRun)
    {
      a = synRef
      b = synQuery
      firstRun = FALSE
    }
    else
    {
      a = rbind(a, synRef)
      b = rbind(b, synQuery)
    } 
  }
  synBands = toGRanges(rbind(a,b))
  inv1 = toGRanges(a)
  inv2 = toGRanges(b)
  
  png(sprintf("%s/%s~combine.png", saveLocation, chr), width = 2048, height = 1272)#1536
  kp = plotKaryotype(genome = currGenome)
  kp = kpPlotLinks(kp, data=inv1, data2=inv2, col = "#647FA4", ymin=0.17, arch.height = 0.3)#, ymax=1 )
  dev.off()
}

