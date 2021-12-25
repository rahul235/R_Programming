library(rattle)   
library(magrittr) 

building <- TRUE
scoring  <- ! building

seed <- 42

fname <- "file:////vmware-host/Shared Folders/Desktop/dataset_saved.csv" 

dataset <- read.csv(fname,
			na.strings=c(".", "NA", "", "?"),
			strip.white=TRUE, encoding="UTF-8")


library(gplots, quietly=TRUE)

#ds <- rbind(summary(na.omit(dataset[,]$Onboarded)),
#    summary(na.omit(dataset[,][dataset$Survived=="0",]$Onboarded)),
#    summary(na.omit(dataset[,][dataset$Survived=="1",]$Onboarded)))

ds <- table(dataset$Onboarded, dataset$Survived)
ds

#BarPlot
bp <-  barplot2(ds, beside=TRUE, ylab="Frequency", xlab="Survived", col=colorspace::rainbow_hcl(3))
text(bp, 0, round(ds, 1),cex=1,pos=3) 
legend("topright", bty="n", c("Q","C","S"),  fill=colorspace::rainbow_hcl(3))
title(main="Distribution of Onboarded\nby Survived",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

#Mosiac Plot
ds <- table(dataset$Gender, dataset$Survived)
ds
ord <- order(apply(ds, 1, sum), decreasing=TRUE)
mosaicplot(ds[ord,], main="Mosaic of Gender
by Survived", sub="Rattle 2021-Mar-23 15:34:08 Kumar Rahul", color=colorspace::rainbow_hcl(3)[-1], cex=0.7, xlab="Gender", ylab="Survived")
