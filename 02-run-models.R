# Functions to run all the models on all the trees

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
nitt <- 1E06

# Sampling interval
thin <- 1E03

# Burnin
burnin <- 1E05

#----------------------------------------------------------------
# Create an empty output dataframe
#----------------------------------------------------------------
output <- make_mcmc_output(nvar = 21, ntrees = 10)

#----------------------------------------------------------------
# Run models for all the original tree
#----------------------------------------------------------------

#----------------------------------------------------------------
# Run models for all the full trees with extra species
#----------------------------------------------------------------
numbers.to.add <- c(4, 21, 42, 105, 210)
tree.no <- 0 # start counter

for(x in numbers.to.add){
  
  tree.no <- 1 + tree.no
  tree.name <- paste0("tree_", x)
  
  # Load the tree and node count data
  tree <- read.tree(paste0("data/trees/tree_", x, ".tre"))
  nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", x, ".csv"))
  model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)

  # Add model outputs
  output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                            slow.model = model.outputs[[2]], 
                            asym.model = model.outputs[[3]], 
                            tree.no = tree.no,
                            tree.name = tree.name)

}  

# Still to do
# for lloyd trees
# for clade trees

#----------------------------------------------------------------
# Run models for all the clade trees
#----------------------------------------------------------------
