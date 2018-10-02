# Analysis - step 1
# Simulate trees and extract node counts
set.seed(1)

# Load libraries and source functions
library(ape)
library(geiger)
library(MCMCglmm)
source("functions/get_node_count.R")
source("functions/make_trees.R")
source("functions/run_mcmcglmm.R")

# Extract list of trees from folder
tree.list <- c("ArbourTree.tre.nex", "CauTree.tre.nex", "ChibaTree.tre.nex", "CruzadoTree.tre.nex",
               "GonzalezRigaTree.tre.nex", "MallonTree.tre.nex", "RavenTree.tre.nex", 
               "ThompsonTreeExclude.tre.nex")

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
output <- make_mcmc_output(ntrees = 8)
output2 <- make_mcmc_output_intercept(ntrees = 8)

#--------------------------------------------------------------------
# Get node counts and run models
#--------------------------------------------------------------------

for (i in 1:length(tree.list)){
  
  #--------------------------------------------------------------------
  # Get node counts
  #--------------------------------------------------------------------
  
  trees <- read.nexus(paste0("data/trees/", tree.list[i]))
  tree <- trees[[sample(1:100, 1)]]
  # Get node counts
  create_node_counts(tree, path = "data/nodecounts/", 
                     simulation.name = paste0("nodecount_", tree.list[i]))

  #----------------------------------------------------------------
  # Analysis step 2
  # Run all the models 
  #----------------------------------------------------------------

  # Get tree number and name
  tree.no <- i
  tree.name <- tree.list[i]
  
  # Load the node count data
  nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", 
                                    tree.list[i], ".csv"))
  
  # Run the models
  model.outputs <- run_three_models(tree1, nodecount.data, prior, nitt, thin, burnin)
  model.outputs2 <- run_three_models_intercept(tree1, nodecount.data, prior, nitt, thin, burnin)
  
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
  write.csv(file = "outputs/mcmcglmm_outputs_newtrees.csv", output, 
            row.names = FALSE, append = TRUE, quote = FALSE)
  
  write.csv(file = "outputs/mcmcglmm_outputs_intercept_newtrees.csv", output2, 
            row.names = FALSE, append = TRUE, quote = FALSE)
}

