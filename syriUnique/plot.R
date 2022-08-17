library(reshape2)
library(ggplot2)

setwd("/home/scott/Documents/writing/all-eucs2/")
countsEucs = read.csv("data/syri-unique/all.csv") # all species
countsAds = read.csv("data/syri-unique/adnataria.csv") # adnataria species

##########
### stats
summary(countsEucs$PC)
summary(countsAds$PC)

s1 = sprintf("countsEucs all,%f,%f,%f",min(countsEucs$PC[countsEucs$type == "all"]),
             mean(countsEucs$PC[countsEucs$type == "all"]),
             max(countsEucs$PC[countsEucs$type == "all"]))
s2 = sprintf("countsEucs unique,%f,%f,%f",min(countsEucs$PC[countsEucs$type == "unique"]),
             mean(countsEucs$PC[countsEucs$type == "unique"]),
             max(countsEucs$PC[countsEucs$type == "unique"]))
s3 = sprintf("countsAds all,%f,%f,%f",min(countsAds$PC[countsAds$type == "all"]),
             mean(countsAds$PC[countsAds$type == "all"]),
             max(countsAds$PC[countsAds$type == "all"]))
s4 = sprintf("countsAds unique,%f,%f,%f",min(countsAds$PC[countsAds$type == "unique"]),
             mean(countsAds$PC[countsAds$type == "unique"]),
             max(countsAds$PC[countsAds$type == "unique"]))
# print stats
print("min,mean,max")
print(sprintf("%s\n%s\n%s\n%s",s1,s2,s3,s4))


##########
### order plots
countsEucs$species = factor(countsEucs$species, levels = c("E_erythrocorys", "E_tenuipes", "E_curtisii", "E_cloeziana", "E_marginata", "mislabeled",
                                                           "E_pauciflora", "E_regnans", "E_microcorys", "E_guilfoylei", "E_pumila", "E_camaldulensis",
                                                           "E_grandis", "E_globulus", "E_viminalis", "E_decipiens", "E_virginea", "E_brandiana",
                                                           "E_cladocalyx", "E_leucophloia", "E_victrix", "E_coolabah", "E_shirleyi", "E_paniculata",
                                                           "E_fibrosa", "E_caleyi", "E_polyanthemos", "E_dawsonii", "E_lansdowneana", "E_albens",
                                                           "E_melliodora", "E_sideroxylon", "E_melliodora_x_E_sideroxylon"))

countsAds$species = factor(countsAds$species, levels = c("E_victrix", "E_coolabah", "E_shirleyi", "E_paniculata", "E_fibrosa", "E_caleyi",
                                                         "E_polyanthemos", "E_dawsonii", "E_lansdowneana", "E_albens", "E_melliodora", "E_sideroxylon",
                                                         "E_melliodora_x_E_sideroxylon"))
##########
### Plots
maxPC = max(c(max(countsAds$PC), max(countsEucs$PC)))

# only want

p1 = ggplot(countsEucs, aes(x = species, y = PC, fill = type))+
  theme_minimal() + scale_y_continuous(labels = scales::percent, limits= c(0, max(countsEucs$PC)+.01)) +
  geom_bar(position="dodge", stat="identity") +
  xlab("species") +
  ylab("Percent") +
  ggtitle("Proportion of sequence unique to a given species or shared among all species") +
  theme(axis.text.x = element_text(face = "bold", color = "black", 
                                   size = 10, angle = 45),
        axis.text.y = element_text(face = "bold", color = "black", 
                                   size = 14, angle = 0),
        legend.text = element_text(face = "bold", color = "black", 
                                   size = 16, angle = 0)) +
  scale_fill_brewer(palette="Dark2")

p2 = ggplot(countsAds, aes(x = species, y = PC, fill = type))+ theme_minimal()+
  scale_y_continuous(labels = scales::percent, limits= c(0, maxPC)) +
  geom_bar(position="dodge", stat="identity") +
  xlab("species") +
  ylab("Percent") +
  ggtitle("Proportion of sequence unique to a given species or shared among all species") +
  theme(axis.text.x = element_text(face = "bold", color = "black", 
                                   size = 18, angle = 45),
        axis.text.y = element_text(face = "bold", color = "black", 
                                   size = 24, angle = 0)) +
          scale_fill_brewer(palette="Dark2")

png("plots/syri-unique-eucs.png", width = 1333, height = 1000)
print(p1)
dev.off()

png("plots/syri-unique-adnataria.png", width = 1333, height = 1000)
print(p2)
dev.off()
