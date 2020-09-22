# Extract root ages
# Natalie Cooper Sept 2020

# Load libraries
library(ape)
library(tidyverse)
library(paleotree)

# Extract list of trees and dates from folder
tree.list <- list.files("data/trees_TNT", pattern = ".phy")
dates_files <- list.files("data/trees_dates", pattern = ".csv")

# Make blank output
output <- data.frame(tree = rep(NA, 900), age = rep(NA, 900))

# Start counter
tree.no <- 1

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
  
  for(j in 1:100){
    # Add tree name and age to output
    output$tree[tree.no] <- tree.list[i]
    output$age[tree.no] <- tree_dated[[j]]$root.time
  
    # Add to counter
    tree.no <- tree.no+1
  }
}  

# Save output
write_csv(output, path = "outputs/root-ages.csv")
