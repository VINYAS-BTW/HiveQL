
USE pds_analysis;

-- Compare allocation and offtake by year and commodity
SELECT
    financial_year,
    commodity,
    ROUND(allocated_qty, 3) AS allocated_qty,
    ROUND(offtake_qty, 3) AS offtake_qty,
    ROUND(
        100.0 * offtake_qty / allocated_qty, 2
    ) AS offtake_percentage
FROM kerala_allocation_offtake
ORDER BY financial_year, commodity;

-- Annual totals across both commodities
SELECT
    financial_year,
    ROUND(SUM(allocated_qty), 3) AS total_allocation,
    ROUND(SUM(offtake_qty), 3) AS total_offtake,
    ROUND(
        100.0 * SUM(offtake_qty) /
        SUM(allocated_qty), 2
    ) AS overall_offtake_percentage
FROM kerala_allocation_offtake
GROUP BY financial_year
ORDER BY financial_year;
