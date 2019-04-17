# Extract node count and time elapsed data
# Natalie Cooper Apr 2019
# Input is .nex files in `data\trees` folder
# Outputs for 100 dated trees per tree
#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(tidyverse)
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
  
  # If there is > 1 tree then run on all 100 dated trees
  if(class(tree) == "multiPhylo"){
    
    for(j in 1:100){
      
      tree <- tree[[j]]
      
      # Get node counts
      create_node_counts(tree, path = "data/nodecounts/", 
                         tree.name = paste0("nodecount_", tree.list[k]))
    }
  }
  
  # Otherwise just get node counts
  create_node_counts(tree, path = "data/nodecounts/", 
                     tree.name = paste0("nodecount_", tree.list[k]))
}
