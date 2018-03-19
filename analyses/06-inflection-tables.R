# Summarising the results for inflection points

# Load library
library(tidyverse)

# List files for each analysis
files1 <- c("inflection_lloyd2008.csv", "inflection_4.csv", "inflection_21.csv", 
            "inflection_42.csv","inflection_105.csv", "inflection_210.csv")                 
 

files2 <- c("inflection_lloyd2008_intercepts.csv", "inflection_4_intercepts.csv", 
            "inflection_21_intercepts.csv", "inflection_42_intercepts.csv",
            "inflection_105_intercepts.csv", "inflection_210_intercepts.csv")

# List name of path to files
data_path <- "outputs/tables"

d1 <- files1 %>%
  map(~ read_csv(file.path(data_path, .))) %>% 
  reduce(rbind)

d2 <- files2 %>%
  map(~ read_csv(file.path(data_path, .))) %>% 
  reduce(rbind)

# Load libraries
library(tidyverse)
library(xtable)



# Create tidy names for number of taxa added
# and clade names
taxa <- c(rep("-", 4),
          rep("1%", 4), 
          rep("5%", 4),
          rep("10%", 4),
          rep("25%", 4), 
          rep("50%", 4))

clade <- rep(c("all", "ornithischians", 
               "sauropods", "theropods"), 6)

# Formatting the tables
table_out <- data.frame(taxa, clade, dic[, 3:5])
colnames(table_out) <- c("% taxa added", "clade", "null DIC",
                         "slowdown DIC", "asymptote DIC")

table_outi <- data.frame(taxa, clade, dici[, 3:5])
colnames(table_outi) <- c("% taxa added", "clade", "null DIC",
                          "slowdown DIC", "asymptote DIC")

# Save tables as .tex files
sink(file = "outputs/dic_table.tex")
xtable(table_out, caption = "")
sink()

sink(file = "outputs/dic_table_intercepts.tex")
xtable(table_outi, caption = "")
sink()

# Will need to add caption and bold the lowest values manually