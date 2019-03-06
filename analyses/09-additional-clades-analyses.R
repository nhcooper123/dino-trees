# Analyses for other two clades...

# Load libraries and source functions
library(ape)
library(geiger)
library(MCMCglmm)
source("functions/get_node_count.R")
source("functions/make_trees.R")
source("functions/run_mcmcglmm.R")
source("functions/extract_clade_trees.R")

# Read in phylogeny and taxonomy data
tree <- read.tree("data/trees/lloyd2008_midpoint.tre")
taxonomy <- read.csv("data/taxonomy.data.csv")

# Set up priors for modelling
# Priors
prior <- list(R = list(V = 1, nu = 0.002), 
              G = list(G1 = list(V = 1, nu = 1, 
                                 alpha.mu = 0, alpha.V = 25^2)))

# Number of iterations
nitt <- 5E05

# Sampling interval
thin <- 1E03

# Burnin
burnin <- 5E04

# Create two empty output dataframes
output <- make_mcmc_output(ntrees = 3)
output2 <- make_mcmc_output_intercept(ntrees = 3)

#--------------------------------------------------------------------
# Get node counts
#--------------------------------------------------------------------

# Create clade tree and write to file
tree.list <- extract_clade_trees(tree, taxonomy, 
                                 species.col.name = "taxon", 
                                 clade.col.name = "clade2")
# Write clade trees 
write.tree(phy = tree.list, 
           file = paste0("data/trees/lloyd2008_midpoint_clades2.tre"), 
           tree.names = TRUE)

# Loop through each clade  
# Clade 1 is blank so start at clade 2
for(j in 2:length(tree.list)){
  # Split multi phylo into one tree
  tree <- tree.list[[j]]
  # Get node counts
  create_node_counts(tree, path = "data/nodecounts/", 
                     simulation.name = paste0("nodecount_lloyd2008_", 
                                              names(tree.list[j])))
}

#--------------------------------------------------------------------
# Run models
#--------------------------------------------------------------------

for (i in 2:length(tree.list)){
  
  # Get tree number and name
  tree.no <- i
  tree.name <- names(tree.list[i])
  tree <- tree.list[[i]]
  
  # Load the node count data
  nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_lloyd2008_", 
                                    names(tree.list[i]), ".csv"))
  
  # Run the models
  model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)
  model.outputs2 <- run_three_models_intercept(tree, nodecount.data, prior, nitt, thin, burnin)
  
  # Add model outputs
  output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                            slow.model = model.outputs[[2]], 
                            asym.model = model.outputs[[3]], 
                            tree.no = tree.no,
                            tree.name = tree.name)
  
  output2 <- add_mcmc_output_intercept(output2, null.model = model.outputs2[[1]], 
                                       slow.model = model.outputs2[[2]], 
                                       asym.model = model.outputs2[[3]], 
                                       tree.no = tree.no,
                                       tree.name = tree.name)
  
  # Save the outputs as we go
  write.csv(file = "outputs/mcmcglmm_outputs_extraclades.csv", output, 
            row.names = FALSE, append = TRUE, quote = FALSE)
  
  write.csv(file = "outputs/mcmcglmm_outputs_intercept_extraclades.csv", output2, 
            row.names = FALSE, append = TRUE, quote = FALSE)
}

