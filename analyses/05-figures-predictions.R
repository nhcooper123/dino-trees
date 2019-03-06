# Load libraries
library(tidyverse)
library(MCMCglmm)
library(gridExtra)
source("functions/get_predictions.R")
source("functions/make_prediction_figures.R")
source("functions/make_prediction_figures_intercepts.R")

# Add rphylopic
#install.packages("remotes")
#remotes::install_github("sckott/rphylopic")
library(rphylopic) 

# Colour blind friendly palette
# First is grey
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Add silhouettes
library(png)
img_sauro <- readPNG("outputs/img/sauropod.png")
img_orni <- readPNG("outputs/img/stegosaurus.png")
img_thero <- readPNG("outputs/img/velociraptor.png")

#-----------------------------------------------------------------
# Make figures
# Original trees
make_predictions_figures(treename  = "lloyd2008", rep = "", tree = "",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 1% extra
make_predictions_figures(treename  = "4", rep = "_33", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 5% extra
make_predictions_figures(treename  = "21", rep = "_16", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 10% extra
make_predictions_figures(treename  = "42", rep = "_14", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 25% extra
make_predictions_figures(treename  = "105", rep = "_11", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 50% extra
make_predictions_figures(treename  = "210", rep = "_17", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

#-----------------------------------------------------------------
# Make figures for intercepts models
# Original trees
make_predictions_figures_intercepts(treename  = "lloyd2008", rep = "", tree = "",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 1% extra
make_predictions_figures_intercepts(treename  = "4", rep = "_33", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 5% extra
make_predictions_figures_intercepts(treename  = "21", rep = "_16", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 10% extra
make_predictions_figures_intercepts(treename  = "42", rep = "_14", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 25% extra
make_predictions_figures_intercepts(treename  = "105", rep = "_11", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])

# 50% extra
make_predictions_figures_intercepts(treename  = "210", rep = "_17", tree = "tree_",
                         col1 = cbPalette[4], col2 = cbPalette[3])