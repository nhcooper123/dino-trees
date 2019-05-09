# Plot DIC values
# Natalie Cooper Apr 2019

#-----------------
# Load libraries
#----------------
library(tidyverse)

#-------------------------------
# Read and wrangle model outputs
#-------------------------------
ds <- read_csv("outputs/mcmcglmm_outputs.csv")
ds_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")

# Reorder data and tidy up tree names
ds <-
  ds %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Benson.phy.nex" ~ "Benson",
                          tree == "Benson1.nex" ~ "Benson1",
                          tree == "Benson2.nex" ~ "Benson2",
                          tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "Cruzado",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Lloyd.nex" ~ "Lloyd",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson",
                          )) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC"))

ds_intercepts <-
  ds_intercepts %>%
  mutate(tree = case_when(tree == "Arbour.phy.nex" ~ "Arbour",
                          tree == "Benson.phy.nex" ~ "Benson",
                          tree == "Benson1.nex" ~ "Benson1",
                          tree == "Benson2.nex" ~ "Benson2",
                          tree == "Carbadillo.phy.nex" ~ "Carbadillo",
                          tree == "Cau.phy.nex" ~ "Cau",
                          tree == "Chiba.phy.nex" ~ "Chiba",
                          tree == "Cruzado.phy.nex" ~ "Cruzado",
                          tree == "GonzalezRiga.phy.nex" ~ "GonzalezR",
                          tree == "Lloyd.nex" ~ "Lloyd",
                          tree == "Mallon.phy.nex" ~ "Mallon",
                          tree == "Raven.phy.nex" ~ "Raven",
                          tree == "Thompson.phy.nex" ~ "Thompson",
  )) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC"))

####### do we want to order trees by clade?######
  
#-------------------------------------------------------------------------
# Subset to all dinosaur versus clades
# Remove Benson, Lloyd and NAs
ds_new <- filter(ds, 
                 tree != "Benson" & tree != "Benson1" & tree != "Benson2" &
                 tree != "Lloyd" & !is.na(tree))

ds_new_intercepts <- filter(ds_intercepts, 
                            tree != "Benson" & tree != "Benson1" & tree != "Benson2" &
                            tree != "Lloyd" & !is.na(tree))

# Keep only Benson trees
ds_all <- filter(ds, 
                 tree == "Benson1" | tree == "Benson2")

ds_all_intercepts <- filter(ds_intercepts, 
                            tree == "Benson1" | tree == "Benson2")
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

line_data_all_intercepts <- data.frame(x = c(3540, 3540),
                                       y = rep(0.11, 2), 
                                       tree = c("Benson1", "Benson2"))
#-------------------------------------------------------------------------------
# Plot all DICs 
#------------------
# For clade trees
ggplot(ds_new, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_discrete(labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45))

ggsave("outputs/dic-new-clades.png", width = 20, units = "cm")

# For clade trees with intercepts
ggplot(ds_new_intercepts, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new_intercepts,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_discrete(labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45))

ggsave("outputs/dic-new-clades-intercepts.png", width = 20, units = "cm")

# For all dinosaur trees
dens1 <-
  ggplot(ds_all, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  scale_fill_discrete(labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'))

ds_ll <- filter(ds, tree == "Lloyd")

ll <- 
  ggplot(ds_ll, aes(x = DIC, y = NULL, colour = model)) +
  geom_point(alpha = 0.5, y = 1, size = 4) +
  geom_text(data = data.frame(x = 2480, y = 1.95), 
            aes(x = x, y = y, label = "Lloyd"),
            inherit.aes = FALSE,
            size = 4) +
  geom_hline(aes(yintercept = 1.8)) +
  theme_bw(base_size = 14) +
  ylim(0,2) +
  xlab("") +
  theme(legend.position = "none",
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())


p1 <- ll / dens1

ggsave("outputs/dic-all-dino.png", p1, width = 20, units = "cm")

# For all dinosaur trees with intercepts
dens1_i <-
  ggplot(ds_all_intercepts, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free_x") +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_all_intercepts,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_discrete(labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'))

ds_ll_intercepts <- filter(ds_intercepts, tree == "Lloyd")

ll_i <- 
  ggplot(ds_ll_intercepts, aes(x = DIC, y = NULL, colour = model)) +
  geom_point(alpha = 0.5, y = 1, size = 4) +
  geom_text(data = data.frame(x = 2389, y = 1.95), 
            aes(x = x, y = y, label = "Lloyd"),
            inherit.aes = FALSE,
            size = 4) +
  geom_segment(aes(x = 2382, y = 1.70, 
                   xend = 2382 + 4, 
                   yend = 1.70), inherit.aes = FALSE) +
  geom_hline(aes(yintercept = 1.8)) +
  theme_bw(base_size = 14) +
  ylim(0,2) +
  xlab("") +
  theme(legend.position = "none",
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

p1_i <- ll_i / dens1_i

ggsave("outputs/dic-all-dino-intercepts.png", p1_i, width = 20, units = "cm")

