# Determine "best" models
# Natalie Cooper Sept 2020

#-------------------------------
# Read and wrangle model outputs
#-------------------------------
ds <- read_csv("outputs/mcmcglmm_outputs.csv")
ds_i <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")
ds_o <- read_csv("outputs/mcmcglmm_outputs_offset.csv")

# Select only tree and model DIC columns
# Add column describing the intercept
ds <- ds %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_zero"))

ds_i <- ds_i %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_estimated"))

ds_o <- ds_o %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_one"))

# Combine
all <- cbind(ds, ds_i, ds_o)

# Extract best models comparing across intercept models
# Get delta DICs then pick best models based on 4 units DIC difference
best_all <-
  all %>%
  # Compare across intercept types within each model
  mutate(null_zero_est = null_DIC_zero - null_DIC_estimated) %>%
  mutate(null_zero_one = null_DIC_zero - null_DIC_one) %>%
  mutate(null_est_one = null_DIC_estimated - null_DIC_one) %>%
  mutate(asym_zero_est = asym_DIC_zero - asym_DIC_estimated) %>%
  mutate(asym_zero_one = asym_DIC_zero - asym_DIC_one) %>%
  mutate(asym_est_one = asym_DIC_estimated - asym_DIC_one) %>%
  mutate(slow_zero_est = slow_DIC_zero - slow_DIC_estimated) %>%
  mutate(slow_zero_one = slow_DIC_zero - slow_DIC_one) %>%
  mutate(slow_est_one = slow_DIC_estimated - slow_DIC_one) %>%
  # Add best models
  mutate(best_null = case_when(null_zero_est < -4 & null_zero_one < -4 ~ "zero",
                               null_zero_est > 4 & null_est_one < -4 ~ "estimated",
                               null_zero_one > 4 & null_est_one > 4 ~ "one")) %>%
  mutate(best_null = if_else(is.na(best_null) == TRUE, "none", best_null)) %>%
  mutate(best_slow = case_when(slow_zero_est < -4 & slow_zero_one < -4 ~ "zero",
                               slow_zero_est > 4 & slow_est_one < -4 ~ "estimated",
                               slow_zero_one > 4 & slow_est_one > 4 ~ "one")) %>%
  mutate(best_slow = if_else(is.na(best_slow) == TRUE, "none", best_slow)) %>%
  mutate(best_asym = case_when(asym_zero_est < -4 & asym_zero_one < -4 ~ "zero",
                               asym_zero_est > 4 & asym_est_one < -4 ~ "estimated",
                               asym_zero_one > 4 & asym_est_one > 4 ~ "one")) %>%
  mutate(best_asym = if_else(is.na(best_asym) == TRUE, "none", best_asym))
  
  
# Get % of trees supporting each intercept type
# Null models
best_all %>%
  group_by(tree_zero, best_null) %>%
  summarise(n())

best_all %>%
  group_by(tree_zero, best_slow) %>%
  summarise(n())

best_all %>%
  group_by(tree_zero, best_asym) %>%
  summarise(n())

#-------------------------------
# Repeat for Sakamoto trees
# Read and wrangle model outputs
#-------------------------------
ds <- read_csv("outputs/mcmcglmm_outputs_sakamoto.csv")
ds_i <- read_csv("outputs/mcmcglmm_outputs_intercepts_sakamoto.csv")
ds_o <- read_csv("outputs/mcmcglmm_outputs_offset_sakamoto.csv")

# Select only tree and model DIC columns
# Add column describing the intercept
ds <- ds %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_zero"))

ds_i <- ds_i %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_estimated"))

ds_o <- ds_o %>%
  select(tree, null_DIC, slow_DIC, asym_DIC) %>%
  rename_all(function(x) paste0(x,"_one"))

# Combine
all <- cbind(ds, ds_i, ds_o)

# Extract best models comparing across intercept models
# Get delta DICs then pick best models based on 4 units DIC difference
best_all <-
  all %>%
  # Compare across intercept types within each model
  mutate(null_zero_est = null_DIC_zero - null_DIC_estimated) %>%
  mutate(null_zero_one = null_DIC_zero - null_DIC_one) %>%
  mutate(null_est_one = null_DIC_estimated - null_DIC_one) %>%
  mutate(asym_zero_est = asym_DIC_zero - asym_DIC_estimated) %>%
  mutate(asym_zero_one = asym_DIC_zero - asym_DIC_one) %>%
  mutate(asym_est_one = asym_DIC_estimated - asym_DIC_one) %>%
  mutate(slow_zero_est = slow_DIC_zero - slow_DIC_estimated) %>%
  mutate(slow_zero_one = slow_DIC_zero - slow_DIC_one) %>%
  mutate(slow_est_one = slow_DIC_estimated - slow_DIC_one) %>%
  # Add best models
  mutate(best_null = case_when(null_zero_est < -4 & null_zero_one < -4 ~ "zero",
                               null_zero_est > 4 & null_est_one < -4 ~ "estimated",
                               null_zero_one > 4 & null_est_one > 4 ~ "one")) %>%
  mutate(best_null = if_else(is.na(best_null) == TRUE, "none", best_null)) %>%
  mutate(best_slow = case_when(slow_zero_est < -4 & slow_zero_one < -4 ~ "zero",
                               slow_zero_est > 4 & slow_est_one < -4 ~ "estimated",
                               slow_zero_one > 4 & slow_est_one > 4 ~ "one")) %>%
  mutate(best_slow = if_else(is.na(best_slow) == TRUE, "none", best_slow)) %>%
  mutate(best_asym = case_when(asym_zero_est < -4 & asym_zero_one < -4 ~ "zero",
                               asym_zero_est > 4 & asym_est_one < -4 ~ "estimated",
                               asym_zero_one > 4 & asym_est_one > 4 ~ "one")) %>%
  mutate(best_asym = if_else(is.na(best_asym) == TRUE, "none", best_asym))


# Get % of trees supporting each intercept type
# Null models
best_all %>%
  group_by(tree_zero, best_null) %>%
  summarise(n())

best_all %>%
  group_by(tree_zero, best_slow) %>%
  summarise(n())

best_all %>%
  group_by(tree_zero, best_asym) %>%
  summarise(n())
