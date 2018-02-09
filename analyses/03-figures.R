# Figures
# Smoothed model predictions figures for paper

# Load libraries
library(tidyverse)
library(MCMCglmm)
source("functions/get_predictions.R")

# Read in phylogeny and nodecount data
node <- read.csv("data/nodecounts/nodecount_lloyd2008.csv")

# Read in outputs from full tree MCMCglmm models
null <- readRDS("outputs/lloydwhole_null.rds")
#slow <- readRDS("outputs/lloydwhole_slow.rds")
asym <- readRDS("outputs/lloydwhole_asym.rds")

# Get predictions for each million year
# time bin for all three models
# And add speciation rates
# Need to set seed to ensure the same species are sampled each time
set.seed(123)
null.ds <- get_speciation_rates(get_predictions(null, node, n.samples = 2))

set.seed(123)
# slow.ds <- get_speciation_rates(get_predictions(slow, node, slowdown = TRUE, n.samples = 2))

set.seed(123)
asym.ds <- get_speciation_rates(get_predictions(asym, node, n.samples = 2))

# Get mean values for each time across all species
null.mean <- 
  null.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

#slow.mean <- 
#  slow.ds %>%
#  group_by(time) %>%
#  summarise(meanY = mean(nodecount))

asym.mean <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Plot the lines 
ggplot(group_by(null.ds, species), aes(x = time, y = log(nodecount))) + 
  # All lines
  #geom_line(alpha = 0.2) +
  #geom_line(data = group_by(slow.ds, species), col = "blue", alpha = 0.2) +
  #geom_line(data = group_by(asym.ds, species), col = "red", alpha = 0.2) +
  # Mean lines
  geom_line(data = null.mean, aes(x = time, y = meanY),  alpha = 1) +
  #geom_line(data = slow.mean, aes(x = time, y = meanY), col = "blue", alpha = 1) +
  geom_line(data = asym.mean, aes(x = time, y = log(meanY)), col = "red", alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = "log(node count)") +
  theme_bw(base_size = 15)

####### Add Time periods ?strap ######

#--------------------------------------------
# Plot net speciation rates
#--------------------------------------------
# Get mean values for each time across all species
null.meanS <- 
  null.ds %>%
  group_by(time) %>%
  summarise(meanS = mean(speciation))

slow.meanS <- 
  slow.ds %>%
  group_by(time) %>%
  summarise(meanS = mean(speciation))

asym.meanS <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanS = mean(speciation))

# Plot speciation rates
ggplot(group_by(null.ds,species), aes(x = time, y = as.numeric(speciation))) + 
  # All lines
  #geom_line(alpha = 0.2) +
  #geom_line(data = group_by(slow.ds, species), col = "blue", alpha = 0.2) +
  #geom_line(data = group_by(asym.ds, species), col = "red", alpha = 0.2) +
  # Mean lines
  geom_line(data = null.meanS, aes(x = time, y = meanS),  alpha = 1) +
  #geom_line(data = slow.meanS, aes(x = time, y = meanY), col = "blue", alpha = 1) +
  geom_line(data = asym.meanS, aes(x = time, y = meanS), col = "red", alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = paste0(expression("net speciation rates ", MY^-1, sep = ""))) +
  theme_bw(base_size = 15)
