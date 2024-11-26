#### Preamble ####
# Purpose: Simulate synthetic marathon finisher data.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse`, `here`, 'arrow', and `lubridate` packages are installed.

library(tidyverse)
library(here)
library(lubridate)
library(arrow)

set.seed(123) # Ensure that the random numbers are reproducible

num_simulations <- 1000 # Adjust this to the desired number of simulated rows


simulated_data <- tibble(
  # Simulating `runner_id` as random numeric strings
  runner_id = paste0(sample(1000:9999, num_simulations, replace = TRUE)),

  # Simulating `first_name` from a list of common names
  first_name = sample(c("Sophia", "Emma", "Olivia", "Liam", "Noah", "James", "Charlotte", "Amelia", "Benjamin", "Lucas"),
    num_simulations,
    replace = TRUE
  ),

  # Simulating `bib_number` as a unique identifier
  bib_number = sample(1001:9999, num_simulations, replace = FALSE),

  # Simulating `age` between 18 and 80
  age = sample(18:80, num_simulations, replace = TRUE),

  # Simulating `gender` with a binary distribution (e.g., Male and Female)
  gender = sample(c("Male", "Female"), num_simulations, replace = TRUE),

  # Simulating `city` (randomized from a list)
  city = sample(c("New York", "Los Angeles", "Chicago", "San Francisco", "Miami", "Boston"), num_simulations, replace = TRUE),

  # Simulating `country_code` (randomized from a list of country codes)
  country_code = sample(c("US", "CA", "GB", "AU", "IN"), num_simulations, replace = TRUE),

  # Simulating `state_province` from a list of US states
  state_province = sample(c("California", "New York", "Texas", "Florida", "Illinois"), num_simulations, replace = TRUE),

  # Simulating `iaaf_category` as random categories
  iaaf_category = sample(c("Elite", "Amateur", "Novice"), num_simulations, replace = TRUE),

  # Simulating `overall_place` (finish position in the race, 1st to 5000th)
  overall_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `overall_time` as a time in "HH:MM:SS" format (randomized)
  overall_time = sprintf(
    "%02d:%02d:%02d",
    sample(2:5, num_simulations, replace = TRUE), # Random hours (2-5 hours)
    sample(0:59, num_simulations, replace = TRUE), # Random minutes (0-59)
    sample(0:59, num_simulations, replace = TRUE)
  ), # Random seconds (0-59)

  # Simulating `pace` (time per mile or km, as "MM:SS" format)
  pace = sprintf(
    "%02d:%02d",
    sample(4:10, num_simulations, replace = TRUE), # Random pace in minutes (4-10 minutes per km/mile)
    sample(0:59, num_simulations, replace = TRUE)
  ), # Random seconds (0-59)

  # Simulating `gender_place` (place within gender category)
  gender_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `age_grade_time` (graded time based on age and performance)
  age_grade_time = sprintf(
    "%02d:%02d:%02d",
    sample(2:5, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE)
  ),

  # Simulating `age_grade_place` (age grade placement)
  age_grade_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `age_grade_percent` (percent of age-graded time)
  age_grade_percent = runif(num_simulations, 60, 100), # Random percentages between 60% and 100%

  # Simulating `races_count` (number of races completed)
  races_count = sample(1:50, num_simulations, replace = TRUE) # Random number of races completed
)

write_parquet(simulated_data, here::here("data/simulated_data/marathon_results_simulated.parquet"))
