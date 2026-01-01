# Global CO2 Emissions Analysis

## Background and Overview

Fossil fuel combustion is the cause for approximately 75% of global greenhouse gas emissions, which makes carbon dioxide the leading driver of human-caused climate change. This analysis looks at CO2 emissions data from 1800 to 2023 across 40 countries that produce over 90% of worldwide emissions altogether. The dataset tracks output by country, fuel type (coal, oil, gas, cement), and includes metrics like per capita emissions and carbon intensity. This analysis is presented as if having been conducted in 2023, when all findings and data would have been current and recent.

Main questions addressed:
- How have worldwide emissions changed over time, and are we on track for climate targets?
- Which countries emit the most? Who is improving, and who is worsening?
- What fuel sources drive most of emissions growth?
- How do per capita emissions differ across countries and regions?
- Which economies produce the least carbon per dollar of output?

**Dataset Information**

**Source:** [CO2 and Greenhouse Gas Emissions - Our World in Data](https://ourworldindata.org/co2-and-greenhouse-gas-emissions)

**Provider:** Our World in Data

SQL queries for data inspection can be found [here](03_data_inspection.sql).
Analysis queries are available [here](04_analysis_queries.sql).

---

## Data Structure Overview

The dataset is a single flat table with 4,988 records of annual emissions data.

### Schema

| Column | Type | Description |
|--------|------|-------------|
| country | VARCHAR | Country or region name |
| year | INTEGER | Year (1800-2023) |
| iso_code | VARCHAR | ISO 3-letter code |
| region | VARCHAR | Geographic region |
| population | BIGINT | Total population |
| gdp | BIGINT | GDP in USD |
| co2 | FLOAT | Total CO2 (million tonnes) |
| co2_per_capita | FLOAT | CO2 per person (tonnes) |
| co2_per_gdp | FLOAT | CO2 per $ GDP (kg) |
| coal_co2 | FLOAT | CO2 from coal |
| oil_co2 | FLOAT | CO2 from oil |
| gas_co2 | FLOAT | CO2 from gas |
| cement_co2 | FLOAT | CO2 from cement |

### Data Summary

| Metric | Value |
|--------|-------|
| Total Records | 4,988 |
| Countries | 40 |
| Year Range | 1800-2023 |
| Global CO2 (2022) | 32.9 billion tonnes |

---

## Executive Summary

### Overview of Findings

Global CO2 emissions reached 32.9 billion tonnes in 2022, which is 70% higher than levels in 1990. Ten countries account for 78% of the total; China alone contributes 34%. The data shows some geographic concentration.

One trend stands out, which is that coal's share of emissions has grown since 1990, climbing from 35% to 43%, largely because of rapid industrialization in Asia. Developed countries have cut their totals, yet their per capita emissions remain three to five times the global average.

### Key Metrics (2022)

| Metric | Value | Trend |
|--------|-------|-------|
| Global CO2 Emissions | 32.9 Bt | +70% vs 1990 |
| Per Capita (Global Avg) | 5.4 tonnes | +36% vs 1990 |
| Coal Share | 43% | Rising |
| Top 3 Countries Share | 59% | China, US, India |

![Executive Dashboard](05_executive_dashboard.png)

---

## Insights Deep Dive

### 1. Global Emissions Trajectory

Since 1950, global emissions have quadrupled from 7.1 to 32.9 billion tonnes. Growth has slowed down in recent years but has not reversed.

**Key Findings:**
- 1950-1970: +68% (post-war industrial expansion)
- 1970-1990: +62% (growth continued despite oil price crises)
- 1990-2010: +45% (China's rapid increase)
- 2010-2022: +17% (slower but still positive)

**Decadal Growth Rates:**

| Decade | Avg Annual CO2 | Growth vs Prior |
|--------|---------------|-----------------|
| 1950s | 8.0 Bt | -- |
| 1970s | 13.5 Bt | +32% |
| 1990s | 20.9 Bt | +18% |
| 2010s | 30.0 Bt | +18% |
| 2020s | 32.6 Bt | +9% |

Growth is decelerating, but emissions continue to rise. Any serious reduction effort would need to reverse this trend entirely. The Paris Agreement goal (refer to citation) to limit warming to 1.5°C requires emissions to decline 45% by 2030, which is a feat we are nowhere near to achieving. 

---

### 2. Top Emitting Countries

A small group of countries produces most of the world's CO2, which creates both responsibility and opportunity for such countries.

**Top 10 Emitters (2022):**

| Rank | Country | CO2 (Bt) | Global Share | Per Capita |
|------|---------|----------|--------------|------------|
| 1 | China | 11.2 | 34.1% | 8.0t |
| 2 | United States | 5.3 | 16.0% | 16.1t |
| 3 | India | 2.9 | 8.9% | 2.1t |
| 4 | Russia | 1.8 | 5.6% | 12.6t |
| 5 | Japan | 1.0 | 3.2% | 8.3t |
| 6 | Iran | 0.7 | 2.2% | 8.3t |
| 7 | Germany | 0.7 | 2.1% | 8.0t |
| 8 | South Korea | 0.6 | 2.0% | 12.6t |
| 9 | Saudi Arabia | 0.6 | 1.8% | 16.8t |
| 10 | Canada | 0.6 | 1.8% | 15.5t |

**Concentration:**
- Top 3 countries = 59% of global emissions
- Top 10 countries = 78% of global emissions
- Remaining 190+ countries = 22% combined

Because emissions are so concentrated, action from just ten nations could address nearly 80% of the problem. International cooperation with these nations is vital.

![Country Analysis](06_country_analysis.png)

---

### 3. The Per Capita Perspective

Total emissions tell only a part of the story. Per capita numbers show major differences in individual carbon footprints.

**Highest Per Capita Emitters (2022):**

| Country | Per Capita | Total CO2 |
|---------|------------|-----------|
| UAE | 18.8t | 187 Mt |
| Saudi Arabia | 16.8t | 608 Mt |
| United States | 16.1t | 5,261 Mt |
| Canada | 15.5t | 601 Mt |
| Australia | 14.3t | 377 Mt |

**Lowest Per Capita (Large Countries):**

| Country | Per Capita | Population |
|---------|------------|------------|
| Nigeria | 0.6t | 219M |
| Bangladesh | 0.6t | 171M |
| Pakistan | 1.0t | 231M |
| India | 2.1t | 1,417M |
| Indonesia | 2.2t | 275M |

**The Gap:**
- The average American emits 29 times more than the average Nigerian.
- The wealthiest 10% of the world's population has the highest per capita figures, even when their total emissions are declining.
- Historical combined emissions skew even more toward wealthy, developed nations.

Any policy that focuses only on total emissions misses this imbalanced nuance. Per capita figures are important in order to understand who contributes most on an individual level.

---

### 4. Fuel Source Analysis

Coal remains the largest source of CO2. That is the core problem. Coal's share has increased since 1990, not decreased.

**Global Fuel Mix (2022):**

| Source | CO2 (Bt) | Share | vs 1990 |
|--------|----------|-------|---------|
| Coal | 14.1 | 43% | +108% |
| Oil | 10.6 | 32% | +52% |
| Gas | 6.0 | 18% | +89% |
| Cement | 1.3 | 4% | +180% |

**Coal Dependency by Country:**

| Country | Coal Share | Context |
|---------|------------|---------|
| South Africa | 67% | Coal-rich, few alternatives |
| India | 58% | Cheap coal, rising demand |
| China | 55% | World's largest coal user |
| Poland | 55% | Heavy coal dependency |
| United States | 24% | Shifted toward gas |
| France | 12% | Mostly nuclear power |

Switching from coal to gas, as the US has done, helps reduce emissions but is not enough on its own. Real progress means moving from coal to low-carbon sources, especially in Asia where 70% of coal emissions originate.

![Fuel Sources](07_fuel_sources.png)

---

### 5. Regional Dynamics

Asia's growth has reshaped the geography of global emissions fundamentally.

**Regional Emissions (2022):**

| Region | CO2 (Bt) | Share | vs 1990 |
|--------|----------|-------|---------|
| Asia | 19.8 | 60% | +238% |
| North America | 6.3 | 19% | -13% |
| Europe | 4.8 | 15% | -1% |
| South America | 0.8 | 3% | +59% |
| Africa | 0.8 | 2% | +71% |
| Oceania | 0.4 | 1% | -5% |

**The Shift:**
- In 1990, Asia produced 30% of global emissions.
- Today it produces 60%, more than all other regions combined.
- Europe and North America have declined in numbers, not just in their global percentage share, eg. Europe went down from about 6 billion tonnes in 1990 to 4.8 billion in 2022.

**Per Capita by Region:**

| Region | Per Capita | Context |
|--------|------------|---------|
| Oceania | 14.3t | Australia dominates |
| North America | 11.6t | High-consumption patterns |
| Asia | 7.4t | Wide internal variation |
| Europe | 6.9t | Post-industrial efficiency |
| Africa | 3.4t | Low energy access |
| South America | 3.1t | Hydro-powered grids |

Reduction efforts that ignore Asia will have a limited impact, since the region now accounts for 60% of global output. So climate action must largely include Asia, specifically China and India, where emissions are growing the fastest. At the same time, wealthier regions with high per capita figures have room to cut further.

![Regional Analysis](08_regional_analysis.png)

---

### 6. Carbon Intensity (Efficiency)

Some economies emit far more CO2 per dollar of output than others. This reveals where efficiency gains could have the biggest impact.

**Most Carbon-Intensive Economies:**

| Country | kg CO2/$ GDP | Context |
|---------|--------------|---------|
| Iran | 1,968 | Subsidized fuel, older industry |
| Kazakhstan | 1,093 | Legacy infrastructure |
| South Africa | 1,080 | Coal-dependent economy |
| India | 861 | Growing but inefficient |
| Russia | 811 | Energy-heavy exports |
| China | 649 | Improving but still high |

**Most Carbon-Efficient Economies:**

| Country | kg CO2/$ GDP | Context |
|---------|--------------|---------|
| Sweden | 62 | Hydro and nuclear power |
| Norway | 78 | Hydro-powered grid |
| France | 104 | Heavy nuclear reliance |
| UK | 110 | Coal phase-out, services economy |
| Switzerland | 116 | Services plus hydro |

The gap between the most and least efficient economies is dramatic: Iran emits roughly 32 times more CO2 per dollar of GDP than Sweden. Sharing technology and practices from efficient to inefficient economies could result in major reductions without slowing growth.

---

## Recommendations

Based on these findings, the following actions may help policymakers, investors, and business leaders.

### For Policymakers

1. **Speed up coal phase-out in Asia.** China and India produce 70% of coal-related emissions. Focusing on retiring coal plants and pushing alternatives in these markets would make a substantial impact.

2. **Put a price on carbon.** Countries with high carbon intensity, such as Iran, Kazakhstan and South Africa, would benefit from pricing systems that reward efficiency improvements.

3. **Address per capita imbalance.** Nations with per capita emissions above 10 tonnes have more room to cut than those below 3 tonnes. Reduction targets could reflect this difference and create a practical system of equity.

### For Investors

4. **Reduce coal dependence.** Coal accounts for 43% of emissions and faces long-term decline in most scenarios. Companies with heavy coal reliance carry risk.

5. **Support clean energy in Asia.** The fastest emissions growth is happening in Asia. Clean energy investments in China, India, and Southeast Asia will likely see both impact and returns.

6. **Look for efficiency leaders.** Companies achieving low carbon intensity in heavy sectors, like steel, cement, and chemicals, may be in a better position for a low-carbon transition.

### For Business Leaders

7. **Set clear reduction targets.** Align company emissions with long-term reduction goals (particularly the 1.5°C target set within the Paris Agreement). Companies in high-emission sectors should aim for 4-7% reductions annually.

8. **Work with suppliers.** For companies sourcing from Asia, supply chain emissions likely dominate the total. Engaging suppliers on fuel switching from coal to renewable is critical.

9. **Disclose and compare data.** Transparent carbon reporting lets companies compare and contrast against peers and track progress over time.

---
Citation:

1. UNFCCC. (2025). The Paris agreement. United Nations Climate Change. https://unfccc.int/process-and-meetings/the-paris-agreement

---


### Repository Structure

```
├── README.md
├── data/
│   └── 02_co2_emissions.csv
├── sql/
│   ├── 03_data_inspection.sql
│   └── 04_analysis_queries.sql
└── visualizations/
    ├── 05_executive_dashboard.png
    ├── 06_country_analysis.png
    ├── 07_fuel_sources.png
    └── 08_regional_analysis.png
```
