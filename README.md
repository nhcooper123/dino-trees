# Extinction Rates of the Dinosaurs (working title)

*This README is a work in progress...*

Author(s): Joseph Bonsor, Tom Raven, [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk), Paul Barrett.  

This repository contains all the code and data used in the manuscript [Link to final published pdf will be here]().

To cite the paper: 
> Joseph Bonsor, Tom Raven, Paul Barrett \& Natalie Cooper. 2019. TITLE [Journal tbc].

To cite this repo: 
> Natalie Cooper. 2017. GitHub: NaturalHistoryMuseum/dino-trees: Release for publication. DOI.


## Data
Trees for this analysis came from:

* Benson et al. 2014
* Llloyd et al. 2008
* [finish list and add references]

To aid reproducibility we include all trees and dates in the `data/trees_TNT` and `data\trees_dates` folders - please cite the original papers if you use these. The dated trees are available in the `data\trees` folder. To produce the dated trees we took the published NEXUS matrices and recreated the trees in TNT (following the exact same procedure as in the original papers), then took max and min ages from PBDB and used paleotree to date them.

The node count and time elapsed data from these trees in the `data/nodecounts` folder. 

## Analyses
All code used to run analyses and make figures is included in the `analyses/` folder. Functions are in the `functions/` folder. Before starting remember to either set your working directory to the **dino-trees** folder on your computer, or open an RStudio project from that folder.

### Required functions (in the `functions/` folder)
* extract_clade_trees.R  - this takes a full dinosaur tree and extracts clade trees.    
* get_node_count.R - this extracts node count and time elapsed data from a tree.                       
* run_mcmcglmm.R - this runs the mcmcglmm analyses and extracts outputs.

### Running the analyses 
The main analyses are in two scripts:

1. 01-extract-tree-data.R. This script dates the trees, splits each full Dinosauria tree (Benson and Lloyd trees) into the three main dinosaur clades. It then extracts node counts and time elapsed data for each species in each tree. Trees are written out to the `data/trees` folder, node count and time elapsed data to the `data/nodecounts/` folder. 
2. 02-run-mcmcglmm-models.R. This script runs the three models on each of the trees, both without intercepts and estimating intercepts. It outputs two `csv` file with all the required MCMCglmm outputs for all 17 trees. *WARNING This takes a LONG time to run*. 

## Session Info [to complete]
For reproducibility purposes, here is the output of `devtools:session_info()` used to perform the analyses in the publication.

## Checkpoint for reproducibility [to complete]
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2017-08-17") 
```