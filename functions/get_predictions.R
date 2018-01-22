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
# Extract speciation rates
# There's an apply solution but my brain
# can't work it out!
#---------------------------------------
get_speciation_rates <- function(prediction.ds){
  prediction.ds$speciation <- rep("NA", length(prediction.ds[, 1]))
  for(x in 1:(length(add1[, 1]) - 1)){
    prediction.ds$speciation[x + 1] <- prediction.ds$newY[x + 1] - prediction.ds$newY[x]
  }
  return(prediction.ds)
}
  