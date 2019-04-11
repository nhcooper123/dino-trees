# Extinction Rates of the Dinosaurs (working title)

*This README is a work in progress...*

Author(s): Joseph Bonsor, Tom Raven, [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk), Paul Barrett.  

This repository contains all the code and data used in the manuscript [Link to final published pdf will be here]().

To cite the paper: 
> Joseph Bonsor, Tom Raven, Paul Barrett \& Natalie Cooper. 2017. TITLE [Journal tbc].

To cite this repo: 
> Joseph Bonsor \& Natalie Cooper. 2017. GitHub: NaturalHistoryMuseum/dino-trees: Release for publication. DOI.


## Data
These analyses are based on the dinosaur phylogeny of Lloyd et al 2008 (REF). 
To aid reproducibility we include all our simulated trees in this GitHub repo in the `data/trees` folder, and all the node count and time elapsed data from these trees in the `data/nodecounts` folder. However, we include the code used to produce these too (see below).

## Analyses
All code used to run analyses and make figures is included in the `analyses/` folder. Functions are in the `functions/` folder. Before starting remember to either set your working directory to the **dino-trees** folder on your computer, or open an RStudio project from that folder.

### Required packages
* ape
* geiger
* MCMCglmm 
* picante
* purrr

### Required functions (in the `functions/` folder)
* branch_in_period.R         
* break_branches_select_age.R 
* extract_clade_trees.R      
* get_node_count.R            
* make_trees.R                
* run_mcmcglmm.R

### Required data
* phylogenetic tree
* dataframe containing taxon names, time elapsed and node counts

## Running the analyses 
The main analyses are in two scripts:

1. 01-making-trees.R. This script creates 50 simulated trees for each of 1%, 5%, 10%, 25% and 50% taxa (out of the 420 original taxa) added. It splits each tree into the three main dinosaur clades. It then extracts node counts and time elapsed data for each species in each tree. Trees are written out to the `data/trees` folder, node count and time elapsed data to the `data/nodecounts/` folder. 
2. 02-running-models.R. This script runs the three models on each of the simulated trees, the original tree, and all the trees split into the three main dinosaur clades. It outputs a csv file with all the required MCMCglmm outputs for all 1004 trees. *WARNING This takes a VERY LONG time to run*. I've not had time to optimise the code very well. So if you decide to run these models be prepared to wait for a week or so... (sorry!).

## Functions
A brief description of the functions included in the repo is below.

* branch_in_period.R         
* break_branches_select_age.R 

These functions select branches of the phylogeny that are within a user specified age range

* extract_clade_trees.R      
* get_node_count.R            
* make_trees.R                
* run_mcmcglmm.R

## Session Info
For reproducibility purposes, here is the output of `devtools:session_info()` used to perform the analyses in the publication.

## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2017-08-17") 
```