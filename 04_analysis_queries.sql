-- =============================================================================
-- GLOBAL CO2 EMISSIONS - ANALYSIS QUERIES
-- =============================================================================

-- =============================================================================
-- SECTION 1: GLOBAL OVERVIEW
-- =============================================================================

-- Global emissions at key years (32.9 Bt in 2022, +70% vs 1990)
SELECT 
    year,
    ROUND(co2, 0) AS total_co2_mt,
    ROUND(co2/1000, 1) AS total_co2_bt,
    ROUND(co2_per_capita, 2) AS global_per_capita,
    ROUND(coal_co2, 0) AS coal_mt,
    ROUND(oil_co2, 0) AS oil_mt,
    ROUND(gas_co2, 0) AS gas_mt
FROM emissions
WHERE country = 'World'
  AND year IN (1950, 1970, 1990, 2000, 2010, 2020, 2022)
ORDER BY year;

-- Growth since 1990 (+70%)
SELECT 
    ROUND(MAX(CASE WHEN year=1990 THEN co2 END), 0) AS co2_1990_mt,
    ROUND(MAX(CASE WHEN year=2022 THEN co2 END), 0) AS co2_2022_mt,
    ROUND(100.0 * (MAX(CASE WHEN year=2022 THEN co2 END) - MAX(CASE WHEN year=1990 THEN co2 END)) 
          / MAX(CASE WHEN year=1990 THEN co2 END), 0) AS pct_change
FROM emissions 
WHERE country='World';

-- Growth by decade
WITH decade_data AS (
    SELECT 
        (year / 10) * 10 AS decade,
        AVG(co2) AS avg_co2
    FROM emissions
    WHERE country = 'World' AND year >= 1950
    GROUP BY decade
)
SELECT 
    decade,
    ROUND(avg_co2/1000, 1) AS avg_co2_bt,
    ROUND(100.0 * (avg_co2 - LAG(avg_co2) OVER (ORDER BY decade)) / 
          LAG(avg_co2) OVER (ORDER BY decade), 0) AS growth_pct
FROM decade_data;

-- =============================================================================
-- SECTION 2: TOP EMITTERS
-- =============================================================================

-- Top 10 emitters (2022)
SELECT 
    country,
    region,
    ROUND(co2, 0) AS co2_mt,
    ROUND(co2/1000, 1) AS co2_bt,
    ROUND(100.0 * co2 / (SELECT co2 FROM emissions WHERE country = 'World' AND year = 2022), 1) AS global_share_pct,
    ROUND(co2_per_capita, 1) AS per_capita_t
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
ORDER BY co2 DESC
LIMIT 10;

-- Combined concentration (Top 10 = 78%)
WITH ranked AS (
    SELECT 
        country,
        co2,
        SUM(co2) OVER (ORDER BY co2 DESC) AS cumulative_co2,
        (SELECT co2 FROM emissions WHERE country = 'World' AND year = 2022) AS world_total
    FROM emissions
    WHERE year = 2022
      AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
)
SELECT 
    country,
    ROUND(co2, 0) AS co2_mt,
    ROUND(100.0 * cumulative_co2 / world_total, 0) AS cumulative_share_pct
FROM ranked
ORDER BY co2 DESC
LIMIT 10;

-- Top 3 share (59%)
WITH top3 AS (
    SELECT co2
    FROM emissions 
    WHERE year=2022 
    AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
    ORDER BY co2 DESC LIMIT 3
)
SELECT 
    ROUND(100.0 * SUM(co2) / (SELECT co2 FROM emissions WHERE country='World' AND year=2022), 0) AS top3_share_pct
FROM top3;

-- =============================================================================
-- SECTION 3: PER CAPITA ANALYSIS (US 29x Nigeria)
-- =============================================================================

-- Highest per capita emitters (2022)
SELECT 
    country,
    region,
    ROUND(co2_per_capita, 2) AS per_capita_t,
    ROUND(co2, 0) AS total_co2_mt,
    ROUND(population / 1000000, 1) AS pop_millions
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
  AND population > 5000000
ORDER BY co2_per_capita DESC
LIMIT 10;

-- Lowest per capita emitters (large countries)
SELECT 
    country,
    ROUND(co2_per_capita, 2) AS per_capita_t,
    ROUND(co2, 0) AS total_co2_mt,
    ROUND(population / 1000000, 0) AS pop_millions
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
  AND population > 50000000
ORDER BY co2_per_capita ASC
LIMIT 10;

-- US vs Nigeria ratio (29x)
SELECT 
    MAX(CASE WHEN country='United States' THEN co2_per_capita END) AS us_per_capita,
    MAX(CASE WHEN country='Nigeria' THEN co2_per_capita END) AS nigeria_per_capita,
    ROUND(MAX(CASE WHEN country='United States' THEN co2_per_capita END) / 
          MAX(CASE WHEN country='Nigeria' THEN co2_per_capita END), 0) AS ratio
FROM emissions 
WHERE year=2022;

-- =============================================================================
-- SECTION 4: FUEL SOURCE ANALYSIS
-- =============================================================================

-- Global fuel mix over time
SELECT 
    year,
    ROUND(100.0 * coal_co2 / co2, 0) AS coal_pct,
    ROUND(100.0 * oil_co2 / co2, 0) AS oil_pct,
    ROUND(100.0 * gas_co2 / co2, 0) AS gas_pct,
    ROUND(100.0 * cement_co2 / co2, 0) AS cement_pct
FROM emissions
WHERE country = 'World'
  AND year IN (1990, 2000, 2010, 2022)
ORDER BY year;

-- Coal dependency by country (2022)
SELECT 
    country,
    ROUND(co2, 0) AS total_co2,
    ROUND(100.0 * coal_co2 / co2, 0) AS coal_share_pct,
    ROUND(100.0 * gas_co2 / co2, 0) AS gas_share_pct
FROM emissions
WHERE year = 2022
  AND country IN ('South Africa', 'India', 'China', 'Poland', 'United States', 'France')
ORDER BY coal_co2 / co2 DESC;

-- Coal growth since 1990 (+108%)
SELECT 
    ROUND(MAX(CASE WHEN year=1990 THEN coal_co2 END), 0) AS coal_1990,
    ROUND(MAX(CASE WHEN year=2022 THEN coal_co2 END), 0) AS coal_2022,
    ROUND(100.0 * (MAX(CASE WHEN year=2022 THEN coal_co2 END) - MAX(CASE WHEN year=1990 THEN coal_co2 END)) 
          / MAX(CASE WHEN year=1990 THEN coal_co2 END), 0) AS pct_change
FROM emissions 
WHERE country='World';

-- =============================================================================
-- SECTION 5: REGIONAL ANALYSIS
-- =============================================================================

-- Regional totals (2022) with change vs 1990
SELECT 
    region,
    ROUND(SUM(CASE WHEN year=1990 THEN co2 END), 0) AS co2_1990_mt,
    ROUND(SUM(CASE WHEN year=2022 THEN co2 END), 0) AS co2_2022_mt,
    ROUND(100.0 * SUM(CASE WHEN year=2022 THEN co2 END) / 
          (SELECT co2 FROM emissions WHERE country='World' AND year=2022), 0) AS share_2022_pct,
    ROUND(100.0 * (SUM(CASE WHEN year=2022 THEN co2 END) - SUM(CASE WHEN year=1990 THEN co2 END)) / 
          SUM(CASE WHEN year=1990 THEN co2 END), 0) AS change_vs_1990_pct
FROM emissions
WHERE year IN (1990, 2022)
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY region
ORDER BY co2_2022_mt DESC;

-- Asia share in 1990 (30%) vs 2022 (60%)
SELECT 
    year,
    ROUND(100.0 * SUM(CASE WHEN region='Asia' THEN co2 END) / 
          (SELECT co2 FROM emissions e2 WHERE e2.country='World' AND e2.year=emissions.year), 0) AS asia_share_pct
FROM emissions
WHERE year IN (1990, 2022)
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY year;

-- Per capita by region (2022)
SELECT 
    region,
    ROUND(AVG(co2_per_capita), 1) AS avg_per_capita
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY region
ORDER BY avg_per_capita DESC;

-- =============================================================================
-- SECTION 6: CARBON INTENSITY (Iran 32x Sweden)
-- =============================================================================

-- Most carbon-intensive economies (2022)
SELECT 
    country,
    ROUND(co2_per_gdp, 0) AS kg_per_dollar,
    ROUND(co2, 0) AS total_co2,
    ROUND(gdp / 1000000000, 0) AS gdp_billions
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
ORDER BY co2_per_gdp DESC
LIMIT 10;

-- Most carbon-efficient economies (2022)
SELECT 
    country,
    ROUND(co2_per_gdp, 1) AS kg_per_dollar,
    ROUND(co2, 0) AS total_co2,
    ROUND(gdp / 1000000000, 0) AS gdp_billions
FROM emissions
WHERE year = 2022
  AND country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
  AND gdp > 100000000000
ORDER BY co2_per_gdp ASC
LIMIT 10;

-- Iran vs Sweden ratio (32x)
SELECT 
    MAX(CASE WHEN country='Iran' THEN co2_per_gdp END) AS iran_intensity,
    MAX(CASE WHEN country='Sweden' THEN co2_per_gdp END) AS sweden_intensity,
    ROUND(MAX(CASE WHEN country='Iran' THEN co2_per_gdp END) / 
          MAX(CASE WHEN country='Sweden' THEN co2_per_gdp END), 0) AS ratio
FROM emissions 
WHERE year=2022;

-- =============================================================================
-- SECTION 7: HISTORICAL TRENDS
-- =============================================================================

-- Largest increases (2000-2022)
WITH comparison AS (
    SELECT 
        country,
        MAX(CASE WHEN year = 2000 THEN co2 END) AS co2_2000,
        MAX(CASE WHEN year = 2022 THEN co2 END) AS co2_2022
    FROM emissions
    WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
    GROUP BY country
)
SELECT 
    country,
    ROUND(co2_2000, 0) AS co2_2000,
    ROUND(co2_2022, 0) AS co2_2022,
    ROUND(co2_2022 - co2_2000, 0) AS change_mt,
    ROUND(100.0 * (co2_2022 - co2_2000) / NULLIF(co2_2000, 0), 0) AS change_pct
FROM comparison
WHERE co2_2000 IS NOT NULL AND co2_2022 IS NOT NULL
ORDER BY change_mt DESC
LIMIT 10;

-- Countries with declining emissions (2000-2022)
WITH comparison AS (
    SELECT 
        country,
        MAX(CASE WHEN year = 2000 THEN co2 END) AS co2_2000,
        MAX(CASE WHEN year = 2022 THEN co2 END) AS co2_2022
    FROM emissions
    WHERE country NOT IN ('World', 'Asia', 'Europe', 'North America', 'South America', 'Africa', 'Oceania')
    GROUP BY country
)
SELECT 
    country,
    ROUND(co2_2000, 0) AS co2_2000,
    ROUND(co2_2022, 0) AS co2_2022,
    ROUND(100.0 * (co2_2022 - co2_2000) / co2_2000, 0) AS change_pct
FROM comparison
WHERE co2_2022 < co2_2000
ORDER BY change_pct ASC;

-- =============================================================================
-- END OF ANALYSIS QUERIES
-- =============================================================================
