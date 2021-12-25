#=======================================================================

# Rattle is Copyright (c) 2006-2020 Togaware Pty Ltd.
# It is free (as in libre) open source software.
# It is licensed under the GNU General Public License,
# Version 2. Rattle comes with ABSOLUTELY NO WARRANTY.
# Rattle was written by Graham Williams with contributions
# from others as acknowledged in 'library(help=rattle)'.
# Visit https://rattle.togaware.com/ for details.

#=======================================================================
# Rattle timestamp: 2021-03-23 13:15:55 x86_64-w64-mingw32 

# Rattle version 5.4.0 user 'Kumar Rahul'

# This log captures interactions with Rattle as an R script. 

# For repeatability, export this activity log to a 
# file, like 'model.R' using the Export button or 
# through the Tools menu. Th script can then serve as a 
# starting point for developing your own scripts. 
# After xporting to a file called 'model.R', for exmample, 
# you can type into a new R Console the command 
# "source('model.R')" and so repeat all actions. Generally, 
# you will want to edit the file to suit your own needs. 
# You can also edit this log in place to record additional 
# information before exporting the script. 
 
# Note that saving/loading projects retains this log.

# We begin most scripts by loading the required packages.
# Here are some initial packages to load and others will be
# identified as we proceed through the script. When writing
# our own scripts we often collect together the library
# commands at the beginning of the script here.

library(rattle)   # Access the weather dataset and utilities.
library(magrittr) # Utilise %>% and %<>% pipeline operators.

# This log generally records the process of building a model. 
# However, with very little effort the log can also be used 
# to score a new dataset. The logical variable 'building' 
# is used to toggle between generating transformations, 
# when building a model and using the transformations, 
# when scoring a dataset.

building <- TRUE
scoring  <- ! building

# A pre-defined value is used to reset the random seed 
# so that results are repeatable.

seed <- 42 

fname         <- "file:////vmware-host/Shared Folders/Desktop/dataset_saved.csv" 
dataset <- read.csv(fname,
			na.strings=c(".", "NA", "", "?"),
			strip.white=TRUE, encoding="UTF-8")

#=======================================================================
# Rattle timestamp: 2021-03-23 14:52:12 x86_64-w64-mingw32 

# Remap variables. 

# Transform into a factor.

  dataset[["TFC_Survived"]] <- as.factor(dataset[["Survived"]])

  ol <- levels(dataset[["TFC_Survived"]])
  lol <- length(ol)
  nl <- c(sprintf("[%s,%s]", ol[1], ol[1]), sprintf("(%s,%s]", ol[-lol], ol[-1]))
  levels(dataset[["TFC_Survived"]]) <- nl


#=======================================================================
# Rattle timestamp: 2021-03-23 14:53:56 x86_64-w64-mingw32 

# Action the user selections from the Data tab. 

# The following variable selections have been noted.

input     <- c("Pclass", "Gender", "Age", "SibSp", "Parch",
                   "Cabin", "Onboarded", "TFC_Survived")

numeric   <- c("Pclass", "Age", "SibSp", "Parch")

categoric <- c("Gender", "Cabin", "Onboarded", "TFC_Survived")

target    <- "Survived"
risk      <- NULL
ident     <- NULL
ignore    <- c("PassengerId", "Name", "Ticket", "Fare")
weights   <- NULL

#=======================================================================
# Rattle timestamp: 2021-03-23 14:54:07 x86_64-w64-mingw32 

# The 'CrossTable' package provides the 'descr' function.

library(descr, quietly=TRUE)

# Generate cross tabulations for categoric data.

for (i in c(5,12)) 
{ 
  cat(sprintf('CrossTab of %s by target variable %s\n\n', names(dataset)[i], target)) 
  print(CrossTable(dataset[[i]], dataset[[target]], expected=TRUE, format='SAS')) 
  cat(paste(rep('=', 70), collapse=''), '

') 
}

#=======================================================================
# Rattle timestamp: 2021-03-23 14:56:50 x86_64-w64-mingw32 

# The 'gplots' package provides the 'barplot2' function.

library(gplots, quietly=TRUE)

#=======================================================================
# Rattle timestamp: 2021-03-23 14:56:50 x86_64-w64-mingw32 

# Bar Plot 

# Generate the summary data for plotting.

#ds <- rbind(summary(na.omit(dataset[train,]$Gender)),
#    summary(na.omit(dataset[train,][dataset[train,]$Survived=="0",]$Gender)),
#    summary(na.omit(dataset[train,][dataset[train,]$Survived=="1",]$Gender)))

ds <- table(dataset$Gender, dataset$Survived)
ds

# Plot the data.

bp <-  barplot2(ds, beside=TRUE, ylab="Frequency", xlab="Gender", ylim=c(0, 484), col=colorspace::rainbow_hcl(2))

# Add the actual frequencies.

text(bp, 0, round(ds, 1),cex=1,pos=3) 

# Add a legend to the plot.

legend("topright", bty="n", c("male","female"),  fill=colorspace::rainbow_hcl(2))

# Add a title to the plot.

title(main="Distribution of Gender (sample)\nby Survived",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

