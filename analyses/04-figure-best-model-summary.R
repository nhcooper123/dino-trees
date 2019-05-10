# Plot best models
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
  filter(tree != "Benson.phy.nex" & !is.na(tree)) %>%
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
  filter(tree != "Benson.phy.nex" & !is.na(tree)) %>%
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
# Zero intercepts
#-------------------------------------
# Read in data
ds_saka <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")
  
  
  # Extract best models
  # Get delta DICs then pcik best models based on 4 units DIC difference
  sum_all <-
  ds %>%
  filter(tree != "Benson.phy.nex" & !is.na(tree)) %>%
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
ds_saka_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")
