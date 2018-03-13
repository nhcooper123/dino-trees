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
null.ds <- get_speciation_rates(get_predictions(null, node, n.samples = 50))
## predict.mcmcglmm does not seem to work with one variable and no intercept
## I suspect it is estimating the intercepts instead of the slope
## as predicted Y is always very small (< 4) where it should vary
## to at least 15 or up to 40.

set.seed(123)
# slow.ds <- get_speciation_rates(get_predictions(slow, node, slowdown = TRUE, n.samples = 50))

set.seed(123)
asym.ds <- get_speciation_rates(get_predictions(asym, node, n.samples = 50))

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

#--------------------------------------------
# Plot net speciation rates
#--------------------------------------------
# Remove the speciation rate for time 0 as we can't
# estimate that using our method
null.ds <- null.ds %>%
  filter(time > 0)

slow.ds <- slow.ds %>%
  filter(time > 0)

asym.ds <- asym.ds %>%
  filter(time > 0)

# Get mean values for each time across all species
null.meanS <- 
  null.ds %>%
  group_by(time) %>%
  summarise(meanS = mean(speciation))

#slow.meanS <- 
#  slow.ds %>%
#  group_by(time) %>%
#  summarise(meanS = mean(speciation))

asym.meanS <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanS = mean(speciation))

# Plot speciation rates
ggplot(null.ds, aes(x = time, y = speciation, group = species)) + 
  # All lines for each species with high transparency
  geom_line(alpha = 0.2) +
  #geom_line(data = slow.ds, col = "blue", alpha = 0.2) +
  geom_line(data = asym.ds, col = "red", alpha = 0.2) +
  # Mean lines for all sampled species
  geom_line(data = null.meanS, aes(x = time, y = meanS, group = NULL),  alpha = 1) +
  #geom_line(data = slow.meanS, aes(x = time, y = meanS, group = NULL), col = "blue", alpha = 1) +
  geom_line(data = asym.meanS, aes(x = time, y = meanS, group = NULL), col = "red", alpha = 1) +
  # Details
  labs(x = "time elapsed (MY)", y = expression(paste0("net speciation rate", MY^-1))) +
  theme_bw(base_size = 15) +
  # Add 0,0 line to show where speciation = extinction
  geom_abline(intercept = 0, slope = 0, linetype = 3)
