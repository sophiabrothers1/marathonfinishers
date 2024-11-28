#### Preamble ####
# Purpose: This script performs exploratory data analysis on the cleaned marathon finisher data.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `here`, and `lubridate` packages must be installed.
# Any other information needed? Make sure you are in the `marathon_finishers` rproj

library(tidyverse)
library(here)
library(lubridate)

cleaned_data <- arrow::read_parquet(here::here("data/analysis_data/marathon_results_cleaned.parquet"))

# Summary of numerical variables
summary_stats <- cleaned_data %>%
  summarise(
    total_runners = n(),
    avg_age = mean(age, na.rm = TRUE),
    median_age = median(age, na.rm = TRUE),
    gender_distribution = table(gender),
    avg_overall_time = mean(as.numeric(overall_time), na.rm = TRUE),
    avg_pace = mean(as.numeric(pace), na.rm = TRUE),
    avg_age_grade_percent = mean(age_grade_percent, na.rm = TRUE)
  )

print(summary_stats)

# Gender breakdown
gender_distribution <- cleaned_data %>%
  count(gender) %>%
  mutate(percent = n / sum(n) * 100)

print(gender_distribution)
