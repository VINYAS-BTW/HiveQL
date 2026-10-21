
USE pds_analysis;

-- Query 1: Annual allocation totals
SELECT
    financial_year,
    ROUND(SUM(allocated_quantity), 2) AS total_allocation
FROM pds_allocation
GROUP BY financial_year
ORDER BY financial_year;

-- Query 2: Top 10 states by allocation
-- Uses the three complete financial years
SELECT
    state,
    ROUND(SUM(allocated_quantity), 2) AS total_allocation
FROM pds_allocation
WHERE financial_year IN ('2020-21', '2021-22', '2022-23')
GROUP BY state
ORDER BY total_allocation DESC
LIMIT 10;

-- Query 3: Detailed state-wise yearly allocation
SELECT
    state,
    financial_year,
    allocated_quantity,
    period_note
FROM pds_allocation
ORDER BY state, financial_year;
