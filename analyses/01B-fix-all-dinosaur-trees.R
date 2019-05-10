# Sort the Benson and Lloyd trees
# Natalie Cooper Apr 2019
# i.e. root, split into clades, output
# Output 100 dated trees * all clades
#--------------------------------------
# Load libraries and functions
#--------------------------------------
library(paleotree)
library(tidyverse)
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
                                  "Diodorus_scytobrachion"), resolve.root = TRUE)

benson2 <- root(benson2, outgroup = c("Lagerpeton_chanarensis", "Dromomeron_gregorii", "Dromomeron_romeri",
                                    "Marasuchus_lilloensis", "Lewisuchus_admixtus", "Asilisaurus_kongwe",
                                    "Eucoelophysis_baldwini", "Silesaurus_opolensis", "Sacisaurus_agudoensis",
                                    "Diodorus_scytobrachion"), resolve.root = TRUE)

# Remove node labels
benson1$node.label <- NULL
benson2$node.label <- NULL
  
# Read in the dates
dates1 <- read_csv("data/trees_dates/dates_Benson.csv")
    
# Remove names column and add it to row names
timeData <- dates1[, 2:3]
rownames(timeData) <- dates1$name
  
# Date the trees...
tree_dated1 <- timePaleoPhy(benson1, timeData, type = "mbl", 
                           vartime = 1, ntrees = 100,
                           dateTreatment = "minMax", 
                           noisyDrop = TRUE, plot = FALSE)

tree_dated2 <- timePaleoPhy(benson1, timeData, type = "mbl", 
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
taxonomy <- read_csv("data/dino-taxonomy.csv")
clades1 <- c("Ornithischia", "Sauropodomorpha", "Theropoda")
clades2 <- c("Ceratopsidae", "Hadrosauriformes")

# Benson tree 1
# Loop through 100 trees
for(j in 1:100){
  tree <- tree_dated1[[j]]

  for(i in 1:3){
    to_drop <- filter(taxonomy, clade != clades1[i])
    species_drop <- pull(to_drop, taxon)  
    clade_tree <- drop.tip(tree, species_drop)
    
    # Root trees that are not rooted
    if(clades1[i] == "Sauropodomorpha"){
      clade_tree <- root(clade_tree, outgroup = c("Pampdromaeus"), resolve.root = TRUE)
    }
    
    if(clades1[i] == "Ornithischia"){
      clade_tree <- root(clade_tree, outgroup = c("Pisanosaurus_mertii"), resolve.root = TRUE)
    }
  
    # Write clade trees to file
    write.nexus(phy = clade_tree, 
                file = paste0("data/trees/Benson1_", clades1[i], "_", j, ".nex"))
  }
}

# Small clades
for(j in 1:100){
  tree <- tree_dated1[[j]]
  
  for(i in 1:2){
    to_drop <- filter(taxonomy, clade2 != clades2[i] | is.na(clade2))
    species_drop <- pull(to_drop, taxon)  
    clade_tree <- drop.tip(tree, species_drop)
    
    # Write clade trees to file
    write.nexus(phy = clade_tree, 
                file = paste0("data/trees/Benson1_", clades2[i], "_", j, ".nex"))
  }
}

# Benson tree 2
# Loop through 100 trees
for(j in 1:100){
  tree <- tree_dated2[[j]]
  
  for(i in 1:3){
    to_drop <- filter(taxonomy, clade != clades1[i])
    species_drop <- pull(to_drop, taxon)  
    clade_tree <- drop.tip(tree, species_drop)
    
    # Root trees that are not rooted
    if(clades1[i] == "Sauropodomorpha"){
      clade_tree <- root(clade_tree, outgroup = c("Pampdromaeus"), resolve.root = TRUE)
    }
    
    if(clades1[i] == "Ornithischia"){
      clade_tree <- root(clade_tree, outgroup = c("Pisanosaurus_mertii"), resolve.root = TRUE)
    }
    
    # Write clade trees to file
    write.nexus(phy = clade_tree, 
                file = paste0("data/trees/Benson2_", clades1[i], "_", j, ".nex"))
  }
}

# Small clades
for(j in 1:100){
  tree <- tree_dated2[[j]]
  
  for(i in 1:2){
    to_drop <- filter(taxonomy, clade2 != clades2[i] | is.na(clade2))
    species_drop <- pull(to_drop, taxon)  
    clade_tree <- drop.tip(tree, species_drop)
    
    # Write clade trees to file
    write.nexus(phy = clade_tree, 
                file = paste0("data/trees/Benson2_", clades2[i], "_", j, ".nex"))
  }
}

#------------------
# Lloyd trees
#------------------
# Read in phylogeny
tree <- read.nexus("data/trees/Lloyd.nex")

for(i in 1:3){
  to_drop <- filter(taxonomy, clade != clades1[i])
  species_drop <- pull(to_drop, taxon)  
  clade_tree <- drop.tip(tree, species_drop)
    
  # Write clade trees to file
  write.nexus(phy = clade_tree, 
              file = paste0("data/trees/Lloyd_", clades1[i], ".nex"))
  }

# Small clades
for(i in 1:2){
  to_drop <- filter(taxonomy, clade2 != clades2[i] | is.na(clade2))
  species_drop <- pull(to_drop, taxon)  
  clade_tree <- drop.tip(tree, species_drop)
    
  # Write clade trees to file
  write.nexus(phy = clade_tree, 
              file = paste0("data/trees/Lloyd_", clades2[i], ".nex"))
  }