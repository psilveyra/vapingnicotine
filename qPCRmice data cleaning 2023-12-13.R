library(tidyverse)
library(readxl)

pcr.data <- read_excel("../Data/E-cig fold change calculations for manuscript1-SS-PS-12-8-2023.xlsx", sheet = 6) %>%
  janitor::clean_names()
# load the data and clean the names

pcr.data.long <- pcr.data %>%
  rename(target = x1) %>% # rename the "x1" variable to "target" so it accurately represents that it is a mRNA target
  rename_with(., ~ stringr::str_replace_all(., '_percent_', '_')) %>% # remove the "percent" label from the ecig columns
  rename_with(., ~ stringr::str_replace_all(., 'ecig_', 'ecig')) %>% # remove the trailing underscore after "ecig" in the columns - for pivoting step below
  pivot_longer(!target,
               names_to = c("Treatment", "sex", "ID"),
               names_pattern = "(.*)_(.*)_(.*)",
               values_to = "log_fold_change")
# then pivot the data to long form with a row for each sample per target, and columns for treatment, sex, ID, and logFC outcome
  
  
write_csv(pcr.data.long, "../Data/Analysis data/qPCRmice cleaned analysis data 2023-12-13.csv")