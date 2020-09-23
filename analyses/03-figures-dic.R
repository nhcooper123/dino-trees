# Plot DIC values
# Natalie Cooper May 2019
# Modified Sept 2020

#-----------------
# Load libraries
#----------------
library(tidyverse)
library(scales)
library(rphylopic)
library(png)
library(grid)
library(RCurl)

#648FFF = blue
#785EF0 = purple
#DC267F = red
#FE6100 = orange
#FFB000 = yellow

#-----------------------------------------------------------------
# Add pics and function by @baptiste for plotting images on facets
#------------------------------------------------------------------
steg <- readPNG("img/stegosaurus2.png")
raptor <- readPNG("img/eoraptor.png")
pod <- readPNG("img/sauropod2.png")


annotation_custom2 <- 
  function (grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, data){ 
    layer(data = data, stat = StatIdentity, position = PositionIdentity, 
          geom = ggplot2:::GeomCustomAnn,
          inherit.aes = TRUE, params = list(grob = grob, 
                                            xmin = xmin, xmax = xmax, 
                                            ymin = ymin, ymax = ymax))}
#-------------------------------
# Read and wrangle model outputs
#-------------------------------
# No intercept models
#-------------------------------
# Read in the data
ds <- read_csv("outputs/mcmcglmm_outputs.csv")
ds_sak <- read_csv("outputs/mcmcglmm_outputs_sakamoto.csv")

# Split up the Benson and Lloyd tree outputs by topology
ds_sak <- 
  ds_sak %>%
  separate(tree, into = c("tree", "dating"), sep = "_") %>%
  select(-dating)

# Add outputs together
ds <- rbind(ds, ds_sak)

# Reorder data and tidy up tree names
ds <-
  ds %>%
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
                          tree == "lloyd" ~ "Lloyd")) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC")) %>%
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd", 
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))

#---------------------------------------------------------------------
# Intercept models
#---------------------------------------------------------------------
# Read in the data
ds_intercepts <- read_csv("outputs/mcmcglmm_outputs_intercepts.csv")
ds_intercepts_sak <- read_csv("outputs/mcmcglmm_outputs_intercepts_sakamoto.csv")

# Split up the Benson and Lloyd tree outputs by topology
ds_intercepts_sak <- 
  ds_intercepts_sak %>%
  separate(tree, into = c("tree", "dating"), sep = "_") %>%
  select(-dating)

# Add outputs together
ds_intercepts <- rbind(ds_intercepts, ds_intercepts_sak)

ds_intercepts <-
  ds_intercepts %>%
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
                          tree == "lloyd" ~ "Lloyd")) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC"))  %>%
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd", 
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))

#---------------------------------------------------------------------
# # Offset/intercept = 1 models plots
#---------------------------------------------------------------------
# Read in the data
ds_offset <- read_csv("outputs/mcmcglmm_outputs_offset.csv")
ds_offset_sak <- read_csv("outputs/mcmcglmm_outputs_offset_sakamoto.csv")

# Split up the Benson and Lloyd tree outputs by topology
ds_offset_sak <- 
  ds_offset_sak %>%
  separate(tree, into = c("tree", "dating"), sep = "_") %>%
  select(-dating)

# Add outputs together
ds_offset <- rbind(ds_offset, ds_offset_sak)

ds_offset <-
  ds_offset %>%
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
                          tree == "lloyd" ~ "Lloyd")) %>%
  # Gather so DICs are in one column
  gather(model, DIC, c(null_DIC, asym_DIC, slow_DIC)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_DIC"))  %>%
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd", 
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))
#-------------------------------------------------------------------------------
# Plot all DICs 
#------------------
# No intercepts
#------------------
# Create dataset for 4 unit lines which differ depending on the scale
# of the plot for each tree
line_data_new <- data.frame(x = c(3600,3500,2500,
                                  282, 440, 780,
                                  135, 312, 420,
                                  132, 112, 225),
                            y = c(rep(0.02, 3), rep(1, 9)), 
                            tree = c("Benson1", "Benson2", "Lloyd",
                                     "Arbour", "Carballido", "Cau", 
                                     "Chiba", "CruzadoC", "GonzalezR", 
                                     "Mallon", "Raven", "Thompson"))

# Plot
plot <-
  ggplot(ds_offset, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~tree, scales = "free", nrow = 4) +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  scale_x_continuous(breaks= pretty_breaks()) + 
  scale_y_continuous(breaks= pretty_breaks()) + 
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Create images to add to the facets
arbour_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                        xmin = 299, xmax = 309, ymin = 0.75, ymax = 1, data = ds_offset[1, ])
chiba_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 147, xmax = 154, ymin = 0.75, ymax = 1, data = ds_offset[301, ])
cruz_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                               xmin = 344, xmax = 363, ymin = 0.75, ymax = 1, data = ds_offset[401, ])
mallon_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 143, xmax = 149.5, ymin = 0.75, ymax = 1, data = ds_offset[601, ])
raven_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 117.5, xmax = 120.5, ymin = 0.75, ymax = 1, data = ds_offset[701, ])
thom_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 258, xmax = 275, ymin = 0.75, ymax = 1, data = ds_offset[801, ])
carb_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 490, xmax = 520, ymin = 0.75, ymax = 1, data = ds_offset[101, ])
gonz_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 438, xmax = 448, ymin = 0.75, ymax = 1, data = ds_offset[501, ])
cau_img <- annotation_custom2(rasterGrob(raptor, interpolate=TRUE), 
                              xmin = 800, xmax = 810, ymin = 0.75, ymax = 1, data = ds_offset[201, ])
# Add images
plot + arbour_img + cruz_img + chiba_img + 
  mallon_img + raven_img + thom_img +
  gonz_img + carb_img + cau_img

#ggsave("outputs/figure-dic-offset.png", width = 20, height = 20, units = "cm")

#---------------------------------------------------------------------
# Intercept models plots
#---------------------------------------------------------------------
# Create dataset for 4 unit lines which differ depending on the scale
# of the plot for each tree
line_data_new_intercepts <- data.frame(x = c(3400,3400,2300,
                                             281, 418, 713,
                                             132, 310, 394,
                                             131, 112.5, 227),
                                       y = c(rep(0.08, 3), rep(1.2, 9)), 
                                       tree = c("Benson1", "Benson2", "Lloyd",
                                                "Arbour", "Carballido", "Cau", 
                                                "Chiba", "CruzadoC", "GonzalezR", 
                                                "Mallon", "Raven", "Thompson"))
# Plot
plot_intercept <-
  ggplot(ds_intercepts, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free", nrow = 4) +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new_intercepts,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  scale_x_continuous(breaks= pretty_breaks()) + 
  scale_y_continuous(breaks= pretty_breaks()) + 
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Create images to add to the facets
arbour1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                 xmin = 286, xmax = 289, ymin = 0.95, ymax = 1.20, data = ds_intercepts[1, ])
chiba1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 136, xmax = 138.5, ymin = 0.95, ymax = 1.20, data = ds_intercepts[301, ])
cruz1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                               xmin = 315, xmax = 318, ymin = 0.95, ymax = 1.20, data = ds_intercepts[401, ])
mallon1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                 xmin = 135, xmax = 137.5, ymin = 0.95, ymax = 1.20, data = ds_intercepts[601, ])
raven1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 112.5, xmax = 114.3, ymin = 0.95, ymax = 1.20, data = ds_intercepts[701, ])
thom1_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                               xmin = 231.8, xmax = 234.8, ymin = 0.95, ymax = 1.20, data = ds_intercepts[801, ])
carb1_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 435, xmax = 446, ymin = 0.95, ymax = 1.20, data = ds_intercepts[101, ])
gonz1_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 400.5, xmax = 405.5, ymin = 0.95, ymax = 1.20, data = ds_intercepts[501, ])
cau1_img <- annotation_custom2(rasterGrob(raptor, interpolate=TRUE), 
                              xmin = 716.5, xmax = 720, ymin = 0.95, ymax = 1.20, data = ds_intercepts[201, ])
# Add images
plot_intercept + arbour1_img + cruz1_img + chiba1_img + 
  mallon1_img + raven1_img + thom1_img +
  gonz1_img + carb1_img + cau1_img

#ggsave("outputs/figure-dic-intercepts-revision.png", width = 20, height = 20, units = "cm")

#---------------------------------------------------------------------
# Offset/intercept = 1 models plots
#---------------------------------------------------------------------
# Create dataset for 4 unit lines which differ depending on the scale
# of the plot for each tree
line_data_new_offset <- data.frame(x = c(3000,3000,2000,
                                         281, 418, 713,
                                         132, 310, 394,
                                         131, 112.5, 227),
                                   y = rep(1.1, 12), 
                                   tree = c("Benson1", "Benson2", "Lloyd",
                                            "Arbour", "Carballido", "Cau", 
                                            "Chiba", "CruzadoC", "GonzalezR", 
                                            "Mallon", "Raven", "Thompson"))

# Plot
plot_offset <-
  ggplot(ds_offset, aes(x = DIC, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~ tree, scales = "free", nrow = 4) +
  theme_bw(base_size = 14) +
  # Add lines to each of 4 units DIC
  geom_segment(data = line_data_new_intercepts,
               aes(x = x, y = y, 
                   xend = x + 4, 
                   yend = y), inherit.aes = FALSE) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  scale_x_continuous(breaks= pretty_breaks()) + 
  scale_y_continuous(breaks= pretty_breaks()) + 
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Create images to add to the facets
arbour_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                 xmin = 299, xmax = 309, ymin = 0.75, ymax = 1, data = ds[1, ])
chiba_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 147, xmax = 154, ymin = 0.75, ymax = 1, data = ds[301, ])
cruz_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                               xmin = 344, xmax = 363, ymin = 0.75, ymax = 1, data = ds[401, ])
mallon_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                 xmin = 143, xmax = 149.5, ymin = 0.75, ymax = 1, data = ds[601, ])
raven_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                                xmin = 117.5, xmax = 120.5, ymin = 0.75, ymax = 1, data = ds[701, ])
thom_img <- annotation_custom2(rasterGrob(steg, interpolate=TRUE), 
                               xmin = 258, xmax = 275, ymin = 0.75, ymax = 1, data = ds[801, ])
carb_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 490, xmax = 520, ymin = 0.75, ymax = 1, data = ds[101, ])
gonz_img <- annotation_custom2(rasterGrob(pod, interpolate=TRUE), 
                               xmin = 438, xmax = 448, ymin = 0.75, ymax = 1, data = ds[501, ])
cau_img <- annotation_custom2(rasterGrob(raptor, interpolate=TRUE), 
                              xmin = 800, xmax = 810, ymin = 0.75, ymax = 1, data = ds[201, ])
# Add images
plot_offset + arbour_img + cruz_img + chiba_img + 
  mallon_img + raven_img + thom_img +
  gonz_img + carb_img + cau_img

#ggsave("outputs/figure-dic-offset.png", width = 20, height = 20, units = "cm")