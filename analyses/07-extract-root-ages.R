# Extract root ages
# Natalie Cooper Sept 2020

# Load libraries
library(ape)
library(tidyverse)
library(paleotree)
library(scales)

#----------------------------------------------
# Extract root ages for paleotree
#----------------------------------------------
# Extract list of trees and dates from folder
tree.list <- list.files("data/trees_TNT", pattern = ".phy")
dates_files <- list.files("data/trees_dates", pattern = ".csv")

# Make blank output
output <- data.frame(tree = rep(NA, 900), age = rep(NA, 900))

# Start counter
tree.no <- 1

for (i in 1:length(tree.list)){
  
  # Read in the tree and dates
  tree1 <- read.tree(paste0("data/trees_TNT/", tree.list[i]))
  dates1 <- read_csv(paste0("data/trees_dates/", dates_files[i]))
  
  # If there is > 1 tree then select first tree - 
  # this can be an error with TNT which outputs two consensus trees for no reason
  if(class(tree1) == "multiPhylo"){
    tree1 <- tree1[[1]]
  }
  
  # Remove names column and add it to row names
  timeData <- dates1[, 2:3]
  rownames(timeData) <- dates1$name
  
  # Date the tree...
  tree_dated <- timePaleoPhy(tree1, timeData, type = "mbl", 
                             vartime = 1, ntrees = 100,
                             dateTreatment = "minMax", 
                             noisyDrop = TRUE, plot = FALSE)
  
  for(j in 1:100){
    # Add tree name and age to output
    output$tree[tree.no] <- tree.list[i]
    output$age[tree.no] <- tree_dated[[j]]$root.time
    output$max[tree.no] <- max(dates1$max_ma, na.rm = TRUE)
    output$min[tree.no] <- min(dates1$min_ma, na.rm = TRUE)
  
    # Add to counter
    tree.no <- tree.no+1
  }
}  

# Save output
write_csv(output, path = "outputs/root-ages.csv")

#----------------------------------------------
# Plot results
#----------------------------------------------
ages <- read_csv("outputs/root-ages.csv")

# Change tree names for plotting and order based on group
ages <-
  ages %>%
  mutate(tree = case_when(tree == "Arbour.phy" ~ "Arbour",
                          tree == "Carballido.phy" ~ "Carballido",
                          tree == "Cau.phy" ~ "Cau",
                          tree == "Chiba.phy" ~ "Chiba",
                          tree == "Cruzado.phy" ~ "CruzadoC",
                          tree == "GonzalezRiga.phy" ~ "GonzalezR",
                          tree == "Mallon.phy" ~ "Mallon",
                          tree == "Raven.phy" ~ "Raven",
                          tree == "Thompson.phy" ~ "Thompson")) %>%
  mutate(tree = fct_relevel(tree, 
                            "Arbour", "Chiba", "CruzadoC", "Mallon", "Raven", "Thompson",
                            "Carballido", "GonzalezR",
                            "Cau"))

# Create dataset for max and min ages which differ depending on the tree
dates <- 
  ages %>%
  group_by(tree) %>%
  summarise(max_age = max(max),
            min_age = min(min)) %>%
  mutate(overall_max = c(rep(201,6), rep(231,3)))
  
# Plot
ggplot(ages, aes(x = age)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~tree, nrow = 3) +
  theme_bw(base_size = 14) +
  theme(strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_continuous(breaks= pretty_breaks()) +
  scale_y_continuous(breaks= pretty_breaks()) +
  geom_segment(data = dates,
               aes(x = max_age, y = 0, 
                   xend = max_age, 
                   yend = 0.4), inherit.aes = FALSE,
             linetype = "dashed", colour = "#d1495b") +
  geom_segment(data = dates,
               aes(x = min_age, y = 0, 
                   xend = min_age, 
                   yend = 0.4), inherit.aes = FALSE,
               linetype = "dashed", colour = "#00798c") +
  geom_segment(data = dates,
               aes(x = overall_max, y = 0, 
                   xend = overall_max, 
                   yend = 0.4), inherit.aes = FALSE,
               linetype = "dotted", colour = "black") +
  xlab("root age (Ma)")

#ggsave("outputs/figure-root-ages.png", width = 20, height = 20, units = "cm")
