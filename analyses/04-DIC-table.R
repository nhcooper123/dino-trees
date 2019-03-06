# Summarising the results
# Making tables for DIC values

# Load libraries
library(tidyverse)
library(xtable)

# Load the data
ds <- read.csv("outputs/mcmcglmm_outputs.csv")
dsi <- read.csv("outputs/mcmcglmm_outputs_intercepts.csv")

# Group by clade and tree then get mean DIC values
# across 50 replicates
dic <- 
  ds %>%
  group_by(treeID, clade) %>%
  select(1:2, 4:6) %>% 
  summarise(meannull = median(null_DIC),
            meanslow = median(slow_DIC),
            meanasym = median(asym_DIC))

dici <- 
  dsi %>%
  group_by(treeID, clade) %>%
  select(1:2, 4:6) %>% 
  summarise(meannull = median(null_DIC),
            meanslow = median(slow_DIC),
            meanasym = median(asym_DIC))

# Create tidy names for number of taxa added
# and clade names
  taxa <- c(rep("-", 4),
            rep("1%", 4), 
            rep("5%", 4),
            rep("10%", 4),
            rep("25%", 4), 
            rep("50%", 4))
  
  clade <- rep(c("all", "ornithischians", 
                 "sauropods", "theropods"), 6)
            
# Formatting the tables
table_out <- data.frame(taxa, clade, dic[, 3:5])
colnames(table_out) <- c("% taxa added", "clade", "null DIC",
                         "slowdown DIC", "asymptote DIC")

table_outi <- data.frame(taxa, clade, dici[, 3:5])
colnames(table_outi) <- c("% taxa added", "clade", "null DIC",
                         "slowdown DIC", "asymptote DIC")
  
# Save tables as .tex files
sink(file = "outputs/dic_table.tex")
xtable(table_out, caption = "")
sink()

sink(file = "outputs/dic_table_intercepts.tex")
xtable(table_outi, caption = "")
sink()

# Will need to add caption and bold the lowest values manually