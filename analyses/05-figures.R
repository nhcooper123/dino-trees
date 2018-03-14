# Figures - Smoothed model predictions figures for paper
# Natalie Cooper March 2018
#-----------------------------------------------------------------
# Load libraries
library(tidyverse)
library(MCMCglmm)
library(gridExtra)
source("functions/get_predictions.R")

# Add rphylopic
install.packages("remotes")
remotes::install_github("sckott/rphylopic")
library(rphylopic) 

# Colour blind friendly palette
# First is grey
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Add silhouettes
library(png)
img_sauro <- readPNG("outputs/sauropod.png")
img_orni <- readPNG("outputs/stegosaurus.png")
img_thero <- readPNG("outputs/velociraptor.png")

#--------------------------------------------------------------
# For the original trees
#-----------------------------------------------------------------
# Read in nodecount data
#-----------------------------------------------------------------
node <- read.csv("data/nodecounts/nodecount_lloyd2008.csv")
node_o <- read.csv("data/nodecounts/nodecount_lloyd2008_orni.csv")
node_s <- read.csv("data/nodecounts/nodecount_lloyd2008_sauro.csv")
node_t <- read.csv("data/nodecounts/nodecount_lloyd2008_thero.csv")

#-----------------------------------------------------------------
# Read in outputs from MCMCglmm models
#-----------------------------------------------------------------
# All species
slow <- readRDS("outputs/selected-models/lloyd2008_slow.rds")
asym <- readRDS("outputs/selected-models/lloyd2008_aym.rds")

# Ornithischia
slow_o <- readRDS("outputs/selected-models/lloyd2008_orni_slow.rds")
asym_o <- readRDS("outputs/selected-models/lloyd2008_orni_aym.rds")

# Sauropoda
slow_s <- readRDS("outputs/selected-models/lloyd2008_sauro_slow.rds")
asym_s <- readRDS("outputs/selected-models/lloyd2008_sauro_aym.rds")

# Theropoda
slow_t <- readRDS("outputs/selected-models/lloyd2008_thero_slow.rds")
asym_t <- readRDS("outputs/selected-models/lloyd2008_thero_aym.rds")

#-----------------------------------------------------------------
# Get predictions for each million year
# time bin for all three models for a sample of 50 species
# Need to set seed each time to ensure the same species are sampled 
# each time
#-----------------------------------------------------------------
set.seed(123)
slow.ds <- get_predictions(slow, node, slowdown = TRUE, n.samples = 25)
set.seed(123)
asym.ds <- get_predictions(asym, node, n.samples = 50)

# Ornithischia
set.seed(123)
slow.ds_o <- get_predictions(slow_o, node_o, slowdown = TRUE, n.samples = 50)
set.seed(123)
asym.ds_o <- get_predictions(asym_o, node_o, n.samples = 50)

# Sauropoda
set.seed(123)
slow.ds_s <- get_predictions(slow_s, node_s, slowdown = TRUE, n.samples = 50)
set.seed(123)
asym.ds_s <- get_predictions(asym_s, node_s, n.samples = 50)

# Theropoda
set.seed(123)
slow.ds_t <- get_predictions(slow_t, node_t, slowdown = TRUE, n.samples = 50)
set.seed(123)
asym.ds_t <- get_predictions(asym_t, node_t, n.samples = 50)

#-----------------------------------------------------------------
# Get mean values for each time across all species from predictions
# Note predictions are done for a random sample of 50 species
#-----------------------------------------------------------------
# All species
slow.mean <- 
  slow.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Ornithischia
slow.mean_o <- 
  slow.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_o <- 
  asym.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Sauropoda
slow.mean_s <- 
  slow.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_s <- 
  asym.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

# Theropoda
slow.mean_t <- 
  slow.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

asym.mean_t <- 
  asym.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(nodecount))

#-----------------------------------------------------------------
# Extract time at maximum nodecount, i.e. inflection point
#-----------------------------------------------------------------
# All species
slow.mean_t$time[which(slow.mean_t$meanY == max(slow.mean_t$meanY))]
asym.mean_t$time[which(asym.mean_t$meanY == max(asym.mean_t$meanY))]

# Ornithischia
slow.mean$time[which(slow.mean$meanY == max(slow.mean$meanY))]
asym.mean$time[which(asym.mean$meanY == max(asym.mean$meanY))]

# Sauropoda
slow.mean_s$time[which(slow.mean_s$meanY == max(slow.mean_s$meanY))]
asym.mean_s$time[which(asym.mean_s$meanY == max(asym.mean_s$meanY))]

# Theropoda
slow.mean_t$time[which(slow.mean_t$meanY == max(slow.mean_t$meanY))]
asym.mean_t$time[which(asym.mean_t$meanY == max(asym.mean_t$meanY))]

#-----------------------------------------------------------------
# Plot the lines for slowdown and asymptote models
# Group by species
#-----------------------------------------------------------------
# All species
p1 <-
  ggplot(asym.ds, aes(x = time, y = nodecount, group = species)) + 
  # Lines for all species but transparent
  geom_line(alpha = 0.2, col = cbPalette[4]) +
  geom_line(data = slow.ds, col = cbPalette[3], alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean, aes(x = time, y = meanY, group = NULL),  
            alpha = 1, col = cbPalette[3]) +
  geom_line(data = asym.mean, aes(x = time, y = meanY, group = NULL), 
            col = cbPalette[4], alpha = 1) +
  # Axis labels
  labs(x = "time elapsed (MY)", y = "node count") +
  # Remove grey background
  theme_bw(base_size = 15)+
  # Set limits to y axis and x axis
  ylim(0, 25) +
  xlim(0, 200)
  
# Ornithischia
po <-
  ggplot(asym.ds_o, aes(x = time, y = nodecount, group = species)) + 
  geom_line(alpha = 0.2, col = cbPalette[4]) +
  geom_line(data = slow.ds_o, col = cbPalette[3], alpha = 0.2) +
  geom_line(data = slow.mean_o, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = cbPalette[3]) +
  geom_line(data = asym.mean_o, aes(x = time, y = meanY, group = NULL), 
            col = cbPalette[4], alpha = 1) +
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15) +
  ylim(0, 25) +
  xlim(0, 200) +
  # Add silhouette
  add_phylopic(img = img_orni, alpha = 1, x = 20, y = 22.5, ysize = 25)

# Sauropoda
ps <-
  ggplot(asym.ds_s, aes(x = time, y = nodecount, group = species)) + 
  geom_line(alpha = 0.2, col = cbPalette[4]) +
  geom_line(data = slow.ds_s, col = cbPalette[3], alpha = 0.2) +
  geom_line(data = slow.mean_s, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = cbPalette[3]) +
  geom_line(data = asym.mean_s, aes(x = time, y = meanY, group = NULL),
            col = cbPalette[4], alpha = 1) +
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15)+
  ylim(0, 25) +
  xlim(0, 200) +
  add_phylopic(img = img_sauro, alpha = 1, x = 20, y = 22.5, ysize = 35)

# Theropoda
pt <-
  ggplot(asym.ds_t, aes(x = time, y = nodecount, group = species)) + 
  geom_line(alpha = 0.2, col = cbPalette[4]) +
  geom_line(data = slow.ds_t, col = cbPalette[3], alpha = 0.2) +
  geom_line(data = slow.mean_t, aes(x = time, y = meanY, group = NULL), 
            alpha = 1, col = cbPalette[3]) +
  geom_line(data = asym.mean_t, aes(x = time, y = meanY, group = NULL),
            col = cbPalette[4], alpha = 1) +
  labs(x = "time elapsed (MY)", y = "node count") +
  theme_bw(base_size = 15) +
  ylim(0, 25) +
  xlim(0, 200) +
  add_phylopic(img = img_thero, alpha = 1, x = 20, y = 22.5, ysize = 25)

# Plot all four on one grid
grid.arrange(p1, po, ps, pt, ncol = 2)

####### Add Time periods? ######
