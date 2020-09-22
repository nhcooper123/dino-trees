# Plot intercepts
# Natalie Cooper Sept 2020

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

ds_interceptsx <-
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
  # Make null model the reference level
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd", 
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau")) %>%
  # Gather so intercepts are in one column
  gather(model, intercept, c(null_post_mean_intercept, asym_post_mean_intercept, slow_post_mean_intercept)) %>%
  # Make null model the reference level
  mutate(model = relevel(as.factor(model), ref = "null_post_mean_intercept"))

# Get mean, min and max for intercepts
dsx <- 
  ds_interceptsx %>%
  group_by(tree) %>%
  summarise(median_null = median(null_post_mean_intercept),
            min_null = min(null_lower95_CI_intercept),
            max_null = max(null_upper95_CI_intercept),
            median_slow = median(slow_post_mean_intercept),
            min_slow = min(slow_lower95_CI_intercept),
            max_slow = max(slow_upper95_CI_intercept),
            median_asym = median(asym_post_mean_intercept),
            min_asym = min(asym_lower95_CI_intercept),
            max_asym = max(asym_upper95_CI_intercept))

#---------------------------------
# Plot intercepts
#----------------------------------

ggplot(ds_interceptsx, aes(x = intercept, fill = model)) +
  geom_density(alpha = 0.5, colour = NA) +
  facet_wrap(~tree, scales = "free_y", nrow = 4) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c("black", "#648FFF", "#DC267F"),
                    labels = c("null", "asymptote", "downturn")) +
  theme(legend.position = "right",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(breaks= pretty_breaks()) +
  geom_vline(xintercept = 1, linetype = "dotted") +
  xlab("y intercept") +
  xlim(0, 2.5)

#ggsave("outputs/figure-intercepts.png", width = 20, height = 20, units = "cm")