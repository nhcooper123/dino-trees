# Functions to get MCMCglmm running and get outputs
# Natalie Cooper Oct 2017

# Requires MCMCglmm and coda

# Main function (run_three_models) requires a dataframe of node counts, with column headings
# species, nodecount, and time (could change this to make it more flexible).
# Also needs the accompanying tree
# The function runs all three models needed - null, slowdown and asymptote.

# Other functions make the process of extracting outputs from MCMCglmm
# models made using run_three_models easier, and automates the input of 
# these into a dataframe.

#------------------------------------------------------
# Run each of the three models on a tree
#------------------------------------------------------
run_three_models <- function(tree, nodecount.data, prior, nitt, thin, burnin){
  
  # Inverse tree vcv matrix for glmm
  inv <- inverseA(tree, scale = FALSE)$Ainv
  
  # Fit null model
  null <- MCMCglmm(nodecount ~ 0 + time, 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit slowdown model
  # Create new time^2 variable
  nodecount.data$time2 <- nodecount.data$time^2
  slow <- MCMCglmm(nodecount ~ 0 + time + time2, 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit asymptote model
  asym <- MCMCglmm(nodecount ~ 0 + sqrt(time), 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  return(list(null, slow, asym))
}


#---------------------------------------------------------------
# Run each of the three models on a tree with variable intercept
#----------------------------------------------------------------
run_three_models_intercept <- function(tree, nodecount.data, prior, nitt, thin, burnin){
  
  # Inverse tree vcv matrix for glmm
  inv <- inverseA(tree, scale = FALSE)$Ainv
  
  # Fit null model
  null <- MCMCglmm(nodecount ~ time, 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit slowdown model
  # Create new time^2 variable
  nodecount.data$time2 <- nodecount.data$time^2
  slow <- MCMCglmm(nodecount ~ time + time2, 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit asymptote model
  asym <- MCMCglmm(nodecount ~ sqrt(time), 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  return(list(null, slow, asym))
}

#--------------------------------------------------------
# MCMC outputs
#--------------------------------------------------------
# DIC from MCMCglmm object
get_dic <- function(model){
  return(model$DIC)
}

# Get nF for other calculations
get_nf <- function(model){
  model$Fixed$nfl
}

# Posterior mean
get_post_mean <- function(model){
  nF <- get_nf(model)
  colMeans(model$Sol[, 1:model$Fixed$nfl, drop = FALSE])
}

# Upper 95% CI
get_upper_conf_intervals <- function(model){
  nF <- get_nf(model)
  coda::HPDinterval(model$Sol[, 1:nF, drop = FALSE])[,'upper']
}

# Lower 95% CIs
get_lower_conf_intervals <- function(model){
  nF <- get_nf(model)
  coda::HPDinterval(model$Sol[, 1:nF, drop = FALSE])[,'lower']
}  
  
# Effective sample size
get_ess <- function(model){
  nF <- get_nf(model)
  effectiveSize(model$Sol[, 1:nF, drop = FALSE])[[1]]
}

# pMCMC

get_pMCMC <- function(model){
  nF <- get_nf(model)
  2 * pmax(0.5/dim(model$Sol)[1], pmin(colSums(model$Sol[, 1:nF, drop = FALSE] > 0)
                                     /dim(model$Sol)[1], 
                                     1 - colSums(model$Sol[, 1:nF, drop = FALSE] > 
                                     0)/dim(model$Sol)[1]))
}

#--------------------------------------------------------
# MCMC output files to save
#--------------------------------------------------------
# Define dataframe for model output
make_mcmc_output <- function(ntrees){
  output <- data.frame(array(dim = c(ntrees, 23)))
  colnames(output) <- c("tree.ID", "tree", "null_DIC","slow_DIC", "asym_DIC", 
                        "null_post_mean", "null_lower95_CI", "null_upper95_CI", 
                        "null_ess", "null_pMCMC", 
                        "slow_post_mean", "slow_post_mean_2" ,
                        "slow_lower95_CI", "slow_upper95_CI", 
                        "slow_lower95_CI_2", "slow_upper95_CI_2",
                        "slow_ess", "slow_pMCMC", 
                        "asym_post_mean_sqrt", 
                        "asym_lower95_CI_sqrt", "asym_upper95_CI_sqrt", 
                        "asym_ess", "asym_pMCMC")
  return(output)
}

# Add model outputs to dataframe
add_mcmc_output <- function(output, null.model, slow.model, asym.model, tree.no, tree.name){
  
  # Add ID 
  output$tree.ID[tree.no] <- tree.no
  output$tree[tree.no] <- tree.name
  
  # DIC for all three models
  output$null_DIC[tree.no] <- get_dic(null.model)[[1]]
  output$slow_DIC[tree.no] <- get_dic(slow.model)[[1]]
  output$asym_DIC[tree.no] <- get_dic(asym.model)[[1]]
  
  # Outputs for null
  output$null_post_mean[tree.no] <- get_post_mean(null.model)
  output$null_lower95_CI[tree.no] <- get_lower_conf_intervals(null.model)
  output$null_upper95_CI[tree.no] <- get_upper_conf_intervals(null.model)
  output$null_ess[tree.no] <- get_ess(null.model)
  output$null_pMCMC[tree.no]<- get_pMCMC(null.model)
  #saveRDS(null.model, file = paste0("outputs/", tree.name, tree.no, "_null.rds"))
  
  # Outputs for slow down
  output$slow_post_mean[tree.no] <- get_post_mean(slow.model)[[1]]
  output$slow_post_mean_2[tree.no] <- get_post_mean(slow.model)[[2]]
  output$slow_lower95_CI[tree.no] <- get_lower_conf_intervals(slow.model)[[1]]
  output$slow_upper95_CI[tree.no] <- get_upper_conf_intervals(slow.model)[[1]]
  output$slow_lower95_CI_2[tree.no] <- get_lower_conf_intervals(slow.model)[[2]]
  output$slow_upper95_CI_2[tree.no] <- get_upper_conf_intervals(slow.model)[[2]]
  output$slow_ess[tree.no] <- get_ess(slow.model)
  output$slow_pMCMC[tree.no]<- get_pMCMC(slow.model)[[1]]
  #saveRDS(slow.model, file = paste0("outputs/", tree.name, tree.no, "_slow.rds"))
  
  # Outputs for asymtote
  output$asym_post_mean_sqrt[tree.no] <- get_post_mean(asym.model)
  output$asym_lower95_CI_sqrt[tree.no] <- get_lower_conf_intervals(asym.model)
  output$asym_upper95_CI_sqrt[tree.no] <- get_upper_conf_intervals(asym.model)
  output$asym_ess[tree.no] <- get_ess(asym.model)
  output$asym_pMCMC[tree.no]<- get_pMCMC(asym.model)[[1]]
  #saveRDS(asym.model, file = paste0("outputs/", tree.name, tree.no, "_asym.rds"))
  
  return(output)
}

#--------------------------------------------------------
# MCMC output files to save for intercept models
#--------------------------------------------------------
# Define dataframe for model output
make_mcmc_output_intercept <- function(ntrees){
  output <- data.frame(array(dim = c(ntrees, 32)))
  colnames(output) <- c("tree.ID", "tree", "null_DIC","slow_DIC", "asym_DIC", 
                        "null_post_mean_intercept", "null_post_mean",
                        "null_lower95_CI_intercept", "null_upper95_CI_intercept", 
                        "null_lower95_CI", "null_upper95_CI",
                        "null_ess", "null_pMCMC", 
                        "slow_post_mean_intercept", "slow_post_mean", "slow_post_mean_2" ,
                        "slow_lower95_CI_intercept", "slow_upper95_CI_intercept",
                        "slow_lower95_CI", "slow_upper95_CI", 
                        "slow_lower95_CI_2", "slow_upper95_CI_2",
                        "slow_ess", "slow_pMCMC", 
                        "asym_post_mean_intercept", "asym_post_mean_sqrt", 
                        "asym_lower95_CI_intercept", "asym_upper95_CI_intercept", 
                        "asym_lower95_CI_sqrt", "asym_upper95_CI_sqrt",
                        "asym_ess", "asym_pMCMC")

  return(output)
}

# Add model outputs to dataframe
add_mcmc_output_intercept <- function(output, null.model, slow.model, asym.model, tree.no, tree.name){
  
  # Add ID 
  output$tree.ID[tree.no] <- tree.no
  output$tree[tree.no] <- tree.name
  
  # DIC for all three models
  output$null_DIC[tree.no] <- get_dic(null.model)[[1]]
  output$slow_DIC[tree.no] <- get_dic(slow.model)[[1]]
  output$asym_DIC[tree.no] <- get_dic(asym.model)[[1]]
  
  # Outputs for null
  nF <- get_nf(null.model)
  output$null_post_mean_intercept[tree.no] <- get_post_mean(null.model)[[1]]
  output$null_post_mean[tree.no] <- get_post_mean(null.model)[[2]]
  output$null_lower95_CI_intercept[tree.no] <- get_lower_conf_intervals(null.model)[[1]]
  output$null_upper95_CI_intercept[tree.no] <- get_upper_conf_intervals(null.model)[[1]]
  output$null_lower95_CI[tree.no] <- get_lower_conf_intervals(null.model)[[2]]
  output$null_upper95_CI[tree.no] <- get_upper_conf_intervals(null.model)[[2]]
  output$null_ess[tree.no] <- get_ess(null.model)
  output$null_pMCMC[tree.no]<- get_pMCMC(null.model)[[1]]
  #saveRDS(null.model, file = paste0("outputs/", tree.name, tree.no, "_null_intercepts.rds"))
  
  # Outputs for slow down
  nF <- get_nf(slow.model)
  output$slow_post_mean_intercept[tree.no] <- get_post_mean(slow.model)[[1]]
  output$slow_post_mean[tree.no] <- get_post_mean(slow.model)[[2]]
  output$slow_post_mean_2[tree.no] <- get_post_mean(slow.model)[[3]]
  output$slow_lower95_CI_intercept[tree.no] <- get_lower_conf_intervals(slow.model)[[1]]
  output$slow_upper95_CI_intercept[tree.no] <- get_upper_conf_intervals(slow.model)[[1]]
  output$slow_lower95_CI[tree.no] <- get_lower_conf_intervals(slow.model)[[2]]
  output$slow_upper95_CI[tree.no] <- get_upper_conf_intervals(slow.model)[[2]]
  output$slow_lower95_CI_2[tree.no] <- get_lower_conf_intervals(slow.model)[[3]]
  output$slow_upper95_CI_2[tree.no] <- get_upper_conf_intervals(slow.model)[[3]]
  output$slow_ess[tree.no] <- get_ess(slow.model)
  output$slow_pMCMC[tree.no]<- get_pMCMC(slow.model)[[1]]
  #saveRDS(slow.model, file = paste0("outputs/", tree.name, tree.no, "_slow_intercepts.rds"))
  
  # Outputs for asymtote
  nF <- get_nf(asym.model)
  output$asym_post_mean_intercept[tree.no] <- get_post_mean(asym.model)[[1]]
  output$asym_post_mean_sqrt[tree.no] <- get_post_mean(asym.model)[[2]]
  output$asym_lower95_CI_intercept[tree.no] <- get_lower_conf_intervals(asym.model)[[1]]
  output$asym_upper95_CI_intercept[tree.no] <- get_upper_conf_intervals(asym.model)[[1]]
  output$asym_lower95_CI_sqrt[tree.no] <- get_lower_conf_intervals(asym.model)[[2]]
  output$asym_upper95_CI_sqrt[tree.no] <- get_upper_conf_intervals(asym.model)[[2]]
  output$asym_ess[tree.no] <- get_ess(asym.model)
  output$asym_pMCMC[tree.no]<- get_pMCMC(asym.model)[[1]]
  #saveRDS(asym.model, file = paste0("outputs/", tree.name, tree.no, "_asym_intercepts.rds"))
  
  return(output)
}

#---------------------------------------------------------------
# Run each of the three models on a tree with intercept set to 1.0
#----------------------------------------------------------------
run_three_models_offset <- function(tree, nodecount.data, prior, nitt, thin, burnin){
  
  # Add a new column to the data specifying the intercept of 1
  nodecount.data$intercept <- rep(1, length(nodecount.data$nodecount))
  
  # Inverse tree vcv matrix for glmm
  inv <- inverseA(tree, scale = FALSE)$Ainv
  
  # Fit null model
  null <- MCMCglmm(nodecount ~ 0 + time + offset(intercept), 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit slowdown model
  # Create new time^2 variable
  nodecount.data$time2 <- nodecount.data$time^2
  slow <- MCMCglmm(nodecount ~ 0 + time + time2 + offset(intercept), 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  # Fit asymptote model
  asym <- MCMCglmm(nodecount ~ 0 + sqrt(time) + offset(intercept), 
                   data = nodecount.data, random = ~ species,
                   ginverse = list(species = inv), family = "poisson", prior = prior,
                   nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  
  return(list(null, slow, asym))
}
