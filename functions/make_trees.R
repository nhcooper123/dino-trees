# Helper functions to create new trees with X taxa added
# and to get node counts of these trees

# Requires break_branches_select_age, extract_clade_trees and get_node_count
# Plus ape and picante

#-----------------------------------------------------------------------------------
# Simulate trees with extra taxa
#-----------------------------------------------------------------------------------

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
# Extract node counts for trees
#---------------------------------------------------------------------------------------

create_node_counts <- function(tree, path, simulation.name){
  nodecount <- get_node_count(tree)
  write.csv(nodecount, paste0(path, simulation.name, ".csv"))
}