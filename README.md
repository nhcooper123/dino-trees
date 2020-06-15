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

* Arbour, V., Zanno, L. & Gates, T.A. 2016. Ankylosaurian dinosaur palaeoenvironmental associations were influenced by extirpation, sea-level fluctuation, and geodispersal. Palaeogeography Palaeoclimatology Palaeoecology, 449: 289-299.
* Benson, R.B., Campione, N.E., Carrano, M.T., Mannion, P.D., Sullivan, C., Upchurch, P. and Evans, D.C., 2014. Rates of dinosaur body mass evolution indicate 170 million years of sustained ecological innovation on the avian stem lineage. PLoS Biology, 12(5).
* Carballido, J.L., Pol, D., Otero, A., Cerda, I.A., Salgado, L., Garrido, A.C., Ramezani, J., Cúneo, N.R. And Krause, J.M. 2017. A new giant titanosaur sheds light on body mass evolution among sauropod dinosaurs. Proceedings of the Royal Society B: Biological Sciences, 284,  20171219–10.
* Cau, A., Brougham, T. And Naish, D. 2015. The phylogenetic affinities of the bizarre Late Cretaceous Romanian theropod Balaur bondoc (Dinosauria, Maniraptora): dromaeosaurid or flightless bird? PeerJ, 3, 1032–1036.
* Chiba, K., Ryan, M.J., Fanti, F., Loewen, M.A. And Evans, D.C. 2018. New material and systematic re-evaluation of Medusaceratops lokii (Dinosauria, Ceratopsidae) from the Judith River Formation (Campanian, Montana). Journal of Paleontology, 92, 272–288.
* Cruzado-Caballero, P. and Powell, J. 2017. Bonapartesaurus rionegrensis, a new hadrosaurine dinosaur from South America: implications for phylogenetic and biogeographic relations with North America. Journal of Vertebrate Paleontology, 37, e1289381–17.
* Gonzàlez Riga, B.J., Mannion, P.D., Poropat, S.F., Ortiz David, L.D. & Pedro Coria, J. 2018. Osteology of the Late Cretaceous Argentinean sauropod dinosaur Mendozasaurus neguyelap: implications for basal titanosaur relationships. Zoological Journal of the Linnean Society, 184, 136-181
* Lloyd, G.T. Davis, K.E., Pisani, D., Tarver, J.E., Ruta, M., Sakamoto, M., Hone, D.W.E, Jennings, R., & Benton, M.J. 2008. Dinosaurs and the Cretaceous Terrestrial Revolution. Proc. Roy. Soc. B: Biol. Sci., 275: 2483–2490.
* Mallon, J.C., Ott, C.J., Larson, P.L., Iuliano, E.M. & Evans, D.C. 2016. Spicylpeus shipporum, gen. et sp. Nov., a Boldly Audacious New Chasmosaurine Ceratopsid (Dinosauria: Ornithischia) from the Judith River Formation (Upper Cretaceous: Campanian) of Montana, USA. PLoS ONE 11(5): e0154218
* Raven, T.J. & Maidment, S.C.R. 2017. A new phylogeny of Stegosauria (Dinosauria, Ornithischia). Palaeontology, 60: 401-408.
* Thompson, R.S., Parish, J.C., Maidment, S.C.R. & Barrett, P.M. 2012. Phylogeny of the ankylosaurian dinosaurs (Ornithischia: Thyreophora). Journal of Systematic Palaeontology, 10, 301-312.

Sakamoto, M., Benton, M.J. & Venditti, C. 2016. Dinosaurs in decline tens of millions of
years before their final extinction. Proc. Natl. Acad. Sci. USA, 113: 5036–5040.

To aid reproducibility we include all trees and dates in the `data/trees_TNT` and `data\trees_dates` folders - please cite the original papers if you use these. The dated trees are available in the `data\trees` folder. To produce the dated trees we took the published NEXUS matrices and recreated the trees in TNT (following the exact same procedure as in the original papers), then took max and min ages from PBDB and used paleotree to date them.

The node count and time elapsed data from these trees in the `data/nodecounts` folder. 

## Analyses
All code used to run analyses and make figures is included in the `analyses/` folder. Functions are in the `functions/` folder. Before starting remember to either set your working directory to the **dino-trees** folder on your computer, or open an RStudio project from that folder.

### Required functions (in the `functions/` folder)
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
checkpoint("2019-08-17") 
```
