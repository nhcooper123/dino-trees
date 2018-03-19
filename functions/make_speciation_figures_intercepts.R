# Figures - Smoothed speciation rate figures for paper
# Another exceedingly inelegant function
# Natalie Cooper March 2018

# Requires make_predictions.R and MCMCglmm, ggplot2, gridExtra,
# rphylopic, png, img_sauro, img_thero, img_orni.
#-----------------------------------------------------------------

make_speciation_figures <- function(treename, tree, rep, col1, col2){

#-----------------------------------------------------------------
# Read in nodecount data
#-----------------------------------------------------------------
node <- read.csv(paste0("data/nodecounts/nodecount_", treename, rep, ".csv"))
node_o <- read.csv(paste0("data/nodecounts/nodecount_", treename, "_orni", rep, ".csv"))
node_s <- read.csv(paste0("data/nodecounts/nodecount_", treename, "_sauro", rep, ".csv"))
node_t <- read.csv(paste0("data/nodecounts/nodecount_", treename, "_thero", rep, ".csv"))

#-----------------------------------------------------------------
# Read in outputs from MCMCglmm models
#-----------------------------------------------------------------
# All species
slow <- readRDS(paste0("outputs/selected-models/", tree, treename, rep, "_slow_intercepts.rds"))
asym <- readRDS(paste0("outputs/selected-models/", tree, treename, rep, "_aym_intercepts.rds"))

# Ornithischia
slow_o <- readRDS(paste0("outputs/selected-models/", tree, treename, "_orni", rep, "_slow_intercepts.rds"))
asym_o <- readRDS(paste0("outputs/selected-models/", tree, treename, "_orni", rep, "_aym_intercepts.rds"))

# Sauropoda
slow_s <- readRDS(paste0("outputs/selected-models/", tree, treename, "_sauro", rep, "_slow_intercepts.rds"))
asym_s <- readRDS(paste0("outputs/selected-models/", tree, treename, "_sauro", rep, "_aym_intercepts.rds"))

# Theropoda
slow_t <- readRDS(paste0("outputs/selected-models/", tree, treename, "_thero", rep, "_slow_intercepts.rds"))
asym_t <- readRDS(paste0("outputs/selected-models/", tree, treename, "_thero", rep, "_aym_intercepts.rds"))

#-----------------------------------------------------------------
# Get speciation rates for each million year
# time bin for all three models for a sample of 50 species
# Need to set seed each time to ensure the same species are sampled 
# each time
#-----------------------------------------------------------------
set.seed(123)
slow.ds <- get_speciation_rates(get_predictions(slow, node, slowdown = TRUE, n.samples = 50))
set.seed(123)
asym.ds <- get_speciation_rates(get_predictions(asym, node, n.samples = 50))

# Ornithischia
set.seed(123)
slow.ds_o <- get_speciation_rates(get_predictions(slow_o, node_o, slowdown = TRUE, n.samples = 50))
set.seed(123)
asym.ds_o <- get_speciation_rates(get_predictions(asym_o, node_o, n.samples = 50))

# Sauropoda
set.seed(123)
slow.ds_s <- get_speciation_rates(get_predictions(slow_s, node_s, slowdown = TRUE, n.samples = 50))
set.seed(123)
asym.ds_s <- get_speciation_rates(get_predictions(asym_s, node_s, n.samples = 50))

# Theropoda
set.seed(123)
slow.ds_t <- get_speciation_rates(get_predictions(slow_t, node_t, slowdown = TRUE, n.samples = 50))
set.seed(123)
asym.ds_t <- get_speciation_rates(get_predictions(asym_t, node_t, n.samples = 50))

#-----------------------------------------------------------------
# Remove the speciation rate for time 0 as we can't
# estimate that using our method
#-----------------------------------------------------------------
# All species
slow.ds <- slow.ds %>%
  filter(time > 0)

asym.ds <- asym.ds %>%
  filter(time > 0)

# Ornithischia
slow.ds_o <- slow.ds_o %>%
  filter(time > 0)

asym.ds_o <- asym.ds_o %>%
  filter(time > 0)

# Sauropoda
slow.ds_s <- slow.ds_s %>%
  filter(time > 0)

asym.ds_s <- asym.ds_s %>%
  filter(time > 0)

# Theropoda
slow.ds_t <- slow.ds_t %>%
  filter(time > 0)

asym.ds_t <- asym.ds_t %>%
  filter(time > 0)

#-----------------------------------------------------------------
# Get mean values for each time across all species
# Note predictions are done for a random sample of 50 species
#-----------------------------------------------------------------
# All species
slow.mean <- 
  slow.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

asym.mean <- 
  asym.ds %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

# Ornithischia
slow.mean_o <- 
  slow.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

asym.mean_o <- 
  asym.ds_o %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

# Sauropoda
slow.mean_s <- 
  slow.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

asym.mean_s <- 
  asym.ds_s %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

# Theropoda
slow.mean_t <- 
  slow.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

asym.mean_t <- 
  asym.ds_t %>%
  group_by(time) %>%
  summarise(meanY = mean(speciation))

#-----------------------------------------------------------------
# Plot the lines for slowdown and asymptote models
# Group by species
#-----------------------------------------------------------------
# All species
p1 <-
  ggplot(asym.ds, aes(x = time, y = speciation, group = species)) + 
  # Lines for all species but transparent
  geom_line(alpha = 0.2, col = col1) +
  geom_line(data = slow.ds, col = col2, alpha = 0.2) +
  # Mean lines
  geom_line(data = slow.mean, aes(x = time, y = meanY, group = NULL),  
            alpha = 1, col = col2) +
  geom_line(data = asym.mean, aes(x = time, y = meanY, group = NULL), 
            col = col1, alpha = 1) +
  # Axis labels
  labs(x = "time elapsed (MY)", y = expression(paste("net speciation rate (", MY^-1, ")"))) +
  # Remove grey background
  theme_bw(base_size = 15)+
  # Set limits to y axis and x axis
  ylim(-0.15, 0.65) +
  xlim(0, 200) +
  # Add 0,0 line to show where speciation = extinction
  geom_abline(intercept = 0, slope = 0, linetype = 3)

# Ornithischia
po <-
  ggplot(asym.ds_o, aes(x = time, y = speciation, group = species)) + 
  geom_line(alpha = 0.2, col = col1) +
  geom_line(data = slow.ds_o, col = col2, alpha = 0.2) +
  geom_line(data = slow.mean_o, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = col2) +
  geom_line(data = asym.mean_o, aes(x = time, y = meanY, group = NULL), 
            col = col1, alpha = 1) +
  labs(x = "time elapsed (MY)", y = expression(paste("net speciation rate (", MY^-1, ")"))) +
  theme_bw(base_size = 15) +
  ylim(-1.5, 0.65) +
  xlim(0, 200) +
  # Add 0,0 line to show where speciation = extinction
  geom_abline(intercept = 0, slope = 0, linetype = 3) +
  # Add silhouette
  add_phylopic(img = img_orni, alpha = 1, x = 175, y = 0.5, ysize = 25)

# Sauropoda
ps <-
  ggplot(asym.ds_s, aes(x = time, y = speciation, group = species)) + 
  geom_line(alpha = 0.2, col = col1) +
  geom_line(data = slow.ds_s, col = col2, alpha = 0.2) +
  geom_line(data = slow.mean_s, aes(x = time, y = meanY, group = NULL),
            alpha = 1, col = col2) +
  geom_line(data = asym.mean_s, aes(x = time, y = meanY, group = NULL),
            col = col1, alpha = 1) +
  labs(x = "time elapsed (MY)", y = expression(paste("net speciation rate (", MY^-1, ")"))) +
  theme_bw(base_size = 15) +
  # Add 0,0 line to show where speciation = extinction
  geom_abline(intercept = 0, slope = 0, linetype = 3) +
  ylim(-1.5, 0.65) +
  xlim(0, 200) +
  add_phylopic(img = img_sauro, alpha = 1, x = 175, y = 0.5, ysize = 35)

# Theropoda
pt <-
  ggplot(asym.ds_t, aes(x = time, y = speciation, group = species)) + 
  geom_line(alpha = 0.2, col = col1) +
  geom_line(data = slow.ds_t, col = col2, alpha = 0.2) +
  geom_line(data = slow.mean_t, aes(x = time, y = meanY, group = NULL), 
            alpha = 1, col = col2) +
  geom_line(data = asym.mean_t, aes(x = time, y = meanY, group = NULL),
            col = col1, alpha = 1) +
  labs(x = "time elapsed (MY)", y = expression(paste("net speciation rate (", MY^-1, ")"))) +
  theme_bw(base_size = 15) +
  # Add 0,0 line to show where speciation = extinction
  geom_abline(intercept = 0, slope = 0, linetype = 3) +
  ylim(-1.5, 0.65) +
  xlim(0, 200) +
  add_phylopic(img = img_thero, alpha = 1, x = 175, y = 0.5, ysize = 25)

# Plot all four on one grid
allplots <- grid.arrange(p1, po, ps, pt, ncol = 2)
ggsave(file = paste0("outputs/figures/speciation_", treename, "_intercepts.pdf"), allplots)

}
