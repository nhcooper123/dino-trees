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
# Get delta DICs then pick best models based on 4 units DIC difference
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
                                abs(null_asym) < 4 & abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none")) %>%
  mutate(best_model = if_else(is.na(best_model) == TRUE, "none", best_model))

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
                                abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none")) %>%
  mutate(best_model = if_else(is.na(best_model) == TRUE, "none", best_model))

# Get % of trees supporting each model
to_plot_i <- 
  sum_all_i %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  distinct()

#-------------------------------------
# Sakamoto results
# No intercepts
#-------------------------------------
# Read in data
ds_saka <- read_csv("outputs/mcmcglmm_outputs_sakamoto.csv")
ds_saka_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts_sakamoto.csv")

# Separate dates from tree names
ds_saka <- ds_saka %>%
  separate(tree, c("tree", "dating"), sep = "_")

# Extract best models
# Get delta DICs then pick best models based on 4 units DIC difference
sum_all_saka <-
  ds_saka %>%
  mutate(null_asym = null_DIC - asym_DIC) %>%
  mutate(null_slow = null_DIC - slow_DIC) %>%
  mutate(asym_slow = asym_DIC - slow_DIC) %>%
  mutate(best_model = case_when(null_asym < -4 & null_slow < -4 ~ "null",
                                null_asym > 4 & asym_slow < -4 ~ "asymptote",
                                null_slow > 4 & asym_slow > 4 ~ "slowdown",
                                null_asym > 4 & null_slow > 4 & (asym_slow > -4 &  asym_slow < 4) ~ "asymptote/slowdown",
                                (null_asym < 4 & null_asym > -4) & null_slow > 4 & asym_slow < -4 ~ "null/asympote",
                                null_asym > 4 & (null_slow < 4 & null_slow > -4) & asym_slow > 4 ~ "null/slowdown",
                                abs(null_asym) < 4 & abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none")) %>%
  mutate(best_model = if_else(is.na(best_model) == TRUE, "none", best_model))

# Get % of trees supporting each model
to_plot_saka <- 
  sum_all_saka %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  distinct() %>%
  # Make into % for comparison with other data
  mutate(best = best * (100/3))

#-------------------------------------
# Sakamoto results
# Intercepts
#-------------------------------------
# Read in data
ds_saka_i <- read_csv("outputs/mcmcglmm_outputs_intercepts_sakamoto.csv")

# Separate dates from tree names
ds_saka_i <- ds_saka_i %>%
  separate(tree, c("tree", "dating"), sep = "_")


# Extract best models
# Get delta DICs then pick best models based on 4 units DIC difference
sum_all_saka_i <-
  ds_saka_i %>%
  mutate(null_asym = null_DIC - asym_DIC) %>%
  mutate(null_slow = null_DIC - slow_DIC) %>%
  mutate(asym_slow = asym_DIC - slow_DIC) %>%
  mutate(best_model = case_when(null_asym < -4 & null_slow < -4 ~ "null",
                                null_asym > 4 & asym_slow < -4 ~ "asymptote",
                                null_slow > 4 & asym_slow > 4 ~ "slowdown",
                                null_asym > 4 & null_slow > 4 & (asym_slow > -4 &  asym_slow < 4) ~ "asymptote/slowdown",
                                (null_asym < 4 & null_asym > -4) & null_slow > 4 & asym_slow < -4 ~ "null/asympote",
                                null_asym > 4 & (null_slow < 4 & null_slow > -4) & asym_slow > 4 ~ "null/slowdown",
                                abs(null_asym) < 4 & abs(null_slow) < 4 & abs(asym_slow) < 4 ~ "none")) %>%
  mutate(best_model = if_else(is.na(best_model) == TRUE, "none", best_model))

# Get % of trees supporting each model
to_plot_saka_i <- 
  sum_all_saka_i %>%
  group_by(tree) %>%
  add_count(best_model, name = "best") %>%
  select(tree, best_model, best) %>%
  distinct() %>%
  # Make into % for comparison with other data
  mutate(best = best * (100/3))

#------------------------------------- 
# Combine with datasets together
# No intercepts
#-------------------------------------
plot_data <- rbind(to_plot, to_plot_saka)

# Tidy up tree names
plot_data <-
    plot_data %>%
    ungroup(tree) %>%
    mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                            tree == "Carballido.phy.nex" ~ "Carballido",
                            tree == "Cau.phy.nex" ~ "Cau",
                            tree == "Chiba.phy.nex" ~ "Chiba",
                            tree == "Cruzado.phy.nex" ~ "CruzadoC",
                            tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                            tree == "Mallon.phy.nex" ~ "Mallon",
                            tree == "Raven.phy.nex" ~ "Raven",
                            tree == "Thompson.phy.nex" ~ "Thompson",
                            tree == "benson1" ~ "Benson1",
                            tree == "benson2" ~ "Benson2",
                            tree == "lloyd" ~ "Lloyd"))
# Write to file
write_csv(plot_data, path = "outputs/best-models.csv")

#------------------------------------- 
# Combine with datasets together
# With intercepts
#-------------------------------------
plot_data_i <- rbind(to_plot_i, to_plot_saka_i)

# Tidy up tree names
plot_data_i <-
  plot_data_i %>%
  ungroup(tree) %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Carballido.phy.nex" ~ "Carballido",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "CruzadoC",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson",
                          tree == "benson1" ~ "Benson1",
                          tree == "benson2" ~ "Benson2",
                          tree == "lloyd" ~ "Lloyd"))
# Write to file
write_csv(plot_data_i, path = "outputs/best-models-intercepts.csv")
