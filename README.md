# Using phylogenies to assess whether non-avian dinosaur speciation rates were in decline before the Cretaceous-Paleogene (K-Pg) mass extinction
 (working title)

*This README is a work in progress...*

Author(s): Joseph A. Bonsor, Paul M. Barrett, Thomas J. Raven and [Natalie Cooper](mailto:natalie.cooper.@nhm.ac.uk).

This repository contains all the code and data used in the manuscript [Link to final published pdf will be here]().

To cite the paper: 
> Bonsor et al. 2020. TITLE [Journal tbc].

To cite this repo: 
> Natalie Cooper. 2020. GitHub: NaturalHistoryMuseum/dino-trees: Release for publication. DOI.

![alt text](https://github.com/nhcooper123/dino-trees/raw/master/manuscript/outputs/figure-best-models.png)

------

## Data
Trees for these analyses came from:

* Arbour, V., Zanno, L. & Gates, T.A. 2016. Ankylosaurian dinosaur palaeoenvironmental associations were influenced by extirpation, sea-level fluctuation, and geodispersal. Palaeogeography Palaeoclimatology Palaeoecology, 449: 289-299.
* Carballido, J.L., Pol, D., Otero, A., Cerda, I.A., Salgado, L., Garrido, A.C., Ramezani, J., Cúneo, N.R. And Krause, J.M. 2017. A new giant titanosaur sheds light on body mass evolution among sauropod dinosaurs. Proceedings of the Royal Society B: Biological Sciences, 284,  20171219–10.
* Cau, A., Brougham, T. And Naish, D. 2015. The phylogenetic affinities of the bizarre Late Cretaceous Romanian theropod Balaur bondoc (Dinosauria, Maniraptora): dromaeosaurid or flightless bird? PeerJ, 3, 1032–1036.
* Chiba, K., Ryan, M.J., Fanti, F., Loewen, M.A. And Evans, D.C. 2018. New material and systematic re-evaluation of Medusaceratops lokii (Dinosauria, Ceratopsidae) from the Judith River Formation (Campanian, Montana). Journal of Paleontology, 92, 272–288.
* Cruzado-Caballero, P. and Powell, J. 2017. Bonapartesaurus rionegrensis, a new hadrosaurine dinosaur from South America: implications for phylogenetic and biogeographic relations with North America. Journal of Vertebrate Paleontology, 37, e1289381–17.
* Gonzàlez Riga, B.J., Mannion, P.D., Poropat, S.F., Ortiz David, L.D. & Pedro Coria, J. 2018. Osteology of the Late Cretaceous Argentinean sauropod dinosaur Mendozasaurus neguyelap: implications for basal titanosaur relationships. Zoological Journal of the Linnean Society, 184, 136-181
* Mallon, J.C., Ott, C.J., Larson, P.L., Iuliano, E.M. & Evans, D.C. 2016. Spicylpeus shipporum, gen. et sp. Nov., a Boldly Audacious New Chasmosaurine Ceratopsid (Dinosauria: Ornithischia) from the Judith River Formation (Upper Cretaceous: Campanian) of Montana, USA. PLoS ONE 11(5): e0154218
* Raven, T.J. & Maidment, S.C.R. 2017. A new phylogeny of Stegosauria (Dinosauria, Ornithischia). Palaeontology, 60: 401-408.
* Thompson, R.S., Parish, J.C., Maidment, S.C.R. & Barrett, P.M. 2012. Phylogeny of the ankylosaurian dinosaurs (Ornithischia: Thyreophora). Journal of Systematic Palaeontology, 10, 301-312.

To aid reproducibility we include all trees and dates in the `data/trees_TNT` and `data\trees_dates` folders - please cite the original papers if you use these. The dated trees are available in the `data\trees` folder. To produce the dated trees we took the published NEXUS matrices and recreated the trees in TNT (following the exact same procedure as in the original papers), then took max and min ages from PBDB and used paleotree to date them.

We also used the FAD, LAD and midpoint dated trees of Benson et al. (2014) and Lloyd et al. (2008) taken from the supplementary materials of Sakamoto et al. (2016).

* Benson, R.B., Campione, N.E., Carrano, M.T., Mannion, P.D., Sullivan, C., Upchurch, P. and Evans, D.C., 2014. Rates of dinosaur body mass evolution indicate 170 million years of sustained ecological innovation on the avian stem lineage. PLoS Biology, 12(5).
* Lloyd, G.T. Davis, K.E., Pisani, D., Tarver, J.E., Ruta, M., Sakamoto, M., Hone, D.W.E, Jennings, R., & Benton, M.J. 2008. Dinosaurs and the Cretaceous Terrestrial Revolution. Proc. Roy. Soc. B: Biol. Sci., 275: 2483–2490.
* Sakamoto, M., Benton, M.J. & Venditti, C. 2016. Dinosaurs in decline tens of millions of
years before their final extinction. Proc. Natl. Acad. Sci. USA, 113: 5036–5040.

The node count and time elapsed data from these trees are in the `data/nodecounts` folder. 

------
## Analyses
All code used to run analyses and make figures is included in the `analyses/` folder. Functions are in the `functions/` folder. Before starting remember to either set your working directory to the **dino-trees** folder on your computer, or open an RStudio project from that folder.

### Required functions (in the `functions/` folder)
* get_node_count.R - this extracts node count and time elapsed data from a tree.                       
* run_mcmcglmm.R - this runs the mcmcglmm analyses and extracts outputs.

### Running the analyses 
The main analyses are in the following scripts

1. *01A-date-TNT-trees.R*. This script dates the nine new trees. Trees are written out to the `data/trees` folder.
2. *01B-extract-node-counts.R*. This script extracts node counts and time elapsed data for each species in each tree. Node count and time elapsed data are written out to the `data/nodecounts/` folder. 
3. *02-run-mcmcglmm-models.R* and *02B-run-mcmcglmm-models-sakamoto.R*. These scripts run the three models on each of the trees, both without intercepts and estimating intercepts. They each output two `csv` file with all the required MCMCglmm outputs for all trees. *WARNING This takes a LONG time to run*. 
4. *03-figures-dic.R*. This script creates Figures 2 and 4.
5. *04-extract-best-models.R*. This script extracts the best models using DIC from the MCMCglmm outputs.
6. *05-figures-best-models.R*. Creates Figures 3 and 5

-------
## Other folders

* `/outputs` contains the figures and tables
* `/img` contains the silhouettes from from `PhyloPic.org` needed for plotting. Contributed by: Andrew A. Farke (stegosaurus); Scott Hartman (sauropod); Marmelad (theropod).


------
## Session Info
For reproducibility purposes, here is the output of `devtools:session_info()` used to perform the analyses in the publication.

    ─ Session info ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    setting  value                       
    version  R version 3.6.2 (2019-12-12)
    os       OS X El Capitan 10.11.6     
    system   x86_64, darwin15.6.0        
    ui       RStudio                     
    language (EN)                        
    collate  en_GB.UTF-8                 
    ctype    en_GB.UTF-8                 
    tz       Europe/London               
    date     2020-06-16                  

    ─ Packages ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    package           * version    date       lib source                           
    animation           2.6        2018-12-11 [1] CRAN (R 3.6.0)                   
    ape               * 5.3        2019-03-17 [2] CRAN (R 3.6.0)                   
    assertthat          0.2.1      2019-03-21 [2] CRAN (R 3.6.0)                   
    backports           1.1.6      2020-04-05 [1] CRAN (R 3.6.2)                   
    bitops              1.0-6      2013-08-17 [2] CRAN (R 3.6.0)                   
    broom               0.5.3      2019-12-14 [2] CRAN (R 3.6.0)                   
    callr               3.4.3      2020-03-28 [1] CRAN (R 3.6.2)                   
    cellranger          1.1.0      2016-07-27 [2] CRAN (R 3.6.0)                   
    cli                 2.0.2      2020-02-28 [1] CRAN (R 3.6.0)                   
    clusterGeneration   1.3.4      2015-02-18 [1] CRAN (R 3.6.0)                   
    coda              * 0.19-3     2019-07-05 [2] CRAN (R 3.6.0)                   
    colorspace          1.4-1      2019-03-18 [2] CRAN (R 3.6.0)                   
    combinat            0.0-8      2012-10-29 [1] CRAN (R 3.6.0)                   
    corpcor             1.6.9      2017-04-01 [1] CRAN (R 3.6.0)                   
    crayon              1.3.4      2017-09-16 [2] CRAN (R 3.6.0)                   
    crul                0.9.0      2019-11-06 [1] CRAN (R 3.6.0)                   
    cubature            2.0.4      2019-12-04 [1] CRAN (R 3.6.0)                   
    curl                4.3        2019-12-02 [2] CRAN (R 3.6.0)                   
    DBI                 1.1.0      2019-12-15 [2] CRAN (R 3.6.0)                   
    dbplyr              1.4.2      2019-06-17 [2] CRAN (R 3.6.0)                   
    desc                1.2.0      2018-05-01 [1] CRAN (R 3.6.0)                   
    devtools            2.2.2      2020-02-17 [1] CRAN (R 3.6.0)                   
    digest              0.6.25     2020-02-23 [1] CRAN (R 3.6.0)                   
    dplyr             * 0.8.3      2019-07-04 [2] CRAN (R 3.6.0)                   
    ellipsis            0.3.0      2019-09-20 [2] CRAN (R 3.6.0)                   
    expm                0.999-4    2019-03-21 [1] CRAN (R 3.6.0)                   
    fansi               0.4.1      2020-01-08 [2] CRAN (R 3.6.2)                   
    fastmatch           1.1-0      2017-01-28 [1] CRAN (R 3.6.0)                   
    forcats           * 0.4.0      2019-02-17 [2] CRAN (R 3.6.0)                   
    fs                  1.4.1      2020-04-04 [1] CRAN (R 3.6.2)                       
    generics            0.0.2      2018-11-29 [2] CRAN (R 3.6.0)                   
    ggplot2           * 3.3.0      2020-03-05 [1] CRAN (R 3.6.0)                   
    glue                1.4.0      2020-04-03 [1] CRAN (R 3.6.2)                   
    gridBase            0.4-7      2014-02-24 [1] CRAN (R 3.6.0)                   
    gtable              0.3.0      2019-03-25 [2] CRAN (R 3.6.0)                   
    gtools              3.8.1      2018-06-26 [1] CRAN (R 3.6.0)                   
    haven               2.2.0      2019-11-08 [2] CRAN (R 3.6.0)                   
    hms                 0.5.3      2020-01-08 [2] CRAN (R 3.6.2)                   
    httpcode            0.2.0      2016-11-14 [1] CRAN (R 3.6.0)                   
    httr                1.4.1      2019-08-05 [2] CRAN (R 3.6.0)                   
    igraph              1.2.4.2    2019-11-27 [1] CRAN (R 3.6.0)                   
    jsonlite            1.6.1      2020-02-02 [1] CRAN (R 3.6.0)                   
    lattice             0.20-38    2018-11-04 [2] CRAN (R 3.6.2)                   
    lifecycle           0.2.0      2020-03-06 [1] CRAN (R 3.6.0)                   
    lubridate           1.7.4      2018-04-11 [2] CRAN (R 3.6.0)                   
    magrittr            1.5        2014-11-22 [2] CRAN (R 3.6.0)                   
    maps                3.3.0      2018-04-03 [1] CRAN (R 3.6.0)                   
    MASS                7.3-51.4   2019-03-31 [2] CRAN (R 3.6.2)                   
    Matrix            * 1.2-18     2019-11-27 [2] CRAN (R 3.6.2)                   
    MCMCglmm          * 2.29       2019-04-24 [1] CRAN (R 3.6.0)                   
    memoise             1.1.0      2017-04-21 [1] CRAN (R 3.6.0)                   
    mnormt              1.5-6      2020-02-03 [1] CRAN (R 3.6.0)                   
    modelr              0.1.5      2019-08-08 [2] CRAN (R 3.6.0)                   
    munsell             0.5.0      2018-06-12 [2] CRAN (R 3.6.0)                   
    nlme                3.1-142    2019-11-07 [2] CRAN (R 3.6.2)                   
    numDeriv            2016.8-1.1 2019-06-06 [1] CRAN (R 3.6.0)                   
    paleotree         * 3.3.25     2019-12-12 [1] CRAN (R 3.6.0)                   
    pBrackets         * 1.0        2014-10-17 [1] CRAN (R 3.6.0)                   
    phangorn            2.5.5      2019-06-19 [1] CRAN (R 3.6.0)                   
    phytools            0.6-99     2019-06-18 [1] CRAN (R 3.6.0)                   
    pillar              1.4.3      2019-12-20 [2] CRAN (R 3.6.0)                   
    pkgbuild            1.0.6      2019-10-09 [1] CRAN (R 3.6.0)                   
    pkgconfig           2.0.3      2019-09-22 [2] CRAN (R 3.6.0)                   
    pkgload             1.0.2      2018-10-29 [1] CRAN (R 3.6.0)                   
    plotrix             3.7-7      2019-12-05 [1] CRAN (R 3.6.0)                   
    png               * 0.1-7      2013-12-03 [2] CRAN (R 3.6.0)                   
    prettyunits         1.1.1      2020-01-24 [1] CRAN (R 3.6.0)                   
    processx            3.4.2      2020-02-09 [1] CRAN (R 3.6.0)                   
    ps                  1.3.2      2020-02-13 [1] CRAN (R 3.6.0)                   
    purrr             * 0.3.3      2019-10-18 [2] CRAN (R 3.6.0)                   
    quadprog            1.5-8      2019-11-20 [1] CRAN (R 3.6.0)                   
    R6                  2.4.1      2019-11-12 [2] CRAN (R 3.6.0)                   
    Rcpp                1.0.4      2020-03-17 [1] CRAN (R 3.6.0)                   
    RCurl               1.98-1.1   2020-01-19 [1] CRAN (R 3.6.0)                   
    readr             * 1.3.1      2018-12-21 [2] CRAN (R 3.6.0)                   
    readxl              1.3.1      2019-03-13 [2] CRAN (R 3.6.0)                   
    remotes             2.1.1      2020-02-15 [1] CRAN (R 3.6.0)                   
    reprex              0.3.0      2019-05-16 [2] CRAN (R 3.6.0)                   
    rlang               0.4.5      2020-03-01 [1] CRAN (R 3.6.0)                   
    rphylopic         * 0.2.0.9310 2020-04-10 [1] Github (sckott/rphylopic@6c88380)
    rprojroot           1.3-2      2018-01-03 [1] CRAN (R 3.6.0)                   
    rstudioapi          0.11       2020-02-07 [1] CRAN (R 3.6.0)                   
    rvest               0.3.5      2019-11-08 [2] CRAN (R 3.6.0)                   
    scales            * 1.1.0      2019-11-18 [2] CRAN (R 3.6.0)                   
    scatterplot3d       0.3-41     2018-03-14 [1] CRAN (R 3.6.0)                   
    sessioninfo         1.1.1      2018-11-05 [1] CRAN (R 3.6.0)                   
    stringi             1.4.6      2020-02-17 [1] CRAN (R 3.6.0)                   
    stringr           * 1.4.0      2019-02-10 [2] CRAN (R 3.6.0)                   
    tensorA             0.36.1     2018-07-29 [1] CRAN (R 3.6.0)                   
    testthat            2.3.2      2020-03-02 [1] CRAN (R 3.6.0)                   
    tibble            * 3.0.0      2020-03-30 [1] CRAN (R 3.6.2)                   
    tidyr             * 1.0.0      2019-09-11 [2] CRAN (R 3.6.0)                   
    tidyselect          0.2.5      2018-10-11 [2] CRAN (R 3.6.0)                   
    tidyverse         * 1.3.0      2019-11-21 [2] CRAN (R 3.6.0)                   
    usethis             1.5.1      2019-07-04 [1] CRAN (R 3.6.0)                   
    vctrs               0.2.4      2020-03-10 [1] CRAN (R 3.6.0)                   
    withr               2.1.2      2018-03-15 [2] CRAN (R 3.6.0)                   
    xml2                1.2.2      2019-08-09 [2] CRAN (R 3.6.0)                   
    yaml                2.2.1      2020-02-01 [1] CRAN (R 3.6.0)                   

    [1] /Users/natac4/Library/R/3.6/library
    [2] /Library/Frameworks/R.framework/Versions/3.6/Resources/library

## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2020-03-01") 
```
