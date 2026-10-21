# Apache Hive-Based Analysis of Public Distribution System Commodity Allocation and Offtake Patterns

## Project Overview

This project uses Apache Hive and HiveQL to analyze food-grain allocation patterns and reported offtake rates.

## Objectives

- Analyze food-grain allocation across states and financial years.
- Compare rice and wheat allocation with reported offtake.
- Calculate offtake percentages.
- Identify trends and differences in the available records.

## Technologies

- Apache Hive 4.2.1
- Docker Desktop
- HiveQL
- CSV datasets
- Git and GitHub

## Datasets

1. State/UT-wise allocation of food grains, 2020–21 to 2023–24.
2. Kerala allocation and offtake of rice and wheat, 2015–16 to 2017–18.

The datasets cover different time periods and geographic scopes, so they are analyzed separately.

## Analyses

- Financial-year allocation totals.
- Top 10 states by allocation over three complete financial years.
- Commodity-wise offtake percentages for Kerala.
- Annual allocation and offtake comparisons.

## Limitations

The state-wise dataset includes partial-year data for 2023–24. The Kerala dataset covers only three financial years and one state. Reported offtake above 100% requires interpretation using the source's definitions and accounting conventions.

## Execution

The HiveQL scripts are available in the `hive/` directory. Run them against the corresponding tables after loading the datasets into the `pds_analysis` database.

## Data Sources

- Government of India Open Government Data Platform: https://www.data.gov.in/keywords/TPDS
- Rajya Sabha Questions Data, Session 247: https://www.data.gov.in/catalog/answers-data-rajya-sabha-questions-session-247
