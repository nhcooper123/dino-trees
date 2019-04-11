# Extracting new trees
# Natalie Cooper Apr 2019
# Input is .phy file output from TNT

#--------------------------------------
# Load libraries
#--------------------------------------
library(paleotree)
library(tidyverse)
#--------------------------------------
# Dates
#--------------------------------------
# Read in dates 
dino_dates <- read_delim("data/trees_dates/Benson_dates.txt",
                         delim = "\t")
dino_dates <-
  dino_dates %>%
  select(Taxon, Max_age, Min_age) %>%
  group_by(Taxon) %>%
  summarise(max = max(Max_age),
            min = min(Min_age))
#--------------------------------------
# Trees
#--------------------------------------
  # Read in the tree
  tree1 <- read.tree("data/trees_TNT/Benson.phy")
  
  # If there is > 1 tree then select MPR tree
  if(class(tree1) == "multiPhylo"){
  tree1 <- tree1[[1]]
  }
  
  # Select species names in the tree
  tree_names <- data.frame(name = tree1$tip.label)
  tree_names$name <- as.character(tree_names$name)

  # Join species in tree to dates 
  dates <- left_join(tree_names, dino_dates, 
                     by = c("name" = "Taxon"))
  
  # Remove names column and add it to row names
  timeData <- dates[, 2:3]
  rownames(timeData) <- dates$name

  # Date the tree...
  tree_dated <- timePaleoPhy(tree1, timeData, type = "mbl", 
                             vartime = 1, ntrees = 100,
                             dateTreatment = "minMax", 
                             noisyDrop = TRUE, plot = TRUE)

  write.nexus(tree_dated, file = "data/trees2/Benson.nex")
