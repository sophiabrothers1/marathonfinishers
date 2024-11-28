#### Preamble ####
# Purpose: This script creates a linear model for predicting overall finishing time
#          and saves the model to an RDS file in the `models` directory.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse`, 'readr', 'caret', 'arrow', 'mgcv', and `here` packages are installed.
# Any other information needed? Make sure you are in the `marathon_finishers` rproj

# Load libraries
library(tidyverse)
library(readr)
library(here)
library(caret)
library(arrow)
library(mgcv)

# Load the dataset
marathon_data <- read_parquet(here::here("data/analysis_data/marathon_results_cleaned.parquet"))

# Clean the data
marathon_data_cleaned <- marathon_data %>%
  filter(!is.na(overall_time_seconds), !is.na(gender), !is.na(country_code)) %>%
  mutate(
    # Recode gender values to a more interpretable form
    gender = recode(gender, "M" = "Male", "W" = "Female", "X" = "Other"), # Adjust "X" as needed
    gender = as.factor(gender),
    overall_time_seconds = as.numeric(overall_time_seconds),
    iaaf_category = as.factor(iaaf_category),
    races_count = as.integer(races_count)
  )


# Fit the GAM model using 'overall_time_seconds' as the dependent variable
finisher_model <- gam(overall_time_seconds ~ s(age) + gender + s(races_count) + iaaf_category,
  data = marathon_data_cleaned
)

# Save the model to an RDS file
saveRDS(finisher_model, here::here("models/finisher_model.rds"))
write_parquet(marathon_data_cleaned, here::here("data/analysis_data/model_data.parquet"))
