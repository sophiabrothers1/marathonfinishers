#### Preamble ####
# Purpose: This script creates a linear model for predicting overall finishing time
#          and saves the model to an RDS file in the `models` directory.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse` and `here` packages are installed.

# Load necessary libraries
library(tidyverse)
library(readr)
library(here)
library(caret)

# Load the dataset (adjust the file path as needed)
marathon_data <- read_parquet(here::here("data/analysis_data/marathon_results_cleaned.parquet"))

# Inspect the first few rows to identify possible issues
head(marathon_data)

# Inspect unique values in 'gender' and 'overall_time' before cleaning
unique_genders_before <- unique(marathon_data$gender)
print(unique_genders_before)

# Check for any invalid or missing overall_time values
summary(marathon_data$overall_time)

# Clean the data: Remove rows with missing values, convert 'overall_time' to numeric (seconds), and ensure 'gender' is a factor
marathon_data_cleaned <- marathon_data %>%
  filter(!is.na(overall_time_seconds), !is.na(gender), !is.na(country_code)) %>%
  mutate(
    # Recode gender values to a more interpretable form
    gender = recode(gender, "M" = "Male", "W" = "Female", "X" = "Other"), # Adjust "X" as needed
    gender = as.factor(gender), # Ensure gender is a factor variable
    overall_time_seconds = as.numeric(overall_time_seconds), # Convert overall_time to seconds if it's not already
    iaaf_category = as.factor(iaaf_category), # Ensure country_code is a factor
    races_count = as.integer(races_count) # Ensure races_count is an integer
  )


# Fit the linear regression model using 'overall_time_seconds' as the dependent variable
finisher_model <- lm(overall_time_seconds ~ age + gender + races_count + iaaf_category, data = marathon_data_cleaned)

# Save the model to an RDS file
saveRDS(finisher_model, here::here("models/finisher_model.rds"))
write_parquet(marathon_data_cleaned, here::here("data/analysis_data/model_data.parquet"))
