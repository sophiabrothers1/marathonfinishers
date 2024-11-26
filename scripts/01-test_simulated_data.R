#### Preamble ####
# Purpose: Test the validity of the simulated marathon finisher data.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse`, `here`, 'arrow', and `testthat` packages are installed.

#### Load Libraries ####
library(tidyverse)
library(here)
library(testthat)
library(arrow)

#### Load Simulated Data ####
simulated_data <- read_parquet(here::here("data/simulated_data/marathon_results_simulated.parquet"))

#### Define Tests ####

test_that("Simulated data has correct structure", {
  # Test that the data is a tibble
  expect_s3_class(simulated_data, "tbl_df")

  # Test that the data has 17 columns (based on our simulated columns)
  expect_equal(ncol(simulated_data), 17)

  # Test that the data has the correct column names
  expected_columns <- c(
    "runner_id", "first_name", "bib_number", "age", "gender", "city", "country_code",
    "state_province", "iaaf_category", "overall_place", "overall_time", "pace",
    "gender_place", "age_grade_time", "age_grade_place", "age_grade_percent", "races_count"
  )
  expect_equal(colnames(simulated_data), expected_columns)
})

test_that("All numeric variables are in the expected range", {
  # Test that 'age' is between 18 and 80
  expect_true(all(simulated_data$age >= 18 & simulated_data$age <= 80))

  # Test that 'overall_place' is a positive integer
  expect_true(all(simulated_data$overall_place > 0))

  # Test that 'gender_place' is a positive integer
  expect_true(all(simulated_data$gender_place > 0))

  # Test that 'age_grade_percent' is between 60 and 100
  expect_true(all(simulated_data$age_grade_percent >= 60 & simulated_data$age_grade_percent <= 100))

  # Test that 'races_count' is between 1 and 50
  expect_true(all(simulated_data$races_count >= 1 & simulated_data$races_count <= 50))
})

test_that("All character columns have valid entries", {
  # Test that 'runner_id' is a character column
  expect_true(all(str_detect(simulated_data$runner_id, "\\d{4}$")))

  # Test that 'first_name' is a character and contains expected values
  expect_true(all(simulated_data$first_name %in% c("Sophia", "Emma", "Olivia", "Liam", "Noah", "James", "Charlotte", "Amelia", "Benjamin", "Lucas")))

  # Test that 'gender' only contains "Male" or "Female"
  expect_true(all(simulated_data$gender %in% c("Male", "Female")))

  # Test that 'country_code' contains valid country codes
  expect_true(all(simulated_data$country_code %in% c("US", "CA", "GB", "AU", "IN")))

  # Test that 'iaaf_category' contains valid categories
  expect_true(all(simulated_data$iaaf_category %in% c("Elite", "Amateur", "Novice")))
})

test_that("Time-related columns are in valid time formats", {
  # Test that 'overall_time' is in HH:MM:SS format
  expect_true(all(str_detect(simulated_data$overall_time, "^\\d{2}:\\d{2}:\\d{2}$")))

  # Test that 'pace' is in MM:SS format
  expect_true(all(str_detect(simulated_data$pace, "^\\d{2}:\\d{2}$")))

  # Test that 'age_grade_time' is in HH:MM:SS format
  expect_true(all(str_detect(simulated_data$age_grade_time, "^\\d{2}:\\d{2}:\\d{2}$")))
})

test_that("No missing values in key columns", {
  # Test that there are no missing values in important columns
  expect_true(all(!is.na(simulated_data$runner_id)))
  expect_true(all(!is.na(simulated_data$first_name)))
  expect_true(all(!is.na(simulated_data$age)))
  expect_true(all(!is.na(simulated_data$overall_place)))
})
