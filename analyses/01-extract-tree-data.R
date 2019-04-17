# Date trees, split whole dinosaur trees and extract node counts
# Natalie Cooper Apr 2019
# Input is .phy file output from TNT except for Lloyd where tree was already dated

#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(paleotree)
library(tidyverse)
library(geiger)
source("functions/extract_clade_trees.R")
source("functions/get_node_count.R")
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
  
  # If there is > 1 tree then select MPR tree
  if(class(tree1) == "multiPhylo"){
    tree1 <- tree1[[1]]
  }
  
  if(is.rooted(tree1) == FALSE){
    tree <- root(tree, outgroup = c("Lagerpeton_chanarensis", "Dromomeron_gregorii", "Dromomeron_romeri",
                                    "Marasuchus_lilloensis", "Lewisuchus_admixtus", "Asilisaurus_kongwe",
                                    "Eucoelophysis_baldwini", "Silesaurus_opolensis", "Sacisaurus_agudoensis",
                                    "Diodorus_scytobrachion"))
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

#--------------------------------------------------------------------
# Extract clade trees for the whole dinosaur trees
#--------------------------------------------------------------------
# Read in taxonomy
taxonomy <- read.csv("data/dino-taxonomy.csv")
clades1 <- c("Dinosauromorpha", "Ornithischia", "Sauropodomorpha", "Theropoda")
clades2 <- c("Ornithischia", "Sauropodomorpha", "Theropoda")
#------------------
# Benson trees
#------------------
# Read in phylogeny
benson <- read.nexus("data/trees/Benson.phy.nex")
benson <- benson[[57]]

# Create clade tree and write to file
# Note 10 species = early dinosaurs that do not fit into any of the three clades
clade.list <- extract_clade_trees(benson, taxonomy, 
                                 species.col.name = "taxon", 
                                 clade.col.name = "clade")
# Write clade trees 
for (j in 2:4){
write.nexus(phy = clade.list[[j]], 
           file = paste0("data/trees/Benson_", clades1[j], ".nex"))
}

#------------------
# Lloyd trees
#------------------
# Read in phylogeny
lloyd <- read.nexus("data/trees/Lloyd.nex")

# Create clade tree and write to file
clade.list <- extract_clade_trees(lloyd, taxonomy, 
                                 species.col.name = "taxon", 
                                 clade.col.name = "clade")
# Write clade trees 
for (j in 1:3){
  write.nexus(phy = clade.list[[j]], 
              file = paste0("data/trees/Lloyd_", clades2[j], ".nex"))
}

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
                       tree.name = paste0("nodecount_", tree.list[k], "_", j))
    }
  }
  # Otherwise just get node counts
  create_node_counts(tree, path = "data/nodecounts/", 
                     tree.name = paste0("nodecount_", tree.list[k]))
}
