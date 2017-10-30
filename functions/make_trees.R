# Function to create new trees with X taxa added
# Requires break_branches_select_age and extract_clade_trees
# Plus ape

create_new_trees <- function(tree, number.to.add, min.branch.length, 
                             youngest.date, oldest.date, path, simulation.name,
                             split.by.clade = TRUE, data = NULL, 
                             species.col.name  = NULL, clade.col.name = NULL){
  
  # Add X taxa to tree 
  new.tree <- break_branches_select_age(tree, number.to.add = number.to.add, 
                                        min.branch.length = min.branch.length, 
                                        youngest.date = youngest.date, 
                                        oldest.date = oldest.date)
  
  # Write tree to file
  write.tree(new.tree, paste0(path, simulation.name, ".tre"))
  
  # Split new tree into constitutent clades
  # Unless option is turned off
  if(split.by.clade == TRUE){
    tree.list <- extract_clade_trees(new.tree, data, species.col.name, clade.col.name)
  # Write clade trees to file
    write.tree(phy = tree.list, 
               file = paste0(path, simulation.name, "_clades.tre"), 
               tree.names = TRUE)
  }
}

#---------------------------------------------------------------------------------------
# Function to get node counts for trees
# Requires get_node_count
# Plus picante

create_node_counts <- function(tree, path, simulation.name){
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste0(path, simulation.name, ".csv"))
}