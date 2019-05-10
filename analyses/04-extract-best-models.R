# Extract best models
# Natalie Cooper May 2019

#-----------------
# Load libraries
#----------------
library(tidyverse)

#-------------------------------
# Extract best models
# Zero intercept
#-------------------------------
# Read in data
ds <- read_csv("outputs/mcmcglmm_outputs.csv")

# Extract best models
# Get delta DICs then pcik best models based on 4 units DIC difference
sum_all <-
  ds %>%
  mutate(null_asym = null_DIC - asym_DIC) %>%
  mutate(null_slow = null_DIC - slow_DIC) %>%
  mutate(asym_slow = asym_DIC - slow_DIC) %>%
  mutate(best_model = case_when(null_asym < -4 & null_slow < -4 ~ "null",
                                null_asym > 4 & asym_slow < -4 ~ "asymptote",
                                null_slow > 4 & asym_slow > 4 ~ "slowdown",
                                null_asym > 4 & null_slow > 4 & (asym_slow > -4 &  asym_slow < 4) ~ "asymptote/slowdown",
                                (null_asym < 4 & null_asym > -4) & null_slow > 4 & asym_slow < -4 ~ "null/asympote",
                                null_asym > 4 & (null_slow < 4 & null_slow > -4) & asym_slow > 4 ~ "null/slowdown",
                                abs(null_asym) < 4 & abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none"))

# Get % of trees supporting each model
to_plot <- 
  sum_all %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  distinct()

#-------------------------------------
# Intercepts models
#-------------------------------------
# Read in data
ds_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")

# Extract best models
# Get delta DICs then pcik best models based on 4 units DIC difference
sum_all_i <-
  ds_intercepts %>%
  mutate(null_asym = null_DIC - asym_DIC) %>%
  mutate(null_slow = null_DIC - slow_DIC) %>%
  mutate(asym_slow = asym_DIC - slow_DIC) %>%
  mutate(best_model = case_when(null_asym < -4 & null_slow < -4 ~ "null",
                                null_asym > 4 & asym_slow < -4 ~ "asymptote",
                                null_slow > 4 & asym_slow > 4 ~ "slowdown",
                                null_asym > 4 & null_slow > 4 & (asym_slow > -4 &  asym_slow < 4) ~ "asymptote/slowdown",
                                (null_asym < 4 & null_asym > -4) & null_slow > 4 & asym_slow < -4 ~ "null/asympote",
                                null_asym > 4 & (null_slow < 4 & null_slow > -4) & asym_slow > 4 ~ "null/slowdown",
                                abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none"))

# Get % of trees supporting each model
to_plot_i <- 
  sum_all_i %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  distinct()

#-------------------------------------
# Add Sakamoto results
# with intercepts
#-------------------------------------
# Read in data
ds_saka <- read_csv("outputs/sakamoto-results.csv")

# Reshape so it matches the code for other data
ds_saka <- ds_saka %>%
  spread(model, DIC) %>%
  rename(asym_DIC = asym) %>%
  rename(null_DIC = null) %>%
  rename(slow_DIC = slow)

  # Extract best models
  # Get delta DICs then pcik best models based on 4 units DIC difference
  sum_all_saka <-
  ds_saka %>%
  mutate(null_asym = null_DIC - asym_DIC) %>%
  mutate(null_slow = null_DIC - slow_DIC) %>%
  mutate(asym_slow = asym_DIC - slow_DIC) %>%
  mutate(best_model = case_when(null_asym < -4 & null_slow < -4 ~ "null",
                                null_asym > 4 & asym_slow < -4 ~ "asymptote",
                                null_slow > 4 & asym_slow >= 4 ~ "slowdown",
                                null_asym > 4 & null_slow > 4 & (asym_slow > -4 &  asym_slow < 4) ~ "asymptote/slowdown",
                                (null_asym < 4 & null_asym > -4) & null_slow > 4 & asym_slow < -4 ~ "null/asympote",
                                null_asym > 4 & (null_slow < 4 & null_slow > -4) & asym_slow > 4 ~ "null/slowdown",
                                abs(null_asym) < 4 & abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none"))

# Get % of trees supporting each model
# Exclude all but midpoint trees for now
to_plot_saka <- 
  sum_all_saka %>%
  filter(`dating method` == "midpoint") %>%
  unite(tree, tree, `dating method`, clade, sep = "_") %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  # Make into % for comparison with other data
  mutate(best = best * 100)

#------------------------------------- 
# Combine with other data  
plot_data_i <- rbind(to_plot_i, to_plot_saka)

# Tidy up tree names
plot_data_i <-
    plot_data_i %>%
    ungroup(tree) %>%
    mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                            tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                            tree == "Cau.phy.nex" ~ "Cau",
                            tree == "Chiba.phy.nex" ~ "Chiba",
                            tree == "Cruzado.phy.nex" ~ "Cruzado",
                            tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                            tree == "Mallon.phy.nex" ~ "Mallon",
                            tree == "Raven.phy.nex" ~ "Raven",
                            tree == "Thompson.phy.nex" ~ "Thompson",
                            tree == "Benson1_midpoint_3-Group" ~ "Benson1_3",
                            tree == "Benson1_midpoint_5-Group" ~ "Benson1_5",
                            tree == "Benson1_midpoint_Dinosauria" ~ "Benson1",
                            tree == "Benson2_midpoint_3-Group" ~ "Benson2_3",
                            tree == "Benson2_midpoint_5-Group" ~ "Benson2_5",
                            tree == "Benson2_midpoint_Dinosauria" ~ "Benson2",
                            tree == "Lloyd_midpoint_3-Group" ~ "Lloyd_3",
                            tree == "Lloyd_midpoint_5-Group" ~ "Lloyd_5",
                            tree == "Lloyd_midpoint_Dinosauria" ~ "Lloyd"))
# Write to file
write_csv(plot_data_i, path = "outputs/best-models-intercepts.csv")

# Tidy up tree names for only clade data with no intercepts
plot_data <-
  to_plot %>%
  ungroup(tree) %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "Cruzado",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson"))

write_csv(plot_data, path = "outputs/best-models.csv")
