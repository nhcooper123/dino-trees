# Extracting new trees
# Input is .tre file output from TNT
library(paleotree)
library(BioGeoBEARS)
library(tidyverse)

# Read in Nick Matzke's code for dealing with TNT outputs
source("functions/tnt_R_utils_v1.R")

# Read in PBDB dates 
dino_pbdb <- read_csv("data/trees_TNT/dino-dates-PBDB.csv")

# Split up names column so they can be matched
# select just Genus and date columns
dino_dates <- dino_pbdb %>%
  mutate(split.names = accepted_name) %>%
  separate(split.names, sep = " ", c("Genus", "species")) %>%
  unite(binomial, Genus, species, sep = "_", remove = FALSE) %>%
  select(binomial, Genus, max_ma, min_ma) %>%
  gather(taxon, binomial:Genus, -min_ma, -max_ma) %>%
  rename(name = `binomial:Genus`)

# Extract list of trees from folder
tree.list <- list.files("data/trees_TNT")[str_which(list.files("data/trees_TNT"), 
                                                    pattern = ".tre")]

for (i in 1:length(tree.list)){

  # Read in the tree and select MPR tree
  tree1 <- tntfile2R(paste0("data/trees_TNT/", tree.list[i]))
  tree1 <- tree1[[1]]
  tree_names <- data.frame(names = tree1$tip.label)

  # Create dates dataset
  dates <- left_join(tree_names, dino_dates, 
                   by = c("names" = "name"))

  # Select just first occassion
  # This requires finessing in final analyses
  dates2 <- dates[!duplicated(dates$names), ]

  # Remove names column and add it to row names
  timeData <- dates2[, 2:3]
  rownames(timeData) <- dates2$names

  # Date the tree...
  tree_dated <- timePaleoPhy(tree1, timeData, type = "mbl", 
                             vartime = 1, ntrees = 100,
                             dateTreatment = "minMax", 
                             noisyDrop = TRUE, plot = TRUE)

  write.nexus(tree_dated, file = paste0("data/trees/", tree.list[i], ".nex"))
              
}
