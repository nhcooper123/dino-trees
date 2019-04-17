# Summarising the results
# Making tables for DIC values

# Load libraries
library(tidyverse)
library(xtable)
source("functions/run_mcmcglmm.R")

# Load the data
ds <- read.csv("outputs/mcmcglmm_outputs.csv")
dsi <- read.csv("outputs/mcmcglmm_outputs_intercepts.csv")

# Create tidy names for trees
# and clade names
  tree <- c("Arbour", 
            rep("Benson et al", 4), "Carbadillo et al", "Cau et al",
            "Chiba et al", "Cruzado et al", "Gonzalez Riga et al",
            rep("Lloyd et al", 4), 
            "Mallon et al", "Raven & Maidment", "Thompson et al")
  
  clade <- c("Ornithischia",
             "Ornithischia", "Sauropoda", "Theropoda", "All", 
             "Sauropoda",
             "Theropoda",
             "Ornithischia",
             "Ornithischia",
             "Sauropoda",
             "Ornithischia", "Sauropoda", "Theropoda", "All",
             "Ornithischia",
             "Ornithischia",
             "Ornithischia")
            
# Formatting the tables
table_out <- data.frame(tree, clade, ds[, 3:5])
colnames(table_out) <- c("tree", "clade", "null DIC",
                         "slowdown DIC", "asymptote DIC")

table_outi <- data.frame(tree, clade, dsi[, 3:5])
colnames(table_outi) <- c("tree", "clade", "null DIC",
                         "slowdown DIC", "asymptote DIC")
  
# Save tables as .tex files
sink(file = "outputs/dic_table.tex")
xtable(table_out, caption = "")
sink()

sink(file = "outputs/dic_table_intercepts.tex")
xtable(table_outi, caption = "")
sink()

# Will need to add caption and bold the lowest values manually