-- =============================================================================
-- GLOBAL CO2 EMISSIONS - DATA INSPECTION & QUALITY CHECKS
-- =============================================================================

-- =============================================================================
-- SECTION 1: TABLE OVERVIEW
-- =============================================================================

-- Record count and basic stats
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT country) AS unique_countries,
    COUNT(DISTINCT region) AS unique_regions,
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year
FROM emissions;

-- Records by region
SELECT 
    region,
    COUNT(DISTINCT country) AS countries,
    COUNT(*) AS records,
    MIN(year) AS start_year
FROM emissions
WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY region
ORDER BY countries DESC;

-- =============================================================================
-- SECTION 2: NULL VALUE ANALYSIS
-- =============================================================================

-- Check for NULL values in key columns
SELECT 
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN co2 IS NULL THEN 1 ELSE 0 END) AS null_co2,
    SUM(CASE WHEN population IS NULL THEN 1 ELSE 0 END) AS null_population,
    SUM(CASE WHEN gdp IS NULL THEN 1 ELSE 0 END) AS null_gdp,
    SUM(CASE WHEN co2_per_capita IS NULL THEN 1 ELSE 0 END) AS null_per_capita
FROM emissions;

-- =============================================================================
-- SECTION 3: MIN/MAX VALUE CHECKS
-- =============================================================================

-- CO2 emissions range check
SELECT 
    MIN(co2) AS min_co2,
    MAX(co2) AS max_co2,
    ROUND(AVG(co2), 2) AS avg_co2,
    SUM(CASE WHEN co2 < 0 THEN 1 ELSE 0 END) AS negative_values
FROM emissions
WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania');

-- Per capita range check (2022)
SELECT 
    MIN(co2_per_capita) AS min_per_capita,
    MAX(co2_per_capita) AS max_per_capita,
    ROUND(AVG(co2_per_capita), 2) AS avg_per_capita
FROM emissions
WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
  AND year = 2022;

-- =============================================================================
-- SECTION 4: DATA CONSISTENCY CHECKS
-- =============================================================================

-- Verify fuel sources sum approximately to total
SELECT 
    country,
    year,
    ROUND(co2, 2) AS total_co2,
    ROUND(coal_co2 + oil_co2 + gas_co2 + cement_co2 + flaring_co2 + other_co2, 2) AS sum_sources,
    ROUND(ABS(co2 - (coal_co2 + oil_co2 + gas_co2 + cement_co2 + flaring_co2 + other_co2)), 2) AS difference
FROM emissions
WHERE country = 'World'
  AND year IN (2020, 2021, 2022)
ORDER BY year;

-- Verify per capita calculation
SELECT 
    country,
    year,
    co2,
    population,
    co2_per_capita,
    ROUND(co2 / (population / 1000000.0), 2) AS calculated_per_capita,
    ROUND(ABS(co2_per_capita - (co2 / (population / 1000000.0))), 4) AS difference
FROM emissions
WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
  AND year = 2022
LIMIT 10;

-- =============================================================================
-- SECTION 5: YEAR COVERAGE BY COUNTRY
-- =============================================================================

-- Check year coverage by country
SELECT 
    country,
    MIN(year) AS first_year,
    MAX(year) AS last_year,
    COUNT(DISTINCT year) AS years_covered,
    MAX(year) - MIN(year) + 1 AS expected_years
FROM emissions
WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY country
ORDER BY first_year;

-- =============================================================================
-- SECTION 6: FINDING OUTLIERS
-- =============================================================================

-- Identify potential outliers in per capita emissions (2022)
SELECT 
    country,
    year,
    ROUND(co2_per_capita, 2) AS per_capita,
    CASE 
        WHEN co2_per_capita > 20 THEN 'Very High'
        WHEN co2_per_capita > 10 THEN 'High'
        WHEN co2_per_capita < 1 THEN 'Very Low'
        ELSE 'Normal'
    END AS category
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
ORDER BY co2_per_capita DESC;

-- =============================================================================
-- END OF DATA INSPECTION
-- =============================================================================
