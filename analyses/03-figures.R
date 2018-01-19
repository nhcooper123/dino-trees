# Figures
# Attempts to make smoothed model predictions figures for paper

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

# Reminder of what models look like
# null model
# null <- MCMCglmm(nodecount ~ 0 + time, 
#                 data = nodecount.data, random = ~ species,
#                 ginverse = list(species = inv), family = "poisson", prior = prior,
#                 nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
# slowdown model
# nodecount ~ 0 + time + time^2 
# asymptote model
# nodecount ~ 0 + time + sqrt(time) 

#------------------------------
# Add null model predicted line
#------------------------------
# Create new x variable
# Must contain time, species and nodecount
newX <- expand.grid(time = seq(from = min(node$time), 
                               to = max(node$time), 
                               length = 100),
                    species = node$species)
newX$nodecount <- 0

# Create new y using predict
newY <- predict.MCMCglmm(null, newdata = newX, type = "response", 
                         marginal = ~species, interval = "confidence") 

newY <- data.frame(newY)
# OK currently this is producing a prediction for each time point for each species...
# can we pick one species at random instead??? That would maybe fix it?



# Stick newX$time and newY together
addnull <- data.frame(time = newX$time, nodecount = newY$fit, 
                      species = newX$species)

# Manipulate confidence intervals
addnull <- mutate(addnull, ucl = exp(nodecount + 1.96*se.fit))
addnull <- mutate(addnull, lcl = exp(nodecount - 1.96*se.fit))

# Plot!
ggplot(group_by(addnull, species), aes(x = time, y = exp(nodecount))) + 
  theme_bw(base_size = 15) +
  # add line of fitted values on response scale from type = 'response'
  geom_point() +
  geom_ribbon(data = addnull,  aes(ymin = lcl, ymax = ucl), alpha = 0.5)

