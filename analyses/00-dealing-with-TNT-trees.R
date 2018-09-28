# Extracting new trees
# Input is .tre file output from TNT
library(paleotree)
library(BioGeoBEARS)
library(tidyverse)

# Read in Matzke code for dealing with TNT outputs
source("functions/tnt_R_utils_v1.R")

# Read in the tree and select MPR tree
tree1 <- tntfile2R("data/trees_TNT/GonzalezRiga.tre")
tree1 <- tree1[[1]]
tree_names <- data.frame(names = tree1$tip.label)

# Read in PBDB dates 
sauro_pbdb <- read_csv("data/trees_TNT/sauropod-dates-PBDB.csv")

# Split up names column so they can be matched
# select just Genus and date columns
# merge with tree names
sauro_dates <- sauro_pbdb %>%
  mutate(split.names = accepted_name) %>%
  separate(split.names, sep = " ", c("Genus", "species")) %>%
  select(Genus, max_ma, min_ma)
  
# Create dates dataset
dates <- left_join(tree_names, sauro_dates, 
                   by = c("names" = "Genus"))

# Select jsut first occassion
# This requires finessing in final analyses
dates2 <- dates[!duplicated(dates$names), ]

