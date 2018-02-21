# Analysis step 2
# Run all the models on all the simulated trees
# Natalie Cooper Oct 2017, modified from Joe Bonsor summer 2017

# Load libraries and source functions
library(MCMCglmm)
library(ape)
source("functions/run_mcmcglmm.R")

#----------------------------------------------------------------
# Set up priors for modelling
#----------------------------------------------------------------
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

#----------------------------------------------------------------
# Create an empty output dataframe
#----------------------------------------------------------------
output <- make_mcmc_output(ntrees = 2004)
# 4 trees = lloyd plus three clades
# 4 * 5 additional trees = 20 * 50 for each = 1000
#----------------------------------------------------------------
# Run models for the original tree
#----------------------------------------------------------------
tree.no <- 1 # start counter
# This counter runs through all the models
# Take care when resetting/not resetting

tree.name <- "lloydtree"

# Load the tree and node count data
tree <- read.tree("data/trees/lloyd2008_midpoint.tre")
nodecount.data <- read.csv("data/nodecounts/nodecount_lloyd2008.csv")

# Run the models
model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)

# Add model outputs
output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                          slow.model = model.outputs[[2]], 
                          asym.model = model.outputs[[3]], 
                          tree.no = tree.no,
                          tree.name = tree.name)

# Save the outputs as we go
write.csv(file = "outputs/mcmcglmm_outputs.csv", output, 
          row.names = FALSE, quote = FALSE)
#----------------------------------------------------------------
# Run models for the original tree split into three clades
#----------------------------------------------------------------
# Read in clade trees
tree.list <- read.tree("data/trees/lloyd2008_midpoint_clades.tre")

# Loop through each clade  
for(j in 1:length(tree.list)){
  # Split multi phylo into one tree
  tree <- tree.list[[j]]
  
  # Get tree number and name
  tree.no <- 1 + tree.no
  tree.name <- paste0("lloyd2008_", names(tree.list[j]))
  
  # Load the node count data
  nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_lloyd2008_", 
                                    names(tree.list[j]), ".csv"))
  
  # Run the models
  model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)

  # Add model outputs
  output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                            slow.model = model.outputs[[2]], 
                            asym.model = model.outputs[[3]], 
                            tree.no = tree.no,
                            tree.name = tree.name)
  
  # Save the outputs as we go
  write.csv(file = "outputs/mcmcglmm_outputs.csv", output, 
            row.names = FALSE, append = TRUE, quote = FALSE)
}

#----------------------------------------------------------------
# Run models for all the full trees with extra species
#----------------------------------------------------------------
numbers.to.add <- c(4, 21, 42, 105, 210)

for(x in numbers.to.add){
  
  # Run for the 50 trees for each number of taxa added
  for(i in 1:50){ 
      
      # Get tree number and name
      tree.no <- 1 + tree.no
      tree.name <- paste0("tree_", x, "_", i)
  
      # Load the tree and node count data
      tree <- read.tree(paste0("data/trees/tree_", x, "_", i, ".tre"))
      nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", x, "_", i, ".csv"))
    
      # Run models
      model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)

      # Add model outputs
      output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                            slow.model = model.outputs[[2]], 
                            asym.model = model.outputs[[3]], 
                            tree.no = tree.no,
                            tree.name = tree.name)
  
      # Save the outputs as we go
      write.csv(file = "outputs/mcmcglmm_outputs.csv", output, 
                row.names = FALSE, append = TRUE, quote = FALSE)
  }  
}
#----------------------------------------------------------------
# Run models for all the separates trees with extra species
#----------------------------------------------------------------
numbers.to.add <- c(4, 21, 42, 105, 210)

for(x in numbers.to.add){
  
  # Run for the 50 trees for each number of taxa added
  for(i in 1:50){ 
    
    # Read in clade trees
    tree.list <- read.tree(paste0("data/trees/tree_", x, "_", i, "_clades.tre"))
  
    # Loop through each clade  
    for(j in 1:length(tree.list)){
      # Split multi phylo into one tree
      tree <- tree.list[[j]]
      # Get tree number and name
      tree.no <- 1 + tree.no
      tree.name <- paste0("tree_", x, "_", names(tree.list[j]), "_", i)
  
      # Load the node count data
      nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", x, "_", 
                                      names(tree.list[j]), "_", i, ".csv"))
    
      # Run models
      model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)
  
      # Add model outputs
      output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                              slow.model = model.outputs[[2]], 
                              asym.model = model.outputs[[3]], 
                              tree.no = tree.no,
                              tree.name = tree.name)
    
      # Save the outputs as we go
      write.csv(file = "outputs/mcmcglmm_outputs.csv", output, 
                  row.names = FALSE, append = TRUE, quote = FALSE)
    }
  }
}