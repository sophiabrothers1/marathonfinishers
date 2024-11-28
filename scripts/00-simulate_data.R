#### Preamble ####
# Purpose: Simulate marathon finisher data with interactions between variables.
# Author: Sophia Brothers
# Date: November 23rd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure the `tidyverse`, `here`, 'arrow', and `lubridate` packages are installed.
# Any other information needed? Make sure you are in the `marathon_finishers` rproj

library(tidyverse)
library(here)
library(lubridate)
library(arrow)

set.seed(123)

num_simulations <- 1000

simulated_data <- tibble(
  # Simulating `runner_id`
  runner_id = paste0(sample(1000:9999, num_simulations, replace = TRUE)),

  # Simulating `first_name`
  first_name = sample(c("Sophia", "Emma", "Olivia", "Liam", "Noah", "James", "Charlotte", "Amelia", "Benjamin", "Lucas"),
    num_simulations,
    replace = TRUE
  ),

  # Simulating `bib_number`
  bib_number = sample(1001:9999, num_simulations, replace = FALSE),

  # Simulating `age`
  age = sample(18:80, num_simulations, replace = TRUE),

  # Simulating `gender` with a binary distribution (e.g., Male and Female)
  gender = sample(c("Male", "Female"), num_simulations, replace = TRUE),

  # Simulating `city`
  city = sample(c("New York", "Los Angeles", "Chicago", "San Francisco", "Miami", "Boston"), num_simulations, replace = TRUE),

  # Simulating `country_code`
  country_code = sample(c("US", "CA", "GB", "AU", "IN"), num_simulations, replace = TRUE),

  # Simulating `state_province`
  state_province = sample(c("California", "New York", "Texas", "Florida", "Illinois"), num_simulations, replace = TRUE),

  # Simulating `iaaf_category`
  iaaf_category = sample(c("Elite", "Amateur", "Novice"), num_simulations, replace = TRUE),

  # Simulating `overall_place`
  overall_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `overall_time` in "HH:MM:SS" format
  overall_time = sprintf(
    "%02d:%02d:%02d",
    sample(2:5, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE)
  ), # Random seconds (0-59)

  # Simulating `pace`
  pace = sprintf(
    "%02d:%02d",
    sample(4:10, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE)
  ), # Random seconds (0-59)

  # Simulating `gender_place`
  gender_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `age_grade_time`
  age_grade_time = sprintf(
    "%02d:%02d:%02d",
    sample(2:5, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE),
    sample(0:59, num_simulations, replace = TRUE)
  ),

  # Simulating `age_grade_place`
  age_grade_place = sample(1:5000, num_simulations, replace = TRUE),

  # Simulating `age_grade_percent`
  age_grade_percent = runif(num_simulations, 60, 100), # Random percentages between 60% and 100%

  # Simulating `races_count`
  races_count = sample(1:50, num_simulations, replace = TRUE), # Random number of races completed

  # interaction between age and gender
  age_gender_interaction = case_when(
    gender == "Male" ~ age * 1.1,
    gender == "Female" ~ age * 0.9,
    TRUE ~ age
  )
)

write_parquet(simulated_data, here::here("data/simulated_data/marathon_results_simulated_with_interactions.parquet"))
