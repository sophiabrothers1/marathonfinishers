#### Preamble ####
# Purpose: This script performs a series of validation tests on cleaned marathon finisher data.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `here`, `arrow`, and `testthat` packages must be installed.
# Any other information needed? Make sure you are in the `marathon_finishers` rproj

# Load required libraries
library(testthat)
library(dplyr)
library(lubridate)

# Load the cleaned data
cleaned_data <- arrow::read_parquet(here::here("data/analysis_data/marathon_results_cleaned.parquet"))

test_that("Cleaned data has the correct columns", {
  expected_columns <- c(
    "runner_id", "first_name", "bib_number", "age", "gender", "city",
    "country_code", "state_province", "iaaf_category", "overall_place",
    "overall_time", "pace", "gender_place", "age_grade_time",
    "age_grade_place", "age_grade_percent", "races_count",
    "overall_time_seconds", "pace_seconds" # Add these new columns for validation
  )
  actual_columns <- colnames(cleaned_data)
  expect_equal(actual_columns, expected_columns, info = "Column names do not match expected names")
})

test_that("Data types of columns are correct", {
  expect_type(cleaned_data$runner_id, "character")
  expect_type(cleaned_data$first_name, "character")
  expect_type(cleaned_data$bib_number, "character")
  expect_type(cleaned_data$age, "integer")
  expect_s3_class(cleaned_data$gender, "factor")
  expect_type(cleaned_data$city, "character")
  expect_s3_class(cleaned_data$country_code, "factor")
  expect_type(cleaned_data$state_province, "character")
  expect_type(cleaned_data$iaaf_category, "character")
  expect_type(cleaned_data$overall_place, "integer")
  expect_type(cleaned_data$overall_time, "character") # `overall_time` is a character type before conversion
  expect_type(cleaned_data$pace, "character") # pace is also character (HH:MM)
  expect_type(cleaned_data$gender_place, "integer")
  expect_type(cleaned_data$age_grade_time, "integer")
  expect_type(cleaned_data$age_grade_place, "integer")
  expect_type(cleaned_data$age_grade_percent, "double")
  expect_type(cleaned_data$races_count, "integer")

  # Check new columns for correctness of types
  expect_type(cleaned_data$overall_time_seconds, "integer")
  expect_type(cleaned_data$pace_seconds, "integer")
})

test_that("Replaced missing values are correct", {
  expect_true(all(cleaned_data$first_name != ""), info = "Missing values in first_name were not replaced")
  expect_true(all(cleaned_data$city != ""), info = "Missing values in city were not replaced")
  expect_true(all(cleaned_data$state_province != ""), info = "Missing values in state_province were not replaced")
  expect_true(all(cleaned_data$iaaf_category != ""), info = "Missing values in iaaf_category were not replaced")
})

test_that("overall_time is correctly converted to seconds", {
  # Check that the overall_time_seconds column is correctly calculated as integer
  expect_true(all(cleaned_data$overall_time_seconds > 0), info = "Some values in overall_time_seconds are not positive")
  expect_true(all(!is.na(cleaned_data$overall_time_seconds)), info = "Some values in overall_time_seconds are NA")
})

test_that("pace is correctly converted to seconds", {
  # Check that the pace_seconds column is correctly calculated as integer
  expect_true(all(cleaned_data$pace_seconds > 0), info = "Some values in pace_seconds are not positive")
  expect_true(all(!is.na(cleaned_data$pace_seconds)), info = "Some values in pace_seconds are NA")
})

test_that("overall_time_seconds is greater than pace_seconds", {
  # Check that overall time in seconds is greater than pace in seconds (somewhat dependent on the race distance, but overall time should be larger)
  expect_true(all(cleaned_data$overall_time_seconds >= cleaned_data$pace_seconds), info = "Some overall times are smaller than pace times")
})
