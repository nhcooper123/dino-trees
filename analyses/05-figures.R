# Figures
# Smoothed model predictions figures for paper

# Load libraries
library(tidyverse)
library(MCMCglmm)
library(gridExtra)
source("functions/get_predictions.R")

# Colour blind friendly palette
# First is grey
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# List the trees to work with

# Hmm think we need functions
# select tree 
# read in node count
# read in outputs
# predict values for nodecount from time
# plot 

"lloyd2008"
"4_33"
"21_16"
"42_14"
"105_11"
"210_17"

#--------------------------------------------------------------
# For the original trees

# Read in nodecount data
node <- read.csv("data/nodecounts/nodecount_lloyd2008.csv")
node_o <- read.csv("data/nodecounts/nodecount_lloyd2008_orni.csv")
node_s <- read.csv("data/nodecounts/nodecount_lloyd2008_sauro.csv")
node_t <- read.csv("data/nodecounts/nodecount_lloyd2008_thero.csv")

# Read in outputs from MCMCglmm models
slow <- readRDS("outputs/selected-models/lloyd2008_slow.rds")
asym <- readRDS("outputs/selected-models/lloyd2008_aym.rds")
slow_o <- readRDS("outputs/selected-models/lloyd2008_orni_slow.rds")
asym_o <- readRDS("outputs/selected-models/lloyd2008_orni_aym.rds")
slow_s <- readRDS("outputs/selected-models/lloyd2008_sauro_slow.rds")
asym_s <- readRDS("outputs/selected-models/lloyd2008_sauro_aym.rds")
slow_t <- readRDS("outputs/selected-models/lloyd2008_thero_slow.rds")
asym_t <- readRDS("outputs/selected-models/lloyd2008_thero_aym.rds")

# Get predictions for each million year
# time bin for all three models
# Need to set seed to ensure the same species are sampled each time
set.seed(123)
slow.ds <- get_predictions(slow, node, slowdown = TRUE, n.samples = 25)
set.seed(123)
asym.ds <- get_predictions(asym, node, n.samples = 25)

set.seed(123)
slow.ds_o <- get_predictions(slow_o, node_o, slowdown = TRUE, n.samples = 25)
set.seed(123)
asym.ds_o <- get_predictions(asym_o, node_o, n.samples = 25)

set.seed(123)
slow.ds_s <- get_predictions(slow_s, node_s, slowdown = TRUE, n.samples = 25)
set.seed(123)
asym.ds_s <- get_predictions(asym_s, node_s, n.samples = 25)

set.seed(123)
slow.ds_t <- get_predictions(slow_t, node_t, slowdown = TRUE, n.samples = 25)
set.seed(123)
asym.ds_t <- get_predictions(asym_t, node_t, n.samples = 25)

# Get mean values for each time across all species
slow.mean <- 
  slow.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

slow.mean_o <- 
  slow.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_o <- 
  asym.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

slow.mean_s <- 
  slow.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_s <- 
  asym.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

slow.mean_t <- 
  slow.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_t <- 
  asym.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Plot the lines 
# Group by species
p1 <-
  ggplot(asym.ds, aes(x = time, y = nodecount, group = species)) + 
  # All lines
  geom_line(alpha = 0.2, col = cbPalette[6]) +
  geom_line(data = slow.ds, col = cbPalette[5], alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean, aes(x = time, y = meanY, group = NULL),  
            alpha = 1, col = cbPalette[5]) +
  geom_line(data = asym.mean, aes(x = time, y = meanY, group = NULL), 
            col = cbPalette[6], alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)

po <-
  ggplot(asym.ds_o, aes(x = time, y = nodecount, group = species)) + 
  # All lines
  geom_line(alpha = 0.2, col = cbPalette[4]) +
  geom_line(data = slow.ds_o, col = cbPalette[3], alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean_o, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = cbPalette[3]) +
  geom_line(data = asym.mean_o, aes(x = time, y = meanY, group = NULL), 
            col = cbPalette[4], alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)

ps <-
  ggplot(asym.ds_s, aes(x = time, y = nodecount, group = species)) + 
  # All lines
  geom_line(alpha = 0.2, col = cbPalette[7]) +
  geom_line(data = slow.ds_s, col = cbPalette[8], alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean_s, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = cbPalette[8]) +
  geom_line(data = asym.mean_s, aes(x = time, y = meanY, group = NULL),
            col = cbPalette[7], alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)

pt <-
  ggplot(asym.ds_t, aes(x = time, y = nodecount, group = species)) + 
  # All lines
  geom_line(alpha = 0.2, col = cbPalette[1]) +
  geom_line(data = slow.ds_t, col = cbPalette[2], alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean_t, aes(x = time, y = meanY, group = NULL), 
            alpha = 1, col = cbPalette[2]) +
  geom_line(data = asym.mean_t, aes(x = time, y = meanY, group = NULL),
            col = cbPalette[1], alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)

grid.arrange(p1, po, ps, pt, ncol = 2)

####### Add Time periods ?strap ######

