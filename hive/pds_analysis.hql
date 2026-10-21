
-- ============================================================
-- PROJECT: Apache Hive-Based Analysis of Public Distribution
--          System Commodity Allocation and Offtake Patterns
-- ANALYSIS 1: State-wise Food-Grain Allocation
-- DATASET: pds_allocation_normalized.csv
-- ============================================================

-- STEP 1: Create and select the database
CREATE DATABASE IF NOT EXISTS pds_analysis;
USE pds_analysis;

-- STEP 2: Create the state-wise allocation table
CREATE TABLE IF NOT EXISTS pds_allocation (
    state STRING,
    financial_year STRING,
    allocated_quantity DOUBLE,
    period_note STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- STEP 3: Load the normalized CSV.
-- Run the following in Beeline after copying the CSV
-- into the Hive container at /tmp/pds_allocation_normalized.csv.
-- The CSV must have no header row for this command.
LOAD DATA LOCAL INPATH '/tmp/pds_allocation_normalized.csv'
OVERWRITE INTO TABLE pds_allocation;

-- STEP 4: Verify that data was loaded
SELECT COUNT(*) AS total_records
FROM pds_allocation;

SELECT *
FROM pds_allocation
LIMIT 10;

-- STEP 5: Total allocation by financial year
SELECT
    financial_year,
    ROUND(SUM(allocated_quantity), 2) AS total_allocation
FROM pds_allocation
GROUP BY financial_year
ORDER BY financial_year;

-- STEP 6: Top 10 states by allocation across complete years
-- 2023-24 is excluded because the dataset covers only
-- a partial year through December 2023.
SELECT
    state,
    ROUND(SUM(allocated_quantity), 2) AS total_allocation
FROM pds_allocation
WHERE financial_year IN ('2020-21', '2021-22', '2022-23')
GROUP BY state
ORDER BY total_allocation DESC
LIMIT 10;

-- STEP 7: State-wise allocation for each financial year
SELECT
    state,
    financial_year,
    ROUND(allocated_quantity, 2) AS allocated_quantity
FROM pds_allocation
ORDER BY state, financial_year;

-- STEP 8: Allocation by financial year and state
SELECT
    financial_year,
    state,
    ROUND(SUM(allocated_quantity), 2) AS total_allocation
FROM pds_allocation
GROUP BY financial_year, state
ORDER BY financial_year, total_allocation DESC;

-- STEP 9: Compare each state's allocation with the
-- average state allocation for the same financial year
SELECT
    state,
    financial_year,
    ROUND(allocated_quantity, 2) AS allocated_quantity,
    ROUND(
        AVG(allocated_quantity) OVER (
            PARTITION BY financial_year
        ), 2
    ) AS average_state_allocation
FROM pds_allocation
ORDER BY financial_year, allocated_quantity DESC;
