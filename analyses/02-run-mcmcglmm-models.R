# Run MCMCglmm models
# Run all the models on all trees
# Natalie Cooper Apr 2019
# Modified Sept 2020

#------------------------------------
# Load libraries and source functions
#------------------------------------
library(MCMCglmm)
library(ape)
library(tidyverse)
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
# Create empty output dataframes
#----------------------------------------------------------------
# Extract list of trees from folder
tree.list <- list.files("data/trees", pattern = ".nex")

# Make output files # 17 trees
output <- make_mcmc_output(ntrees = 900)
output2 <- make_mcmc_output_intercept(ntrees = 900)
output3 <- make_mcmc_output(ntrees = 900)
#----------------------------------------------------------------
# Run models
#----------------------------------------------------------------
tree.no <- 1 # start counter

for(i in 1:length(tree.list)){
  
  # Read in tree
  tree <- read.nexus(paste0("data/trees/", tree.list[[i]]))
  
  # Run on all 100 dated trees
  for(j in 1:100){
      
      tree1 <- tree[[j]]
      tree1$node.label <- NULL
      
      # Load the node count data
      # Note this breaks if you use read_csv
      nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", 
                                        tree.list[i], "_", j, ".csv"))
      
      # Run the models
      model.outputs <- run_three_models(tree1, nodecount.data, prior, nitt, thin, burnin)
      model.outputs2 <- run_three_models_intercept(tree1, nodecount.data, prior, nitt, thin, burnin)
      model.outputs3 <- run_three_models_offset(tree1, nodecount.data, prior, nitt, thin, burnin)
      
      # Add model outputs
      output <- add_mcmc_output(output, null.model = model.outputs[[1]], 
                                slow.model = model.outputs[[2]], 
                                asym.model = model.outputs[[3]], 
                                tree.no = tree.no,
                                tree.name = tree.list[i])
      
      output2 <- add_mcmc_output_intercept(output2, null.model = model.outputs2[[1]], 
                                           slow.model = model.outputs2[[2]], 
                                           asym.model = model.outputs2[[3]], 
                                           tree.no = tree.no,
                                           tree.name = tree.list[i])
      
      output3 <- add_mcmc_output(output3, null.model = model.outputs3[[1]], 
                                slow.model = model.outputs3[[2]], 
                                asym.model = model.outputs3[[3]], 
                                tree.no = tree.no,
                                tree.name = tree.list[i])
      
      # Save the outputs
      write_csv(output, path = "outputs/mcmcglmm_outputs.csv")
      write_csv(output2, path = "outputs/mcmcglmm_outputs_intercepts.csv")
      write_csv(output3, path = "outputs/mcmcglmm_outputs_offset.csv")
      
      # Add to counter
      tree.no <- tree.no + 1
    }
}