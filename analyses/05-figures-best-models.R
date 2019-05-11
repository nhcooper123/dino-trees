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
  mutate(tree = fct_relevel(tree, 
                            "Arbour", "Chiba", "Cruzado", "Mallon", "Raven", "Thompson",
                            "Carbadillo", "GonzalezR",
                            "Cau"))

ds_i <- ds_i %>%
  mutate(best_model = fct_relevel(best_model, "none")) %>%
  mutate(tree = fct_relevel(tree, "Benson1", "Benson2", "Lloyd",
                            "Benson1_3", "Benson2_3", "Lloyd_3",
                            "Benson1_5", "Benson2_5", "Lloyd_5",
                            "Arbour", "Chiba", "Cruzado", "Mallon", "Raven", "Thompson",
                            "Carbadillo", "GonzalezR",
                            "Cau"))

# No intercept
ggplot(ds, aes(x = tree, y = best, fill = best_model)) +
  geom_bar(stat = "identity", alpha = 1) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c("#648FFF", "#785EF0"),
                    labels = c("asymptote", "asymptote/downturn")) +
  labs(x = "", y = "% trees", fill = "") +
  theme(legend.position = "top",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  add_phylopic(img = steg, alpha = 1, x = 3.5, y = 85, ysize = 15) +
  add_phylopic(img = pod, alpha = 1, x = 7.5, y = 86, ysize = 18) +
  add_phylopic(img = raptor, alpha = 1, x = 8.9, y = 83, ysize = 12)

grid.brackets(52, 68, 222, 68, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(226, 68, 280, 68, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(284, 68, 310, 68, lwd = 2, col = "black",
              type = 4, tick = NA)

# Save plot via export
  
library(grid)
grid.locator(unit="native") 


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
  add_phylopic(img = steg, alpha = 1, x = 12.5, y = 85, ysize = 15) +
  add_phylopic(img = pod, alpha = 1, x = 16.5, y = 86, ysize = 18) +
  add_phylopic(img = raptor, alpha = 1, x = 17.9, y = 83, ysize = 10)

grid.brackets(50, 68, 179, 68, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(181, 68, 268, 68, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(270, 68, 297, 68, lwd = 2, col = "black",
              type = 4, tick = NA)
grid.brackets(299, 68, 313, 68, lwd = 2, col = "black",
              type = 4, tick = NA)