# Plot best models 
# Natalie Cooper May 2019

#-----------------
# Load libraries
#----------------
library(tidyverse)
library(rphylopic)
library(png)
library(pBrackets)
#-------------------
# Add pics
#-------------------
steg <- readPNG("img/stegosaurus.png")
raptor <- readPNG("img/velociraptor.png")
pod <- readPNG("img/sauropod.png")

#648FFF = blue
#785EF0 = purple
#DC267F = red
#FE6100 = orange
#FFB000 = yellow
#-------------------------------
# Read and wrangle model outputs
#-------------------------------
ds <- read_csv("outputs/best-models.csv")
ds_i <- read_csv("outputs/best-models-intercepts.csv")

# Relevel to order by model as required and by clade
ds <- ds %>%
  mutate(best_model = fct_relevel(best_model, "none")) %>%
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd",
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))

ds_i <- ds_i %>%
  mutate(best_model = fct_relevel(best_model, "none")) %>%
  mutate(tree = fct_relevel(tree, 
                            "Benson1", "Benson2", "Lloyd",
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))

# No intercept
ggplot(ds, aes(x = tree, y = best, fill = best_model)) +
  geom_bar(stat = "identity", alpha = 1) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c("grey", "#648FFF", "#785EF0", "#DC267F"),
                    labels = c("none", "asymptote", "asymptote/downturn", "downturn")) +
  labs(x = "", y = "% trees", fill = "") +
  theme(legend.position = "top",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  add_phylopic(img = steg, alpha = 1, x = 6.5, y = 85, ysize = 15) +
  add_phylopic(img = pod, alpha = 1, x = 10.5, y = 86, ysize = 22) +
  add_phylopic(img = raptor, alpha = 1, x = 11.9, y = 83, ysize = 12)

# Brackets need to be added individually. Placement is trial and error
# Use corner screen not zoom as this misplaces them
# Make it as large as you want the final figure to be first
grid.brackets(54, 78, 165, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(168, 78, 394, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(397, 78, 470, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(475, 78, 508, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
#### Save plot via export or it won't save the brackets####

# Intercept
ggplot(ds_i, aes(x = tree, y = best, fill = best_model)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c("grey", "#785EF0", "#DC267F"),
                    labels = c("none", "asymptote/downturn", "downturn")) +
  labs(x = "", y = "% trees", fill = "") +
  theme(legend.position = "top",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  add_phylopic(img = steg, alpha = 1, x = 6.5, y = 85, ysize = 15) +
  add_phylopic(img = pod, alpha = 1, x = 10.5, y = 86, ysize = 22) +
  add_phylopic(img = raptor, alpha = 1, x = 11.9, y = 83, ysize = 12)

# Brackets need to be added individually. Placement is trial and error
# Use corner screen not zoom as this misplaces them
# Make it as large as you want the final figure to be first
grid.brackets(54, 78, 165, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(168, 78, 394, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(397, 78, 470, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(475, 78, 508, 78, lwd = 2, col = "black",
              type = 4, tick = NA)
#### Save plot via export or it won't save the brackets####