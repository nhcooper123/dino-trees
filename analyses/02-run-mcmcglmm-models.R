# Run MCMCglmm models
# Run all the models on all trees
# Natalie Cooper Apr 2019

#------------------------------------
# Load libraries and source functions
#------------------------------------
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
# Create empty output dataframes
#----------------------------------------------------------------
# Extract list of trees from folder
tree.list <- list.files("data/trees", pattern = ".nex")

# Make output files # 17 trees
output <- make_mcmc_output(ntrees = 2100)
output2 <- make_mcmc_output_intercept(ntrees = 2100)

#----------------------------------------------------------------
# Run models
#----------------------------------------------------------------
tree.no <- 0 # start counter

for(i in 1:length(tree.list)){
  
  tree.no <- tree.no + 1
  
  # Read in tree
  tree <- read.nexus(paste0("data/trees/", tree.list[[i]]))
  
  # If there is > 1 tree then run on all 100 dated trees
  if(class(tree) == "multiPhylo"){
    
    for(j in 1:100){
      
      tree1 <- tree[[j]]
      
      # Load the node count data
      # Note this breaks if you use read_csv
      nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", 
                                        tree.list[i], "_", j, ".csv"))
      
      # Run the models
      model.outputs <- run_three_models(tree1, nodecount.data, prior, nitt, thin, burnin)
      model.outputs2 <- run_three_models_intercept(tree1, nodecount.data, prior, nitt, thin, burnin)
      
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
      
      # Save the outputs
      write_csv(output, path = "outputs/mcmcglmm_outputs.csv")
      write_csv(output2, path = "outputs/mcmcglmm_outputs_intercepts.csv")
      
      # Add to counter
      tree.no <- tree.no + 1
    }
  }
  else{
    
    # Load the node count data
    # Note this breaks if you use read_csv
    nodecount.data <- read.csv(paste0("data/nodecounts/nodecount_", 
                                      tree.list[i], "_", j, ".csv"))
    
    # Run the models
    model.outputs <- run_three_models(tree, nodecount.data, prior, nitt, thin, burnin)
    model.outputs2 <- run_three_models_intercept(tree, nodecount.data, prior, nitt, thin, burnin)
    
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
    
    # Save the outputs
    write_csv(output, path = "outputs/mcmcglmm_outputs.csv")
    write_csv(output2, path = "outputs/mcmcglmm_outputs_intercepts.csv")
  }
}
