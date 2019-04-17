# Sort the Benson and Lloyd trees
# Natalie Cooper Apr 2019
# i.e. root, split into clades, output
# Output 100 dated trees * all clades
#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(paleotree)
library(tidyverse)
source("functions/extract_clade_trees.R")
#--------------------------------------
# Benson trees
#------------------
# Read in phylogeny
benson <- read.tree("data/trees_TNT/Benson.phy")
benson1 <- benson[[1]]
benson2 <- benson[[2]]

# Root the trees on Dinosauromorpha
benson1 <- root(benson1, outgroup = c("Lagerpeton_chanarensis", "Dromomeron_gregorii", "Dromomeron_romeri",
                                  "Marasuchus_lilloensis", "Lewisuchus_admixtus", "Asilisaurus_kongwe",
                                  "Eucoelophysis_baldwini", "Silesaurus_opolensis", "Sacisaurus_agudoensis",
                                  "Diodorus_scytobrachion"))

benson2 <- root(benson2, outgroup = c("Lagerpeton_chanarensis", "Dromomeron_gregorii", "Dromomeron_romeri",
                                    "Marasuchus_lilloensis", "Lewisuchus_admixtus", "Asilisaurus_kongwe",
                                    "Eucoelophysis_baldwini", "Silesaurus_opolensis", "Sacisaurus_agudoensis",
                                    "Diodorus_scytobrachion"))

# Remove node labels
benson1$node.label <- NULL
benson2$node.label <- NULL
  
# Read in the dates
dates1 <- read_csv("data/trees_dates/dates_Benson.csv")
    
# Remove names column and add it to row names
timeData <- dates1[, 2:3]
rownames(timeData) <- dates1$name
  
# Date the trees...
tree_dated1 <- timePaleoPhy(tree1, timeData, type = "mbl", 
                           vartime = 1, ntrees = 100,
                           dateTreatment = "minMax", 
                           noisyDrop = TRUE, plot = FALSE)

tree_dated2 <- timePaleoPhy(tree1, timeData, type = "mbl", 
                           vartime = 1, ntrees = 100,
                           dateTreatment = "minMax", 
                           noisyDrop = TRUE, plot = FALSE)
  
# Save the outputs
write.nexus(tree_dated1, file = "data/trees/Benson1.nex")
write.nexus(tree_dated2, file = "data/trees/Benson2.nex")

#--------------------------------------------------------------------
# Extract clade trees for the whole dinosaur trees
#--------------------------------------------------------------------
# Read in taxonomy
taxonomy <- read.csv("data/dino-taxonomy.csv")
clades1 <- c("Ceratopsidae", "Dinosauromorpha", "Hadrosauriformes", "Ornithischia", "Sauropodomorpha", "Theropoda")
clades2 <- c("Ceratopsidae", "Hadrosauriformes", "Ornithischia", "Sauropodomorpha", "Theropoda")

# Split into clades for each of the 100 dated trees
for (i in 1:100) {
  # Create clade tree and write to file
  # Note 10 species = early dinosaurs that do not fit into any of the three clades
  clade.list <- extract_clade_trees(tree_dated1[[i]], taxonomy, 
                                  species.col.name = "taxon", 
                                  clade.col.name = "clade")

  # Root trees that are not rooted
  clade.list[["Sauropodomorpha"]] <- root(clade.list[["Sauropodomorpha"]], outgroup = c("Pampdromaeus"))
  clade.list[["Ornithischia"]] <- root(clade.list[["Ornithischia"]], outgroup = c("Pisanosaurus_mertii"))
  
  # Write clade trees 
  for (j in 2:4){
    write.nexus(phy = clade.list[[j]], 
                file = paste0("data/trees/Benson_", clades1[j], "_", i, ".nex"))
  }
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
