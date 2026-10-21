
-- ============================================================
-- PROJECT: Apache Hive-Based Analysis of Public Distribution
--          System Commodity Allocation and Offtake Patterns
-- ANALYSIS 2: Kerala Rice and Wheat Allocation and Offtake
-- DATASET: kerala_allocation_offtake.csv
-- PERIOD: 2015-16 to 2017-18
-- ============================================================

-- STEP 1: Select the project database
USE pds_analysis;

-- STEP 2: Create the Kerala allocation and offtake table
CREATE TABLE IF NOT EXISTS kerala_allocation_offtake (
    financial_year STRING,
    commodity STRING,
    allocated_qty DOUBLE,
    offtake_qty DOUBLE,
    offtake_percentage DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- STEP 3: Load the normalized CSV.
-- Run the following in Beeline after copying the CSV
-- into the Hive container at /tmp/kerala_allocation_offtake.csv.
-- The CSV must have no header row for this command.
LOAD DATA LOCAL INPATH '/tmp/kerala_allocation_offtake.csv'
OVERWRITE INTO TABLE kerala_allocation_offtake;

-- STEP 4: Verify the loaded data
SELECT COUNT(*) AS total_records
FROM kerala_allocation_offtake;

SELECT *
FROM kerala_allocation_offtake
ORDER BY financial_year, commodity;

-- STEP 5: Allocation and offtake by commodity and year
SELECT
    financial_year,
    commodity,
    ROUND(allocated_qty, 3) AS allocated_quantity,
    ROUND(offtake_qty, 3) AS offtake_quantity,
    ROUND(offtake_percentage, 2) AS offtake_percentage
FROM kerala_allocation_offtake
ORDER BY financial_year, commodity;

-- STEP 6: Annual totals and overall offtake percentage
SELECT
    financial_year,
    ROUND(SUM(allocated_qty), 3) AS total_allocation,
    ROUND(SUM(offtake_qty), 3) AS total_offtake,
    ROUND(
        100.0 * SUM(offtake_qty) /
        NULLIF(SUM(allocated_qty), 0),
        2
    ) AS offtake_percentage
FROM kerala_allocation_offtake
GROUP BY financial_year
ORDER BY financial_year;

-- STEP 7: Compare rice and wheat offtake across years
SELECT
    commodity,
    financial_year,
    ROUND(allocated_qty, 3) AS allocated_quantity,
    ROUND(offtake_qty, 3) AS offtake_quantity,
    ROUND(offtake_qty - allocated_qty, 3) AS quantity_difference,
    ROUND(
        100.0 * offtake_qty / NULLIF(allocated_qty, 0),
        2
    ) AS calculated_offtake_percentage
FROM kerala_allocation_offtake
ORDER BY commodity, financial_year;

-- STEP 8: Average offtake percentage by commodity
SELECT
    commodity,
    ROUND(AVG(offtake_percentage), 2) AS average_offtake_percentage
FROM kerala_allocation_offtake
GROUP BY commodity
ORDER BY average_offtake_percentage DESC;

-- STEP 9: Identify records where offtake exceeds allocation
SELECT
    financial_year,
    commodity,
    allocated_qty,
    offtake_qty,
    ROUND(
        100.0 * offtake_qty / NULLIF(allocated_qty, 0),
        2
    ) AS calculated_offtake_percentage
FROM kerala_allocation_offtake
WHERE offtake_qty > allocated_qty
ORDER BY financial_year, commodity;

-- STEP 10: Overall totals for the full Kerala dataset
SELECT
    ROUND(SUM(allocated_qty), 3) AS overall_allocation,
    ROUND(SUM(offtake_qty), 3) AS overall_offtake,
    ROUND(
        100.0 * SUM(offtake_qty) /
        NULLIF(SUM(allocated_qty), 0),
        2
    ) AS overall_offtake_percentage
FROM kerala_allocation_offtake;
