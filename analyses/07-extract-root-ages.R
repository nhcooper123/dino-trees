# Extract root ages
# Natalie Cooper Sept 2020

# Load libraries
library(ape)
library(tidyverse)

# List trees
tree.list <- list.files("data/trees", pattern = ".nex")

# Make blank output
output <- data.frame(tree = rep(NA, 900), age = rep(NA, 900))

# Start counter
tree.no <- 1
# Loop through trees and output root ages
for(i in 1:length(tree.list)){
  
  # Read in trees
  tree <- read.nexus(paste0("data/trees/", tree.list[[i]]))
  
  # Run on all 100 dated trees
  for(j in 1:100){
    tree1 <- tree[[j]]
    
    # Add tree name and age to output
    output$tree[tree.no] <- tree.list[i]
    output$age[tree.no] <- max(branching.times(tree1))
   
     # Add to counter
    tree.no <- tree.no+1
  }
}    

# Save output
write_csv(output, path = "outputs/root-ages.csv")
