# Date trees
# Natalie Cooper Apr 2019
# Input is .phy file output from TNT
# Outputs 100 dated trees per tree
#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(paleotree)
library(tidyverse)
#--------------------------------------
# Date trees
#--------------------------------------
# Extract list of trees and dates from folder
tree.list <- list.files("data/trees_TNT", pattern = ".phy")
dates_files <- list.files("data/trees_dates", pattern = ".csv")

for (i in 1:length(tree.list)){

  # Read in the tree and dates
  tree1 <- read.tree(paste0("data/trees_TNT/", tree.list[i]))
  dates1 <- read_csv(paste0("data/trees_dates/", dates_files[i]))
  
  # If there is > 1 tree then select first tree - 
  # this can be an error with TNT which outputs two consensus trees for no reason
  if(class(tree1) == "multiPhylo"){
    tree1 <- tree1[[1]]
  }
  
  # Remove names column and add it to row names
  timeData <- dates1[, 2:3]
  rownames(timeData) <- dates1$name

  # Date the tree...
  tree_dated <- timePaleoPhy(tree1, timeData, type = "mbl", 
                             vartime = 1, ntrees = 100,
                             dateTreatment = "minMax", 
                             noisyDrop = TRUE, plot = FALSE)

  write.nexus(tree_dated, file = paste0("data/trees/", tree.list[i], ".nex"))
              
}
