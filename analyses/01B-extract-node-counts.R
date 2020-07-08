# Extract node count and time elapsed data
# Natalie Cooper Apr 2019
# Input is .nex files in `data\trees` folder
# Outputs for 100 dated trees per tree
#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(tidyverse)
library(ape)
source("functions/get_node_count.R")
#--------------------------------------
# Extract node counts
#--------------------------------------
# Extract list of trees from folder
tree.list <- list.files("data/trees", pattern = ".nex")

# Get nodecounts for all trees
for(k in 1:length(tree.list)){
  
  # Read in tree
  tree <- read.nexus(paste0("data/trees/", tree.list[[k]]))
  
  # Run on all 100 dated trees
  for(j in 1:100){
      
      tree1 <- tree[[j]]
      
      # Get node counts
      create_node_counts(tree1, path = "data/nodecounts/", 
                         tree.name = paste0("nodecount_", tree.list[k], "_", j))
  }
}

#--------------------------------------
# Extract node counts for sakamoto trees
#--------------------------------------
# Extract list of trees from folder
tree.list <- list.files("data/trees_sakamoto", pattern = ".txt")

# Get nodecounts for all trees
for(k in 1:length(tree.list)){
  
  # Read in tree
  tree <- read.tree(paste0("data/trees_sakamoto/", tree.list[[k]]))

   # Get node counts
   create_node_counts(tree, path = "data/nodecounts/", 
                      tree.name = paste0("nodecount_", tree.list[k]))
}
