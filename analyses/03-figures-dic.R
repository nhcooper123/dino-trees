# Plot DIC values
# Natalie Cooper May 2019

#-----------------
# Load libraries
#----------------
library(tidyverse)

#648FFF = blue
#785EF0 = purple
#DC267F = red
#FE6100 = orange
#FFB000 = yellow
#-------------------------------
# Read and wrangle model outputs
#-------------------------------
ds <- read_csv("outputs/mcmcglmm_outputs.csv")
ds_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")

# Reorder data and tidy up tree names
ds <-
  ds %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "Cruzado",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson")) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC")) %>%
  mutate(tree = factor(tree, levels = c("Arbour", "Chiba", "Cruzado", "Mallon", 
                                        "Raven", "Thompson", "Carbadillo", "GonzalezR", "Cau")))

ds_intercepts <-
  ds_intercepts %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "Cruzado",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson")) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC"))  %>%
  mutate(tree = factor(tree, levels = c("Arbour", "Chiba", "Cruzado", "Mallon", 
                                        "Raven", "Thompson", "Carbadillo", "GonzalezR", "Cau")))

####### do we want to order trees by clade?######

#--------------------------------------------------------------------------
# Create dataset for 4 unit lines which differ depending on the scale
# of the plot for each tree
line_data_new <- data.frame(x = c(282, 420, 730,
                                  133, 312, 392,
                                  132, 112, 225),
                            y = rep(1, 9), 
                            tree = c("Arbour", "Carbadillo", "Cau", 
                                     "Chiba", "Cruzado", "GonzalezR", 
                                     "Mallon", "Raven", "Thompson"))

line_data_new_intercepts <- data.frame(x = c(282, 418, 714,
                                             132, 310, 392.5,
                                             131, 113, 227),
                                       y = rep(1.1, 9), 
                                       tree = c("Arbour", "Carbadillo", "Cau", 
                                                "Chiba", "Cruzado", "GonzalezR", 
                                                "Mallon", "Raven", "Thompson"))
#-------------------------------------------------------------------------------
# Plot all DICs 
#------------------
# For clade trees
ggplot(ds, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45))

ggsave("outputs/figure-dic.png", width = 20, units = "cm")

# For clade trees with intercepts
ggplot(ds_intercepts, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new_intercepts,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45))

ggsave("outputs/figure-dic-intercepts.png", width = 20, units = "cm")
