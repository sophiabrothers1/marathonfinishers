#### Preamble ####
# Purpose: This script reads and cleans raw marathon finisher data,
#          performing various transformations, and outputs the cleaned data to a Parquet file.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, 'here', 'dplyr', 'stringr', and 'arrow' packages must be installed
# Any other information needed? Make sure you are in the `marathon_finishers` rproj

# Load libraries
library(tidyverse)
library(here)
library(arrow)
library(dplyr)
library(stringr)

# Load the raw data
data <- read_csv(here::here("data/raw_data/marathon_results.csv"))

# Clean and process the data
cleaned_data <- data %>%
  rename(
    runner_id = runnerId,
    first_name = firstName,
    bib_number = bib,
    age = age,
    gender = gender,
    city = city,
    country_code = countryCode,
    state_province = stateProvince,
    iaaf_category = iaaf,
    overall_place = overallPlace,
    overall_time = overallTime,
    pace = pace,
    gender_place = genderPlace,
    age_grade_time = ageGradeTime,
    age_grade_place = ageGradePlace,
    age_grade_percent = ageGradePercent,
    races_count = racesCount
  ) %>%
  # Convert columns to appropriate data types
  mutate(
    runner_id = as.character(runner_id),
    first_name = as.character(first_name),
    bib_number = as.character(bib_number),
    age = as.integer(age),
    gender = as.factor(gender),
    city = as.character(city),
    country_code = as.factor(country_code),
    state_province = as.character(state_province),
    iaaf_category = as.character(iaaf_category),
    overall_place = as.integer(overall_place),
    # Convert overall_time (HH:MM:SS) to seconds
    overall_time = as.character(overall_time),
    pace = as.character(pace),
    gender_place = as.integer(gender_place),
    age_grade_time = as.integer(age_grade_time),
    age_grade_place = as.integer(age_grade_place),
    age_grade_percent = as.numeric(age_grade_percent),
    races_count = as.integer(races_count)
  ) %>%
  # Convert overall_time (HH:MM:SS) into seconds
  mutate(
    overall_time_seconds = as.integer(
      as.numeric(str_split(overall_time, ":", simplify = TRUE)[, 1]) * 3600 + # Hours * 3600
        as.numeric(str_split(overall_time, ":", simplify = TRUE)[, 2]) * 60 + # Minutes * 60
        as.numeric(str_split(overall_time, ":", simplify = TRUE)[, 3]) # Seconds
    ),
    # Convert pace (MM:SS) into seconds per mile/km
    pace_seconds = as.integer(
      as.numeric(str_split(pace, ":", simplify = TRUE)[, 1]) * 60 + # Minutes * 60
        as.numeric(str_split(pace, ":", simplify = TRUE)[, 2]) # Seconds
    )
  ) %>%
  # Handle missing values
  mutate(
    first_name = if_else(is.na(first_name), "Unknown", first_name),
    city = if_else(is.na(city), "Unknown", city),
    state_province = if_else(is.na(state_province), "Unknown", state_province),
    iaaf_category = if_else(is.na(iaaf_category), "N/A", iaaf_category)
  )

# Write the cleaned data to a new file
write_parquet(cleaned_data, here::here("data/analysis_data/marathon_results_cleaned.parquet"))
