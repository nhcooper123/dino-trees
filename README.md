# Extinction Rates of the Dinosaurs

### Required packages: ape, MCMCglmm

### Data required: Phylogenetic tree, data table containing taxon names, time elapsed and nodecount.

* This README is a work in progress... *

These scripts are designed to break up long branches on a phylogenetic tree to fill in gaps left by missing fossil taxa. The hypothetical taxa are inserted to represent new finds filling in the fossil record.

Initial loading of functions within R environment:

1.	Load the functions “make_age_data” and “branch_in_period” from the “1_Get_data.R” script.
2.	Load the function “break_branches_select_age” from the 2_Break_Branches_in_Gap.R” script.
3.	Load the function “get_node_count” from the “3_Nodecount.R” script.

The loops contained within the script “4_repeat_runs.R” takes the original tree and adds a specified amount of new taxa (for example, increments of 10%) to break up long branches within a specified time period. 

The next part of the script then runs “get_node_count” on all the newly generated trees and produces spreadsheets containing the data required for running the models.

The models are then run on all the newly generated trees and data files and the values extracted from the produced MCMCglmms and used to populate a spreadsheet.
