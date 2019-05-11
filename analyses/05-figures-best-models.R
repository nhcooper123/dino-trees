# Plot best models 
# Natalie Cooper May 2019

#-----------------
# Load libraries
#----------------
library(tidyverse)
library(rphylopic)

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
  

# Intercept
ggplot(ds_i, aes(x = tree, y = best, fill = best_model)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c("grey", "#785EF0", "#DC267F"),
                    labels = c("none", "asymptote/downturn", "downturn")) +
  labs(x = "", y = "% trees", fill = "best model") +
  theme(legend.position = "top",
        strip.background = element_rect(fill = "white"),
        legend.spacing.x = unit(0.2, 'cm'),
        axis.text.x = element_text(angle = 45, hjust = 1))



add_phylopic(img = img_frog, alpha = 1, x = 4, y = 90, ysize = 10) +
