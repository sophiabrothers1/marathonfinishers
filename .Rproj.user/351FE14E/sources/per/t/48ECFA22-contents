#### Preamble ####
# Purpose: This script performs out-of-sample testing and calculates the RMSE
#          for the linear model trained in the previous script.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse`, `caret`, and `here` packages are installed.

# Load necessary libraries
library(tidyverse)
library(caret)
library(here)

# Load the cleaned dataset (adjust the file path as needed)
marathon_data <- read_parquet(here::here("data/analysis_data/marathon_results_cleaned.parquet"))

# Clean the data again to ensure consistency with the model
marathon_data_cleaned <- marathon_data %>%
  filter(!is.na(overall_time_seconds), !is.na(gender), !is.na(country_code)) %>%
  mutate(
    gender = recode(gender, "M" = "Male", "W" = "Female", "X" = "Other"),
    gender = as.factor(gender),
    overall_time_seconds = as.numeric(overall_time_seconds),
    iaaf_category = as.factor(iaaf_category),
    races_count = as.integer(races_count)
  )

# Split the data into training (80%) and testing (20%) sets
set.seed(123) # For reproducibility
trainIndex <- createDataPartition(marathon_data_cleaned$overall_time_seconds,
  p = 0.8,
  list = FALSE,
  times = 1
)

train_data <- marathon_data_cleaned[trainIndex, ]
test_data <- marathon_data_cleaned[-trainIndex, ]

# Load the saved model
finisher_model <- readRDS(here::here("models/finisher_model.rds"))

# Perform out-of-sample prediction on the test set
predicted_times <- predict(finisher_model, newdata = test_data)

# Calculate the RMSE (Root Mean Squared Error)
rmse_value <- sqrt(mean((predicted_times - test_data$overall_time_seconds)^2))

# Print RMSE value
cat("Root Mean Squared Error (RMSE) on the test data: ", round(rmse_value, 2), "\n")
