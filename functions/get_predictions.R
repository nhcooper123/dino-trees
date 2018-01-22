# Functions to get MCMCglmm predictions
# Natalie Cooper Jan 2018

# First uses MCMCglmm.predict to extract per million year predicted nodecounts
# then extracts "speciation rates" from these 
# (just nodecount at time t+1 - nodecount at time t)
# for further plotting

# Requires MCMCglmm
#-----------------------------------------------
# Create new x variable for predicting on
# slowdown model requires time2
# All models require time, nodecount and species
#-----------------------------------------------
get_newX <- function(nodecount.data, slowdown = FALSE){
  if(slowdown == FALSE){
  newX <- expand.grid(time = seq(from = 0, to = 177, by = 1),
                      species = nodecount.data$species)
  }else{
  newX <- expand.grid(time = seq(from = 0, to = 177, by = 1),
                      time2 = (seq(from = 0, to = 177, by = 1))^2,
                      species = nodecount.data$species)  
  }
  newX$nodecount <- 0
  return(newX)
}

#---------------------------------------
# Tidying up predictions
# make newY into dataframe and join 
# newX and newY
#---------------------------------------
tidy_predictions <- function(newX, newY){
  newY <- data.frame(newY)
  data.frame(time = newX$time, nodecount = newY$fit, 
             species = newX$species)
}

#---------------------------------------
# Get predictions for each million year
# time bin for one model
# Export tidy dataframe of predictions
#---------------------------------------
get_predictions <- function(model, nodecount.data, slowdown = FALSE){
  if(slowdown == FALSE){
    newX <- get_newX(nodecount.data)
  }else{
    newX <- get_newX(nodecount.data, slowdown = TRUE)  
  }
  newY <- predict.MCMCglmm(model, newdata = newX, type = "response", marginal = ~species) 
  tidy_predictions(newX, newY)
}

#---------------------------------------
# Get predictions for each million year
# time bin for all three models
# Export list of prediction dataframes
#---------------------------------------
get_all_predictions <- function(nodecount.data, null, slow, asym){
  null.ds <- get_predictions(null, nodecount.data)
  slow.ds <- get_predictions(slow, nodecount.data, slowdown = TRUE)
  asym.ds <- get_predictions(asym, nodecount.data)

  return(list(null.ds, slow.ds, aysm.ds))
}

#---------------------------------------
# Extract speciation rates
#---------------------------------------
for(x in 1:99){
xxx <- add1$newY[x + 1] - add1$newY[x]
}
