# What Makes a Marathon Runner Fast? Key Predictors of Finishing Times

By: Sophia Brothers

## Overview

This repository provides readers with all the necessary data, R scripts, and files to understand and reproduce a prediction on marathon finishing times.

We analyze the predictors of marathon finishing times using a Generalized Additive Model (GAM). The model incorporates key variables such as age, gender, race experience, and age-graded performance to understand their influence on runners' performance. The results highlight age and gender as the most significant predictors, with younger ages and male runners correlating with faster times. Additionally, the analysis looks at relationships between performance and these variables through smooth terms, providing insights into non-linear effects like age-related performance decline.

The data used in this analysis comes from Data is Plural, capturing runners' demographics, race history, and performance metrics. The analysis leverages R and many different packages to develop and visualize the model.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from [https://projects.fivethirtyeight.com/polls/president-general/2024/national/.](https://www.data-is-plural.com/archive/2024-11-13-edition/).
-   `data/analysis_data` contains the cleaned datasets that were constructed.
-   `data/simulated_data` contains the simulated data that were constructed.
-   `models` contains fitted models. 
-   `other` contains the shiny app as well as details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, test data, exploratory analysis, modelling and validation.


## Statement on LLM usage

LLMs such as ChatGPT were used to help formulate the questions for the simulated survey as well as for minor coding help. Full usage can be found on `other/llm_usage/usage.txt`.
