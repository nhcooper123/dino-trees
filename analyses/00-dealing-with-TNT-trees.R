# Extracting new trees
# Natalie Cooper Apr 2019
# Input is .phy file output from TNT

#--------------------------------------
# Load libraries
#--------------------------------------
library(paleotree)
#library(BioGeoBEARS)
library(tidyverse)

# Read in Nick Matzke's code for dealing with TNT outputs
#source("functions/tnt_R_utils_v1.R")

#--------------------------------------
# Dates
#--------------------------------------
# Read in PBDB dates 
# find all file names ending in .csv 
# add folder name to the front of each
dates_files <- list.files("data/trees_dates", pattern = ".csv")
dates_files <- paste0("data/trees_dates/", dates_files)

# Read in all dates files and combine
dino_dates <- 
  dates_files %>%
  map(read_csv) %>%    
  reduce(rbind)        

# Tidy the dates
dino_dates <- dino_dates %>%
  # Select only the columns we need
  select(accepted_name, max_ma, min_ma) %>%
  # Get rid of the weird NA lines
  na.omit() %>%
  # Split up names column so they can be matched
  # This throws a warning because some species have subspecies
  separate(accepted_name, sep = "_", c("Genus", "species")) %>%
  # Create a binomial column
  unite(binomial, Genus, species, sep = "_", remove = FALSE) %>%
  # Some annoying taxonomic corrections
  # Make dates match tree names
  mutate(binomial = str_replace(binomial, "Albertosaurus_sarcophagus" , "Albertosaurus_sacrophagus")) %>%
  mutate(binomial = str_replace(binomial, "Archaeornithomimus_asiaticus" , "Archaeornithomimus_asiati")) %>%
  mutate(Genus = str_replace(Genus, "Bambiraptor" , "Bambiraptor_feinbergi")) %>%
  mutate(binomial = str_replace(binomial, "Buitreraptor_gonzalezorum" , "Buitreraptor_gonzalozorum")) %>%
  mutate(binomial = str_replace(binomial, "Hongshanornis_longicresta", "Hongshanornis_longicrest")) %>%
  mutate(binomial = str_replace(binomial, "Iaceornis_marshi" , "Iaceornis_marshii")) %>%
  mutate(binomial = str_replace(binomial, "Liaoningornis_longidigitris" , "Liaoningornis_longidigitus")) %>%
  mutate(Genus = str_replace(Genus, "Neuquenraptor" , "Neuquenraptor_plus_Unenlagia")) %>%
  mutate(binomial = str_replace(binomial, "Ornithomimus_edmontonicus" , "Ornithomimus_edmonticus")) %>%
  mutate(binomial = str_replace(binomial, "Pelecanimimus_polyodon" , "Pelecanimimus_polydon")) %>%
  mutate(binomial = str_replace(binomial, "Tarbosaurus_bataar" , "Tarbosaurus_baatar")) %>%
  mutate(binomial = str_replace(binomial, "Crichtonsaurus_benxiensis" , "Crichtonpelta_benxiensis")) %>%
  mutate(Genus = str_replace(Genus, "Crichtonsaurus" , "Chrichtonsaurus_benxiensis")) %>%
  mutate(Genus = str_replace(Genus, "Minmi" , "Minmi_sp.")) %>%
  mutate(binomial = str_replace(binomial, "Sauropelta_edwardsorum" , "Sauropelta_edwardsi")) %>%
  mutate(Genus = str_replace(Genus, "Pawpawsaurus" , "Paw_Paw_scuteling")) %>%
  mutate(binomial = str_replace(binomial, "Argentinosaurus_huinculensis" , "Argentinosaurus_hunculensis")) %>%
  mutate(binomial = str_replace(binomial, "Brachytrachelopan_mesai" , "Brachytrachelopan_messai")) %>%
  mutate(binomial = str_replace(binomial, "Cedarosaurus_weiskopfae" , "Cedarosaurus_weiskopfe")) %>%
  mutate(binomial = str_replace(binomial, "Comahuesaurus_windhauseni" , "Comahuesaurus_windhanseni")) %>%
  mutate(binomial = str_replace(binomial, "Futalognkosaurus_dukei" , "Futalongkosaurus_dukei")) %>%
  mutate(binomial = str_replace(binomial, "Histriasaurus_boscarollii" , "Histriasaurus_bocardeli")) %>%
  mutate(binomial = str_replace(binomial, "Ligabuesaurus_leanzai" , "Ligabuesaurus_lenzai")) %>%
  mutate(binomial = str_replace(binomial, "Notocolossus_gonzalezparejasi" , "Notocolossus_gonzalesparejasi")) %>%
  mutate(binomial = str_replace(binomial, "Suuwassea_emilieae" , "Suwassea_emiliae")) %>%
  mutate(Genus = str_replace(Genus, "Aeolosaurus" , "Aeolosaurus_sp.")) %>%
  mutate(binomial = str_replace(binomial, "Dongyangosaurus_sinensis" , "D_sinensis")) %>%
  mutate(binomial = str_replace(binomial, "Diplodocus_carnegii" , "Diplodocus_carnegiei")) %>%
  mutate(Genus = str_replace(Genus, "Galvesaurus" , "Galveosaurus")) %>%
  mutate(Genus = str_replace(Genus, "Jiangshanosaurus" , "Jingshanosaurus")) %>%
  mutate(binomial = str_replace(binomial, "Minmi_paravertebrata" , "Minmi_paravertebra")) %>%
  mutate(Genus = str_replace(Genus, "Animantarx" , "Animantarx_ramaljonsei")) %>%
  mutate(binomial = str_replace(binomial, "Ankylosaurus_magniventris" , "Ankylosaurus_marginoventris")) %>%
  mutate(binomial = str_replace(binomial, "Huayangosaurus_taibaii" , "Huayangosaurus_tabaii")) %>%
  mutate(binomial = str_replace(binomial, "Lesothosaurus_diagnosticus" , "Lesothosaurus_diagnotsicus")) %>%
  mutate(binomial = str_replace(binomial, "Nodosaurus_textilis" , "Nodosaurus_textillis")) %>%
  mutate(binomial = str_replace(binomial, "Pawpawsaurus_campbelli" , "Pawpawsaurus_cambelli")) %>%
  mutate(binomial = str_replace(binomial, "Tatankacephalus_cooneyorum" , "Tatankocephalus_cooneyorum")) %>%
  mutate(binomial = str_replace(binomial, "Dacentrurus_armatus" , "D._armatus")) %>%
  mutate(binomial = str_replace(binomial, "Stegosaurus_stenops" , "S._stenops")) %>%
  mutate(binomial = str_replace(binomial, "Wuerhosaurus_homheni" , "S._homheni")) %>%
  mutate(binomial = str_replace(binomial, "Torosaurus_latus" , "Torosaurus_utahensis")) %>%
  mutate(Genus = str_replace(Genus, "Huanghetitan" , "Huanghetitan_ruyangensis")) %>%
  mutate(binomial = str_replace(binomial, "Olorotitan_arharensis" , "Olorotitan_ararhensis")) %>%
  mutate(binomial = str_replace(binomial, "Ouranosaurus_nigeriensis" , "Ouranosaurus_nigeriensis_")) %>%
  mutate(Genus = str_replace(Genus, "Aeolosaurus" , "Aeolosaurus_sp.")) %>%
  mutate(Genus = str_replace(Genus, "Anchisauripus" , "Anchisaurus")) %>%
  mutate(binomial = str_replace(binomial, "Cedrorestes_crichtoni" , "Cedarorestes_crichtoni")) %>%
  mutate(binomial = str_replace(binomial, "Dyoplosaurus_acutosquameus" , "Dyoplosaurus_acutesquamous")) %>%
  mutate(binomial = str_replace(binomial, "Gilmoreosaurus_mongoliensis" , "Gilmoreosaurus_mongolensis")) %>%
  mutate(binomial = str_replace(binomial, "Lambeosaurus_clavinitialis" , "Lambeosaurus_clavintialis")) %>%
  mutate(Genus = str_replace(Genus, "Mahakala" , "Makhala")) %>%
  mutate(binomial = str_replace(binomial, "Montanoceratops_cerorhynchus" , "Montanoceratops_cerorynchus")) %>%
  mutate(binomial = str_replace(binomial, "Omeisaurus_maoianus" , "Omeisaurus_maoanus")) %>%
  mutate(binomial = str_replace(binomial, "Parasaurolophus_cyrtocristatus" , "Parasaurolophus_cyrtoctristatus")) %>%
  mutate(Genus = str_replace(Genus, "Piatnitzkysaurus" , "Piatnizkysaurus")) %>%
  mutate(Genus = str_replace(Genus, "Piveteausaurus" , "Piveaeausaurus")) %>%
  mutate(binomial = str_replace(binomial, "Rhabdodon_priscus" , "Rhabdodon_priscum")) %>%
  mutate(binomial = str_replace(binomial, "Struthiosaurus_transylvanicus" , "Struthiosaurus_transilvanicus")) %>%
  mutate(Genus = str_replace(Genus, "Zanabazar" , "Zanzabazaar")) %>%
  mutate(binomial = str_replace(binomial, "Zhongyuangosaurus_luoyangensis" , "Zhongyuanosaurus_luoyangensis")) %>%
  mutate(Genus = str_replace(Genus, "Zhongyuangosaurus" , "Zhejiangosaurus_luoyangensis")) %>%
  # Combine binomial and Genus into one column so we can
  # have dates for each species and Genus
  gather(type, name, binomial:Genus) %>%
  # Group by binomial/genus and then get the oldest and youngest dates for 
  # each species/genus
  group_by(name) %>%
  summarise(max_ma = max(max_ma),
            min_ma = min(min_ma))

#--------------------------------------
# Trees
#--------------------------------------
# Extract list of trees from folder
tree.list <- list.files("data/trees_TNT", pattern = ".phy")

for (i in 1:length(tree.list)){

  # Read in the tree
  tree1 <- read.tree(paste0("data/trees_TNT/", tree.list[i]))
  
  # If there is > 1 tree then select MPR tree
  if(class(tree1) == "multiPhylo"){
  tree1 <- tree1[[1]]
  }
  
  # Select species names in the tree
  tree_names <- data.frame(name = tree1$tip.label)
  tree_names$name <- as.character(tree_names$name)

  # Join species in tree to dates 
  dates <- left_join(tree_names, dino_dates, 
                     by = "name")
  
  print(sort(dates$name[is.na(dates$min_ma)])) }
  
  # Remove names column and add it to row names
  timeData <- dates[, 2:3]
  rownames(timeData) <- dates$name

  # Date the tree...
  tree_dated <- timePaleoPhy(tree1, timeData, type = "mbl", 
                             vartime = 1, ntrees = 100,
                             dateTreatment = "minMax", 
                             noisyDrop = TRUE, plot = TRUE)

  write.nexus(tree_dated, file = paste0("data/trees/", tree.list[i], ".nex"))
              
}
