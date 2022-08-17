library(ggplot2)
library(data.table)
library(ggthemes)
library(gridExtra)
library(viridis)

setwd("/home/scott/Documents/writing/all-eucs2/")
dfAll = fread("data/syri-eventStats/overall/200.csv")  # 200-noInv.csv")
saveLocation = "plots/eventCounts-200-NoInv"
dir.create(saveLocation)

dfAll$type[dfAll$type == "DUP"] = "Duplication"
dfAll$type[dfAll$type == "INV"] = "Inversion"
#dfAll$type[dfAll$type == "INVDP"] = "Inverted duplication"
#dfAll$type[dfAll$type == "INVTR"] = "Inverted translocation"
dfAll$type[dfAll$type == "SYN"] = "Syntenic"
dfAll$type[dfAll$type == "TRANS"] = "Translocation"
dfAll$type[dfAll$type == "NOTAL"] = "Not-aligned"
dfAll$type[dfAll$type == "SR"] = "Rearrangement"
names(dfAll)[names(dfAll) == 'reference'] = "Genome"
dfAll$type = factor(dfAll$type, levels = c("Syntenic", "Not-aligned", "Rearrangement", "Duplication", "Inversion", "Translocation"))

##########
# display event sizes

eb = data.frame(min = dfAll$meanLength, max = dfAll$meanLength+dfAll$sdLength) # error bars

p = ggplot(dfAll, aes(x = type, y = meanLength, fill = Genome)) +
  geom_bar(stat="identity", color="black", position = "dodge", width = .7) +
  geom_errorbar(aes(ymin=eb$min, ymax=eb$max), width=.3, position = position_dodge(0.7)) +
  scale_colour_brewer(type = "seq", palette = "Spectral") +
  scale_y_continuous(trans = "log10", limits = c(1, max(eb$max)+ 10), labels = scales::comma_format(accuracy = 1)) +
  theme_minimal() +
  theme(text = element_text(size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold", color = "black"),
        legend.text = element_text(face = "bold.italic"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(size=.5, color="black"),
        panel.grid.minor.y = element_line(size=.1, color="black"),
        legend.position = c(0.35, 0.88)) + 
  ggtitle("Average event length") + ylab("Length (bp)") + xlab("Event type")

png(sprintf("%s/eventLengths.png", saveLocation), width = 1600, height = 1200)
print(p)
dev.off()


##########
# display counts

eb = data.frame(min = dfAll$meanCount, max = dfAll$maxCount)

p = ggplot(dfAll, aes(x = type, y = meanCount, fill = Genome)) +
  geom_bar(stat="identity", color="black", position = "dodge", width = .7) +
  geom_errorbar(aes(ymin=eb$min, ymax=eb$max), width=.3, position = position_dodge(0.7)) +
  scale_colour_brewer(type = "seq", palette = "Spectral") +
  scale_y_continuous(trans = "log10", limits = c(1, max(eb$max)+ 10), labels = scales::comma_format(accuracy = 1)) +
  theme_minimal() +
  theme(text = element_text(size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold", color = "black"),
        legend.text = element_text(face = "bold.italic"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(size=.5, color="black"),
        panel.grid.minor.y = element_line(size=.1, color="black"),
        legend.position = c(0.75, 0.88)) + 
  ggtitle("Average number of events per comparison") + ylab("Count") + xlab("Event type")
png(sprintf("%s/eventCounts.png", saveLocation), width = 1600, height = 1200)
print(p)
dev.off()


##########
# display percents
dfAll = dfAll[dfAll$maxPC < 1]
eb = data.frame(min = dfAll$meanPC, max = dfAll$maxPC)

p = ggplot(dfAll, aes(x = type, y = meanPC, fill = Genome)) +
  geom_bar(stat="identity", color="black", position = "dodge", width = .7) +
  geom_errorbar(aes(ymin=eb$min, ymax=eb$max), width=.3, position = position_dodge(0.7)) +
  scale_colour_brewer(type = "seq", palette = "Spectral") +
    scale_y_continuous(limits = c(0, max(dfAll$maxPC)+ .05), labels = scales::percent_format(accuracy=1)) +
  theme_minimal() +
  theme(text = element_text(size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold", color = "black"),
        legend.text = element_text(face = "bold.italic"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(size=.5, color="black"),
        panel.grid.minor.y = element_line(size=.1, color="black"),
        legend.position = c(0.85, 0.88)) + 
  ggtitle("Average percent of geneome within event type") + ylab("Count") + xlab("Event type")
png(sprintf("%s/eventPC.png", saveLocation), width = 1600, height = 1200)
print(p)
dev.off()
