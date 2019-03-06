# Analysis - step 1
# Simulate trees and extract node counts
# Natalie Cooper Oct 2017, modified from Joe Bonsor summer 2017

# Load libraries and source functions
library(ape)
library(geiger)
source("functions/branch_in_period.R")
source("functions/break_branches_select_age.R")
source("functions/extract_clade_trees.R")
source("functions/make_trees.R")
source("functions/get_node_count.R")

# Read in phylogeny and taxonomy data
tree <- read.tree("data/trees/lloyd2008_midpoint.tre")
taxonomy <- read.csv("data/taxonomy.data.csv")

#--------------------------------------------------------------------
# For original tree
#--------------------------------------------------------------------
# Create clade tree and write to file
tree.list <- extract_clade_trees(tree, taxonomy, 
                                 species.col.name = "taxon", 
                                 clade.col.name = "clade")
# Write clade trees 
write.tree(phy = tree.list, 
           file = paste0("data/trees/lloyd2008_midpoint_clades.tre"), 
           tree.names = TRUE)

# Get node count for full tree
nodecount <- get_node_count(tree)
write.csv(nodecount, "data/nodecounts/nodecount_lloyd2008.csv")

# Loop through each clade  
for(j in 1:length(tree.list)){
  # Split multi phylo into one tree
  tree <- tree.list[[j]]
  # Get node counts
  create_node_counts(tree, path = "data/nodecounts/", 
                     simulation.name = paste0("nodecount_lloyd2008_", 
                                              names(tree.list[j])))
}

#--------------------------------------------------------------------
# For trees with added taxa
#--------------------------------------------------------------------
# Create list of numbers.to.add
# These are 1%, 5%, 10%, 25% and 50% additional taxa
# out of 420 in the Lloyd tree
numbers.to.add <- c(4, 21, 42, 105, 210)

# Create all the trees
# for(x in numbers.to.add){
# For no clear reason when this loop is added, the clade trees output only
# one clade. If you set x to 4, 21 etc in turn, the code below works...
  
  # Create 50 trees for each number of taxa added
  for(i in 1:50){ 
    
    create_new_trees(tree, number.to.add = x, 
                     min.branch.length = 5, 
                     youngest.date = 83.6, 
                     oldest.date = 100.5, 
                     path = "data/trees/", 
                     simulation.name = paste0("tree_", x, "_", i),
                     split.by.clade = TRUE, 
                     data = taxonomy, 
                     species.col.name = "taxon", 
                     clade.col.name = "clade")
  
    }
#}
 
#-------------------------------------------------------
# Node counts
#--------------------------------------------------------
# Get node counts for all full trees
for(x in numbers.to.add){
  
    # Create 50 for each number of taxa added
    for(i in 1:50){ 
    
    # Read in tree
    tree <- read.tree(paste0("data/trees/tree_", x, "_", i, ".tre"))
    # Get node counts
    create_node_counts(tree, 
                     path = "data/nodecounts/", 
                     simulation.name = paste0("nodecount_", x, "_", i))

  }
}  

# Get node counts for all clade trees
for(x in numbers.to.add){
  
  # Create 50 for each number of taxa added
  for(i in 1:50){ 
    
  # Read in multiphylo object
  tree.list <- read.tree(paste0("data/trees/tree_", x, "_", i, "_clades.tre"))
  
  # Loop through each clade  
  for(j in 1:length(tree.list)){
    # Split multi phylo into one tree
    tree <- tree.list[[j]]
    # Get node counts
    create_node_counts(tree, path = "data/nodecounts/", 
                       simulation.name = paste0("nodecount_", x , "_", 
                                               names(tree.list[j]), "_", i))
  
    }
  }
}