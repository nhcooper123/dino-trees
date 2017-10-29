library(ape)
library(MCMCglmm)

#make 100 trees with x% of taxa added
for(x in 1:100){
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree10 <- break_branches_select_age(tree, number.to.add = 42, min.branch.length = 5, 
                            youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree10, paste("Runs/Outputs/simulations/trees/10_taxa/10_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree20 <- break_branches_select_age(tree, number.to.add = 84, min.branch.length = 5, 
                              youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree20, paste("Runs/Outputs/simulations/trees/20_taxa/20_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree30 <- break_branches_select_age(tree, number.to.add = 122, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree30, paste("Runs/Outputs/simulations/trees/30_taxa/30_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree40 <- break_branches_select_age(tree, number.to.add = 168, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree40, paste("Runs/Outputs/simulations/trees/40_taxa/40_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree50 <- break_branches_select_age(tree, number.to.add = 210, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree50, paste("Runs/Outputs/simulations/trees/50_taxa/50_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree60 <- break_branches_select_age(tree, number.to.add = 252, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree60, paste("Runs/Outputs/simulations/trees/60_taxa/60_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree70 <- break_branches_select_age(tree, number.to.add = 294, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree70, paste("Runs/Outputs/simulations/trees/70_taxa/70_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree80 <- break_branches_select_age(tree, number.to.add = 336, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree80, paste("Runs/Outputs/simulations/trees/80_taxa/80_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree90 <- break_branches_select_age(tree, number.to.add = 378, min.branch.length = 5, 
                                          youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree90, paste("Runs/Outputs/simulations/trees/90_taxa/90_new_tree", x, ".tre", sep = "_"))
  
  tree <- read.tree("Runs/lloyd_midpoint.tre")
  new_tree100 <- break_branches_select_age(tree, number.to.add = 420, min.branch.length = 5, 
                                           youngest.date = 83.6, oldest.date = 100.5)
  write.tree(new_tree100, paste("Runs/Outputs/simulations/trees/100_taxa/100_new_tree", x, ".tre", sep = "_"))
  
}


#Run nodecount script on all the newly produced trees
for(i in 1:100){
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/10_taxa/10_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/10_taxa/10_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/20_taxa/20_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/20_taxa/20_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/30_taxa/30_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/30_taxa/30_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/40_taxa/40_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/40_taxa/40_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/50_taxa/50_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/50_taxa/50_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/60_taxa/60_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/60_taxa/60_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/70_taxa/70_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/70_taxa/70_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/80_taxa/80_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/80_taxa/80_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/90_taxa/90_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/90_taxa/90_nodecount", i, ".csv", sep = "_"))
  
  tree <- read.tree(paste("Runs/Outputs/simulations/trees/100_taxa/100_new_tree", i, ".tre", sep = "_"))
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste("Runs/Outputs/simulations/nodecounts/100_taxa/100_nodecount", i, ".csv", sep = "_"))
  
}


alltrees <- list.files("all_trees/")
allnodecounts <- list.files("all_nodecounts/")

#define data table for model output
mydat <- array(dim = c(1000,20))
colnames(mydat) <- c("ID", "null_DIC","slow_DIC", "asym_DIC", "null_post_mean", "null_L-95%_CI", "null_U-95%_CI", "null_eff_samp", "null_pMCMC", "slow_post_mean", "slow_L-95%_CI", "slow_U-95%_CI", "slow_eff_samp", "slow_pMCMC", "asym_post_mean", "asym_post_mean(sqrt)", "asym_L-95%_CI", "asym_U-95%_CI", "asym_eff_samp", "asym_pMCMC")

# simple function to retrieve DIC from MCMCglmm object
DIC.MCMCglmm <- function(x){return(x$DIC)}

#set up models outside of script
null_model <-  nodecount ~ 0 + time_elapsed
slow <-  nodecount ~ 0 + time_elapsed + time_elapsed^2
asym <-  nodecount ~ 0 + time_elapsed + sqrt(time_elapsed)

# set priors
prior1 <- list(R = list(V=1, nu=0.002), G=list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 25^2)))
# set number of iterations
nitt <- 1E06
# set sampling interval
thin <- 1E03
# set burnin
burnin <- 1E05

#run models for all the new trees
for(i in 1:length(alltrees)){
  
  #load the tree, dataset (nodecount) and create an inverse model for the tree
  
  tree <- read.tree(file = alltrees[i])
  dm <- read.csv(allnodecounts[i])
  
  #tree <- read.tree(paste("Runs/Outputs/simulations/trees/10_taxa/10_new_tree", i, ".tre", sep = "_"))
  #dm <- read.csv(paste("Runs/Outputs/simulations/nodecounts/10_taxa/10_nodecount", i, ".csv", sep = "_"))
  inv <- inverseA(tree, scale = FALSE)$Ainv

  
  new_null <- MCMCglmm(null_model, data = dm, random = ~ taxon,
                             ginverse = list(taxon = inv), family = "poisson", prior = prior1,
                             nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  save(new_null, file = paste("models/null", alltrees[i], i, ".rda", sep = "_"))
  
  new_slow <- MCMCglmm(slow, data = dm, random = ~ taxon,
                             ginverse = list(taxon = inv), family = "poisson", prior = prior1,
                             nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  save(new_slow, file= paste("models/slow", alltrees[i], i, ".rda", sep = "_"))
  
  new_asym <- MCMCglmm(asym, data = dm, random = ~ taxon,
                             ginverse = list(taxon = inv), family = "poisson", prior = prior1,
                             nitt = nitt, thin = thin, burnin = burnin, pl = TRUE)
  save(new_asym, file= paste("models/asym", alltrees[i], i, ".rda", sep = "_"))
  
  
  mydat[i, 1] <- i
  mydat[i, 2] <- DIC.MCMCglmm(new_null)[[1]]
  mydat[i, 3] <- DIC.MCMCglmm(new_slow)[[1]]
  mydat[i, 4] <- DIC.MCMCglmm(new_asym)[[1]]
  
  nF <- new_null$Fixed$nfl
  
  mydat[i, 5] <- colMeans(new_null$Sol[, 1:new_null$Fixed$nfl, drop = FALSE])
  mydat[i, 6] <- coda::HPDinterval(new_null$Sol[, 1:nF, drop = FALSE])[1]
  mydat[i, 7] <- coda::HPDinterval(new_null$Sol[, 1:nF, drop = FALSE])[2]
  mydat[i, 8] <- effectiveSize(new_null$Sol[, 1:nF, drop = FALSE])[[1]]
  mydat[i, 9]<- 2 * 
    pmax(0.5/dim(new_null$Sol)[1], pmin(colSums(new_null$Sol[, 
                                                         1:nF, drop = FALSE] > 0)/dim(new_null$Sol)[1], 
                                      1 - colSums(new_null$Sol[, 1:nF, drop = FALSE] > 
                                                    0)/dim(new_null$Sol)[1]))
  
  nF <- new_slow$Fixed$nfl
  
  mydat[i, 10] <- colMeans(new_slow$Sol[, 1:new_slow$Fixed$nfl, drop = FALSE])
  mydat[i, 11] <- coda::HPDinterval(new_slow$Sol[, 1:nF, drop = FALSE])[1]
  mydat[i, 12] <- coda::HPDinterval(new_slow$Sol[, 1:nF, drop = FALSE])[2]
  mydat[i, 13] <- effectiveSize(new_slow$Sol[, 1:nF, drop = FALSE])[[1]]
  mydat[i, 14] <- 2 * 
    pmax(0.5/dim(new_slow$Sol)[1], pmin(colSums(new_slow$Sol[, 
                                                         1:nF, drop = FALSE] > 0)/dim(new_slow$Sol)[1], 
                                      1 - colSums(new_slow$Sol[, 1:nF, drop = FALSE] > 
                                                    0)/dim(new_slow$Sol)[1]))
  
  nF <- new_asym$Fixed$nfl
  
  mydat[i, 15] <- colMeans(new_asym$Sol[, 1:new_asym$Fixed$nfl, drop = FALSE])[[1]]
  mydat[i, 16] <- colMeans(new_asym$Sol[, 1:new_asym$Fixed$nfl, drop = FALSE])[[2]]
  mydat[i, 17] <- coda::HPDinterval(new_asym$Sol[, 1:nF, drop = FALSE])[1]
  mydat[i, 18] <- coda::HPDinterval(new_asym$Sol[, 1:nF, drop = FALSE])[2]
  mydat[i, 19] <- effectiveSize(new_asym$Sol[, 1:nF, drop = FALSE])[[1]]
  mydat[i, 20] <- 2 * 
    pmax(0.5/dim(new_asym$Sol)[1], pmin(colSums(new_asym$Sol[, 
                                                         1:nF, drop = FALSE] > 0)/dim(new_asym$Sol)[1], 
                                      1 - colSums(new_asym$Sol[, 1:nF, drop = FALSE] > 
                                                    0)/dim(new_asym$Sol)[1]))[[1]]
  
  
}


summary(new_10_null)
mydat

write.csv(mydat, "mydat.csv")

########################################################################

#post mean
nF <- new_10_null$Fixed$nfl
nL <- new_10_null$Fixed$nll
colMeans(new_10_null$Sol[, 1:new_10_null$Fixed$nfl, drop = FALSE])

#upper and lower CI
coda::HPDinterval(object$Sol[, 1:nF, drop = FALSE])[1]
coda::HPDinterval(object$Sol[, 1:nF, drop = FALSE])[2]

#eff samm
effectiveSize(object$Sol[, 1:nF, drop = FALSE])[[1]]

#pMCMC
2 * 
  pmax(0.5/dim(object$Sol)[1], pmin(colSums(object$Sol[, 
                                                       1:nF, drop = FALSE] > 0)/dim(object$Sol)[1], 
                                    1 - colSums(object$Sol[, 1:nF, drop = FALSE] > 
                                                  0)/dim(object$Sol)[1]))

