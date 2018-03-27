# BL5233: Tutorial 8

# Exercise A. We are interested in the yield of 56 different varieties of wheat distributed
# across the world. The farms where the yield analysis were performed are located at 
# different latitudes and longitudes with some nearer to others, perhaps creating problems
# of spatial correlation. In addition, the plots where the experiments were carried out 
# were nested within blocks, perhaps also violating the assumption of independence.

# 1. Load package nlme. Read dataset “spatialdata” into R. Explore the names of the variables.

setwd("/Users/dondealban/Desktop/BL5233/Datasets/")
library(nlme)
data <- read.table(file="spatialdata.txt", header=TRUE, sep="\t")
names(data)

# 2. Develop a two sub-plot graph to explore the effects of latitude and longitude on yield.

model0 <- gls(yield~Block, data=data)
plot(Variogram(model0, form=~data$latitude + data$longitude))

# 3. Develop a barplot to study the difference in mean yield among wheat varieties. Also 
# the mean yield per block.

library(ggplot2)

yieldvars <- aggregate(data[,3], list(data$variety), mean)
colnames(yieldvars) <- c("Variety","MeanYield")
p1 <- ggplot() + geom_bar(aes(y=MeanYield, x=Variety), data=yieldvars, stat="identity")
p1 <- p1 + theme(axis.text.x = element_text(angle=90, hjust=1))

yieldblock <- aggregate(data[,3], list(data$Block), mean)
colnames(yieldblock) <- c("Block","MeanYield")
p2 <- ggplot() + geom_bar(aes(y=MeanYield, x=Block), data=yieldblock, stat="identity")

# 4. Fit a GLS model ignoring spatial correlation and nestedness. Then fit a mixed-effects
# model that accounts for nestedness within block. Compare the models to see if accounting
# for nestedness is necessary.
