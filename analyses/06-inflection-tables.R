# Summarising the results for inflection points

# Load libraries
library(tidyverse)
library(xtable)

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

# For now let's just output these as is, may create proper
# tables later

write_csv(path = "outputs/inflection_table.csv", d1)
write_csv(path = "outputs/inflection_table_intercepts.csv", d2)
