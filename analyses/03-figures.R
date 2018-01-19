# Figures

# Load libraries
library(tidyverse)
library(MCMCglmm)

# Read in phylogeny and nodecount data
tree <- read.tree("data/trees/lloyd2008_midpoint.tre")
node <- read.csv("data/nodecounts/nodecount_lloyd2008.csv")

# Read in outputs from full tree MCMCglmm models
null <- readRDS("outputs/lloydwhole_null.rds")
asym <- readRDS("outputs/lloydwhole_asym.rds")
slow <- readRDS("outputs/lloydwhole_slow.rds")

str(null)

# Fit null model
null <- MCMCglmm(nodecount ~ 0 + time, 
                 data = nodecount.data, random = ~ species,
                 ginverse = list(species = inv), family = "poisson", prior = prior,
                 nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)

# Fit slowdown model
slow <- MCMCglmm(nodecount ~ 0 + time + time^2, 
                 data = nodecount.data, random = ~ species,
                 ginverse = list(species = inv), family = "poisson", prior = prior,
                 nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)

# Fit asymptote model
asym <- MCMCglmm(nodecount ~ 0 + time + sqrt(time), 
                 data = nodecount.data, random = ~ species,
                 ginverse = list(species = inv), family = "poisson", prior = prior,
                 nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)


# Add null model smoothed
# Create new x variable
newX <- expand.grid(time = seq(from = min(node$time), 
                               to = max(node$time), 
                               length = 100),
                    species = node$species)
# Weird trick to get predict.MCMCglmm to run
newX$nodecount <- 0

# Create new y using predict
newY <- predict.MCMCglmm(null, newdata = newX, type = "response", 
                         marginal = ~species, interval = "confidence") 

# housekeeping
addnull <- data.frame(newX, nodecount = newY)

addnull <- mutate(addnull, ucl=exp(nodecount + 1.96*se.fit))

ggplot(node, aes(x = time, y = nodecount)) + 
  theme_bw(base_size = 15) +
  # add line of fitted values on response scale from type = 'response'
  geom_line(data = addnull) +
  geom_ribbon(data = addnull,  aes(ymin = lcl, ymax = ucl), alpha = 0.5)

