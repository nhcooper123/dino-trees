# Requires geiger, purrr, ape
library(geiger)
tree <- read.tree("data/lloyd2008_midpoint.tre")
taxonomy <- read.csv("data/taxonomy.data.csv")

extract_clade_trees <- function(tree, data, species.col.name, clade.col.name){
  
  # Extract column numbers for species and clade names in taxonomy data
  species.col <- columnID(data, species.col.name)
  clade.col <- columnID(data, clade.col.name)
  
  # Sort data
  data <- sort_data_by_tips(tree, data, species.col)
  
  # Extract species in each clade
  clade.species.list <- get_all_clade_species(data, species.col, clade.col, tree)
  
  # Extract trees
  get_clade_trees(clade.species.list, tree)
}


## save trees
  

############################  
# Identify column numbers
columnID <- function(data, column.name) { 
  which(names(data) == column.name)
}	

# Sort taxonomy so it matches order of tips on phylogeny
sort_data_by_tips <- function(tree, data, species.col){
  data[match(tree$tip.label, data[, species.col]), ]
}

# Get list of clades to include
clade_list <- function(data, clade.col){
  as.list(unique(data[, clade.col]))
}

# Get two most extreme taxa in a clade
# Needs data to be ordered like tip labels
extreme_taxa <- function(data, species.col, clade.col, clade){
  taxa <- data[, species.col][data[, clade.col] == clade]
  min.taxon <- taxa[1]
  max.taxon <- taxa[length(taxa)]
  return(list(min.taxon, max.taxon))
}

# Extract extreme taxa for all clades
get_extreme_taxa <- function(data, species.col, clade.col, clade.list) {
  purrr::map(clade.list, extreme_taxa, data = data, species.col = species.col, 
             clade.col = clade.col)
}

# Get most recent common ancestor of extreme species
get_MRCA_extremes <- function(tree, extreme.taxa){
  getMRCA(tree, as.vector(unlist(extreme.taxa)))
}

# Get list with the node numbers of most recent common ancestors and add
# clade names as names on the list
get_clade_node_list <- function(clade.list, data, species.col, clade.col, tree){
  extreme.taxa.list <- purrr::map(clade.list, extreme_taxa, data = data, 
                                  species.col = species.col, clade.col = clade.col)
  clade.node.list <- purrr::map(extreme.taxa.list, get_MRCA_extremes, tree = tree)
  names(clade.node.list) <- unlist(clade.list)
  return(clade.node.list)
}

# Extract species coming from node
get_clade_species <- function(tree, node){
  geiger::tips(tree, node)
}

# Extract species list for each clade
get_clade_species_list <- function(clade.node.list, tree){
  purrr::map(clade.node.list, get_clade_species, tree = tree)
}

# Get species in each clade
get_all_clade_species <- function(data, species.col, clade.col, tree){
  # Get list of clades in taxonomy data
  clade.list <- clade_list(data, clade.col)
  # Extract nodes of mrca of clades
  clade.node.list <- get_clade_node_list(clade.list, data, species.col, clade.col, tree)
  # Extract species in each clade
  get_clade_species_list(clade.node.list, tree)
}
  
# Extract and output tree for clade of interest
get_clade_tree <- function(clade.species, tree){
  clade.of.interest <- match(tree$tip.label, clade.species, nomatch = 0)
  not.clade.species <- tree$tip.label[clade.of.interest == 0]
  drop.tip(tree, not.clade.species)
}

# Extract and output tree for list of clades of interest
# Convert list to multiphylo object
get_clade_trees <- function(clade.species.list, tree){
  tree.list <- purrr::map(clade.species.list, get_clade_tree, tree = tree)
  class(tree.list) <- "multiPhylo"
  return(tree.list)
}

# Write tree from list to file
write_trees_to_file <- function(tree.list, path, tree.name){
  ape::write.tree(phy = tree.to.write, 
                  file = paste0(path, tree.name, ".tre"), 
                  tree.names = TRUE)
}