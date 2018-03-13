# Figures
# Smoothed model predictions figures for paper

# Load libraries
library(tidyverse)
library(MCMCglmm)
source("functions/get_predictions.R")

# List the trees to work with

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
asym <- readRDS("outputs/selected-models/lloyd2008_asym.rds")
slow_o <- readRDS("outputs/selected-models/lloyd2008_orni_slow.rds")
asym_o <- readRDS("outputs/selected-models/lloyd2008_orni_asym.rds")
slow_s <- readRDS("outputs/selected-models/lloyd2008_sauro_slow.rds")
asym_s <- readRDS("outputs/selected-models/lloyd2008_sauro_asym.rds")
slow_t <- readRDS("outputs/selected-models/lloyd2008_thero_slow.rds")
asym_t <- readRDS("outputs/selected-models/lloyd2008_thero_asym.rds")

# Get predictions for each million year
# time bin for all three models
# And add speciation rates
# Need to set seed to ensure the same species are sampled each time
set.seed(123)
null.ds <- get_speciation_rates(get_predictions(null, node, n.samples = 50))
## predict.mcmcglmm does not seem to work with one variable and no intercept
## I suspect it is estimating the intercepts instead of the slope
## as predicted Y is always very small (< 4) where it should vary
## to at least 15 or up to 40.

set.seed(123)
slow.ds <- get_predictions(slow, node, slowdown = TRUE, n.samples = 50)

set.seed(123)
asym.ds <- get_predictions(asym, node, n.samples = 50)

# Get mean values for each time across all species
slow.mean <- 
  slow.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Plot the lines 
# Group by species
ggplot(null.ds, aes(x = time, y = nodecount, group = species)) + 
  # All lines
  geom_line(alpha = 0.2) +
  #geom_line(data = slow.ds, col = "blue", alpha = 0.2) +
  geom_line(data = asym.ds, col = "red", alpha = 0.2) +
  # Mean lines
  geom_line(data = null.mean, aes(x = time, y = meanY, group = NULL),  alpha = 1) +
  #geom_line(data = slow.mean, aes(x = time, y = meanY), col = "blue", alpha = 1) +
  geom_line(data = asym.mean, aes(x = time, y = meanY, group = NULL), col = "red", alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)

####### Add Time periods ?strap ######

