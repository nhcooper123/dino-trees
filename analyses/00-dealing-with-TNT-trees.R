# Extracting new trees
# Input is .tre file output from TNT
library(paleotree)

# Read in Matzke code for dealing with TNT outputs
source("functions/tnt_R_utils_v1.R")

# Read in the tree and select MPR tree
tree1 <- tntfile2R("data/trees_TNT/GonzalezRiga.tre")
tree1 <- tree1[[1]]

